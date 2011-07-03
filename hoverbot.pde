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



void setup() {
  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(powerA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(powerB, OUTPUT);
  pinMode(rpin, OUTPUT);


}

void loop() {
  fwd_drive();
  Lift();

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
