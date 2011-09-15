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


#ifndef  __SNOOTOR_STEP_H
#define  __SNOOTOR_STEP_H


#include "snootor_common.h"
#include "snootor_motor.h"
/**
 *
 */

class SnootorStep : public SnootorMotor{
  unsigned int motor_step_delay_microsecs;    // delay between steps
  unsigned int motor_step_count;              // steps per round of motor
  uint8_t motor_mode;              // steps per tour of motor
  uint8_t motor_regA;
  uint8_t motor_regC;        // max registry for motor
  uint8_t motor_pinA;
  uint8_t motor_pinC;        // pwm pins for motor
  uint8_t pos;                                   // current step of the motor
  uint8_t last_val, cur_val;                     // current / last coil position
  unsigned long last_time;                    // last step done un microsecs
  long steps_to_do;                           // requested steps
  uint16_t (*callback)();

 public:
  /**
   * empty constructor
   *
   */
  SnootorStep(void);
  /**
   * empty destructor
   *
   */
  ~SnootorStep(void){}
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
  void init(int motorstepdelay,int motorstepcount,int motornum, uint8_t motormode);//  motorstepdelay, motorstepcount, motornum, motormode
  /**
   * next
   *
   *  scheduling via SnootorMotor
   *
   */
  uint16_t next(void);
  /**
   * goTo
   * 
   * attain specified position 
   *
   */
  void goTo(int);
  /** 
   * forward
   *
   * step forward
   * 
   * @param steps to go forward
   *
   */
  void forward(uint32_t steps); // step forward
  /** 
   * back
   *
   * step backward
   * 
   * @param steps to go backward
   *
   */
  void back(uint32_t steps);// step backward
  /**
   * dump
   * 
   * dumps motor state information if MOTOR_DEBUG define is active
   *
   */
#ifdef MOTOR_DEBUG
  void dump(void);
#else
  void dump(){} // noop
#endif
  /**
   * stop
   * 
   * stops this motor
   *
   */
  void stop(void);// -> SnootorMotor, halt motor
  /**
   * stopped
   * 
   * @return true if motor is stopped, 0 otherwise
   *
   */
  uint8_t stopped(void){return (steps_to_do==0);}
  /**
   * getSteps
   * 
   * @return number of steps to do
   *
   */
  long getSteps(void){return (steps_to_do);}
  /**
   * getPosition
   * 
   * @return current position
   *
   */
  uint8_t getPosition(void){return (pos);}
  /**
   * setDelay
   * 
   * @param delay - delay in µs between each microstep (see example "frequency_test")
   *
   */
  void setDelay(unsigned int delay){motor_step_delay_microsecs=delay;} // delay between each i2c message
  void setRPM(unsigned long rpm){motor_step_delay_microsecs=rpm/(4*motor_step_count);} // speed in RPM
  /**
   * setMode
   * 
   * @param motormode - halfstep or full step 
   *
   */
  void setMode(unsigned int mode){motor_mode=mode;} // MOTOR_MODE_HALFSTEP or MOTOR_MODE_FULLSTEP
  /**
   * setCallback
   * 
   * allows to call a function after each step
   *
   * !!! CARFUL - for advanced users only !!! 
   *
   * @param cb - function to run, no parameters, expected to return the approximative expected execution time of the function in µs
   *
   */
  void setCallback(  uint16_t (*cb)()){callback=cb;}
  
 private:
  uint16_t fullstep(void);
  uint16_t halfstep(void);
  uint16_t sixwire(void);
};

#endif
