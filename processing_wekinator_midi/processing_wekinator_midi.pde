// Sketch básico para trabajar con Wekinator
// Recibe clasificaciones de wekinator puerto 12000
// Convierte las clasificaciones a notas MIDI

// luiscript 2017

import oscP5.*;
import netP5.*;
import themidibus.*;

int[] notes;
boolean[] notesOn;

MidiBus myBus;
OscP5 osc;

void setup() {
  size(300,300);
  frameRate(20);
  
  //seleccionar bus MIDI válido
  MidiBus.list();
  myBus = new MidiBus(this, -1, "Bus 1");
  
  //recibir datos de wekinator puerto 12000
  osc = new OscP5(this, 12000);

  notesOn = new boolean[4];
  notesOn[0] = false;
  notesOn[1] = false;
  notesOn[2] = false;
  notesOn[3] = false;
  
  //el valor de las notas MIDI que se van a enviar
  notes = new int[4];
  notes[0] = 47;
  notes[1] = 47;
  notes[2] = 49;
  notes[3] = 51;
}

void draw() {
   background(0);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

//recibimos un nuevo mensaje OSC
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/wek/outputs")){
    //el valor de la clasificación de wekinator
    int value = (int) theOscMessage.get(0).floatValue();
   
    if(value < 4.0){
      if(!notesOn[value]){
        updateMidi(value);
      }
    }else {
      updateMidi(0);
    }
  }
}

void updateMidi(int i){
  myBus.sendNoteOn(1, notes[i], 127);
  
  notesOn[1] = i == 1;
  notesOn[2] = i == 2;
  notesOn[3] = i == 3;
  
  if(i == 0){
    myBus.sendNoteOff(1, notes[1], 127);
    myBus.sendNoteOff(1, notes[2], 127);
    myBus.sendNoteOff(1, notes[3], 127);
  } else if(i == 1){
    myBus.sendNoteOff(1, notes[2], 127);
    myBus.sendNoteOff(1, notes[3], 127);
  } else if(i == 2){
    myBus.sendNoteOff(1, notes[1], 127);
    myBus.sendNoteOff(1, notes[3], 127);    
  } else if(i == 3){
    myBus.sendNoteOff(1, notes[1], 127);
    myBus.sendNoteOff(1, notes[2], 127);
  }
}
    