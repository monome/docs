---
layout: default
parent: crow
title: update
nav_order: 3
permalink: /crow/update/
---

# Firmware Update

New firmware can be checked and installed now through druid. Make sure you have the [latest version](https://monome.org/docs/crow/druid/#update) which supports this feature.

With crow connected to your computer, open a terminal and execute:

```
druid firmware
```

You should see something like this:

```
Checking for updates...
>> git version 2.2.0
>> local version:  2.0.0
Downloading new version: https://github.com/monome/crow/releases/download/v2.2.0/crow.dfu
Crow bootloader enabled.
File: crow.dfu
    b'DfuSe' v1, image size: 304605, targets: 1
    b'Target' 0, alt setting: 0, name: "ST...", size: 304320, elements: 1
      0, address: 0x08020000, size: 304312
    usb: 0483:df11, device: 0x0000, dfu: 0x011a, b'UFD', 16, 0x03737ae6
Writing memory...
0x08020000  304312 [=========================] 100% 
Exiting DFU...
Update complete.
```

## Version

To check the current version inside of druid, type `^^version` into the command line.

## Manual Firmware Upate

If you have trouble updating, see the [manual firmware update](/docs/crow/manual-update).
