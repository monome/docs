---
layout: default
title: norns shield
nav_exclude: true
has_toc: false
---

![](https://monome.org/docs/norns/image/norns-shield.png)

# norns shield

a DIY circuit which extends a normal Raspberry Pi, turning it into a norns.

the norns shield is [open source hardware](https://github.com/monome/norns-shield). monome sells a complete kit so that you can get straight to making sound and code.

## requirements

- [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b) ($35) 3B+ is also fine. **important! other models are not compatible.**
- microSD card - use a high quality brand such as [SanDisk](https://www.adafruit.com/product/2820) ($10)
- power supply - we *highly* recommend [this one](https://www.adafruit.com/product/1995). the Pi3B has a micro-USB power port and requires at least 2A and 5.25V ideally supplied through a cable with 24AWG or less. lower AWG = lower noise & more stable voltage delivery for better performance. **most consumer USB cables do not meet this spec, so please be sure to keep an eye out**. you can also use a portable USB battery if it's sufficiently large.

## comparison

there are some differences between the norns and norns shield:

- norns has a battery, 1/4" mono jacks, a separate headphone jack and driver, very high quality audio, serial connection over power port
- norns shield has 3.5mm stereo jacks (headphones work on the output jack) and an ethernet port

software is fully compatible between the two.

## flashing microSD card

since the Pi uses a microSD card in lieu of internal memory, you'll need to load the norns "operating system" (an *image*) onto the microSD card you intend to use with your Pi. this process (*flashing*) is straightforward thanks to a program called etcher.

1. download and install [etcher](https://www.balena.io/etcher/) on your computer
2. download the [latest norns shield image](https://github.com/monome/norns-image/releases/download/201202/norns201202-shield.img.zip) to your computer (*nb. the base image might not include the latest software updates*)
3. unzip the shield image (which will result in an `.img` file) and insert your SD card into your computer
4. run etcher, which will ask you to direct it to the unzipped shield image and to identify your microSD card as the target -- after that, the program will take care of everything
5. once the process completes, eject the microSD card from your computer and move onto the assembly steps below

## assembly

all you need is a normal philips screwdriver.

peel the clear acrylic cover. observe the orientation below to see which way is up. add the four short standoffs, using the four short screws:

![](https://monome.org/docs/norns/image/norns-shield-assembly1.png)

press the black key caps on to the white keys. this takes a bit of force, and you will hear a satisfying snap. press the knob caps into the top of the knobs, then put them on the encoders:

![](https://monome.org/docs/norns/image/norns-shield-assembly2.png)

peel the protective sheet away from the screen. the acrylic assembly will fit over the top, poking the threads through the circuit board. flip it over and add the longer standoffs. the short standoffs go near the audio jacks. hand-tightening is sufficient:

![](https://monome.org/docs/norns/image/norns-shield-assembly3.png)

insert your flashed microSD card into the Raspberry Pi and attach the Pi to the corresponding header on the shield. attach the white case. add four long screws to secure the case (nb. please be careful not to over-tighten, as these screws will pull the shield downward and too much pull might crack the acrylic top). add the rubber feet:

![](https://monome.org/docs/norns/image/norns-shield-assembly4.png)

## power on, power off

ON:

- Attach a high quality Raspberry Pi power supply that provides at least 2A at 5V to the micro USB port on the Pi.
- The red light on the Pi will be steady, while the not-red light will flash.
- In a few seconds, you’ll see a sparkle animation on the screen (some call it dust).

OFF:

- Press **K1** and navigate to HOME.
- Use **E2** to select SLEEP.
- Press **K3**. You’ll be asked to confirm.
- Press **K3** again to go to SLEEP.
- *Wait* until you see the not-red light on the side of the Pi stop blinking and go out completely.
- *Only after the not-red light on the side of the Pi is no longer visible*, you can safely remove the power connector from the Pi.

## explore + expand

once norns shield is on, [play](../play) will orient you to the norns system as well as how to control `awake`, the startup script that should be playing on first boot.

you should also [connect to WIFI](https://monome.org/docs/norns/wifi-files/) to run a software update, in case the shield image is behind the latest release. to learn more about software updates, visit [the latest norns update thread on lines](https://l.llllllll.co/norns).

once you're settled in, you might notice that shield doesn't seem to see the entire capacity of your microSD card. this is normal, since shield can't anticipate how much space it's allowed to allocate for itself. to expand the filesystem:

- open a terminal on a computer connected to the same network as your shield
- execute: `ssh we@norns.local`
- password: `sleep`
- execute: `sudo raspi-config`
- navigate to `Advanced` and hit RETURN
- select `expand filesystem` and hit RETURN
- lots of activity will happen. when it's done, power down and reboot. if you get any errors, reboot again.
- if you SSH back into norns and execute `df -h`, you'll see the newly expanded capacity.

## credits

shield circuit design by [tehn](https://llllllll.co/u/tehn). 3D enclosure design by [JHC](https://llllllll.co/u/JHC).
