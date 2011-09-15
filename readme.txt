Snootlab Max 7313 Motor shield library
Based on Adafruit Motor shield library
https://github.com/adafruit/Adafruit-Motor-Shield-library
copyleft Snootlab, 2011
this code is public domain, enjoy!




works for up to 2 stepper or 4 dc or 2 dc+1 stepper motors
-> care needed, you can declare invalid motors !!

identification is done by "motornumbers" passed to init() methods

pins/registers used : 

stepper 1:
pin 11/register 10  - coil "A"
pin  3/register 11   - coil "C"

stepper 2:
pin  6/register 13  - coil "A"
pin  5/register 12   - coil "C"

dc 1:
pin 11/register 10

dc 2:
pin 3/register 11

dc 3:
pin 5/register 12

dc 4:
pin 6/register 13

4Bit-pwm for extra slots : 

pwm1 : 0xF0 on register 14
pwm2 : 0x0F on register 14
pwm3 : 0xF0 on register 15
pwm4 : 0x0F on register 15
pwm5 : 0xF0 on register 16
pwm6 : 0x0F on register 16
pwm7 : 0xF0 on register 17
pwm8 : 0x0F on register 17


-----

basic use : 

* declare stepper/dc motor like this :

SnootorDC DC;
SnootorStep Step;

* init em (watch pins !!):

DC.init(1); 
Step.init(100,48,1, MOTOR_MODE_HALFSTEP);

* start : 

DC.setSpeed(42); // up to 255
DC.run(FORWARD);

Step.forward(48); // number of steps

* use, everywhere instead of delay() or delayMicroseconds() : 

SC.delay(); 

* stop all the motors : 

SC.stop();

* stop them 1 by one : 

DC.stop();
Step.stop();

* each class has a dump() method to give details about current motor status, when MOTOR_DEBUG is defined in snootor_common.h

