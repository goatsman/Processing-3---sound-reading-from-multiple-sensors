import ddf.minim.*; //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.serial.*;
import processing.sound.*;

Serial mySerialPort;       // Create object from Serial class
String serialPortData;     // Data received from the serial port

int time;                  // timer for synchronization of sensors
int wait = 5000;

int sensorsValues[] = {0, 0, 0, 0, 0, 0}; //values of sensors
//int sensorsMinValues[] = {1023,1023,1023,1023,1023,1023};
//int sensorsCompare[] = {0, 0, 0, 0, 0, 0};
int sensorsMinValues[] = {0,0,0,0,0,0};

int positionsX[] = { 10, 200, 400, 10,200, 400};
int positionsY[] = { 10, 10, 10, 200, 200, 2000};

int colours [] = {50, 70, 100, 150, 200, 250};

boolean looping[] = {false,false,false,false,false,false,};

Minim minim;
AudioPlayer samples[] = {null,null,null,null,null,null};
AudioPlayer base;

boolean beatLoop = false;

void setup() {
  size(600, 800);
  background(255);

  time = millis();

  mySerialPort = new Serial(this, Serial.list()[2], 9600);
  mySerialPort.bufferUntil('\n');
  
   //Load and play a soundfile and loop it
    minim = new Minim(this);
    
    base = minim.loadFile("beat.wav");
    
    samples[0] = minim.loadFile("sample6.wav");
    samples[1] = minim.loadFile("sample1.wav");
    samples[2] = minim.loadFile("sample2.wav");
    samples[3] = minim.loadFile("sample3.wav");
    samples[4] = minim.loadFile("sample4.wav");
    samples[5] = minim.loadFile("sample5.wav");
    
    //base.setVolume(0.5);
    
}

void draw() {
  
  //println(sensorsMinValues);

  if (millis() - time >= wait) {
    
    if(!beatLoop){
       base.loop();
       beatLoop = true;  
  }
    
    for (int i = 0; i < 6; i++) {
      if (sensorsValues[i] < sensorsMinValues[i]) {
        if(looping[i] == false){ 
          samples[i].loop();
          looping[i] = true;
        }
         //base.play();
      }else{ 
        samples[i].pause();
        looping[i] = false;
        //base.pause();
      }
    }
  }
}

void serialEvent(Serial mySerialPort) {
  
  String inString = mySerialPort.readStringUntil('\n');
  
   if (inString != null) {
    
    inString = trim(inString); 
    
    int[] serialDataArduino = int(split(inString, ",")); 
    
    //println(serialDataArduino);
    
    if (serialDataArduino.length >=6) {
  
      for (int i = 0; i<6; i++) {
        sensorsValues[i] = serialDataArduino[i];
       }
       
       int j = 0;
       
       for (int i = 6; i<12; i++) {
        sensorsMinValues[j] = serialDataArduino[i];
        j += 1;
       }
       
       j = 0;
       
       //println(sensorsMinValues);
       
        /*if (sensorsValues[i] < sensorsMinValues[i]) {
          sensorsMinValues[i] = sensorsValues[i];
      }*/
    
   }
  }
}