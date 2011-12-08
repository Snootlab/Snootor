// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

#include <Wire.h>
#include <snootor.h>
#include <Deuligne.h>


SnootorStep M;
Deuligne lcd;


void setup(){
// Serial.begin(9600);
  Wire.begin();
  lcd.init();
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
  M.init(100,48,1,MOTOR_MODE_FULLSTEP);
}
void loop(){
  loop_delay();
}

void loop_next(){
  static int d;
  uint8_t i;
//  Serial.println("start fullstep mode...");
    M.forward(200  );
  for(i=1;i<200;i++){
    M.next();
    lcd.setCursor(0,0);
    lcd.print("nb ");
    lcd.print(i,DEC);
    lcd.print(" reg 0x");
    lcd.print(SC.getReg(),HEX);
    lcd.print("      ");
    lcd.setCursor(0,1);
    lcd.print("Steps/pos");
    lcd.print(getSteps(),DEC);
    lcd.print("/");
    lcd.print(M.getPosition(),DEC);
    lcd.print("      ");
}
    M.stop();
    lcd.setCursor(0,1);
    lcd.print("done ~");
  delay(2000);
    lcd.setCursor(0,1);

}

void loop_delay(){
  static int d;
  uint8_t i;
//  Serial.println("start fullstep mode...");
  for(i=1;i<24;i++){
    M.forward(200  );
    lcd.setCursor(0,0);
    SC.delay(5);
    lcd.print("nb ");
    SC.delay(5);
    lcd.print(i,DEC);
    SC.delay(5);
    lcd.print(" reg 0x");
    SC.delay(5);
    lcd.print(SC.getReg(),HEX);
    lcd.print("  ");
    SC.delay(5);
    lcd.setCursor(0,1);
    SC.delay(5);
    lcd.print("Step/pos ");
    SC.delay(5);
    lcd.print(getSteps(),DEC);
    SC.delay(5);
    lcd.print("/");
    SC.delay(5);
    lcd.print(M.getPosition(),DEC);
    lcd.print("  ");
    SC.delay(500);
    lcd.print("  ");
}
    M.stop();
    lcd.setCursor(0,1);
    lcd.print("done ~");
  delay(2000);
    lcd.setCursor(0,1);
    lcd.print("      ");

}
