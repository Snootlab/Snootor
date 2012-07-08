// Snootlab Max 7313 Motor shield library
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011-2012
// this code is public domain, enjoy!



#include <Wire.h>
#include <snootor.h>

// moves

#define LEFT_TURN 7
#define RIGHT_TURN 8
#define BLOCK_RIGHT 9
#define BLOCK_LEFT 10
#define BLOCK_FRONT 11
#define BLOCK_REAR 12

#define FRONT_LEFT 3
#define FRONT_RIGHT 4
#define REAR_LEFT 1
#define REAR_RIGHT 2




class car {
  SnootorDC MFL; // front left
  SnootorDC MFR; // front right
  SnootorDC MRL; // rear left
  SnootorDC MRR; // rear right
 public:
  car(){}
  void init(){
    MFL.init(FRONT_LEFT);
    MFR.init(FRONT_RIGHT);
    MRL.init(REAR_LEFT);
    MRR.init(REAR_RIGHT);
  }
  car* run(uint8_t direction){
    switch(direction){
    case FORWARD:
    case RELEASE:
    case BACKWARD:
      MFL.run(direction);
      MFR.run(direction);
      MRL.run(direction);
      MRR.run(direction);
    break;
    case LEFT_TURN:
      run(RELEASE);
      MFL.run(FORWARD);
      MFR.run(BACKWARD);
      MRL.run(FORWARD);
      MRR.run(BACKWARD);
    break;
    case RIGHT_TURN:
      run(RELEASE);
      MFL.run(BACKWARD);
      MFR.run(FORWARD);
      MRL.run(BACKWARD);
      MRR.run(FORWARD);
    break;
    case BLOCK_RIGHT:
      MFR.run(RELEASE);
      MRR.run(RELEASE);
    break;
    case BLOCK_LEFT:
      MFL.run(RELEASE);
      MRL.run(RELEASE);
    break;
    case BLOCK_FRONT:
      MFR.run(RELEASE);
      MFL.run(RELEASE);
    break;
    case BLOCK_REAR:
      MRR.run(RELEASE);
      MRL.run(RELEASE);
    break;
    }
    return this;
  }

  car* accel(uint8_t direction,uint16_t msec, uint8_t maxspeed){
    return run(direction)-> setSpeed(40)->delay(500)->setSpeed(80)->delay(500)->setSpeed(160)->delay(500)->setSpeed(maxspeed)->delay(msec)->setSpeed(160)->delay(500)->setSpeed(120)->delay(500)->setSpeed(80)->delay(500)->setSpeed(40);
  }

  car* setSpeed(uint8_t speed){
    MFL.setSpeed(speed);
    MFR.setSpeed(speed);
    MRL.setSpeed(speed);
    MRR.setSpeed(speed);
    return this;
  }

  car* delay(uint16_t ms){
    SC.delay(ms);
    return this;
  }

  // "controle technique :)"

  void checkWheels(){
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("front left");
    MFL.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("front right");
    MFR.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("rear left");
    MRL.setSpeed(200)->run(FORWARD)->delay(2000);
    MRL.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("rear right");
    MRR.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
  }

  void invert(uint8_t motor){
    switch(motor){
    case FRONT_LEFT:
      MFL.invert();
      break;
    case FRONT_RIGHT:
      MFR.invert();
      break;
    case REAR_LEFT:
      MRL.invert();
      break;
    case REAR_RIGHT:
      MRR.invert();
      break;
    }
  }
};


car mycar;

void setup(){
  Serial.begin(115200);
  Serial.println("QQ");
  mycar.init();
  mycar.invert(FRONT_LEFT);
  mycar.invert(REAR_LEFT);
  Serial.println("QQ");
  SC.dump();
  mycar.checkWheels();
}

void loop(){
  mycar.checkWheels();
  //  accelloop();
}

void checkloop(){
  mycar.checkWheels();
}

void accelloop(){
  mycar.accel(FORWARD,2000,216);
  mycar.accel(BACKWARD,4000,216);
  mycar.accel(FORWARD,2000,216);
  mycar.accel(LEFT_TURN,2000,216);
  mycar.accel(FORWARD,2000,255);
  mycar.accel(BACKWARD,2000,255);
  mycar.accel(RIGHT_TURN,2000,255);
  mycar.accel(RIGHT_TURN,2000,192);
}
