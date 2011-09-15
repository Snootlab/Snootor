// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!
 
/*

   This sketch demonstrates how to address DC motors. It uses 2 motors, 
   but you can handle up to 4 motors using this library.

*/

// need to include this first
#include <Wire.h>

// this is the snootor library
#include <snootor.h>

// Declaration of 2 motor objects

SnootorDC Motor_1;
SnootorDC Motor_2;
int i;
void setup(){

// Initialization according to pins
Serial.begin(115200);
 Wire.begin();
  Motor_1.init(1);
  Motor_2.init(2);
	Serial.println("init ok");
}

void loop(){
  Serial.print("Round ");
  Serial.println(i++);
  SC.dump();
// run forward at maximal speed

  Motor_1.setSpeed(255);
  Motor_2.setSpeed(255);
  Motor_1.run(FORWARD);
  Motor_2.run(FORWARD);
  delay(2000);

// stop for 2 seconds
  Motor_1.run(RELEASE);
  Motor_2.run(RELEASE);
  delay(2000);

// run backward at maximal speed

  Motor_1.setSpeed(255);
  Motor_2.setSpeed(255);
  Motor_1.run(BACKWARD);
  Motor_2.run(BACKWARD);
  delay(2000);
}
