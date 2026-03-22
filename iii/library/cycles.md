---
layout: default
title: cycles
has_children: false
nav_exclude: true
has_toc: false
---

<div class="vid">
<iframe allow="fullscreen" loading="lazy" src="https://hyper8.monome.org/arc-iii-cycles/embed/" style="aspect-ratio: 1.7777778; border: none; width: 100%;" title="Video player widget for &quot;Embed – arc iii cycles&quot;"></iframe>
</div>

# cycles

_rotating MIDI CC with friction_

made by [tehn](https://nnnnnnnn.co)

## Download

- [cycles.lua](https://codeberg.org/tehn/iii-scripts/raw/branch/main/arc/cycles.lua)
- (archive) [cycles.lua](archive/cycles.lua) -- v1.0.0 original firmware version

## Instructions

Each knob spins a position which can be accelerated or decelerated with a turn. This position is transmitted as USB-MIDI CC.

The position is converted to CC values according to the _SHAPE_.

- _SHAPE = SIN_ -- north is _MAX_, south is _MIN_.
- _SHAPE = SAW_ -- north is _MIN_, clockwise moves towards _MAX_.

CC number and MIDI channel are set within the parameters.

Hold the key to apply a friction brake to the spinning, slowing all down until they stop.

To edit parameters, short press and release the key. You're now in the parameter editing loop:

_MIN > MAX > SHAPE > FRICTION > CC > CH_

Each parameter has a distinct visualization. Short pressing the key will advance to the next parameter. Note that you will cycle through each parameter in a loop.

To exit parameter setting, hold the key. You will return to play mode. Settings will be saved to flash and be recalled on next boot.

- _MIN_ -- this is the low value. Values 0-127 shown as 7'o'clock to 5'o'clock. 
- _MAX_ -- this is the high value. Note that _MAX_ does not need to be greater than _MIN_, they can be inverted.
- _SHAPE_ -- _SIN_ or _SAW_ as described above. Visualized as two-way gradient (_SIN_) and one-way (_SAW_).
- _FRICTION_ -- increase to add friction, slowing down rotation over time.
- _CC_ -- MIDI CC number, 0-127. Visualized by three "digits" from bottom to top: 0-9, 0-9, and 0-1. Ex: CC 25 would be position 5 on the bottom, 2 in the middle, with the top spot off.
- _CH_ -- MIDI CH, 1-16. Visualized as a bar, 1 on the bottom, 16 on top.
