---
layout: page
permalink: /docs/modular/ansible/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/182119406?color=ff7700&title=0&byline=0&portrait=0" width="860" height="483" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>



# Ansible

*Far communicator, speaks openly.*

Connects to Grids, Arcs, and MIDI devices, integrating external controllers into the modular environment. Also extends Teletype. Many modes are available, activated by connecting different USB devices and a preset key:

* Kria (Grid) live step sequencer, polyphasic parameters, emergent patterns. Grid default.
* Meadowphysics (Grid) rhizomatic cascading counter.
* Earthsea (grid) polyphonic pattern instrument
* Levels (Arc) rotational pattern instrument.
* Cycles (Arc) physically manipulated waves.
* Reach (Teletype) further ecosystem output and input.
* Traffic (MIDI) device voice allocation and various arpeggiation.

**Grid, Arc, MIDI device, or Teletype required.**

* Eurorack
* 6hp width
* 39mm depth

![](/images/ansible.jpg)

## Installation

Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the lower edge of the module.

Be careful not to misalign the connector left-to-right either – while Ansible is protected against incorrect connection, doing so may damage other modules in your Eurorack case.

If you wish Ansible to communicate with Teletype you will need to attach the II ribbon cable behind the panel. Be sure to align the red stripe on the cable with the white line on the board.

Secure the module with the two included screws.

*Power consumption:*

These are maximums. Power consumption varies greatly based on which USB controller is attached and how many LEDs are being lit. You can drastically lower your +12V consumption by using a [Switch](/docs/modular/switch/) with your USB controller.

- 200mA @ +12V
- 19ma @ -12V
- No +5v required

## Firmware Updates

Ansible ships with a strange USB A-A cable. This is used for firmware updates. We expect to be adding features from time to time, and the Ansible is a good candidate for community hacking. It's suggested to update your firmware to ensure you're running the newest version-- so the following documentation will be applicable rather than confusing.

Firmware update information [instructions are available](http://monome.org/docs/modular/update/).

## Firmware Version

This documentation documents firmware version **2.0.0**. Changelogs and binaries for previous releases can be found [here](https://github.com/monome/ansible/releases).

## Basics

![Panel Overlay](images/ansible_CLEAN.png)

Output and input functionality vary according to which application is running.

Applications are determined by which USB device is plugged in. For example, when you plug in a Grid it will be running Kria. Hold the preset key (next to the USB port) to switch to Meadowphysics; push it again to switch to Earthsea. Ansible will remember which application you were last running between power-ups.

Unplugging the Grid and plugging an Arc will change to Levels.

With nothing plugged in the Ansible works as a Teletype input/output extender.

Modes are indicated with a white or orange LED near the mode key. (Earthsea is indicated with a "whitish-orange" colour)