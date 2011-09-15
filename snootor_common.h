// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!


#include <inttypes.h>
#include <avr/io.h>

#ifndef  __SNOOTOR_COMMON_H
#define  __SNOOTOR_COMMON_H

// activates debug mode : 

//#define MOTOR_DEBUG

#include "snootor_motor.h"

/*
 * Snootor
 * 
 * Scheduler & i2c wrapper class
 *
 * - handles Max7313 initialization
 * - add motors to scheduler
 * - provides "delay(t)" wrapper for multitasking
 * - provides "pwm" wrapper to address available registers on max7313
 *
 */

class Snootor{
  SnootorMotor * motors[4]; // motors tracked by scheduler
  uint8_t maxstate; // max7313 init calls done ?
  uint8_t pwm_state[8]; // keep track of pwm state
  uint8_t motor_state; // bitmask for active motors
 public:
  void i2c(uint8_t,uint8_t); // i2c messages
  void i2c2(uint8_t,uint8_t,uint8_t,uint8_t); // i2c messages, two data bytes
  Snootor();
  ~Snootor(){}
  void delay(uint32_t); // scheduler
#ifdef MOTOR_DEBUG
  void dump(); // debug information for each motor
#else
  void dump(){} // debug information for each motor
#endif
  void stop(); // stop each motor
  void add( SnootorMotor*);
  void reset(){stop();motor_state=0;} // removes motors from scheduler
  void enableMax(); // MAX7313 initialization
  uint8_t isEnabled() {return (maxstate);}  // test MAX7313 state
  void sendPWM(uint8_t number,uint8_t value);// number : 1-8, value : 0-15
};


extern Snootor SC;

#endif
