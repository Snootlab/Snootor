Snootlab Max 7313 Motor shield library
Based on Adafruit Motor shield library
https://github.com/adafruit/Adafruit-Motor-Shield-library
copyleft Snootlab, 2011
this code is public domain, enjoy!




works for up to 2 stepper or 4 dc or 2 dc+1 stepper motors
-> care needed, you can declare invalid motors !!

identification is done by "motornumbers" passed to init() methods

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

