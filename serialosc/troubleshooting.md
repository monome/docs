---
layout: default
parent: serialosc
title: troubleshooting
nav_order: 2
---

## Troubleshooting

This section assume two things are true:

- your grid/arc is displaying a light burst when you plug it into your computer, which means its receiving power over USB
	- if your grid/arc is *not* displaying a light burst when you plug it into your computer, then the unit is not receiving power -- please try another cable and/or USB port
- your grid/arc is simply not visible in any apps designed to connect with it, eg. the dropdown menu in the Max test patchers
	- if your grid/arc *is* visible to these applications and is successfully connecting but perhaps MIDI out from these applications isn't working the way you expect, then you do not need to perform any of the steps in this section -- instead, please consult MIDI routing documentation for those environments

### macOS

1. On your Mac, open Activity Monitor and search `serialosc`. You should see entries for both `serialosc-detector` and `serialoscd`. If you do not, then serialosc is not installed.

2. Once you confirm serialosc is installed, please connect your grid/arc and open Terminal.  
    - execute `ls -lrt /dev/tty.usb*`  
    - if you get `ls: /dev/tty.usb*: No such file or directory` back, then your grid/arc is not connecting and you should try a different USB cable.
    - successful responses will look like:
      - `crw-rw-rw-  1 root  wheel   20,   6 Nov  8 08:08 /dev/tty.usbserial-m1100368`  
      - `crw-rw-rw-  1 root  wheel    9,   4 Oct 28 09:54 /dev/tty.usbmodemm44094551`

 **If you are running macOS 10.14 or earlier, then there are some additional troubleshooting steps to pursue:**

3. In Terminal, confirm that you do not have any conflicting FTDI drivers installed:
    - execute `ls /System/Library/Extensions | grep FTDI`
    - you should only get `AppleUSBFTDI.kext` back.
    - if you get `FTDIKext.kext` back, it needs to be uninstalled:

	```
	cd /System/Library/Extensions
	rm -r FTDIUSBSerialDriver.kext
	cd /Library/Receipts
	rm -r FTDIUSBSerialDriver.kext
	```

4. Now, reboot and try step 2 again. If things are still not working, open Terminal and execute:

	```
	brew services list
	brew services stop serialosc
	serialoscd
	```
	
	In Max, open either grid-test.maxpat or arc-test.maxpat (depending on the monome device). If you can't find the patchers, use CMD+B to open Max's file browser and search either `package:monome grid-test.maxpat` or `package:monome arc-test.maxpat`. plug in your grid/arc and you should see your grid/arc connect automatically!

	![](images/arc-test-connect.png)

#### Still not working?

- First, please try [re-installing serialosc](/docs/serialosc/setup). Note that if you did not previously install serialosc via homebrew, then you will need to remove any existing installations before proceeding.
- Do you have TouchOSC Bridge or TouchOSC Editor installed? Try removing them and installing [the latest versions](https://hexler.net/products/touchosc). You should be able to run both TouchOSC and serialosc, but we've found that reinstalling the TouchOSC software is necessary in some situations.
- Do you have any Wacom drivers installed? Please follow [these removal steps](https://www.wacom.com/en-in/support?guideTitle=How-do-I-uninstall-(manually)-and-re-install-the-Wacom-driver-on-Mac-OS-for-a-Pen-Tablet%2C-Pen-Display%2C-or-Pen-Computer%3F&guideId=002-235), as we've found that these drivers can block serialosc.
- If you have [a grid made before 2021](https://monome.org/docs/grid/editions/), try the "uninstalling d2xx drivers" steps from [page 18 of this guide](https://www.ftdichip.com/Support/Documents/AppNotes/AN_134_FTDI_Drivers_Installation_Guide_for_MAC_OSX.pdf) and try installing [the FTDI driver](https://ftdichip.com/drivers/vcp-drivers/) manually.

If you've reached this point and things still aren't working, please contact [help@monome.org](mailto:help@monome.org) with screenshots of what you see in steps 1-4, what you see in the Max console (CMD+B), and your Mac's OS version.

### Windows 10 + 11

If your grid or arc is not being detected when you plug into your Windows machine (but it is showing the light burst indicating its receiving power over USB), here are a few things to try.

1. If you're using Max/MSP and don't have iTunes installed on your device, you might be missing Bonjour, which Max uses to communicate with OSC and networked devices. To remedy, please install [Bonjour Print Services](http://support.apple.com/kb/DL999).
2. The [beta version of serialosc 1.4.1](https://github.com/monome/serialosc/releases/download/v1.4.1/serialosc-1.4.2-pre.exe.zip) might improve connectivity.
3. Try starting serialosc manually from the Services program. If you see `Error 1075`, you might need to [tweak your registry](https://llllllll.co/t/trouble-setting-up-monome/7001/5).
4. If you have [a grid made before 2021](https://monome.org/docs/grid/editions/), you may need to manually install the FTDI VCP driver, which you get get [here](https://ftdichip.com/drivers/vcp-drivers/).
