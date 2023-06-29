---
layout: default
parent: grid
title: computer
nav_order: 2
has_children: false
has_toc: false
---

### serialosc (required) {#serialosc}

grid uses serialosc to communicate back and forth with applications on your computer. Once you install it, it runs in the background and converts serial communication (over USB) into Open Sound Control (OSC). Applications query serialosc to connect to grid and arc, so while you'll never interact with serialosc directly, it's necessary to have installed before we do anything else.

To begin, [check out the serialosc docs](/docs/serialosc/setup).

#### studies

The following tutorials (written for macOS, Windows and Linux) show how to use different languages and environments to achieve the same goal: a playable step sequencer which interfaces with the grid.

- [SuperCollider](/docs/grid/studies/sc) // synthesis engine and programming environment
- [Puredata](/docs/grid/studies/pd) // open-source graphical patching for audio processing
- [Max](/docs/grid/studies/max) // a highly refined graphical patching environment
- [Arduino](/docs/grid/studies/arduino) // embedded programming to connect grids to external hardware
- [Processing](/docs/grid/studies/processing) // integrated development environment for visual experimentation
- [Python](/docs/grid/studies/python) // general purpose programming language
- [Node.js](/docs/grid/studies/nodejs) // web-centric script programming platform

#### development

Additional resources to help you exercise greater control over the grid's serial messages, modify serialosc itself, or build your own grid libraries using C:

- [serialosc programming docs](/docs/serialosc/osc) // osc format and device discovery
- [monome serial protocol](/docs/serialosc/serial.txt) // serial format details
- [libmonome](https://github.com/monome/libmonome) // a library which simplifies serial communication with the grid, which serialosc is built on
- [libmonome tutorial](/docs/libmonome/tutorial) // control grids with libmonome + C

### community {#community}

We've collected a handful of contributed applications over the years which are excellent starting points.

- [VCV Rack](/docs/grid/computer/vcv-rack) (macOS + Windows + Linux)
- [Max + Max for Live](/docs/grid/computer/max) (macOS + Windows)
- [Mark Eats Sequencer](/docs/grid/computer/mark-eats) (macOS only)