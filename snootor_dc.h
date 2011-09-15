/**
 * @file
 * @author ikujam@ikujam.org
 * @version 148
 * @section LICENSE
 * copyleft Snootlab, 2011
 * this code is public domain, enjoy!
 * @section DESCRIPTION
 * Snootlab Max 7313 Motor shield library
 * Based on Adafruit Motor shield library
 * https://github.com/adafruit/Adafruit-Motor-Shield-library
 *
*/

#include "snootor_defines.h"

#include "snootor_common.h"

#ifndef  __SNOOTOR_DC_H
#define  __SNOOTOR_DC_H



/**
 *  SnootorDC
 *
 * DC motor class
 *
 * strongly inspired from Lady Ada's code
 *
 */


class SnootorDC: public SnootorMotor{
 public:
  /**
   * Empty constructor
   */

  SnootorDC(void);
  ~SnootorDC(void);
  /**
   *  init
   *
   * @param motornum - PWM numerotation adafruit, 1->4, registry 0x10 -> 0x13
   * @param  freq - motorspeed (from adafruit library)
   */
  void init(uint8_t motornum, uint8_t freq =  MOTOR34_8KHZ);
  /** 
   * delay
   * "multitask" wrapper for SC.delay
   *
   * @param ms - time to wait
   *
   * @return - this, for chaining method calls
   *
   */
  SnootorDC* delay(uint16_t ms){SC.delay(ms);return this;} // 
  /**
   * run
   * 
   * @param run - sets direction - FORWARD, BACKWARD,RELEASE
   *
   * @return - this, for chaining method calls
   *
   */
  SnootorDC* run(uint8_t cmd);
  /**
   * run
   * 
   * @param run - sets direction - FORWARD, BACKWARD,RELEASE
   *
   * @return - this, for chaining method calls
   *
   */
  SnootorDC* setSpeed(uint8_t speed); // via PWM

  /**
   * invert
   * 
   * inverts the direction for this motor (FORWARD <=> BACKWARD)
   * for simplification
   *
   */
  void invert(){(inverted)?inverted=0: inverted=1;}
  /**
   * isInverted
   * 
   * checks if this motor is inverted
   *
   * @return 1 if inverted, 0 if not
   */
  uint8_t isInverted();
  /**
   * next
   *
   * does one "multitask" step, not used for DC motors
   *
   */

  uint16_t next(){return 0;} // -> SnootorMotor
  /**
   * dump
   * 
   * dumps motor state information if MOTOR_DEBUG define is active
   *
   */
#ifdef MOTOR_DEBUG
  void dump();
#else
  void dump(){} // noop
#endif
  /**
   * stop
   * 
   * stops this motor
   *
   */
  void stop(); // -> SnootorMotor
 private:
  uint8_t motornum;
  uint8_t registry;
  uint8_t motor_speed;
  uint8_t inverted;
};


#endif
