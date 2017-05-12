---
layout: page
permalink: /docs/modular/update/
---

# modular firmware updates

new releases are available per module:

- [teletype](https://github.com/monome/teletype/releases)
- [ansible](https://github.com/monome/ansible/releases)
- [whitewhale](https://github.com/monome/whitewhale/releases)
- [meadowphysics](https://github.com/monome/meadowphysics/releases)
- [earthsea](https://github.com/monome/earthsea/releases)

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


## windows

download the dfu-programmer binary from [dfu-programmer.github.io](http://dfu-programmer.github.io).

connect the USB A-A cable to your computer and the module. on the module, hold down the front panel button while powering up to launch the bootloader. the leds may be lit or not; don't worry. at this point, Windows should say a new device was detected and it's installing drivers for it.

open your device manager.

there should be a new category: _Atmel USB Devices_ (you might need to select _view > show hidden devices_) with AT32UC3B device. If there is a warning icon next to it you need to update the driver -- right click and select _Update Driver Software_, then _Browse my computer for driver software_. navigate to the folder where you installed dfu-programmer. it should find a new driver there; install it. if everything installs okay, the warning icon next to the device should disappear.

get the firmware from the links at the top of the page. remember where these are stored on your computer.

copy the firmware hex file to your dfu-programmer folder.

run `cmd` as Administrator (not sure it matters but best to anyway), cd to the dfu-programmer folder and execute the following (replace `whitewhale.hex` with whatever firmware you're updating):

	dfu-programmer at32uc3b0256 erase
	dfu-programmer at32uc3b0256 flash whitewhale.hex --suppress-bootloader-mem
	dfu-programmer at32uc3b0256 start

the clock led (if present) will flash to show it has successfully installed.

you will need to power-cycle the module to re-enable USB device detection.

## linux

you’ll need to install [dfu-programmer](https://dfu-programmer.github.io/) from your distribution’s package repository, or build it from source.

get the firmware from the links at the top of the page. remember where these are stored on your computer. unzip the firmware to get the script called `update_firmware.command` within the named module folder.

    $ unzip firmware.zip

connect the USB A-A cable to your computer and the module. on the module, hold down the front panel button while powering up to launch the bootloader. the leds may be lit or not; don't worry.

to run the firmware update command, your user will need to be in the `dialout` or `uucp` group, depending on what your distribution calls it. otherwise you'll need to run it as root/sudo:

```
$ ./update_firmware.command
Checking memory from 0x2000 to 0x3FFFF... Not blank at 0x2001.
Erasing flash... Success
Checking memory from 0x2000 to 0x3FFFF... Empty.
Checking memory from 0x2000 to 0xBDFF... Empty.
Programming 0x9E00 bytes... Success
Reading 0x3E000 bytes... Success
Validating... Success
```

the clock led (if present) will flash to show it has successfully installed.

you will need to power-cycle the module to re-enable USB device detection.