---
layout: default
title: snows
has_children: false
nav_exclude: true
has_toc: false
---

<div class="vid">
<iframe allow="fullscreen" loading="lazy" src="https://hyper8.monome.org/arc-snows/embed/" style="aspect-ratio: 1.7777778; border: none; width: 100%;" title="Video player widget for &quot;Embed – arc snows&quot;"></iframe>
</div>

# snows

_very slow asynchronous arpeggiator_

made by [tehn](https://nnnnnnnn.co)

## media

- performance: [monome.org/arc-snows/](https://hyper8.monome.org/arc-snows/)

## download

- [snows.lua](snows.lua)

## instructions

Each ring is an arpeggio. Set each speed my turning. When the position crosses North, the note is changed to the next or previous note according to the direction of travel.

Push the key to stop all motion.

Set the note values and number of notes by editing the source code. Towards the top you'll see:

```
note[1] = {45,43,50}
note[2] = {55,64}
note[3] = {69,74,76,79}
note[4] = {86,83,81,72,79}
```

These are the MIDI note values per ring. The length of the arpeggio can be changed simply by adding more or fewer values.

You can change them an upload your script again. Or you can live-edit the running script in diii by typing into the REPL line at the bottom, for example:

```
note[2] = {50,55,57}
```

This would change the second ring to have a new arpeggio. Note this won't be saved to flash. If you want it to stay, edit the source code.

Also, each ring is sending on its own MIDI channel. If you'd prefer to to have them all send on one channel, edit line 20:

```
ch = n
```

Change this to `ch = 1` or whatever channel you need.

## further

There are a bunch of ideas that could be added here. An easy one would be adding a CC value corresponding to the position, modulating the volume so that notes swell across one another.
