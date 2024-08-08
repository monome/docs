---
layout: default
parent: grid
title: modular
nav_order: 3
---

# grid + modular

*Note: all of our discontinued eurorack modules have been ported into the virtual modular synthesis playground VCV Rack through tireless community efforts led by [`@Dewb`](https://github.com/Dewb/). [The monome VCV Rack library](/docs/grid/computer/vcv-rack/) fully replicates the hardware projects in a free software environment, connecting directly to hardware grids over USB and even offering virtual grids in all sizes. When paired with a multi-channel DC-coupled audio interface, these modules find new life within any system.*

As modular synths became more accessible and ubiquitous in the mid-2010's, the opportunity to explore how grids could provide new compositional capabilities in a modular system presented itself. The first three grid-compatible modules each attempted to enable unique perspectives and approaches via control voltage (CV):

- [White Whale](/docs/whitewhale) (and its alternative firmware, an early version of [Kria](/docs/ansible/kria)) is the result of a decade of step-sequencer experiments for grid
- [Meadowphysics](/docs/meadowphysics) is a polyrhythmic, rule-based sequencer for CV triggers (which paired nicely with [Teletype](/docs/teletype))
- [Earthsea](/docs/earthsea) is a platform for playing, looping, and manipulating CV for melodic and timbral transformation

These modules formed Trilogy. Production was discontinued in favor of the applications' joint-embodiment as [Ansible](/docs/ansible). Thanks to the tireless generosity and vision of `@scanner_darkly`, it's also possible to write your own firmware for any monome module via [multipass](https://llllllll.co/t/multipass-a-framework-for-developing-firmwares-for-monome-eurorack-modules/26354).

## power

### Trilogy (White Whale / Meadowphysics / Earthsea)

In the early days of Trilogy modules (see above), connected grids pulled power from the +5v rail on Eurorack power supplies -- often, up to 600mA. The power supplies in the market at that time often didn't provide enough power, so we used to offer external 5v solutions. These are no longer sold as robust +5v rails are more common, though we always recommend keeping an eye on your consumption by calculating your power draw against your power supply with [modulargrid](https://modulargrid.com).

If you wish to DIY an external power solution for grid, please check out [Offworld](https://llllllll.co/t/offworld-1-usb-power-utility/9578).

### Ansible

With Ansible, the +5v rail is no longer used -- instead, grid pulls from the common +12V rail (200mA maximum). Power consumption varies greatly based on how many LEDs are being lit. See [ansible's docs](/docs/ansible) for more info.

### Teletype

If your Teletype does not have a black circuit board (which we started manufacturing in December 2018), it is not recommended to plug grid directly into Teletype's USB port. The older models with green boards are not designed to supply enough power through USB, which won't harm your equipment at all but it will reset the voltage regulator and cause instability. Our recommendation is to power the grid externally when plugging into Teletype, regardless of board color, as this also reduces the likelihood of noise. [two > one](https://llllllll.co/t/2-devices-to-1-host-eurorack-switch-two-one/18826/1) was designed specifically for this purpose, but if you'd like to go the pre-manufactured route, you can also utilize Expressive E's [ground loop adapter](https://www.expressivee.com/14-ground-loop-adaptor).

### troubleshooting noise

If you are experiencing noise in your system as you use grid (there are no hard-and-fast rules for which case power supplies will cause or avoid ground loops), we recommend powering grid externally and connecting only the data line to your modular system. This can be achieved using a ground loop adapter similar to [this one from Expressive E](https://www.expressivee.com/14-ground-loop-adaptor). This will ensure isolation between the grid and your system's audio path. Please note that by decoupling the power from your modular system, you'll need to unplug the grid after playing in order to turn the grid's LEDs off.

If you have any questions or concerns about power, please feel free to email `help@monome.org` or post to the [New to monome and modular](https://llllllll.co/t/new-to-monome-and-modular-ask-questions-here/11682) thread on lines.

## compatibility

*nb. 2021 grids require updated firmware for compatibility -- please see [modular firmware updates](/docs/modular/update) for more info*

### Ansible

- varibright grids only
- monobright grids unsupported
- 64 (8x8) unsupported by stock apps (community modifications may be available)
- 128 (8x16) preferred
- 256 (16x16) supported, bottom half unused

### Teletype

As of Teletype 3.0, you can use [Scanner Darkly](https://www.instagram.com/scanner_darkly_)'s excellent [grid ops for Teletype](https://llllllll.co/t/grid-ops-integration/9216) to integrate grid with Teletype to trigger scripts and code your own performance interfaces.

All grids are supported, as you define the way information and controls are displayed.

Further info:

- [grid ops studies](https://github.com/scanner-darkly/teletype/wiki/GRID-INTEGRATION)
- [grid code exchange](https://llllllll.co/t/teletype-grid-code-exchange/10084)

### Trilogy (White Whale / Meadowphysics / Earthsea)

Though these modules are [discontinued](/docs/legacy), they each have a rich afterlife.

- varibright and monobright grids supported
- 64 (8x8) supported
- 128 (8x16) preferred
- 256 (16x16) supported
