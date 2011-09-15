#include "Wire.h"
#include "snootor.h"
#include <LiquidCrystal.h>

/*
	Sketch displaying state on LCD panel, displaying I²C delay between each operation
*/

#define DELAYTEST 2000

SnootorStep step2;
SnootorDC dc2,dc3;
LiquidCrystal lcd(10, 9, 8, 7, 4, 2);
uint32_t lasttime;


void setup(){
  Serial.begin(115200);
  Wire.begin();
  pinMode(13, OUTPUT);     
  lcd.begin(16,2);
  checkdelay();
}

void checkdelay(){
  Serial.println("empty controller");
  lcd.setCursor(0,0);
  TimerStart("empty controller");
  SC.delay(DELAYTEST);
  TimerEnd();
  Serial.println("1 DC initialized: ");
  dc2.init(1);
  TimerStart("1 DC initialized");
  SC.delay(DELAYTEST);
  TimerEnd();
  Serial.println("1 DC running : ");
  dc2.setSpeed(23);
  dc2.run(FORWARD);
  TimerStart("1 DC running    ");
  SC.delay(DELAYTEST);
  TimerEnd();
  SC.reset();
  SC.stop();
  step2.init(500,48,2,MOTOR_MODE_FULLSTEP);
  SC.stop();
  Serial.println("stepper initialized : ");
  TimerStart("1 stepper init");
  SC.delay(DELAYTEST);
  TimerEnd();
  Serial.println("stepper fullstepping : ");
  step2.forward(14400);
  TimerStart("stepper full    ");
  SC.delay(DELAYTEST);
  TimerEnd();
  SC.stop();
  Serial.println("stepper halfstepping : ");
  step2.forward(14400);
  TimerStart("stepper half    ");
  SC.delay(DELAYTEST);
  TimerEnd();
  SC.stop();
  step2.stop();
}

void TimerStart(const char*str){
  lcd.setCursor(0,0);
  lcd.print(str);
  lasttime=millis();
}


void TimerEnd(){
  uint32_t diff=millis()-lasttime;
  
  Serial.println("Timer : ");
  Serial.println(diff);
  lcd.setCursor(0,1);
  lcd.print(diff,DEC);
}

void loop(){
}
