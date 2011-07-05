/*
  this is my code.. nihaopaul @ gmail o com
  i will use it to win the race :D
*/


// motor forward/reverse
int dir1PinA = 13;
int dir2PinA = 12;
int powerA = 10;

// motor left/right
int dir1PinB = 11;
int dir2PinB = 8;
int powerB = 9;

// lift - controlls the transistor
int rpin = 2;

// ultrasonic sensors ping array..
// gets them all going and free's up a port
int trigger_pin = 3;

// ultrasonic sensor reply
int echoL = 4;
int echoC = 5;
int echoR = 6;

//store variables
int l, c, r;

//
  int min_distance = 20;
  int emergency_distance = 10;
  int max_distance = 50;


void setup() {
  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(powerA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(powerB, OUTPUT);
  //lift
  pinMode(rpin, OUTPUT);
  //make sure it's off to begin with
  digitalWrite(rpin, HIGH); 
  //ping send
  pinMode(trigger_pin, OUTPUT);
  //echo receive
  pinMode(echoL, INPUT);
  pinMode(echoC, INPUT);
  pinMode(echoR, INPUT);
  //
  Serial.begin(9600);
}

void loop() {
  //first lets populate all the distance sensors
  distance();
  
  driveLogic();
  delay(100);

}

void driveLogic() {
  /* 
   check left|center|right sensors to make sure we can go forward, 
   lets pick an obligatory number for distance, remember we can be polluted with a 0 answer.. 
   so if it's zero then assume to go forward, 
   should probably calculate a mean distance based on 3 samples
  */


  //some decissions will need to be made
  if (l > emergency_distance && c > emergency_distance && r > emergency_distance) {
    if(l > min_distance && c > min_distance && r > min_distance) {
      //keep on doing what you are doing :)
      return logic();
    } else {
      //min distance reached.. we need to work out which way to go.
      return logic();
    }
  } else {
    //emergency distance reached.. we need to stop and work out which way to go
    //AirBreak(); -- not going to work
    return logic();
  }
}
/*
logic missing:
  if we've just turn right or left, how do we set it back to straight? 
  what about % difference between left and right - as this makes sense to me.. 
  could we simplify our code if we done this?
  if we need to turn then we work out the percentage 0 50 100 and map this to max turning of our servo..
  need to swap the motor for a servo.
*/
void logic() {
      if (l>c && c>r) {
      //  turn left
        return turnLeft();
      }
      if (l<c && c>r) {
      //  forward
        return Straight();
      }
      if (l<c && c<r) {
      //  turn right
        return turnRight();
      }
      if (l>c && c<r) {
      //  (!left or right!) - we'll favour left for this race :-)
        return turnLeft();
      }
      if(l==c && c==r) {
       // forward
       //return fwdDrive();
       return Straight();
      }
      if (l==c && c<r) {
      //  turn right
        return turnRight();
      }
      if (l==c && c>r) {
      //  turn left
        return turnLeft();
      }
      if (l>c && c==r) {
      //  turn left
        return turnLeft();
      }
      if (l<c && c==r) {
      //  turn right
        return turnRight();
      }
}

/*
lets slam this baby into high speed forward.
*/
void cut() {
    analogWrite(powerA, 0);
    digitalWrite(dir1PinA, LOW);
    digitalWrite(dir2PinA, LOW);
}
void fwdDrive() {
    Lift();
    analogWrite(powerA, 255);
    digitalWrite(dir1PinA, LOW);
    digitalWrite(dir2PinA, HIGH);
}
/*
reverse? do we really need reverse?..
*/
void revDrive() {
    analogWrite(powerA, 255);
    digitalWrite(dir1PinA, HIGH);
    digitalWrite(dir2PinA, LOW);
}
/* left/right */
void turnLeft() {
   // fwdDrive();
    analogWrite(powerB, 255);
    digitalWrite(dir1PinB, LOW);
    digitalWrite(dir2PinB, HIGH);
}

void turnRight() {
    fwdDrive();
    analogWrite(powerB, 255);
    digitalWrite(dir1PinB, HIGH);
    digitalWrite(dir2PinB, LOW);
}

void Straight() {
    fwdDrive();
    analogWrite(powerB, 0);
    digitalWrite(dir1PinB, LOW);
    digitalWrite(dir2PinB, LOW); 
}
void Lift() {
    digitalWrite(rpin, LOW);
}
void AirBreak() {
  
    digitalWrite(rpin, HIGH);
}


/*                   *
 * *                   *
 * * * ultrasonic stuff  *
 * *                   *
 *                   */
void ping() 
{
  digitalWrite(trigger_pin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigger_pin, HIGH);
  delay(5);
  digitalWrite(trigger_pin, LOW);
}

void leftdistance()
{
  delay(10);
  ping();
  l = microsecondsToCentimeters(pulseIn(echoL, HIGH,2000));

}
void centerdistance()
{
  delay(10);
  ping();
  c = microsecondsToCentimeters(pulseIn(echoC, HIGH,2000));
}
void rightdistance()
{
  delay(10);
  ping();
  r = microsecondsToCentimeters(pulseIn(echoR, HIGH, 2000));
}
/* got this from the bug bot by david */

void distance()
{
  leftdistance();
  centerdistance();
  rightdistance();
//
  //lets cheat and set the max distance we'll record
  if (l > max_distance || l == 0) {
    l = max_distance;
  }
  if (c > max_distance || c == 0) {
    c = max_distance;
  }
  if (r > max_distance || r == 0) {
    r = max_distance;
  }
//
  Serial.print("LEFT: \t" );
  Serial.print(l, DEC);
  Serial.print("\t Center: \t");
  Serial.print(c, DEC);
  Serial.print("\t Right: \t");
  Serial.println(r,DEC);

}



long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
