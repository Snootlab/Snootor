// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!


/*

sketch with one stepper motor, aiming to dod exactly one turn (and back)

*/

#include <Wire.h>
#include <snootor.h>

SnootorStep M;

void setup(){
  Serial.begin(115200);
  Wire.begin();
  M.init(100,48,2, MOTOR_MODE_FULLSTEP);
  M.setDelay(1000);
}

void loop(){
  static int d;
  Serial.print("start loop...");
  Serial.println(d++,DEC);
  Serial.println("fwd ");
  M.forward(480);
  while(!M.stopped()){
    SC.delay(200);
    SC.dump();
  }
  delay(2000);
  Serial.print("back ");
  Serial.println(d,DEC);
  M.back(480);
  while(!M.stopped()){
    SC.delay(200);
    SC.dump();
  }
  SC.stop();
  delay(200);

}
