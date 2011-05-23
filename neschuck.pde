/*
   Reading a NES Controller

   Original code by:
   Sebastian Tomczak
   21 July 2007
   Adelaide, Australia

   Modified by:
   Joshua de Haan
   21 June 2009
   Landgraaf, The Netherlands
 */

/* INITIALISATION */

/*
   A5 - clock
   A4 - data
   A3 - VCC
   A2 - GND

   looking at connector with clip on top/up we have
   DAT --- VCC
   GND --- CLK

 */

#include <Wire.h>
#include "nunchuck_funcs.h"

int loop_cnt = 0;

byte joyx,joyy,zbut,cbut,roll,pitch,accx,accy,accz;
byte a,b,select,start,up,down,left,right;

int clock = 0; // set the clock pin (RED)
int latch = 1; // set the latch pin (ORANGE)
int data  = 4; // set the data pin (YELLOW)
//int A = 10;
//int B = 11;
//int UP = 9;
//int DOWN = 8;
//int LEFT = 7;
//int RIGHT = 6;

char controller_data[8];
int mode = 0;
int buttons[16];

void clockRising()
{
  switch(mode)
  {
    case 0: // pre-request
      digitalWrite(data, a);
      break;
    case 1: // B
      digitalWrite(data, b);
      break;
    case 2: // SELECT
      digitalWrite(data, select);
      break;
    case 3: // START
      digitalWrite(data, start);
      break;
    case 4: // UP
      digitalWrite(data, up);
      break;
    case 5: // DOWN
      digitalWrite(data, down);
      break;
    case 6: // LEFT
      digitalWrite(data, left);
      break;
    case 7: // RIGHT
      digitalWrite(data, right);
      break;
    case 8: // post-request
      digitalWrite(data, a);
      mode = 7;
      break;
  }  
  mode++;
}

void latchRising()
{
  mode = 1;
  // A button
  digitalWrite(data, a);
}


/* SETUP */
void setup()
{
  Serial.begin(115200);
  pinMode(latch,INPUT);
  pinMode(clock,INPUT);
  pinMode(data,OUTPUT);
  attachInterrupt(0, clockRising, RISING);
  attachInterrupt(1, latchRising, RISING);
  //pinMode(A,OUTPUT);
  //pinMode(B,OUTPUT);
  //pinMode(LEFT,OUTPUT);
  //pinMode(RIGHT,OUTPUT);
  //pinMode(UP,OUTPUT);
  //pinMode(DOWN,OUTPUT);

  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
}

/* PROGRAM */
void loop()
{
  //controllerRead();
  //for (int i = 0; i <= 7; i++){
  //  Serial.print(controller_data[i]);
  //  delayMicroseconds(200);
  //}
  //Serial.println('z');

  nunchuck_get_data();
  joyx  = nunchuck_joyx(); // ranges from approx 70 - 182
  joyy  = nunchuck_joyy(); // ranges from approx 65 - 173
  zbut = nunchuck_zbutton();
  cbut = nunchuck_cbutton();
  accx = nunchuck_accelx();
  accy = nunchuck_accely();
  accz = nunchuck_accelz();
  roll = nunchuck_roll();
  pitch = nunchuck_pitch();

  // A
  if(accy > 80 && cbut)
    a = LOW;
  else
    a = HIGH;

  // B
  if(accy > 80 && zbut)
    b = LOW;
  else
    b = HIGH;

  // SELECT
  if(accy <=80 && zbut)
    select = LOW;
  else
    select = HIGH;

  // START
  if(accy <=80 && cbut)
    start = LOW;
  else
    start = HIGH;

  // UP
  if(joyy>182)
    up = LOW;
  else
    up = HIGH;

  // DOWN
  if(joyy<89)
    down = LOW;
  else
    down = HIGH;

  // LEFT
  if(joyx<83)
    left = LOW;
  else
    left = HIGH;

  // RIGHT
  if(joyx>177)
    right = LOW;
  else
    right = HIGH;



  /*
  Serial.print("Joysticks: ");
  Serial.print(joyx,DEC);
  Serial.print(", ");
  Serial.print(joyy,DEC);
  Serial.print(", ");
  Serial.print("Buttons: ");
  Serial.print(zbut,DEC);
  Serial.print(", ");
  Serial.print(cbut,DEC);
  Serial.print(", ");
  Serial.print("Accel: ");
  Serial.print(accx,DEC);
  Serial.print(", ");
  Serial.print(accy,DEC);
  Serial.print(", ");
  Serial.print(accz,DEC);
  Serial.print(", ");
  Serial.print("Roll/Pitch: ");
  Serial.print(roll,DEC);
  Serial.print(", ");
  Serial.print(pitch,DEC);
  Serial.println();
  */


  //digitalWrite(A,!zbut);
  //digitalWrite(B,!cbut);

  //if(joyx<83)
  //  digitalWrite(LEFT,LOW);
  //else
  //  digitalWrite(LEFT,HIGH);

  //if(joyx>177)
  //  digitalWrite(RIGHT,LOW);
  //else
  //  digitalWrite(RIGHT,HIGH);

  //if(joyy>182)
  //  digitalWrite(UP,LOW);
  //else
  //  digitalWrite(UP,HIGH);

  //if(joyy<89)
  //  digitalWrite(DOWN,LOW);
  //else
  //  digitalWrite(DOWN,HIGH);

  //Serial.print("noob");
  //Serial.print((byte)joyy,DEC);
  //Serial.println();
  delay(10);
} 
