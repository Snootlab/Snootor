// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#include <Wire.h>
#include <snootor.h>


SnootorStep M;


void setup(){
// Serial.begin(9600);
  Wire.begin();

/*
 * Stepper initialization : 
 *
 * init(delay,stepcount,motornum, mode);
 *
 * where : 
 * 
 * * delay is the time between each basic step, in microseconds, which determines the motor speed
 * * stepcount is the number of steps per turn
 * * motornum is 1 or 2, depending wiring
 * * mode is either MOTOR_MODE_HALFSTEP or MOTOR_MODE_FULLSTEP
 */
  M.init(100,48,1,MOTOR_MODE_HALFSTEP);
}

void loop(){
  static int d;
  uint8_t i;
  M.setMode(MOTOR_MODE_HALFSTEP);
//  Serial.println("start halfstep mode...");
  M.forward(480);
  SC.delay(2000);
  M.setMode(MOTOR_MODE_FULLSTEP);
//  Serial.println("start fullstep mode...");
  M.forward(240);
  SC.delay(2500);
  delay(2000);

}
