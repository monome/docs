---
layout: default
parent: crow
title: update
nav_order: 3
permalink: /crow/update/
---

# Firmware Update

New firmware can be checked and installed now through druid. Make sure you have the [latest version](https://monome.org/docs/crow/druid/#update) which supports this feature.

## Linux / Mac OS

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

If you see `command not found: druid`, then please confirm that you've completed druid's [preparation](/docs/crow/druid/#preparation) and [installation](/docs/crow/druid/#install-druid).

If you continue to see `command not found: druid`, there's a chance that your installation was added to your PATH under a different shell (likely either `bash` or `zsh`). You can confirm your shell by executing `echo $0` in Terminal, which will return either `-zsh` or `-bash`, depending on the current shell. To switch between them, use one of the following commands:

- to switch to bash: execute `chsh -s /bin/bash`, enter your password, and restart Terminal
- to switch to zsh: execute `chsh -s /bin/zsh`, enter your password, and restart Terminal

Once you're back in the shell you used to install, you should be good to go!

If you see `Error: No such command 'firmware'`, you first need to [update druid](/docs/crow/druid/#update).

## Windows

Before updating crow you'll need to install the driver for crow's bootloader, and the `libusb1` DLL file so that the PowerShell can talk to crow's bootloader.

*NB: If you've previously installed & used `dfu-util` you should be able to run `druid firmware` in PowerShell.*

### Install the WinUSB driver using Zadig

- put crow in bootloader mode: open `druid`, send `^^b` (crow will disconnect from druid), enter `q` to quit.
- download [Zadig](https://zadig.akeo.ie)
- open Zadig and from `Options` check `"List All Devices"`
- select `crow: dfu bootloader` from the list (if you see `crow: telephone line` then crow is not in bootloader mode)
- for the current driver, you should see `None` or `STTub30 (v3.0.4.0)`
- to the right of the green arrow, you should have `WinUSB (v6.1.7600.16385)` (if you don't, please select it)
- click the `Replace Driver` button and wait a few minutes for the process to complete

### Install libusb.dll

- download [libusb1.dll](https://github.com/monome/docs/blob/gh-pages/crow/libusb-1.0.zip)
- make a folder in your user directory called `Drivers`, eg: `C:\Users\Trent\Drivers`
- add the new `Drivers` folder to your `PATH` variable. [Instructions here](https://monome.org/docs/crow/druid/#windows-errors).
- extract the DLL file, and place it in the folder you just created

### Update the Firmware

- Open a new PowerShell as Administrator
- Run `druid firmware` and watch your crow absorb new knowledge

If you see `Error: No such command 'firmware'`, you first need to [update druid](/docs/crow/druid/#update).

## Version

To check the current version inside of druid, type `^^version` into the command line.

## Manual Update

If you have trouble, see the [manual update](/docs/crow/manual-update).
