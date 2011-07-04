#include <Servo.h>

Servo front;
Servo back;
int center = 90;
int front_diff = 30;
int back_diff = 40;
int speed = 200;
int calibrated = 0;
int activated = 0;

int trigger_pin = 3;
int echo_pin = 2;

#define FRONT_LEFT (center - front_diff)
#define FRONT_RIGHT (center + front_diff)
#define BACK_LEFT (center - back_diff)
#define BACK_RIGHT (center + back_diff)

void setup()
{
  front.attach(5);
  back.attach(6);
  if (calibrated == 0) 
  {
    /*
      only needed to run once to make sure 
      we have the correct center and our servo was working correctly
      call calibrate();
      otherwise just set the center position
    */
    front.write(center);
    back.write(center);
    delay(800);
    calibrated = 1;
  } 
  Serial.begin(9600);

}

void loop()
{
  int dis, i;
  if (activated >= 1) 
  {
    move_forward(-10);  
    dis = get_distance();
    if (dis < 30)
    {
      for (i=0; i<10; ++i)
      {
        move_backward();
      }
    }
    Serial.println(dis, DEC);
  } else {
    dis = get_distance();
    if (dis < 10) {
      ++activated;
      delay(speed);
    }
  }

    

}

void move_forward(int angle)
{
  front.write(center);
  back.write(center);
  delay(speed);
  front.write(FRONT_LEFT);
  back.write(BACK_RIGHT + angle);
  delay(speed);
  front.write(center);
  back.write(center + angle);
  delay(speed);
  front.write(FRONT_RIGHT);
  back.write(BACK_LEFT - angle);
  delay(speed);
}

void calibrate()
{
  //reset, find the boundaries
  front.write(0);
  back.write(0);
  delay(1000);
  front.write(360);
  back.write(360); 
  delay(1000);
  front.write(center);
  back.write(center);
  delay(3000);
}

void move_backward()
{
  front.write(center);
  back.write(center);
  delay(speed);
  front.write(FRONT_LEFT);
  back.write(BACK_LEFT);
  delay(speed);
  front.write(center);
  back.write(center);
  delay(speed);
  front.write(FRONT_RIGHT);
  back.write(BACK_RIGHT);
  delay(speed);
}

int get_distance()
{
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is trigger_pined by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:

  digitalWrite(trigger_pin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigger_pin, HIGH);
  delayMicroseconds(5);
  digitalWrite(trigger_pin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(echo_pin, INPUT);
  duration = pulseIn(echo_pin, HIGH);

  // convert the time into a distance
  return microsecondsToCentimeters(duration);
}



long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}




