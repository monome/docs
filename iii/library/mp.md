---
layout: default
title: meadowphysics
has_children: false
nav_exclude: true
has_toc: false
---

# meadowphysics

_grid to MIDI note map_

made by [tehn](https://nnnnnnnn.co)

## Download

- [mp.lua](https://codeberg.org/tehn/iii-scripts/raw/branch/main/grid/mp.lua)

## Instructions

See the instructions from the [original module](https://monome.org/docs/meadowphysics/#getting-started).

Note: currently the MIDI note scale and metronome speed are fixed. They can be changed simply by editing the first few lines of the script:

```
NOTE = {86,83,81,79,76,74,69,64}
CLOCKTIME = 0.05
```

`NOTE` table is MIDI note values, top to bottom.

`CLOCKTIME` is the clock interval in seconds (smaller = faster clock).

## Implementation

I documented the process of re-implementing this script [step by step](https://github.com/monome/iii/discussions/34) which may be of interest.
