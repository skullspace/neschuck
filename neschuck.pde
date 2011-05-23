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
  if(mode > 0)
  {
    switch(mode)
    {
      case 1: // B
        if(accy > 80 && zbut)
        {
          //Serial.println("B");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 2: // SELECT
        if(accy <=80 && zbut)
        {
          //Serial.println("SELECT");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 3: // START
        if(accy <=80 && cbut)
        {
          //Serial.println("START");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 4: // UP
        if(joyy>182)
        {
          //Serial.println("UP");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 5: // DOWN
        if(joyy<89)
        {
          //Serial.println("DOWN");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 6: // LEFT
        if(joyx<83)
        {
          //Serial.println("LEFT");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
      case 7: // RIGHT
        if(joyx>177)
        {
          //Serial.println("RIGHT");
          digitalWrite(data, LOW);
        }
        else
          digitalWrite(data, HIGH);
        break;
    }  
    mode++;
    if(mode == 8)
    {
      mode = 0;  
    }
  }
}

void latchRising()
{
  mode = 1;
  // A button
  if(accy > 80 && cbut)
  {
    //Serial.println("A");
    digitalWrite(data, LOW);
  }
  else
    digitalWrite(data, HIGH);
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
  //delay(100);
} 
