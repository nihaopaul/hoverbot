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


void setup() {
  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(powerA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(powerB, OUTPUT);
  pinMode(rpin, OUTPUT);
  //ping send
  pinMode(trigger_pin, OUTPUT);
  //echo receive
  pinMode(echoL, INPUT);
  pinMode(echoC, INPUT);
  pinMode(echoR, INPUT);
  //
  Serial.begin(115200);

}

void loop() {
  int dis;
  //
  fwd_drive();
  Lift();

  dis = get_distance();


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

void Lift() {
    digitalWrite(rpin, LOW);
}
void AirBreak() {
    digitalWrite(rpin, HIGH);
}




/* got this from the bug bot by david */

int get_distance()
{
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long left, right, center, inches, cm;

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
  
  left = pulseIn(echoL, HIGH);
  center = pulseIn(echoC, HIGH);
  right = pulseIn(echoR, HIGH);

//
  Serial.print("LEFT: \t" );
  Serial.print(left, DEC);
  Serial.print("\t Center: \t");
  Serial.print(center, DEC);
  Serial.print("\t Right: \t");
  Serial.println(right,DEC);
//  Serial.println(left, DEC);
//    Serial.println(center, DEC);
//      Serial.println(right, DEC);
//
  // convert the time into a distance
  return microsecondsToCentimeters(center);
}



long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
