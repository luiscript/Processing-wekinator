// Sketch básico para trabajar con Wekinator
// Envía 2 valores mouseX y mouseY por OSC
// Wekinator regresa la clasificación según el entrenamiento

// luiscript 2017

import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress wekinator;
color bg = color(0);

void setup() {
  size(800,800);
  frameRate(20);
  
  osc = new OscP5(this, 12000);
  wekinator = new NetAddress("localhost", 6448);
}

void draw() {
  background(bg);
}

void mousePressed(){
  sendOsc();
}

void sendOsc() {
  //enviar los valores a wekinator por medio de OSC
  OscMessage msg = new OscMessage("/wek/inputs");  
  msg.add((float) mouseX);
  msg.add((float) mouseY);
  osc.send(msg, wekinator);
}

void oscEvent(OscMessage theOscMessage) {
  //recibir la clasificación hecha por wekinator
  if(theOscMessage.checkAddrPattern("/wek/outputs")){
    float classification = theOscMessage.get(0).floatValue();
    //si la clase es 1, asignar color rojo
    if( classification == 1.0){
      bg = color(255,0,0);
    }
    //si la clase es 2, asignar color azul
    if( classification == 2.0){
      bg = color(0,0,255);
    }
  }
}