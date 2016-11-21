---
layout: page
permalink: /docs/setup/
---

# grid setup

### [download serialosc](https://github.com/monome/serialosc/releases/latest)

serialosc is the grid communication router. it runs in the background and converts serial communication (over USB) into [OSC](/docs/osc). applications can query serialosc to connect to the grid.

if you're using Windows or an older version of Mac OS (older than 10.9), you will need to manually install the [FTDI VCP driver](http://www.ftdichip.com/Drivers/VCP.htm) (*not* the D2XX driver).

if you have upgraded to Mac OS 10.11 from an earlier version and have the FTDI driver installed, you'll need to remove it. Open a terminal and type `sudo
rm -r /Library/Extensions/FTDIUSBSerialDriver.kext` and then reboot.

if you have a Mac OS version below 10.11 you'll need to install the FTDI driver. Apple's version on 10.9 and 10.10 are not good. [full guide here](http://www.ftdichip.com/Support/Documents/AppNotes/AN_134_FTDI_Drivers_Installation_Guide_for_MAC_OSX.pdf) but we really would simply suggest upgrading to Mac OS 10.11.

*linux users, see the [linux setup guide](/docs/linux).*

### getting started

* [monome sum](/docs/app/sum) is a all-in-one multi-application and the quickest way to get started.

* [max 7 monome package](/docs/app/package) is a collection of applications and tools for Max 7 which can be used with the free runtime.

* [monome terms](/docs/app/terms) is a series of grid-enabled Ableton Live devices.

see the [applications list](/docs/app) for several more.

### [help!](/docs/help)