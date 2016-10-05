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
  Serial.print("\r\nmonome device connected!\r\n\n");
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
  
  // draw toggles with play bar
  byte highlight;
  for(byte x=0;x<16;x++) {
    if(x == play_position)
      highlight = 4;
    else
      highlight = 0;
      
    for(byte y=0;y<6;y++)
      monome.led_set(x,y,step[y][x] * 11 + highlight);
  }
  
  // draw trigger row and on-triggers
  for(byte x=0;x<16;x++)
    monome.led_set(x,6,4);
  for(byte y=0;y<6;y++)
    if(step[y][play_position] == 1)
      monome.led_set(y,6,15);
}

void next() {
  if(play_position == 15)
      play_position = 0;
  else 
      play_position++;
  
  // TRIGGER SOMETHING
  for(byte y=0;y<6;y++)
    if(step[y][play_position] == 1)
      trigger(y);
  
  dirty = true;
}

void trigger(byte i) {
   Serial.print(i);
}
