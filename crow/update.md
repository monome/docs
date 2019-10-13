---
layout: page
permalink: /crow/update/
---

# Firmware Update

Flashing the crow requires setting up `dfu-util` on your laptop, downloading the new firmware, and getting crow connected in bootloader mode.

## Setup dfu-util

- Linux: `apt-get install dfu-util` (or similar)
- MacOS: install [homebrew](https://brew.sh) and then run `brew install dfu-util` from the command line.
- Windows: get a [win32 binary](http://dfu-util.sourceforge.net)

## Get new firmware

![](../images/crow-releases.png)

[https://github.com/monome/crow/releases](https://github.com/monome/crow/releases)

Download the `crow-vx.x.x.zip` file.


## Activate bootloader

With the crow connected to druid (or a similar utility) you can enter the bootloader with a `^^b` message, which will instantly reset the module and take you to the bootloader. `druid` will start printing `<lost connection>` at which point crow is ready to bootload, and you should quit `druid` with `q`.


## Forcing the bootloader

In case both the above doesn't work, you can manually force the bootloader to run by placing a jumper on the i2c header and restarting (power-cycling) crow.

The jumper should bridge between either of the centre pins to either of the
ground pins (i.e. the pins closest to the power connector, indicated by the
white stripe on the pcb). In a pinch you can hold a (!disconnected!) patch cable
to bridge the pins while powering on the case.

![](../images/crow-dfu.jpg)

## Flashing the update

From the Terminal (make sure you've quit `druid`), execute the `flash.sh` command which is included in the release .zip file. The actual firmware file that is uploaded is `crow.bin`.

For example if your file was extracted to `~/Downloads/crow-1.1.0` type this on the command line:

```console
cd ~/Downloads/crow-1.1.0
./flash.sh
```

**Having trouble using the `cd` command?**
  
- Mac: right click the unzipped `crow-vx.x.x` folder and then press the OPTION key. This will reveal a **Copy "crow-vx.x.x" as Pathname** action. Select it and then paste into terminal after `cd [spacebar]`.
- Windows: hold the SHIFT key and right click the unzipped `crow-vx.x.x` folder. This will reveal a **Copy as path** action. Select it and then paste into terminal after `cd [spacebar]`.
- Linux: right click the unzipped `crow-vx.x.x` folder and select "**Copy**". Then, simply **Paste** into terminal after `cd [spacebar]`.

After executing `./flash.sh`, you'll see something like:

```console
dfu-util 0.9

Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2016 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

dfu-util: Invalid DFU suffix signature
dfu-util: A valid DFU suffix will be required in a future dfu-util release!!!
Deducing device DFU version from functional descriptor length
Opening DFU capable USB device...
ID 0483:df11
Run-time device DFU version 011a
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 011a
Device returned transfer size 1024
DfuSe interface name: "Internal Flash   "
Downloading to address = 0x08020000, size = 290876
Download	[=========================] 100%       290876 bytes
Download done.
File downloaded successfully
```

## Troubleshooting

If you get an error: `dfu-util: No DFU capable USB device available` this means the bootloader is not running and connected to the laptop.

You can type `dfu-util -l` to list the connected bootloader devices.
