---
layout: default
title: teletype
nav_order: 5
has_children: true
has_toc: false
redirect_from: /modular/teletype/
permalink: /teletype/
---


<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/129271731?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

# Teletype

Algorithmic ecosystem: a dynamic, musical event triggering platform.

Scripts are assigned to each of the eight trigger inputs. Herein you can set CV values (four outputs) and trigger gates (four outputs) with extended functionality for pattern manipulation, slews, randomness, sequences, basic arithmetic, stacks, delays, and much more.

Edit scripts with a USB keyboard (included with new modules + [replacements available](https://market.monome.org/collections/other/products/usb-keyboard)) which plugs into the front panel. Syntax is simple and easy to learn with the provided tutorials, video, and reference pages. Teletype runs without the keyboard attached: you might treat editing as precomposition, or leave the keyboard plugged in for live coding.

![](/images/tt.jpg)

### Specifications

* Eurorack
* 18hp width
* 26mm depth

## Installation

### Power
Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the lower edge of the module.

Be careful not to misalign the connector left-to-right either – while Teletype is protected against incorrect connection, doing so may damage other modules in your Eurorack case.

Secure the module with the four included screws, hiding under the tape in the box lid.

*Power consumption:*

- 72mA @ +12V
- 12ma @ -12V
- No +5v required

### ii/i2c

If you wish Teletype to communicate with Ansible or other modules with [ii](/docs/modular/ii), you will need to attach an ii cable (not included, but DIY'able [here](https://www.adafruit.com/product/1950)) as outlined in the [ii Communication](/docs/modular/iiheader#connecting-the-trilogy) page. Teletype can also connect to a world of other [i2c-capable devices](https://llllllll.co/t/a-users-guide-to-i2c/19219). If your Teletype has a green circuit board, it can support 2 direct ii/i2c connections. If it has a black circuit board (Dec 2018 revision), it can support 4 direct ii/i2c connections.

### Keyboard

Teletype cannot use a USB keyboard if it has an internal USB hub, and does not work with USB hubs in general. Otherwise most keyboards should work, but keep in mind that backlit keyboards etc. are drawing power from Teletype, so you may wish to use external USB power. Teletype assumes the keyboard layout is US-ANSI. For more discussion, see [lines](https://llllllll.co/t/alternative-teletype-keyboard-recommendations-mechanical-wireless-etc/5859).

### Firmware

**[Firmware updates](/docs/modular/update) may be available. The currently installed firmware version is displayed at startup.**

It is possible to backup all your presets as part of the module's firmware; see [modular firmware updates](/docs/modular/update/).

## Getting Started

The basics of Teletype are quick to learn. The tutorials will get you started and the manual provides a complete reference.

* [Teletype Studies](studies-1) - guided series of tutorials

* [Teletype Manual](manual) - full manual, also available as a [pdf](manual.pdf)

* [Just Type Studies](jt-1) - a guided series of tutorials on integrating Teletype with Just Friends

* [PDF command reference](TT_commands_3.0.pdf)
* [PDF scene recall sheet](TT_scene_RECALL_sheet.pdf)

* [Default scenes](scenes-10/)

You can also access in-module help any time by using ALT-H to toggle help mode.

## Further

Teletype is [open-source](https://github.com/monome/teletype). Since its initial release Teletype has grown an improved extensively thanks to various contributors including @sam, @scanner_darkly, and @sliderule. Additionally the documentation has undergone full reworking.

Discussion happens at [llllllll.co](https://llllllll.co). All contributions are welcome!
