// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!


/**
 *
 * generic snootor methods, each snootor-driven motor uses them,
 * especially for 'pseudo-multitasking' 
 *
 **/

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#define SNOOT_WIREWRITE Wire.write
#else
#include <avr/io.h>
#include "WProgram.h"
#define SNOOT_WIREWRITE Wire.send
#endif

#include "../Wire/Wire.h"
#include <snootor.h>


Snootor::Snootor(){
    motor_state=0;
    maxstate=0;
    /**
     * keep track of "directions"
     **/
    _regvalue=0;
}

void Snootor::enableMax(void) {
  if(maxstate==0){

    i2c( 0x6, 0x00);			// input and output config.
    i2c( 0x2, 0x00);			// input and output config.
    i2c( 0xe, 0x0f);			// config bit
    i2c( 0xf, 0x0c);			// blink 0 on
    /*
    i2c( 0xe, 0xff);                    // 0f Internal oscilator disabled. All output are static WITHOUT PWM
    i2c( 0xf, 0x10);			// blink 0 on
    i2c( 0x6, 0x00);			// input and output config.
    i2c( 0x7, 0x00);			// ...
    i2c( 0x2, 0xFF);			// global intensity reg.
    i2c(0x3, 0xff);
    i2c(0xe, 0xff);			// config bit
    */

    /*
    i2c(0x10,0x00);                        // zero out pwms on register 0x10
    i2c(0x11,0x00);                        // zero out pwms on register 0x11
    i2c(0x12,0x00);                        // zero out pwms on register 0x12
    i2c(0x13,0x00);                        // zero out pwms on register 0x13
    */
    i2c(0x14,0x00);                        // zero out pwms on register 0x14
    i2c(0x15,0x00);                        // zero out pwms on register 0x15
    i2c(0x16,0x00);                        // zero out pwms on register 0x16
    i2c(0x17,0x00);                        // zero out pwms on register 0x17

    maxstate=1;

  }
#ifdef MOTOR_DEBUG
  Serial.println("MAX7313 I2C INIT DONE !");
#endif
}

/**
 *
 * wrapper around delay() 
 *
 * MOTOR_MICRO_DELAY -> 'tick' of pseudo-scheduler
 * check for each motor if it's loaded, (MOTOR_MASK vs motor_state)
 * execute basic step for loaded motors
 *
 **/

void Snootor::delay(uint32_t msecs){

  uint32_t i;
  for(i=0;i<msecs*1000;i+=MOTOR_MICRO_DELAY){
    delayMicroseconds(MOTOR_MICRO_DELAY);
    if(motor_state & MOTOR_MASK_1) i+=motors[0]->next();
    if(motor_state & MOTOR_MASK_2) i+=motors[1]-> next();
    if(motor_state & MOTOR_MASK_3) i+=motors[2]-> next();
    if(motor_state & MOTOR_MASK_4) i+=motors[3]-> next();
  }
}



void Snootor::stop(){
  if(motor_state & MOTOR_MASK_1) {
#ifdef MOTOR_DEBUG
   Serial.println("Stop Motor nr 1");
#endif
    motors[0]-> stop();
  }
  if(motor_state & MOTOR_MASK_2) {
#ifdef MOTOR_DEBUG
    Serial.println("Stop Motor nr 2");
#endif
    motors[1]-> stop();
  }
  if(motor_state & MOTOR_MASK_3) {
#ifdef MOTOR_DEBUG
    Serial.println("Stop Motor nr 3");
#endif
    motors[2]-> stop();
  }
  if(motor_state & MOTOR_MASK_4) {
#ifdef MOTOR_DEBUG
    Serial.println("Stop Motor nr 4");
#endif
    motors[3]-> stop();
  }
}

void Snootor::add(SnootorMotor*m){
  enableMax();
  uint8_t i=0;
  while((motor_state & 1<<i)&& i<3)
    i++;
  motors[i]=m;
  motor_state |= 1<<i;
#ifdef MOTOR_DEBUG
  Serial.println("snootor::add!");
  m->dump();
  Serial.print("motor state : ");
  Serial.println(motor_state,DEC);
  Serial.print("motor state & MOTOR_MASK_1 : ");
  Serial.println(motor_state & MOTOR_MASK_1,DEC);
  Serial.print("motor 1 : ");
  Serial.println((long)motors,HEX);
  Serial.print("motor state & MOTOR_MASK_2 : ");
  Serial.println(motor_state & MOTOR_MASK_2,DEC);
  Serial.print("motor 2 : ");
  Serial.println((long)(motors+1),HEX);
  Serial.print("motor state & MOTOR_MASK_3 : ");
  Serial.println(motor_state & MOTOR_MASK_3,DEC);
  Serial.print("motor 3 : ");
  Serial.println((long)(motors+2),HEX);
  Serial.print("motor state & MOTOR_MASK_4 : ");
  Serial.println(motor_state & MOTOR_MASK_4,DEC);
  Serial.print("motor 4 : ");
  Serial.println((long)(motors+3),HEX);
#endif
}



