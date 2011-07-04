
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
long left, center, right;


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
  //
  delay(1000);
  turnRight();
}




/*
lets slam this baby into high speed forward.
*/
void fwd_drive() {
    analogWrite(powerA, 255);
    digitalWrite(dir1PinA, LOW);
    digitalWrite(dir2PinA, HIGH);
}
/*
reverse? do we really need reverse?..
*/
void rev_drive() {
    analogWrite(powerA, 255);
    digitalWrite(dir1PinA, HIGH);
    digitalWrite(dir2PinA, LOW);
}
/* left/right */
void turnLeft() {
    analogWrite(powerB, 255);
    digitalWrite(dir1PinB, LOW);
    digitalWrite(dir2PinB, HIGH);
}

void turnRight() {
    analogWrite(powerB, 255);
    digitalWrite(dir1PinB, HIGH);
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
  left = microsecondsToCentimeters(pulseIn(echoL, HIGH,2000));

}
void centerdistance()
{
  delay(10);
  ping();
 center = microsecondsToCentimeters(pulseIn(echoC, HIGH,2000));
}
void rightdistance()
{
  delay(10);
  ping();
  right = microsecondsToCentimeters(pulseIn(echoR, HIGH, 2000));
}
/* got this from the bug bot by david */

void distance()
{
  leftdistance();
  centerdistance();
  rightdistance();
//
  Serial.print("LEFT: \t" );
  Serial.print(left, DEC);
  Serial.print("\t Center: \t");
  Serial.print(center, DEC);
  Serial.print("\t Right: \t");
  Serial.println(right,DEC);

}



long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
