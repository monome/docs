#include <Usb.h>  
#include "MonomeController.h"

USBHost usb;
MonomeController monome(usb);

byte step[6][16];
boolean dirty;
byte play_position;

unsigned long t = millis();
unsigned long interval = 200;

void GridKeyCallback(byte x, byte y, byte z) { 
  if(z == 1 && y < 6) {
    step[y][x] ^= 1;
    dirty = true; 
  }
}

void ConnectCallback(const char * name, byte cols, byte rows) {
  Serial.print("\r\nmonome device connected!");
}


void setup() { 
  monome.SetConnectCallback(&ConnectCallback);
  monome.SetGridKeyCallback(&GridKeyCallback);

  Serial.begin(115200);
  Serial.print("\r\ninitialized.\r\n");
  delay(200);
}

void loop() { 
  usb.Task();
  
  if(millis() - t > interval) {
    t = millis();
    next();
  }
  
  if(dirty) {
    redraw();
    monome.refresh();
    dirty = false;
  }
}

void redraw() {
  monome.led_clear();
  
  byte highlight;
  for(byte x=0;x<16;x++) {
    if(x == play_position)
      highlight = 4;
    else
      highlight = 0;
      
    for(byte y=0;y<6;y++)
      monome.led_set(x,y,step[y][x] * 11 + highlight);
  }
}

void next() {
  if(play_position == 15)
      play_position = 0;
  else 
      play_position++;
    
  dirty = true;
}
