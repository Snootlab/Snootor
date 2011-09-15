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
  M.init();
}

void loop(){
  static int d;
  uint8_t i;
  M.setMode(MOTOR_MODE_HALFSTEP);
  M.setDelay(DELAY_MICROSECS);
//  Serial.println("start halfstep mode...");
  M.forward(480);
  SC.delay(2000);
  M1.setMode(MOTOR_MODE_FULLSTEP);
//  Serial.println("start fullstep mode...");
  M.forward(240);
  SC.delay(2500);
  delay(2000);

}
