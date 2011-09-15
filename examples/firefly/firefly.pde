// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!

// configuration

#define FIREFLY_DC_LEFT 1
#define FIREFLY_DC_RIGHT 2

#define FIREFLY_SENSOR_LEFT A0
#define FIREFLY_SENSOR_RIGHT A1

#define LCD_DEBUG 1

#define DIR_STOP 0
#define DIR_FWD_LEFT 1
#define DIR_FWD_RIGHT 2
#define DIR_FULL_LEFT 3
#define DIR_FULL_RIGHT 4
#define DIR_FORWARD 5


// Speed for DC motors (0-255)

#define LEFT_SPEED 180 
#define RIGHT_SPEED 180


// --------- CODE

#include <Wire.h>
#include <snootor.h>

#ifdef LCD_DEBUG
#include <LiquidCrystal.h>
LiquidCrystal lcd(10, 9, 8, 7, 4, 2);
#endif

class firefly {

  SnootorDC L; // left
  SnootorDC R; // right
  unsigned int direction;
  unsigned int right_light;
  unsigned int left_light;
  unsigned int last_right_light;
  unsigned int last_left_light;


  void read_sensors(){
    last_left_light=left_light;
    last_right_light=right_light;
    left_light=analogRead(FIREFLY_SENSOR_LEFT);
    right_light=analogRead(FIREFLY_SENSOR_RIGHT);
    if(left_light > last_left_light && left_light > last_left_light ){
      direction=RELEASE;
#ifdef LCD_DEBUG

    update_lcd();
#endif
    return;
    }
    last_left_light++;
    last_right_light++;
    int diff=- left_light + right_light;
    if(diff < - 512){
      direction= DIR_FULL_RIGHT;
    }
    else {
      if(diff < - 256){
	direction= DIR_FWD_RIGHT;
      }
      else {
	if(diff < 256){
	  direction= DIR_FORWARD;
	}
	else {
	  if(diff < 512){
	    direction= DIR_FWD_LEFT;
	  }
	  else {
	    direction= DIR_FULL_LEFT;
	  }
	}
      }
    }
#ifdef LCD_DEBUG

    update_lcd();
#endif
  }

 public:
  void init(){
    L.init(FIREFLY_DC_LEFT);
    R.init(FIREFLY_DC_RIGHT);
    L.setSpeed(LEFT_SPEED);
    R.setSpeed(RIGHT_SPEED);
    direction=0;
#ifdef LCD_DEBUG
    Serial.begin(115200);
    lcd.begin(16,2);
    lcd.setCursor(0,0);
    lcd.print("Firefly Example");
    update_lcd();
#endif
  }

  void run(){
    read_sensors();
    switch(direction){
    case DIR_STOP:
      L.run(RELEASE);
      R.run(RELEASE);
      break;
    case DIR_FWD_LEFT:
      L.run(FORWARD);
      R.run(RELEASE);
      break;
    case DIR_FWD_RIGHT:
      L.run(RELEASE);
      R.run(FORWARD);
      break;
    case DIR_FULL_LEFT:
      R.run(BACKWARD);
      L.run(FORWARD);
      break;
    case DIR_FULL_RIGHT:
      L.run(BACKWARD);
      R.run(FORWARD);
      break;
    case DIR_FORWARD:
      L.run(FORWARD);
      R.run(FORWARD);
      break;

    }
  }

#ifdef LCD_DEBUG
  void update_lcd(){
    Serial.println("update_lcd");
    lcd.setCursor(0,1);
    lcd.print("               ");
    lcd.setCursor(0,1);
    switch(direction){
    case 0: 
      lcd.print("STOP ");
      break;
    case 1: 
      lcd.print("LEFT ");
      break;
    case 2: 
      lcd.print("RIGHT");
      break;
    case 3: 
      lcd.print("L+R- ");
      break;
    case 4: 
      lcd.print("L-R+ ");
      break;
    case 5: 
      lcd.print("FOR  ");
      break;
    }
    lcd.print("L");
    lcd.print(left_light,DEC);
    lcd.print("R");
    lcd.print(right_light,DEC);
  }
#endif
  
};
firefly F;

void setup(){

  F.init();
}

void loop(){
  F.run();
  SC.delay(500);
}
