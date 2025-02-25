---
layout: default
parent: arc
title: computer
nav_order: 2
has_children: false
has_toc: false
---

# arc + computer

<div class="vid"><iframe src="https://player.vimeo.com/video/63240734?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

### serialosc (required) {#serialosc}

The arc uses serialosc to communicate back and forth with applications on your computer. Once you install it, serialosc runs in the background and converts serial communication (over USB) into Open Sound Control (OSC). Applications query serialosc to connect to grid and arc, so while you'll never interact with serialosc directly, it's necessary to have installed before we do anything else.

To begin, [check out the serialosc docs](/docs/serialosc/setup).

#### development

Additional resources to help you exercise greater control over the grid's serial messages, modify serialosc itself, or build your own grid libraries using C:

- [serialosc programming docs](/docs/serialosc/osc) // osc format and device discovery
- [monome serial protocol](/docs/serialosc/serial.txt) // serial format details
- [libmonome](https://github.com/monome/libmonome) // a library which simplifies serial communication with the grid, which serialosc is built on
- [libmonome tutorial](/docs/libmonome/tutorial) // control grids with libmonome + C

### community {#community}

We've collected a handful of contributed applications over the years which are excellent starting points.

- [VCV Rack](/docs/grid/computer/vcv-rack) (macOS + Windows + Linux)
- [Max and Max for Live](/docs/arc/computer/max) (macOS + Windows)