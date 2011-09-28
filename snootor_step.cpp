/**
 * @file
 * @author ikujam@ikujam.org
 * @version 148
 *
 * @section LICENSE
 * copyleft Snootlab, 2011
 * this code is public domain, enjoy!
 *
 * @section DESCRIPTION
 * Snootlab Max 7313 Motor shield library
 * Based on Adafruit Motor shield library
 * https://github.com/adafruit/Adafruit-Motor-Shield-library
 *
 * SnootorStep
 *
 * Stepper motor class
 *
 * inspired from Lady Ada's code, rewritten from scratch
 *
 *
 * Notes :
 * - "halfstep" mode doubles steps per round (we're counting a step as the motor does them ~ )
 * - "speed" is specified as motorstepdelay, eg, delay between each step. different speeds can be achieved by varying this parameter, you'll need to find out your mileage ;)
 *
 */


#include "snootor_step.h"
#include "snootor_defines.h"

#include "Arduino.h"


  /**
   * empty constructor
   *
   */
 SnootorStep::SnootorStep(){
   callback=NULL;
 }

  /**
   * init
   * 
   * initialization of stepper motor
   *
   * @param motorstepdelay - delay in µs between each microstep (see example "frequency_test")
   * @param motorstepcount - number of steps for this motor
   * @param motornum - number of this motor (1-4)
   * @param motormode - halfstep or full step 
   *
   */
void SnootorStep::init(int motorstepdelay,int motorstepcount,int motornum, uint8_t motormode){
  pos=0;                                   // current step
  last_val= cur_val=0;                     // current / last coil position
  last_time=0;                    // last step done un microsecs
  steps_to_do=0;                           // requested steps
  motor_step_delay_microsecs=motorstepdelay;
  motor_step_count=motorstepcount;
  motor_mode=motormode;
  switch(motornum){
  case 1:
    motor_regA=M1regA;
    motor_regC=M1regC;
    motor_pinA=M1PWMPinA;
    motor_pinC=M1PWMPinC;
    break;
  case 2:
    motor_regA=M2regA;
    motor_regC=M2regC;
    motor_pinA=M2PWMPinA;
    motor_pinC=M2PWMPinC;
    break;
  }
  SC.delay(20);
  analogWrite(motor_pinA, 255);
  analogWrite(motor_pinC, 255);     
  SC.add(this);
  // -> remember to set other PWM to 0 !!
}



uint16_t SnootorStep::next(){
  if(steps_to_do==0){
    SC.i2c2(motor_regA,0x0,motor_regC,0x0); //A0,C0
    return I2C_MESSAGE_DELAY;
  }

  if (micros()>last_time+motor_step_delay_microsecs){
    if(steps_to_do>0){
      steps_to_do--;
      pos++;
    pos=(pos)%motor_step_count;
    }
    if(steps_to_do<0){
      steps_to_do++;
      if(pos==0)
	pos=motor_step_count-1;
      else
	pos--;
    }
    switch(motor_mode){
    case MOTOR_MODE_FULLSTEP:
		return fullstep();
      break;
    case MOTOR_MODE_HALFSTEP:
      return halfstep();
      break;
    case MOTOR_MODE_SIXWIRE:
      return sixwire();
      break;
    }
  }
  return 12;
}

uint16_t SnootorStep::fullstep(){
  cur_val=pos%4;
  if(last_val != cur_val){
    switch(last_val = cur_val){
    case 0:
      SC.i2c2(motor_regA,0xF0,motor_regC,0xF0); //C+,A+
      break;
    case 1:
      SC.i2c2(motor_regA,0x0F,motor_regC,0xF0); //C+,A-
      break;
    case 2:
      SC.i2c2(motor_regA,0x0F,motor_regC,0x0F); //C-,A- 
      break;
    case 3:
      SC.i2c2(motor_regA,0xF0,motor_regC,0x0F); //C-,A+
      break;
    }
    last_time=micros();
  }
  if(callback)
    return I2C_MESSAGE_DELAY+this->callback();
  return I2C_MESSAGE_DELAY;
}



