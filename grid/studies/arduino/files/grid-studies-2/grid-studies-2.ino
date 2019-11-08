#include <Usb.h>  
#include "MonomeController.h"

USBHost usb;
MonomeController monome(usb);

void GridKeyCallback(byte x, byte y, byte z) { 
  Serial.print("\r\ngrid key: ");
  Serial.print(x);
  Serial.print(" , ");
  Serial.print(y);
  Serial.print(" : ");
  Serial.print(z);
  
  monome.led_set(x, y, z * 15);
  monome.refresh();
}

void ConnectCallback(const char * name, byte cols, byte rows) {
  Serial.print("\r\nmonome device connected; type: ");
  Serial.print(name);
  Serial.print(" ; columns: ");
  Serial.print(cols);
  Serial.print(" ; rows: ");
  Serial.print(rows);
  Serial.print("\r\n");
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
}
