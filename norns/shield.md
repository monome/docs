---
layout: default
title: norns shield
has_toc: false
---

![](https://monome.org/docs/norns/image/norns-shield.png)

# norns shield

a DIY circuit which extends a normal Raspberry Pi, turning it into a norns.

the norns shield is [open source hardware](https://github.com/monome/norns-shield). monome sells a complete kit so that you can get straight to making sound and code.

## requirements

- [raspberry pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b) ($35) 3B+ is also fine. important! other models are not compatible.
- sd card - use a high quality brand such as [SanDisk](https://www.adafruit.com/product/2820) ($10)
- power supply - the Pi3B has a micro-USB power port and requires [at least 2A](https://www.adafruit.com/product/1995). you can also use a portable USB battery if it's sufficiently large.

## comparison

there are some differences between the norns and norns shield:

- norns has a battery, 1/4" mono jacks, an separate headphone jack and driver, very high quality audio, serial connection over power port
- norns shield has 3.5mm stereo jacks (headphones work on the output jack) and additionally an ethernet port

software is fully compatible between the two.


## assembly

all you need is a normal philips screwdriver.

![](https://monome.org/docs/norns/image/norns-shield-assembly1.png)

1. peel the clear acrylic cover. observe the orientation above to see which way is up. add the four short standoffs, using the four short screws.

![](https://monome.org/docs/norns/image/norns-shield-assembly2.png)

2. press the black key caps on to the white keys. this takes a bit of force, and you will hear a satisfying snap. press the knob caps into the top of the knobs, then put them on the encoders.

![](https://monome.org/docs/norns/image/norns-shield-assembly3.png)

3. peel the protective sheet away from the screen. the acrylic assembly will fit over the top, poking the threads through the circuit board. flip it over and add the longer standoffs. the short standoffs go near the audio jacks. hand-tightening is sufficient.

![](https://monome.org/docs/norns/image/norns-shield-assembly4.png)

4. attach the raspberry pi. attach the white case. add four long screws to secure the case. add the rubber feet.

5. read on for instructions on flashing your sd card...


## flashing sd card

1. download and install [etcher](https://www.balena.io/etcher/)
2. get the [current image](https://github.com/monome/norns-image/releases/download/201029/norns201029-shield.zip)
3. run etcher, it's very straightforward. be aware that your sdcard will be erased!


## credits

shield circuit design by [tehn](https://llllllll.co/u/tehn). 3D enclosure design by [JHC](https://llllllll.co/u/JHC).
