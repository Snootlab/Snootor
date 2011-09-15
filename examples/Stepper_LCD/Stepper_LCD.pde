// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!


/**
*
* Advanced usage : callbacks
*
* you can add a LCD display (using stock liquid crystal library)
* for fun (or debug information...)
*
* in this example, a callback function gets called by the scheduler 
* printing motor status information 
*
**/

#include <Wire.h>
#include <snootor.h>
#include <LiquidCrystal.h>

#define DELAY_MICROSECS 300

SnootorStep M1;

LiquidCrystal lcd(10, 9, 8, 7, 4, 2);

void setup(){
  Serial.begin(115200);
  Wire.begin();
  M1.init(100,48,1,MOTOR_MODE_HALFSTEP);
  SC.dump();
  M1.setDelay(500);
  pinMode(13, OUTPUT);     
  lcd.begin(16,2);
  SC.dump();
}

uint16_t callback(){
  lcd.setCursor(8,0);
  lcd.print("pos: ");
  lcd.print(M1.getPosition(),DEC);
  lcd.setCursor(0,1);
  lcd.print("togo: ");
  lcd.print(M1.getSteps(),DEC);
  return 30; // estimated time in microseconds
}

void loop(){
  M1.setCallback(callback);
  SC.dump();
  static int d;
  uint8_t i;
  M1.setMode(MOTOR_MODE_HALFSTEP);
  M1.setDelay(DELAY_MICROSECS);
  Serial.println("start half...");
  lcd.setCursor(0,0);
  lcd.print("Half");
  for (d=0;d<10;d++){
    M1.forward(48);
    SC.delay(2500);
    if(d%16==15)  digitalWrite(13, HIGH);   // set the LED on
    if(d%16==7)  digitalWrite(13, LOW);   // set the LED on
 
 }
  SC.delay(2000);
  M1.setDelay(DELAY_MICROSECS);
  M1.setMode(MOTOR_MODE_FULLSTEP);
  Serial.println("start full...");
  lcd.setCursor(0,0);
  lcd.print("Full");
  for (d=0;d<10;d++){
    M1.forward(10);
    SC.delay(2500);
    if(d%16==15)  digitalWrite(13, HIGH);   // set the LED on
    if(d%16==7)  digitalWrite(13, LOW);   // set the LED on
  }
  delay(2000);

}
