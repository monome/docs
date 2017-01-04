---
layout: page
permalink: /docs/setup/
---

# grid and arc basic setup

### [&rarr; download serialosc](https://github.com/monome/serialosc/releases/latest)

serialosc runs in the background and converts serial communication (over USB) into [OSC](/docs/osc). applications can query serialosc to connect to the grid and arc.

**windows: manually install the [FTDI VCP driver](http://www.ftdichip.com/Drivers/VCP.htm) (*not* the D2XX driver)**

**linux: see the [linux setup guide](/docs/linux)**

## getting started

the [max 7 monome package](/docs/app/package) is a collection of applications and tools for Max 7 which can be used with the free runtime.

see the [applications list](/docs/app) for several more.

## [help!](/docs/help)

if you're using an older version of Mac OS older than 10.9, you will need to manually install the [FTDI VCP driver](http://www.ftdichip.com/Drivers/VCP.htm) (*not* the D2XX driver).

if you have upgraded to Mac OS 10.12 from an earlier version and have the FTDI driver installed, you'll need to remove it. Open a terminal and type `sudo rm -r /Library/Extensions/FTDIUSBSerialDriver.kext` and then reboot.