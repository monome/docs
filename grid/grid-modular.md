---
layout: default
parent: grid
title: + modular
nav_order: 3
---

# grid + modular

## power

In the early days of Trilogy modules (White Whale, Meadowphysics, and Earthsea), connected grids pulled power from the +5v rail on Eurorack power supplies -- often, up to 600mA. The power supplies in the market at that time often didn't provide enough power, so we used to offer external 5v solutions. These are no longer sold as robust +5v rails are more common, though we always recommend keeping an eye on your consumption by calculating your power draw against your power supply with [modulargrid](https://modulargrid.com).

If you wish to DIY an external power solution for grid, please check out [Offworld](https://llllllll.co/t/offworld-1-usb-power-utility/9578).

With Ansible, the +5v rail is no longer used -- instead, grid pulls from the common +12V rail (200mA maximum).

If your Teletype does not have a black circuit board (which we started manufacturing in December 2018), it is not recommended to plug grid directly into Teletype's USB port. The older models with green boards are not designed to supply enough power through USB, which won't harm your equipment at all but it will reset the voltage regulator and cause instability. Our recommendation is to power the grid externally when plugging into Teletype, regardless of board color, as this also reduces the likelihood of noise. [two > one](https://llllllll.co/t/2-devices-to-1-host-eurorack-switch-two-one/18826/1) was designed specifically for this purpose.

If you have any questions or concerns about power, please feel free to email `help@monome.org` or post to the [New to monome and modular](https://llllllll.co/t/new-to-monome-and-modular-ask-questions-here/11682) thread on lines.

## compatibility

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

- varibright + monobright grids supported
- 64 (8x8) supported
- 128 (8x16) preferred
- 256 (16x16) supported