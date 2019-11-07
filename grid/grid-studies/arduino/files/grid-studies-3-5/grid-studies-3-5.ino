#include <Usb.h>  
#include "MonomeController.h"

USBHost usb;
MonomeController monome(usb);

byte step[6][16];
boolean dirty;
byte play_position;
byte next_position;
boolean cutting;
byte keys_held, key_last;
byte loop_start, loop_end = 15;

unsigned long t = millis();
unsigned long interval = 200;


// SETUP //////////////////
void setup() { 
  monome.SetConnectCallback(&ConnectCallback);
  monome.SetGridKeyCallback(&GridKeyCallback);

  Serial.begin(115200);
  Serial.print("\r\ninitialized.\r\n");
  delay(200);
}

// KEY //////////////////
void GridKeyCallback(byte x, byte y, byte z) { 
  // toggle steps
  if(z == 1 && y < 6) {
    step[y][x] ^= 1;
    dirty = true; 
  }
  else if(y == 7) {
    // track number of keys held
    keys_held = keys_held + (z*2) - 1;
	    
    // cut
    if(z == 1 && keys_held == 1) {
      cutting = true;
      next_position = x;
      key_last = x;
    }
    // set loop points
    else if(z == 1 && keys_held == 2) {
      loop_start = key_last;
      loop_end = x;
    }
  }
}

// CONNECT //////////////////
void ConnectCallback(const char * name, byte cols, byte rows) {
  Serial.print("\r\nmonome device connected!\r\n\n");
}


// LOOP ////////////////// 
void loop() { 
  usb.Task();
  
  // check timer for next step
  if(millis() - t > interval) {
    t = millis();
    next();
  }
  
  // redraw if dirty
  if(dirty) {
    redraw();
    monome.refresh();
    dirty = false;
  }
}

// REDRAW ////////////////// 
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
      
  // draw playback position
  monome.led_set(play_position,7,15);
}

// NEXT ////////////////// 
void next() {
  if(cutting)
    play_position = next_position;
  else if(play_position == 15)
    play_position = 0;
  else if(play_position == loop_end)
    play_position = loop_start;
  else 
      play_position++;
  
  cutting = false;
  
  // TRIGGER SOMETHING
  for(byte y=0;y<6;y++)
    if(step[y][play_position] == 1)
      trigger(y);
  
  dirty = true;
}

// TRIGGER ////////////////// 
void trigger(byte i) {
   Serial.print(i);
}
