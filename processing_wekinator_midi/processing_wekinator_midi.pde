// Sketch básico para trabajar con Wekinator
// Recibe clasificaciones de wekinator puerto 12000
// Convierte las clasificaciones a notas MIDI

// luiscript 2017

import oscP5.*;
import netP5.*;
import themidibus.*;

//el valor de las notas MIDI que se van a enviar
int[] notes = new int[] {0, 47, 49, 51}; 
int lastNote;

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
}

void draw() {
   background(0);
}

//recibimos un nuevo mensaje OSC
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/wek/outputs")){
    //el valor de la clasificación de wekinator 
    int value = (int) theOscMessage.get(0).floatValue();
    updateMidi(value);
  }
}

void updateMidi(int i){
  if(lastNote != notes[i]){
    myBus.sendNoteOff(1, lastNote, 127);
    myBus.sendNoteOn(1, notes[i], 127);
    lastNote = notes[i];
  }
}
    