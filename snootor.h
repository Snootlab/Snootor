// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!



#ifndef TwoWire_h
#error "need to include Wire.h before snootor.h !"
#endif

#ifndef  __SNOOTOR_H
#define  __SNOOTOR_H

#define MAX_ADRESS 0x20 // address of max7313


/**
 *
 * snootor main header
 * 
 * #define MOTOR_DEBUG is in this header :
 *
 **/

#include "snootor_common.h"


/**
 *
 * snootor dc driver
 * 
 **/

#include "snootor_dc.h"

/**
 *
 * snootor stepper driver
 *
 **/

#include "snootor_step.h"


#endif

