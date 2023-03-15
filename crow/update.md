---
layout: default
parent: crow
title: update
nav_order: 3
permalink: /crow/update/
---

# Firmware Update
{: .no_toc }

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## Latest

To check the current version of your crow inside of druid, type `^^version` into the command line.

### 4.0.1

*Huge thanks to all the contributors!*

**NEW**

- `timeline` library: [DOCS](https://monome.org/docs/crow/timeline/)  
- `sequins`: transformers: [DOCS](https://monome.org/docs/crow/sequins2/#transformers)  
- `sequins`: string-syntax: [DOCS](https://monome.org/docs/crow/sequins2/#sequins-strings)  
- `hotswap` library: [DOCS](https://monome.org/docs/crow/hotswap/)  
- seeded pseudo-random generator available as `math.srandom()`: [DOCS](https://monome.org/docs/crow/seededrandom/)  
- support for newest hardware revision (debug led & hardware i2c pullups)  
- extended `disting` ii interface (thanks @jroo, @ryland)  
- method for peeking the current sequins value (thanks @tyleretters)  

**FIXED**

- ASL segments now correctly handle `'log'` shapes (thanks @beels)  
- dsp samplerate was incorrect. ASL now runs at the correct speed  
- `i2c` timing refined for more reliable transmission  
- `i2c` driver more resilient to errors  
- `input[n].query()` now works correctly via norns (using the `input[n].stream` event)  
- solve "out of memory" errors when loading `ii` libraries in data-heavy scripts  
- `input[n].scale` mode avoids double-triggers near note boundaries  
- `ii.<module>.help()` is no longer truncated to 1024 characters  
- `ii` address now correctly applies for up to 4 simultaneous crows on the bus  
- `clock.sync` timing is now more accurate, and runs indefinitely  
- changing `clock.tempo` while `clock` routines are running no longer skips events  
- true random generator recovers when becoming insufficiently entropic  

## druid

New firmware can be checked and installed directly through druid. Make sure you have the [latest version of druid](https://monome.org/docs/crow/druid/#update), which supports this feature.

With crow connected to your computer, open a terminal and execute:

```
druid firmware
```

You should see something like this:

```
Checking for updates...
>> git version 3.0.1
>> local version:  2.0.0
Downloading new version: https://github.com/monome/crow/releases/download/v3.0.1/crow.dfu
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

### Linux / Mac OS troubleshooting

#### 'command not found: druid'

If you see `command not found: druid`, then please confirm that you've completed druid's [preparation](/docs/crow/druid/#preparation) and [installation](/docs/crow/druid/#install-druid).

If you continue to see `command not found: druid`, there's a chance that your installation was added to your PATH under a different shell (likely either `bash` or `zsh`). You can confirm your shell by executing `echo $0` in Terminal, which will return either `-zsh` or `-bash`, depending on the current shell. To switch between them, use one of the following commands:

- to switch to bash: execute `chsh -s /bin/bash`, enter your password, and restart Terminal
- to switch to zsh: execute `chsh -s /bin/zsh`, enter your password, and restart Terminal

Once you're back in the shell you used to install, you should be good to go!

#### Error: No such command 'firmware'

If you see `Error: No such command 'firmware'`, you first need to [update druid](/docs/crow/druid/#update).

### Windows troubleshooting

#### Update the Firmware

If you've previously installed and used `dfu-util`:

- Open a new PowerShell as Administrator
- Run `druid firmware` and crow will be erased and updated

If you see `Error: No such command 'firmware'`, you first need to [update druid](/docs/crow/druid/#update).

If you continue to run into trouble, you'll likely need to install the driver for crow's bootloader and the `libusb1` DLL file so that the PowerShell can talk to crow's bootloader. This process is outlined in the following sections. Once completed, try `druid firmware` again.

#### Install the WinUSB driver using Zadig

- put crow in bootloader mode: open `druid`, send `^^b` (crow will disconnect from druid), enter `q` to quit.
- download [Zadig](https://zadig.akeo.ie)
- open Zadig and from `Options` check `"List All Devices"`
- select `crow: dfu bootloader` from the list (if you see `crow: telephone line` then crow is not in bootloader mode)
- for the current driver, you should see `None` or `STTub30 (v3.0.4.0)`
- to the right of the green arrow, you should have `WinUSB (v6.1.7600.16385)` (if you don't, please select it)
- click the `Replace Driver` button and wait a few minutes for the process to complete

#### Install libusb.dll

- download [libusb1.dll](https://github.com/monome/docs/blob/gh-pages/crow/libusb-1.0.zip)
- make a folder in your user directory called `Drivers`, eg: `C:\Users\Trent\Drivers`
- add the new `Drivers` folder to your `PATH` variable. [Instructions here](https://monome.org/docs/crow/druid/#windows-errors).
- extract the DLL file, and place it in the folder you just created

## norns

You can use the [`fledge`](https://github.com/monome/fledge) script on norns to update a connected crow to its latest firmware.

- connect your norns to the internet (via [WIFI](/docs/norns/wifi-files/) or ethernet)
- open [maiden](/docs/norns/maiden)
- execute `;install https://github.com/monome/fledge`
- launch the `fledge` script
- keep maiden open for progress details

## Manual Update

If you have trouble with the `druid firmware` command on a non-norns computer, or wish to install a specific firmware version, see the [manual update](/docs/crow/manual-update).