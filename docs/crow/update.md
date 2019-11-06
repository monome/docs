---
layout: page
permalink: /crow/update/
---

# Firmware Update

Flashing the crow requires setting up `dfu-util` on your laptop, downloading the new firmware, and getting crow connected in bootloader mode.

## Setup dfu-util<a name="setup"></a>

- Linux: `apt-get install dfu-util` (or similar)
- MacOS: install [homebrew](https://brew.sh) and then run `brew install dfu-util` from the command line.
- Windows: get a [win32 binary](http://dfu-util.sourceforge.net)

## Get new firmware

![](../images/crow-releases.png)

[https://github.com/monome/crow/releases](https://github.com/monome/crow/releases)

Download the `crow-vx.x.x.zip` file.


## Activate bootloader

With the crow connected to druid (or a similar utility) you can enter the bootloader with a `^^b` message, which will instantly reset the module and take you to the bootloader. `druid` will start printing `<crow disconnected>` at which point crow is ready to bootload, and you should quit `druid` with `q`.


## Forcing the bootloader

In case both the above doesn't work, you can manually force the bootloader to run by placing a jumper on the i2c header and restarting (power-cycling) crow.

The jumper should bridge between either of the centre pins to either of the
ground pins (i.e. the pins closest to the power connector, indicated by the
white stripe on the pcb). In a pinch you can hold a (!disconnected!) patch cable
to bridge the pins while powering on the case.

![](../images/crow-dfu.jpg)

## Flashing the update

You can run the firmware update from either a file browser, or within the terminal, whichever you find more convenient.

### Finder / File Explorer

Locate the release .zip file you downloaded above and extract it.

On Mac, you'll double-click the command file called `osx_linux-update_firmware.command`.

On Windows, you'll double-click the batch file called `windows-update_firmware.bat`.

### Command Line

From the Terminal:

* Make sure you've quit `druid`
* `cd` to the folder where you downloaded the firmware update
* Depending on your operating system you'll run one of:
  * Mac/Linux: `./osx_linux-update_firmware.command`
  * Windows: `.\windows-update_firmware.bat`

For example if your file was extracted to `~/Downloads/crow-1.0.1` type this on the command line for Mac:

```console
cd ~/Downloads/crow-1.1.0
./osx_linux-update_firmware.command
```

After executing the `update_firmware` command, you'll see something like:

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

If you get an error: `dfu-util: No DFU capable USB device available` this means crow is not in the bootloader or is not connected to the laptop.

You can type `dfu-util -l` to list the connected bootloader devices.

If you get an error: `'dfu-util' is not recognized as an internal or external command, operable program or batch file.` you haven't correctly installed dfu-util, or need to add it to your PATH. Try the [setup](#setup) section again.
