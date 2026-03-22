---
layout: default
title: ribbons
has_children: false
nav_exclude: true
has_toc: false
---

<div class="vid">
<iframe allow="fullscreen" loading="lazy" src="https://hyper8.monome.org/arc-ribbons/embed/" style="aspect-ratio: 1.7777778; border: none; width: 100%;" title="Video player widget for &quot;Embed – arc ribbons&quot;"></iframe>
</div>

# ribbons

_folded euclidean arpeggiator_

made by [tehn](https://nnnnnnnn.co)

## media

- video: [monome.org/arc-ribbons/](https://hyper8.monome.org/arc-ribbons/)

## download

- [ribbons.lua](https://codeberg.org/tehn/iii-scripts/raw/branch/main/arc/ribbons.lua)
- (archive)[ribbons.lua](archive/ribbons.lua) -- v1.0.0 original firmware version

## instructions

A set of notes is generated according to several parameters:

- STEPS: how many notes
- SPAN: range to spread the notes over
- FOLD: range to wrap the notes into

The combination of STEPS and SPAN allocate scale positions with the same technique as euclidean rhythm. For larger SPAN values, FOLD will wrap values back into a smaller range, creating various overlaid arpeggio patterns. These scale positions are then turned into a note set according to the ROOT, SCALE, and OFFSET.

Parameter mapping:

- 1 OFFSET, shows note values and current playing note
- 2 STEP, shows current step position along with SPAN
- 3 RANGE, shown in relation to SPAN
- 4 TEMPO

hold KEY for alternate mappings:

- 1 SCALE, shows 7 modes below
- 2 SPAN, shown with STEP value
- 3 DIRECTION, up or down indicated by bottom left/right
- 4 ROOT, base MIDI note for note set

All MIDI is sent on channel 1. Note length is an eighth note at given tempo.

## further

No pattern saving is implemented. This arpeggiator shall be played freely and weirdly. It often sounds great, and sometimes less so.

There's a bunch of in-progress-experiment code in this script, specifically for multiple voices and time division. None of the interface is currently provided. Note that the long keypress is underutilized, if one were interested in tinkering.

