// Snootlab Max 7313 Motor shield library
//
// Lightcar / Braitenberg example code
//
// Based on Adafruit Motor shield library
// https://github.com/adafruit/Adafruit-Motor-Shield-library
// copyleft Snootlab, 2011
// this code is public domain, enjoy!


#include <Wire.h>


#include <snootor.h>


// moves

#define LEFT_TURN 7
#define RIGHT_TURN 8
#define BLOCK_RIGHT 9
#define BLOCK_LEFT 10


// DC motor numbers
#define LEFT 2
#define RIGHT 1

// thresholds
#define LIGHTSENSORDIFF 200 // increment -> less sensible on light delta, less spinning


class LightCar {
  SnootorDC ML; // left
  SnootorDC MR; // right
 public:
  LightCar(){}

  void init(){
    int i;
    ML.init(LEFT);
    MR.init(RIGHT);
    for(int i=0;i<8;i++){
      SC.sendPWM(i+1,0);}
      /*
    setRGB(0,0,0);
    rightEye(0);
    heart(0);
    leftEye(0);
      */
  }

  LightCar* run(uint8_t direction){
    switch(direction){
    case FORWARD:
    case RELEASE:
    case BACKWARD:
      ML.run(direction);
      MR.run(direction);
    break;
    case LEFT_TURN:
      run(RELEASE);
      MR.run(FORWARD);
      ML.run(BACKWARD);
    break;
    case RIGHT_TURN:
      run(RELEASE);
      MR.run(BACKWARD);
      ML.run(FORWARD);
    break;
    case BLOCK_RIGHT:
      MR.run(RELEASE);
    break;
    case BLOCK_LEFT:
      ML.run(RELEASE);
    break;
    }
    return this;
  }


  LightCar* leftTurn(uint8_t angle){
    if(angle>511)angle=511;
    Serial.print("leftturn : ");
    Serial.println(angle,DEC);
    setLRSpeed(angle/8,-angle/8);
    /*
    ML.run(FORWARD)->setSpeed(192+angle/8);
    MR.run(BACKWARD)->setSpeed(192+angle/8);
    */
    leftEye(angle/48);
    rightEye(0);
    setRGB(0,0,0);
  }

  LightCar* rightTurn(uint8_t angle){
    if(angle>511)angle=511;
    Serial.print("rightturn : ");
    Serial.println(angle,DEC);
    setLRSpeed(-angle/8,angle/8);
    /*
    MR.run(FORWARD)->setSpeed(192+angle/8);
    ML.run(BACKWARD)->setSpeed(192+angle/8);
    */
    rightEye(angle/48);
    leftEye(0);
    setRGB(0,0,0);
  }

  LightCar* braitenBerg(){
    uint16_t lv,rv;
    rv=analogRead(1);
    lv=analogRead(0);
    Serial.print(" braitenberg : ");
    Serial.print(rv,DEC);
    Serial.print("/");
    Serial.println(lv,DEC);
    if(rv > LIGHTSENSORDIFF+lv) return rightTurn(rv-lv-LIGHTSENSORDIFF);
    if(lv > LIGHTSENSORDIFF+rv) return leftTurn(lv-rv-LIGHTSENSORDIFF);
    if(rv+lv > 1200) {
      Serial.print("release : ");
      Serial.println(rv+lv,DEC);
      setRGB(255,0,0);
      return run(RELEASE);
    }
    Serial.println("forward !");
    setLRSpeed(rv/16,lv/16);
    /*
    ML.setSpeed(192+rv/16);
    MR.setSpeed(192+lv/16);
    */
    setRGB(0,0,255);
    return run(FORWARD);
  }


  LightCar* setSpeed(uint8_t speed){

    ML.setSpeed(speed);
    MR.setSpeed(speed);
    return this;
  }


  LightCar* setLRSpeed(int16_t lspeed,int16_t rspeed){
    
    if(lspeed>0)ML.run(FORWARD);
    else ML.run(BACKWARD);
    if(rspeed>0)MR.run(FORWARD);
    else MR.run(BACKWARD);
    if(fabs(lspeed)>63)lspeed=63;
    if(fabs(rspeed)>63)rspeed=63;
    ML.setSpeed(192+fabs(lspeed));
    MR.setSpeed(192+fabs(rspeed));
    return this;
  }


  LightCar* delay(uint16_t ms){
    SC.delay(ms);
    return this;
  }

  // "controle technique :)"

  void checkWheels(){
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("left");
    ML.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
    Serial.println("right");
    MR.setSpeed(200)->run(FORWARD)->delay(2000);
    Serial.println("release");
    run(RELEASE)->delay(1000);
  }

  LightCar*  invert(uint8_t motor){
    switch(motor){
    case LEFT:
      ML.invert();
      break;
    case RIGHT:
      MR.invert();
      break;
    }
    return this;
  }
 
  void setRGB(uint8_t R,uint8_t G,uint8_t B){
    SC.sendPWM(1,R );
    SC.sendPWM(8,G);
    SC.sendPWM(2,B);
  }

  LightCar* rightEye(uint8_t V){
    SC.sendPWM(3,V); // ou 4
  }
  LightCar* leftEye(uint8_t V){
    SC.sendPWM(6,V);
  }
  LightCar* heart(uint8_t V){
    SC.sendPWM(4,V);
  }

  void readSensors(){
    Serial.print("Sensor reading: left ");
    Serial.print(analogRead(0),DEC);
    Serial.print(" ||  right ");
    Serial.print(analogRead(1),DEC);
  }
};


LightCar mycar;

void setup(){
  Serial.begin(115200);
  Wire.begin();
  mycar.init();
  mycar.setSpeed(0)->invert(RIGHT)->run(FORWARD);
}

void loop(){
  mycar.braitenBerg()->delay(100);
}