uint16_t SnootorStep::sixwire(){
  cur_val=pos%4;
  if(last_val != cur_val){
    switch(last_val = cur_val){
    case 0:
      SC.i2c2(motor_regA,0xF0,motor_regC,0x0F); //C-,A+
      break;
    case 1:
      SC.i2c2(motor_regA,0xF0,motor_regC,0xF0); //C+,A+
      break;
    case 2:
      SC.i2c2(motor_regA,0x0F,motor_regC,0xF0); //C+,A- 
      break;
    case 3:
      SC.i2c2(motor_regA,0x0F,motor_regC,0x0F); //C-,A-
      break;
    }
    last_time=micros();
  }
  if(callback)
    return I2C_MESSAGE_DELAY+this->callback();
  return I2C_MESSAGE_DELAY;
}



uint16_t SnootorStep::halfstep(){
  cur_val=pos%8;

  if(last_val != cur_val){
    switch(last_val = cur_val){
      
    case 0:
      SC.i2c2(motor_regA,0x0,motor_regC,0xF0); //A0,C+
      break;
    case 1:
      SC.i2c2(motor_regA,0x0F,motor_regC,0xF0); //C,+A-
      break;
      
    case 2:
      SC.i2c2(motor_regA,0x0F,motor_regC,0x0); //C0,A-
      break;
      
      
    case 3:
      SC.i2c2(motor_regA,0x0F,motor_regC,0x0F); //C-,A-
      break;
    case 4:
      SC.i2c2(motor_regA,0x0,motor_regC,0x0F); //C-,A0
      break;
      
    case 5:
      SC.i2c2(motor_regA,0xF0,motor_regC,0x0F); //C-,A+
      break;
    case 6:
      SC.i2c2(motor_regA,0xF0,motor_regC,0x0); //C0,A+
      break;
    case 7:
      SC.i2c2(motor_regA,0xF0,motor_regC,0xF0); //C+,A+
      break;
      
    }
    last_time=micros();
  } 
  if(callback)
    return I2C_MESSAGE_DELAY+this->callback();
  return I2C_MESSAGE_DELAY;
}


void SnootorStep::goTo(int pos_to_go){
  steps_to_do=pos_to_go-pos;
}

void SnootorStep::forward(uint32_t steps){
  steps_to_do=steps;
}

void SnootorStep::back(uint32_t steps){
  steps_to_do=-steps;
}

void SnootorStep::stop(){
      SC.i2c(motor_regA,0x0); //A0
      SC.i2c(motor_regC,0x0); //C0
  steps_to_do=0;
}

#ifdef MOTOR_DEBUG
void SnootorStep::dump(){
  Serial.println("SnootorStep Motor state : ");
  Serial.print("motor_step_delay_microsecs: ");
  Serial.print(  motor_step_delay_microsecs,DEC);
  Serial.print(" motor_step_count: ");
  Serial.print(  motor_step_count,DEC);
  Serial.print(" motor_regA : ");
  Serial.print(motor_regA,DEC);
  Serial.print(" motor_regC : ");
  Serial.print(motor_regC,DEC);
  Serial.print(" motor_pinA : ");
  Serial.print(motor_pinA,DEC);
  Serial.print(" motor_pinC : ");
  Serial.print(motor_pinC,DEC);
  Serial.print(" pos : ");
  Serial.print(pos,DEC);
  Serial.print(" last_val : ");
  Serial.print(last_val,DEC);
  Serial.print(" cur_val : ");
  Serial.print(cur_val,DEC);
  Serial.print(" last_time : ");
  Serial.print(last_time,DEC);
  Serial.print(" steps_to_do : ");
  Serial.println(steps_to_do,DEC);
}

#endif


