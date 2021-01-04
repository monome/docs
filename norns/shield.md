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
- SD card - use a high quality brand such as [SanDisk](https://www.adafruit.com/product/2820) ($10)
- power supply - the Pi3B has a micro-USB power port and requires [at least 2A](https://www.adafruit.com/product/1995). you can also use a portable USB battery if it's sufficiently large.

## comparison

there are some differences between the norns and norns shield:

- norns has a battery, 1/4" mono jacks, a separate headphone jack and driver, very high quality audio, serial connection over power port
- norns shield has 3.5mm stereo jacks (headphones work on the output jack) and an ethernet port

software is fully compatible between the two.

## flashing SD card

to use shield, we'll need to load an SD card flashed with the correct software (called an *image*). this process is straightforward thanks to a program called etcher.

1. download and install [etcher](https://www.balena.io/etcher/) on your computer
2. download the [latest norns shield image](https://github.com/monome/norns-image/releases/download/201202/norns201202-shield.img.zip)
3. unzip the shield image and insert your SD card into your computer
4. run etcher, which will ask you to select the unzipped shield image and identify your SD card as the target -- after that, the program will take care of everything
5. once the process completes, eject the SD card from your computer and move onto the assembly steps below

## assembly

all you need is a normal philips screwdriver.

peel the clear acrylic cover. observe the orientation below to see which way is up. add the four short standoffs, using the four short screws:

![](https://monome.org/docs/norns/image/norns-shield-assembly1.png)

press the black key caps on to the white keys. this takes a bit of force, and you will hear a satisfying snap. press the knob caps into the top of the knobs, then put them on the encoders:

![](https://monome.org/docs/norns/image/norns-shield-assembly2.png)

peel the protective sheet away from the screen. the acrylic assembly will fit over the top, poking the threads through the circuit board. flip it over and add the longer standoffs. the short standoffs go near the audio jacks. hand-tightening is sufficient:

![](https://monome.org/docs/norns/image/norns-shield-assembly3.png)

insert your flashed SD card into the Raspberry Pi and attac the Pi to the corresponding header on the shield. attach the white case. add four long screws to secure the case. add the rubber feet:

![](https://monome.org/docs/norns/image/norns-shield-assembly4.png)

attach a high quality Raspberry Pi power supply that provides at least 2A at 5V to the micro USB port on the Pi. the red light on the Pi will be steady, while the not-red light will flash. in a few seconds, you'll see a sparkle animation on the screen. some call it a dust. either way, norns shield is on and you're ready to [play](../norns/play).

## credits

shield circuit design by [tehn](https://llllllll.co/u/tehn). 3D enclosure design by [JHC](https://llllllll.co/u/JHC).