/**
 * single bit i2c communication
 **/

void Snootor::i2c(uint8_t reg,uint8_t val){
  Wire.beginTransmission(MAX_ADRESS);
  SNOOT_WIREWRITE( reg);
  SNOOT_WIREWRITE( val);
  Wire.endTransmission();
}

/**
 * two bit i2c communication
 **/


void Snootor::i2c2(uint8_t reg,uint8_t val,uint8_t reg2,uint8_t val2){
  Wire.beginTransmission(MAX_ADRESS);
  SNOOT_WIREWRITE( reg);
  SNOOT_WIREWRITE( val);
  if(reg+1 != reg2){
    Wire.endTransmission();
    Wire.beginTransmission(MAX_ADRESS);
    SNOOT_WIREWRITE( reg2);
  }
  SNOOT_WIREWRITE( val2);
  Wire.endTransmission();
 }

/**
 *    sending 4bit pwm by "number"
 *   "value" is reversed
 *   pwm_state keeps track of pwm values
 *   lnumber : 0-7, corresponds to pwm number 1-8
 *
 *   number 1/2 -> registry 0x14
 *   number 3/4 -> registry 0x15
 *   number 5/6 -> registry 0x16
 *   number 7/8 -> registry 0x17
 *   0xFF = off
 *   0xF0 = first pwm activated
 *   0x0F = second pwm activated
 *   0x0 = no pwm activated
 *
 **/

void Snootor::sendPWM(uint8_t number,uint8_t value){
  int reg_number=0x14 + (number-1)/2;
  int even_number=2*((number-1)/2);
  value&=0xf;
  pwm_state[number-1]=0xf-value;

 #ifdef MOTOR_DEBUG

  Serial.print("sendpwm on led (w/o offset):");
  Serial.print(number,DEC);
  Serial.print(" - EN");
  Serial.print(even_number,DEC);
  Serial.print(" - value (4bit) : 0x");
  Serial.print(value,HEX);
  Serial.print(" - value inv (4bit) : 0x");
  Serial.print(0xf-value,HEX);
  Serial.print(" - reg : 0x");
  Serial.print(reg_number,HEX);
  Serial.print("- state (4bit) : 0x");
  Serial.print(pwm_state[number-1],HEX);
  Serial.print("- state (8bit) : 0x");
  Serial.println(pwm_state[even_number]+(pwm_state[even_number+1]<<4),HEX);

#endif 
  i2c(reg_number,pwm_state[even_number]+(pwm_state[even_number+1]<<4));
}


/**
 * debug function
 *
 **/


#ifdef MOTOR_DEBUG

void Snootor::dump(){
  if(motor_state & MOTOR_MASK_1) {
    Serial.println("Motor nr 1");
    motors[0]-> dump();
  }
  if(motor_state & MOTOR_MASK_2) {
    Serial.println("Motor nr 2");
    motors[1]-> dump();
  }
  if(motor_state & MOTOR_MASK_3) {
    Serial.println("Motor nr 3");
    motors[2]-> dump();
  }
  if(motor_state & MOTOR_MASK_4) {
    Serial.println("Motor nr 4");
    motors[3]-> dump();
  }
  for(int i=0;i<4;i++){
    Serial.print("REG 0x");
    Serial.print(0x14+i,HEX);
    Serial.print(" - NR ");
    Serial.print(2*i+1,DEC);
    Serial.print(" - VAL 0x");
    Serial.print(pwm_state[2*i] ,HEX);
    Serial.print(" - NR ");
    Serial.print(2*i+2,DEC);
    Serial.print(" - VAL 0x");
    Serial.print(pwm_state[2*i+1] ,HEX);
    Serial.print(" - state 0x");
    Serial.println(pwm_state[2*i]+(pwm_state[2*i+1]<<4),HEX);
  }
}

#endif


/**
*
* Declaration of global object
*
**/

Snootor SC;
