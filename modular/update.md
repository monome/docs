---
layout: default
nav_exclude: true
permalink: /modular/update/
---

# modular firmware updates

new releases are available per module:

- [teletype](https://github.com/monome/teletype/releases) **3.2.0** (april 22 2020)
- [ansible](https://github.com/monome/ansible/releases) **3.0.0** (april 22  2020)
- [whitewhale](https://github.com/monome/whitewhale/releases) **1.5.0** (march 27 2017)
- [meadowphysics](https://github.com/monome/meadowphysics/releases) **2.1.0** (march 25 2017)
- [earthsea](https://github.com/monome/earthsea/releases) **1.9.4** (june 19 2017)
- [crow](https://github.com/monome/crow/releases) - for update procedure see [here](/docs/crow/update)

firmware is updated by connecting a USB A-A cable to your computer and using the utility [dfu programmer](http://dfu-programmer.github.io).

get a normal, inexpensive USB A-A cable such as [p/n 1175-1035-ND on digikey](http://www.digikey.com/product-detail/en/101-1020-BE-00100/1175-1035-ND/3064766). a "transfer" cable will not work.

## mac

use [homebrew](http://brew.sh) to install dfu-programmer. go to the homebrew page and scroll down to "Install Homebrew" where you'll paste a line of text into Terminal.

after this is installed, you should be able to simply type:

	brew install dfu-programmer

get the firmware from the links at the top of the page. remember where these are stored on your computer. inside, there's a script called `update_firmware.command` within the named module folder.

connect the USB A-A cable to your computer and the module. on the module, hold down the front panel button while powering up to launch the bootloader. the leds may be lit or not; don't worry.

within the folder execute the downloaded script by double-clicking (in mac):

	update_firmware.command

and the firmware will be updated. the clock led (if present) will flash to show it has successfully installed.

you will need to power-cycle the module to re-enable USB device detection.

seeing `device not present`? first, ensure you are following the connection steps in order. then, it might be good to update Xcode's command-line tools (following [the steps in this post](https://llllllll.co/t/solved-dfu-programmer-device-not-present/31163/4)).


## windows

download the dfu-programmer binary from [dfu-programmer.github.io](http://dfu-programmer.github.io).

connect the USB A-A cable to your computer and the module. on the module, hold down the front panel button while powering up to launch the bootloader. the leds may be lit or not; don't worry. at this point, Windows should say a new device was detected and it's installing drivers for it.

open your device manager.

there should be a new category: _Atmel USB Devices_ (you might need to select _view > show hidden devices_) with AT32UC3B device. If there is a warning icon next to it you need to update the driver -- right click and select _Update Driver Software_, then _Browse my computer for driver software_. navigate to the folder where you installed dfu-programmer. it should find a new driver there; install it. if everything installs okay, the warning icon next to the device should disappear.

get the firmware from the links at the top of the page. remember where these are stored on your computer.

copy the firmware hex file to your dfu-programmer folder.

run `cmd` as Administrator (not sure it matters but best to anyway), cd to the dfu-programmer folder and execute the following (replace `whitewhale.hex` with whatever firmware you're updating):

	dfu-programmer at32uc3b0512 erase
	dfu-programmer at32uc3b0512 flash whitewhale.hex --suppress-bootloader-mem
	dfu-programmer at32uc3b0512 start

the clock led (if present) will flash to show it has successfully installed.

you will need to power-cycle the module to re-enable USB device detection.

having trouble with libusb? please see [this post](https://llllllll.co/t/dfu-programmer-installation-windows/622/12) for troubleshooting.

## linux

you’ll need to install [dfu-programmer](https://dfu-programmer.github.io/) from your distribution’s package repository, or build it from source.

get the firmware from the links at the top of the page. remember where these are stored on your computer. unzip the firmware to get the script called `update_firmware.command` within the named module folder.

    $ unzip firmware.zip

connect the USB A-A cable to your computer and the module. on the module, hold down the front panel button while powering up to launch the bootloader. the leds may be lit or not; don't worry.

to run the firmware update command, your user will need to be in the `dialout` or `uucp` group, depending on what your distribution calls it. otherwise you'll need to run it as `root` or `sudo`:

    $ ./update_firmware.command

the clock led (if present) will flash to show it has successfully installed.

you will need to power-cycle the module to re-enable USB device detection.

# firmware backups

you may wish to backup your module firmware before updating it, particularly if you want to save your presets, patterns, scales, settings. at this time, it is not possible to save or restore _only_ presets; the _entire_ firmware image, including any presets, is backed up from or loaded into the module. this means that restoring a backup may reinstall an older version of the firmware, potentially losing features or bugfixes in newer firmware versions.

to backup your firmware, install [dfu-programmer](http://dfu-programmer.github.io) and power up the module in bootloader mode according to the earlier instructions. then, follow the steps below for your module.

## ansible, meadowphysics, white whale, earthsea

once in bootloader mode, open a terminal and run:

    dfu-programmer at32uc3b0512 read > firmware-name.hex

restart the module before you unplug the USB cable:

    dfu-programmer at32uc3b0512 start

you can restore the backed-up firmware any time by getting back into bootloader mode, opening a terminal in your backup's directory, and running:

```
dfu-programmer at32uc3b0512 erase
dfu-programmer at32uc3b0512 flash firmware-name.hex --suppress-bootloader-mem
dfu-programmer at32uc3b0512 start
```

> note: these are the same commands that are run by the `update_firmware.command` script included in the official firmware releases.

## teletype

once in bootloader mode, open a terminal and run:

    dfu-programmer at32uc3b0512 read > firmware-name.hex

restart the module before you unplug the USB cable:

    dfu-programmer at32uc3b0512 start

you can restore the backed-up firmware any time by getting back into bootloader mode, opening a terminal in your backup's directory, and running:

```
dfu-programmer at32uc3b0512 erase
dfu-programmer at32uc3b0512 flash firmware-name.hex --suppress-bootloader-mem
dfu-programmer at32uc3b0512 start
```

> note: these are the same commands that are run by the `update_firmware.command` script included in the official firmware releases.

after reflashing teletype, it makes the following proclamation:

```
SCENES WILL BE OVERWRITTEN!
PRESS TO CONFIRM
DO NOT PRESS OTHERWISE!
```

this will appear every time you power on the module until the panel
button is pressed during this message, after which the module will
behave normally. this is a safeguard that requires user confirmation
before teletype will reset its flash memory to the default state, and
was added to avoid accidentally wiping out saved scenes. if you see
this message or get stuck in this state after normal usage of teletype
without reflashing, do not press the button and please do post on
lines, it should be possible to recover your scenes and troubleshoot
using a firmware backup .hex file.
