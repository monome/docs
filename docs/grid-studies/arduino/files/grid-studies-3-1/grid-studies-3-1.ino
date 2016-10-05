#include <Usb.h>  
#include "MonomeController.h"

USBHost usb;
MonomeController monome(usb);

byte step[6][16];
boolean dirty;

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
  
  if(dirty) {
    redraw();
    monome.refresh();
    dirty = false;
  }
}

void redraw() {
  monome.led_clear();
  for(int y=0;y<6;y++)
    for(int x=0;x<16;x++)
      monome.led_set(x,y,step[y][x] * 11);
}
