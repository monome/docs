---
layout: default
parent: crow
title: max + max for live
nav_order: 6
permalink: /crow/max-m4l/
---

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/437853836" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

# Max and Max for Live


[Max](https://cycling74.com) is a powerful visual coding language that has integrations with [Ableton Live](https://www.ableton.com/en/live/max-for-live/).

We have created a custom `[crow]` object and several helpful abstractions for Max, to welcome crow into your existing and future patches.

Using the `[crow]` object, we have also created a suite of Max for Live devices which help connect your Eurorack system and Ableton Live in ways beyond simple clocking.

Before we begin: [download the latest Max and Max for Live releases](https://github.com/monome/crow-max-and-m4l/archive/master.zip).

If any of the devices or objects are crashing Max or Ableton Live upon load, please follow the [clean install](https://cycling74.com/support/faq-maxcrash) steps from Cycling '74.

## Max

### Install

After downloading the entire `crow-max-and-m4l` repo, extract the zip file and you should get two unique folders: `crow_max` and `crow_m4l`.

Open `Max` > `Options` > `File Preferences` > highlight `User Library` > the rightmost icon in the bottom bar should illuminate. Clicking this icon will open the User Library folder, where you can drop the `crow_max` folder.

If you are performing an update of an existing `crow_max` installation, you can simply allow the system to replace the existing files. If you somehow have previous **beta** crow files in your User Library (or anywhere along your Max search path), please delete them and start fresh with `crow_max`.

Restart Max and you should be able to instantiate the `crow` object!

### Help Patcher

Right-click the [crow] object and select `Open crow Help`, which will reveal:

![](../images/max-help.png)

- **anatomy**: demonstration of the necessary signal flow to start patching with crow in Max.
- **cv input**: showcases reading CV through crow's 2 hardware inputs either on-demand, as a stream, or when a signal crosses a specified threshold.
- **basic cv output**: setting CV slew and specifying target voltages for crow's 4 hardware outputs. introduces `sprintf` techniques to help assign values dynamically.
- **cv notes**: showcases MIDI-to-CV translation for v/8 notemaking. also introduces *pulse* and *ar* commands.
- **cv shapes**: introduction to *actions* as user-definable envelopes/lfo's.
- **i2c**: demonstrates i2c connectivity + simple interactions with Just Friends (Whimsical Raps). this seemed the most interesting application, though the fundamental approach is translatable to any i2c device that has pre-defined Teletype interactions (w/, ER-301, Ansible, etc).
- **^^**: an index of system commands that report on connected hardware + flash new scripts to the module.

### [crow.] library

In addition to the `crow` object, there are many helper objects which can aid in development of crow Max and Max for Live applications. Each object comes with its own help-patcher and built in Max reference page.

- `crow.volts`: directly set one of crow's outputs to a voltage (with an optional slew time)
- `crow.inputs`: a bpatcher gui to easily access data from crow's inputs within Max
- `crow.ar`: easily configure and trigger an attack-release envelope on any of crow's outputs
- `crow.adsr`: easily configure and trigger an ADSR envelope on one of crow's outputs
- `crow.var`: assign a value, table, variable, or function return to a variable (or to an element of a table)
- `crow.function`: tell crow to execute a function, or generate a function call to pass to another `crow.` object.
- `crow.makefunction`: convert a value, variable, or function call into an anonymous function that returns the original value/variable/function call.
- `crow.n2v`: convert semitones to V/oct voltage levels.

### ^^bootloader
To help make flashing [new crow firmware](https://github.com/monome/crow/releases) easy, we've included a straightforward Max patch that walks through the necessary steps:

![](../images/max-bootloader.png)

You can either open it from inside the `crow_max` folder **or** by opening a new patcher in Max and instantiating a `^^bootloader` object (lock the patch and double-click the object to open the bootloader helper).

After loading new firmware, you will need to re-establish the connection between Max and the crow module but there is no need to reboot your modular.

## Max for Live

### Install

*nb. Max installation is **not** required to use the devices in `crow_m4l`.*

After downloading the entire `crow-max-and-m4l` repo, extract the zip file and you should get two unique folders: `crow_max` and `crow_m4l`.

Open Live (9 or 10) Suite, running at least Max 7.3.6. Place `crow_m4l` wherever you'd prefer it living longterm on your hard drive. Open Live and drag the folder into Live's browser, under `PLACES`.

If you are updating a previous installation, just replace the previous `crow_m4l` folder's contents with the new files.

### Getting started with crow + Max for Live

There is a full PDF manual for the devices [in the GitHub repo](https://github.com/monome/crow-max-and-m4l/blob/master/crowm4lmanual%20-%20200713.pdf).