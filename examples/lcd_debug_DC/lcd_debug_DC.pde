// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#include <Wire.h>
#include <snootor.h>
#include <Deuligne.h>

#define DO_M1 1
#define DO_M2 1
#define DO_M3 1
#define DO_M4 1

SnootorDC M1, M2, M3, M4;

Deuligne lcd;


void setup(){
// Serial.begin(9600);
  Wire.begin();
  lcd.init();
if(DO_M1)  M1.init(1);
if(DO_M2)   M2.init(2);
if(DO_M3)   M3.init(3);
if(DO_M4)   M4.init(4);
if(DO_M1)  M1.setSpeed(255);
if(DO_M2)   M2.setSpeed(255);
if(DO_M3)   M3.setSpeed(255);
if(DO_M4)   M4.setSpeed(255);
  lcd.setCursor(0,0);
  lcd.print("init ok");
}
void loop(){
  loop_next();
}

void loop_next(){
  static int d;
  uint8_t i;
if(DO_M1)     M1.run(FORWARD);
if(DO_M2)     M2.run(FORWARD);
if(DO_M3)     M3.run(FORWARD);
if(DO_M4)     M4.run(FORWARD);
    lcd.setCursor(0,0);
    lcd.print("M1 FW - M2 FW ");
    lcd.print(SC.getReg(),HEX);
    lcd.print("  ");
    lcd.setCursor(0,1);
    lcd.print("RUN1 : ");
    lcd.print(SC.getReg(),BIN);
    lcd.print("  ");
    delay(2000);
    SC.stop();
    lcd.setCursor(0,0);
    lcd.print("M1 RL - M2 RL ");
    lcd.print(SC.getReg(),HEX);
    lcd.print("  ");
    lcd.setCursor(0,1);
    lcd.print("STOP : ");
    lcd.print(SC.getReg(),BIN);  delay(2000);
if(DO_M1)     M1.run(FORWARD);
if(DO_M2)     M2.run(BACKWARD);
if(DO_M3)     M3.run(FORWARD);
if(DO_M4)     M4.run(BACKWARD);
    lcd.setCursor(0,0);
    lcd.print("M1 FW - M2 BW ");
    lcd.print(SC.getReg(),HEX);
    lcd.print("  ");
    lcd.setCursor(0,1);
    lcd.print("RUN2 : ");
    lcd.print(SC.getReg(),BIN);
    lcd.print("  ");
    delay(2000);
    SC.stop();
}

void lcd_dump(const char* msg){
    lcd.setCursor(0,0);
    lcd.print("cfg:");
if(DO_M1)    lcd.print(" 1");
if(DO_M2)    lcd.print(" 2");
if(DO_M3)    lcd.print(" 3");
if(DO_M4)    lcd.print(" 4");
    lcd.print(" x");

    lcd.print(SC.getReg(),HEX);
    lcd.setCursor(0,1);
    lcd.print(msg);
    lcd.print(" : ");
    lcd.print(SC.getReg(),BIN);  delay(2000);
}
