// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#ifndef  __SNOOTOR_DEFINES_H
#define  __SNOOTOR_DEFINES_H




// Controller configuration

#define MOTOR_MICRO_DELAY 64 // microsec "scheduler" interval
#define I2C_MESSAGE_DELAY 480 // microsec I2C message duration


//bit mask to track which motors are initialized

#define MOTOR_MASK_1 1 // Motor 1
#define MOTOR_MASK_2 2 // Motor 2
#define MOTOR_MASK_3 4 // Motor 3
#define MOTOR_MASK_4 8 // Motor 4


// motor speeds (from adafruit motor shield library)

#define MOTOR12_64KHZ _BV(CS20)  // no prescale
#define MOTOR12_8KHZ _BV(CS21)   // divide by 8
#define MOTOR12_2KHZ _BV(CS21) | _BV(CS20) // divide by 32
#define MOTOR12_1KHZ _BV(CS22)  // divide by 64

#define MOTOR34_64KHZ _BV(CS00)  // no prescale
#define MOTOR34_8KHZ _BV(CS01)   // divide by 8
#define MOTOR34_1KHZ _BV(CS01) | _BV(CS00)  // divide by 64


// directions for DC Motor
#define RELEASE 0
#define FORWARD 1
#define BACKWARD 2



// Stepper

#define MOTOR_MODE_HALFSTEP 2 // Half-step mode
#define MOTOR_MODE_FULLSTEP 1 // Full-step mode
#define MOTOR_MODE_SIXWIRE  3 // Six wire stepper


// Stepper Motor 1

#define M1PWMPinA  11
#define M1PWMPinC 3
#define M1regA  0x10 // Max7313 registry A 
#define M1regC  0x11 // Max7313 registry C

// StepperMotor 2

#define M2PWMPinA 6
#define M2PWMPinC 5
#define M2regA  0x13 // Max7313 registry A 
#define M2regC  0x12 // Max7313 registry C




#endif
