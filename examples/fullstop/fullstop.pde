#define FRONT_LEFT 1
#define FRONT_RIGHT 2
#define REAR_LEFT 3
#define REAR_RIGHT 4

#include <Wire.h>
#include <snootor.h>

void loop(){}
void setup(){
  SnootorDC MFL; // front left
  SnootorDC MFR; // front right
  SnootorDC MRL; // rear left
  SnootorDC MRR; // rear right
  MFL.init(FRONT_LEFT);
  MFR.init(FRONT_RIGHT);
  MRL.init(REAR_LEFT);
  MRR.init(REAR_RIGHT);
  SC.stop();
}
