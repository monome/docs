---
layout: default
title: norns shield
nav_exclude: true
has_toc: false
---

![](https://monome.org/docs/norns/image/norns-shield.png)

# norns shield
{: .no_toc }

A DIY circuit which extends a normal Raspberry Pi, turning it into a norns.

The norns shield is [open source hardware](https://github.com/monome/norns-shield). monome sells a complete kit so that you can get straight to making sound with code.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## requirements

- [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b) ([$35](https://chicagodist.com/products/raspberry-pi-model-3-b-1-4-ghz)) 3B+ is also fine. **important! other models are not compatible.**
- microSD card - use a high quality brand such as [SanDisk](https://chicagodist.com/products/raspberry-pi-official-noobs-microsd-card?variant=12404373160015) ($10)
- Power supply - we *highly* recommend [this one](https://chicagodist.com/products/raspberry-pi-2-amp-micro-usb-power-supply). The Pi3B has a micro-USB power port and requires at least 2A and 5.25V ideally supplied through a cable with 24AWG or less. Lower AWG = lower noise & more stable voltage delivery for better performance. **Most consumer USB cables do not meet this spec, so please be sure to keep an eye out**. You can also use a portable USB battery if it's sufficiently large.

*please note: The total cost for this project is ~$330 USD. no soldering is required, only screwdriver assembly done in minutes. Flashing the SD card should take 15 minutes of passive time. If you run into any trouble along the way, we are happy to assist via help@monome.org*

## comparison

There are some differences between the norns and norns shield:

- norns has a battery, 1/4" mono jacks, a separate headphone jack and driver, very high quality audio, serial connection over power port
- norns shield has 1/8" (interchangeably referred to as 3.5mm) stereo jacks (headphones work on the output jack) and an ethernet port

Software is fully compatible between the two.

*please note: shield hardware was updated in June 2021 for cleaner audio path and more mechanically robust jacks*

## connecting audio

At the top of the shield's board, you'll notice two arrows -- their points represent audio in (`▽`) and audio out (`△`). These jacks are each 1/8" stereo. The headphone jack on the Raspberry Pi itself is unused, as is the Pi's HDMI port.

To learn more about how to use shield, please refer to the standard norns documentation, staring with [play](https://monome.org/docs/norns/play/). Software is 100% compatible between the two, so the same instructions largely apply to both (and cases where things are different are notated within the docs).

## flashing microSD card

Since the Pi uses a microSD card in lieu of internal memory, you'll need to load the norns system (referred to as an **image**) onto the microSD card you intend to use with your Pi. This process (referred to as **flashing**) will erase and replace the microSD card's contents with the norns image. We'll use a program called [balenaEtcher](https://www.balena.io/etcher/), which makes flashing very straightforward:

1. download and install [balenaEtcher](https://www.balena.io/etcher/) on your computer
2. download the [latest norns shield image](https://github.com/monome/norns-image/releases/latest) to your computer (*nb. the base image might not include the latest software updates*)
3. unzip the shield image (which will result in an `.img` file) and insert your SD card into your computer
4. run balenaEtcher, which will ask you to direct it to the unzipped shield image and to identify your microSD card as the target -- after that, the program will take care of everything
5. once the process completes, eject the microSD card from your computer and move onto the assembly steps below

*please note: don't forget to [expand your filesystem](#expand-filesystem) after you boot norns for the first time!*

## assembly

All you need is a normal phillips-head screwdriver.

Peel the wrapping from the clear acrylic cover -- if you have trouble, try coaxing from a corner. Observe the orientation below to see which way is up and add the four short standoffs, using the four short screws:

![](https://monome.org/docs/norns/image/norns-shield-assembly1.png)

The black button caps have square holes that fit snugly over the white buttons. Press down until they click on with a satisfying snap. Then, press the knob caps into the top of the knobs and put the knobs onto the encoders:

![](https://monome.org/docs/norns/image/norns-shield-assembly2.png)

Peel the protective sheet away from the screen. If you have a dust-blower handy, remove any residual debris on the inside of the acrylic and on the screen. The acrylic assembly will fit over the top, poking the threads through the circuit board. Flip it over and add the longer standoffs. The short standoffs go near the audio jacks. Hand-tightening is sufficient:

![](https://monome.org/docs/norns/image/norns-shield-assembly3.png)

Insert your newly-flashed microSD card into the Raspberry Pi and attach the Pi to the corresponding header on the shield. Attach the white case. Add four long screws to secure the case (**please be careful not to over-tighten, as these screws will pull the shield downward and too much pull might crack the acrylic top**). Finally, add the rubber feet:

![](https://monome.org/docs/norns/image/norns-shield-assembly4.png)

## power on, power off

ON:

- attach a high quality Raspberry Pi power supply that provides at least 2A at 5V to the micro USB port on the Pi
- the red light on the Pi will be steady, while the not-red light will flash
- in a few seconds, you’ll see a sparkle animation on the screen

OFF:

- press **K1** and navigate to HOME
- use **E2** to select SLEEP
- press **K3** -- you’ll be asked to confirm
- press **K3** again to go to SLEEP
- *wait* until you see the not-red light on the side of the Pi stop blinking and go out completely
- **only after the not-red light on the side of the Pi is no longer visible:** remove the power connector from the Pi

## explore + expand filesystem (important!) {#expand-filesystem}

Once norns shield is on, [play](../play) will orient you to the norns system as well as how to control `awake`, the startup script that should be playing on first boot.

You should also [connect to WiFi](https://monome.org/docs/norns/wifi-files/) to run a software update, in case the shield image is behind the latest release. To learn more about software updates, visit [the latest norns update thread on lines](https://l.llllllll.co/norns).

Once you're settled in, you might notice that shield doesn't seem to see the entire capacity of your microSD card. This is normal, since shield can't anticipate how much space it's allowed to allocate for itself. To expand the filesystem:

- open the terminal program on a computer connected to the same network as your shield
  - Windows: use PowerShell
  - Mac: use Terminal
  - Linux: use your favorite
- type: `ssh we@norns.local` and press Enter
- this will prompt you for a password, which is: `sleep`
- type: `df -h` and press Enter
  - the information returned to you next to `/dev/root` will show the current allocated Size of the card
  - if you see `3.6G` and your microSD card is actually larger than 4 GB, please follow the rest of the steps in this section! otherwise, if the allocated Size is close to your card's capacity, then there's no need to continue.
- type: `sudo raspi-config` and press Enter
- navigate to `Advanced Options` and press Enter
- select `Expand Filesystem` and press Enter
- dismiss the alert by pressing Enter, navigate to Finish (press keyboard right arrow twice) and press Enter
- when asked to reboot, select Yes and press Enter
- norns will begin powering down, which will take a few minutes after this procedure, and will reboot
  - if you encounter any errors after this reboot, simply power your device down and start fresh

Once your norns has rebooted, press K2 on the SELECT / SYSTEM / SLEEP screen to toggle on some system statistics -- the number next to `disk` will show how many megabytes are still available on your microSD card. 1000 megabytes = 1 gigabyte, so a 32 gigabyte microSD card should have approximately `disk 27570M` available storage.

## credits

shield circuit design by [tehn](https://llllllll.co/u/tehn). 3D enclosure design by [JHC](https://llllllll.co/u/JHC).
