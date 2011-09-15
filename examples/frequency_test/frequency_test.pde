// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

/*

 This sketch tests a configurable number of delay/frequency values applied to the stepper motor.
 Output on the serial console.

*/


#include <Wire.h>
#include <snootor.h>

#define FREQ_MIN 100 // minimal delay to test 
#define FREQ_STEP 50 // delta for each step
#define FREQ_COUNT 20 // number of loops to test

// e.g. will test delays 

SnootorStep M;

void setup(){
  Serial.begin(115200);
  Wire.begin();
  // parameters for init : delay in microseconds/steps per round/motor number (1 or 2)/ mode
  M.init(100,48,1, MOTOR_MODE_HALFSTEP);

//  M.init(100,48,2, MOTOR_MODE_FULLSTEP);
//  M.init(100,48,2, MOTOR_MODE_SIXWIRE);

}

void loop(){
  Serial.println("start loop...");
  for (long d=0;d<FREQ_COUNT;d++){
    Serial.print("Round ");
    Serial.println(d,DEC);
    Serial.print(" - frequence ");
    Serial.print(FREQ_MIN+d*FREQ_STEP,DEC);
    Serial.print(" - millis ");
    Serial.println(millis(),DEC);
    M.forward(576);
    while(!M.stopped()){
      SC.delay(200);
      SC.dump();
    }
    delay(2000);
    M.setDelay(FREQ_MIN+d*FREQ_STEP);
  }
}
