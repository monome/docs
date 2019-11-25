---
layout: default
title: cycles
parent: ansible
nav_order: 4
redirect_from: /modular/ansible/cycles/
---

## Cycles (Ansible + Arc)

Cycles is an app for the [Ansible](/docs/ansible) Eurorack module that converts [Arc](/docs/arc) gestures into rotational energy mapped to CV and TR outputs, with control for friction and force.

The mode LED will show white when running.

### Basics

![](../images/ansible_CYCLES_1.2.png)

Each ring has its own rotational momentum: turn the ring to accelerate in either direction. Each ring's current position is mapped to its respective CV and TR output.

The CV value is determined by the ring's Shape which is either Triangle (default) or Saw. A Tri shape has the CV output high towards to north side of a ring, and low towards the south side. A Saw shape is a gradual increase from low to high when rotating clockwise from north.

The TR value is a phase indicator. At the lowest division setting, on the right side of a ring TR is low, on the left it is high.

![](../images/arc_CYCLES_main_mode_PHASE_1.2.png)

Friction can be introduced by pushing and holding `Key 1`.

A short press to `Key 2` will reset all positions to 0 (north).

### Config

Enter CONFIG mode by holding down `Key 2`. In the main CONFIG view, the four rings control parameters that affect all rings:

![](../images/arc_CYCLES_config_1.5.png)

 * Ring 1 - Mode: Unsync/Sync
 * Ring 2 - Shape: Tri/Saw
 * Ring 3 - Force: ring sensitivity
 * Ring 4 - Friction: constant friction amount

While holding down `Key 2`, tap `Key 1` to switch to the RANGE view, where you can attenuate the CV output of each ring. Tap `Key 1` again to enter the `DIVISIONS` view, where you can increase the frequency of TR gates from the default of one high/low cycle per rotation to 2, 4, or 8 cycles. Tap `Key 1` a third time to return to the main CONFIG view, or release `Key 2` to leave CONFIG.

### Sync mode

By default Cycles is in Unsync mode, where each ring is independent.

In Sync mode Ring 1 determines the base speed, and the remaining rings follow by a given multiple. Touching ring 2-4 in Unsync mode changes this multiple.

![](../images/arc_CYCLES_main_mode_SPEED_full_1.3.png)

### Presets

![](../images/arc_LEVELS_saveANDrecall_1.1.png)

A short press to the `preset` key (next to the USB port) will enter PRESET mode.

The current preset will be shown dimly. Rotate to one of the other slots press either `Key 1` or `Key 2` to read and write respectively. Or press `preset` again to cancel.

Presets are written to flash, and the most recently used preset will be loaded upon power-up.

It is possible to backup all your presets as part of the module's firmware; see [modular firmware updates](/docs/modular/update/). Ansible can also save and load presets directly to a USB disk, see [here](/docs/ansible#usb-disk-mode).
