// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#include <Wire.h>
#include <snootor.h>
#include <LiquidCrystal.h>

SnootorStep step2;
SnootorDC dc2,dc3;
LiquidCrystal lcd(10, 9, 8, 7, 4, 2);

void setup(){
  Serial.begin(115200);
  Wire.begin();
  step2.init(100,48,2,MOTOR_MODE_FULLSTEP);
  dc2.init(2);
  dc3.init(1);
  SC.dump();
  step2.setDelay(500);
  pinMode(13, OUTPUT);     
  lcd.begin(16,2);
  SC.stop();
}

void loop(){
  SC.dump();
  static int d;
  uint8_t i,dc_speed;
  dc2.run(BACKWARD);
  dc3.run(BACKWARD);
  Serial.println("start half...");
  step2.setMode(MOTOR_MODE_HALFSTEP);
  step2.setDelay(400);
  lcd.setCursor(0,0);
  lcd.print("HalfBACK");
  for (d=0;d<48;d++){
    dc2.setSpeed(dc_speed);
    dc3.setSpeed(dc_speed+=4);
    step2.forward(10);
    for(i=0;i<10;i++){
/*
      lcd.setCursor(8,0);
      lcd.print("pos: ");
      lcd.print(step2.getPosition(),DEC);
      lcd.setCursor(0,1);
      lcd.print("togo: ");
      lcd.print(step2.getSteps(),DEC);
*/
      SC.delay(4);
    }
    if(d%16==15)  
      digitalWrite(13, HIGH);   // set the LED on
    if(d%16==7)  
      digitalWrite(13, LOW);   // set the LED on
    SC.sendPWM(1,d/3);
  }
  dc_speed=0;
  SC.stop();
  SC.dump();
  delay(2000);
  step2.setDelay(1000);
  step2.setMode(MOTOR_MODE_FULLSTEP);
  Serial.println("start full...");
  lcd.setCursor(0,0);
  lcd.print("Full for");
  dc2.run(FORWARD);
  dc3.run(FORWARD);
  for (d=0;d<48;d++){
    dc2.setSpeed(dc_speed);
    dc3.setSpeed(dc_speed+=4);
    step2.forward(10);
    for(i=0;i<10;i++){
/*
      lcd.setCursor(8,0);
      lcd.print("pos: ");
      lcd.print(step2.getPosition(),DEC);
      lcd.setCursor(0,1);
      lcd.print("togo: ");
      lcd.print(step2.getSteps(),DEC);

*/
      SC.delay(40);
    }
    if(d%16==15)  
      digitalWrite(13, HIGH);   // set the LED on
    if(d%16==7)  
      digitalWrite(13, LOW);   // set the LED on
    SC.sendPWM(1,d/3);
  }
  SC.stop();
  SC.dump();
  delay(2000);
}
