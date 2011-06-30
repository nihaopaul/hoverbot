// motor forward/reverse
int dir1PinA = 13;
int dir2PinA = 12;
int powerA = 10;

// motor left/right
int dir1PinB = 11;
int dir2PinB = 8;
int powerB = 9;

unsigned long time;
int speed;
int dir;

void setup() {
  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(powerA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(powerB, OUTPUT);

  time = millis();
  speed = 0;
  dir = 1;
}

void loop() {
  fwd_drive();
  /*  
  //analogWrite(powerB, 255);
  // set direction
  if (1 == dir) {
    fwd_drive();
    digitalWrite(dir1PinB, HIGH);
    digitalWrite(dir2PinB, LOW);
  } else {
    //rev_drive();
    digitalWrite(dir1PinB, LOW);
    digitalWrite(dir2PinB, HIGH);
  }
  if (millis() - time > 5000)  {
    time = millis();
    speed += 20;
    if (speed > 255) {
      speed = 0;
    }
    if (1 == dir) {
      dir = 0;
    } else {
      dir =1;
    }
  }
  */
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
