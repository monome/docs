---
layout: default
title: reference
parent: aleph
nav_order: 1
---

# Aleph Reference

*Quick Links*: [Bees](../bees) - [Scenes](../scenes) - [Modules](../modules) - [Development](../development) - [Hardware Build](../hardware)

## Introduction

The Aleph is an open source sound computer. It can run different applications and connect to various hardware.

![](../images/aleph-map.png)

### Quickstart

Insert the SD card. On first boot it will run as a cyclic tone generator. Plug in a set of headphones. The small, leftmost knob is the headphone volume. Turn the ENCODERS and push SWITCHes to modify the synthesis and sequencing parameters.

~~~
ENC0 – Arp cycle time
ENC1 – Wave modulation
ENC2 – Osc2 filter
ENC3 – Overall pitch
SW0 – Start/stop arpeggiator
SW1 – Manual advance cycle for voice 2
SW3 – Randomize cycle lengths for each cycle
SW4 – Mute osc1
~~~

Plug in a monome grid to individually play note values and wave modulation.

*See [Tutorial 0: Getting Started with Bees](../tutorial-0) for more depth!*

To switch scenes, hit the MODE switch to leave PLAY mode, turn ENC2 until you get to the SCENES page, ENC0 scrolls through the scenes, and press SW1 twice to load the selected scene. Scenes included on the card are described on the [scenes](../scenes) page.

### Booting and Shutdown

The Aleph stores its current state on shutdown and will resume when powered up! The current state is stored in the *default* scene.

If you want to start the aleph with a *clear* state, hold SW0 while booting up. This will take you directly to the SCENES page where you can load a scene, or start building your own.

To shut down quickly without storing the current state, hold the MODE switch while shutting down.

If the Aleph crashes you'll need to pull the power plug. After a crash we suggest a clean boot by holding SW0.

### Updating

The latest stable Aleph software package is hosted on [github](https://github.com/tehn/aleph). You can find the newest version of Bees & the included modules at the [Latest Releases](https://github.com/tehn/aleph/releases/latest) page, ready to be copied to your SD card.

*For full instructions see the [updates](../updates) page.*

### Bees

Bees is the Aleph's standard application designed to be a flexible routing system. It can arbitrarily and dynamically map and process *control rate* input, manage audio modules, and store/recall presets (or *scenes*) from an SD card.

*Much more information on the [Bees](../bees) subpage.*

### Development

The Aleph can be extended in various ways:

- New Bees functionality can be added by coding new OPERATORs.
- Completely custom control applications can replace Bees.
- New DSP modules can be created with custom parameter sets to be controlled via Bees or another application.

*For more information see the [development](../development) subpage.*

### Getting Help and Further Information

The best way to get answers is via our community forum [lines](http://llllllll.co)

this way we can help solve problems publicly which can then become part of a greater knowledge base.

e-mail assistance available at help@monome.org
