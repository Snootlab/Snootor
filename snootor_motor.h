// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#ifndef  __SNOOTOR_MOTOR_H
#define  __SNOOTOR_MOTOR_H


#include <avr/io.h>
#include "snootor_defines.h"


/*
 *
 * SnootorMotor
 *
 * abstract motor interface
 *
 * provides common methods for each motor connected to the arduino
 *
 */


class SnootorMotor{
 public:
  SnootorMotor(){}

  virtual  uint16_t next(){} // checks if action is needed, otherwise  quits (for stepper)
  virtual  void stop(){} // stops motor
  virtual  void dump(){}; // debug information

};

#endif
