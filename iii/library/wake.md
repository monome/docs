---
layout: default
title: wake
has_children: false
nav_exclude: true
has_toc: false
---

<div class="vid">
<iframe allow="fullscreen" loading="lazy" src="https://hyper8.monome.org/wake-atrium/embed/" style="aspect-ratio: 1.7777778; border: none; width: 100%;" title="Video player"></iframe>
</div>

# wake

_polymodulated parameter sequencer_

made by [tehn](https://nnnnnnnn.co)

A variation of [awake](https://l.llllllll.co/awake), where a note sequence gets modulated by four other sequences: offset note, octave, note length, and velocity. Each sequence can have a different length and tempo division.

Includes a scale selector, tempo controls (including MIDI tempo following) and pset read/write.

Uses 16x8 grid space.

## Download

- [wake.lua](https://codeberg.org/tehn/iii-scripts/raw/branch/main/grid/wake.lua)

## Instructions

(Diagrams coming soon!)

ALT is the top right.

Top row, in order from left to right:

### EDIT

The first five keys change the page to edit:

- Primary note sequence (also note trigger, so can be toggled off)
- Note offset (+/- 3 notes)
- Octave (+/- 3 octaves)
- Note length (shorter notes towards bottom)
- Velocity (louder towards top)

Each sequence has its own independent playhead, which is shown.

### LOOP/DIVISION

The sixth page shows all five sequences:

- Playhead (tap to jump positions)
- Loop (hold start and tap end to set loop)
- Division (hold ALT to show/edit, left is smaller division which means faster)

### PSETS

Seven pset slots are dimly lit across the top.

- Write: hold ALT when pressing a pset position
- Read: press a position

(Note: when internally clocked there's a tiny delay when writing to flash, I'll address this in future updates).

### CLOCK

Third from right (we're still on the top row).

Left:

- Clock on/off, RESET positions to start, (gap), toggle for RESET on pset read
- Below clock on/off there is a flashing metro indicator.

Right:

- Against the right is external MIDI toggle, inward is a toggle to follow clock MIDI start/stop
- Below this is MIDI clock division

Bottom:

- Two rows at the bottom change the internal clock, top row is coarse, bottom is fine. Horizontal "sliders" with slow on the left, fast on the right.

### SCALE

Starting from the left, vertical selectors:

Column 1: Octave
Column 2: Note offset (within generated scale)
Column 3: Scale mode

The two "circles" to the right are selectors for the root note.

The center circle starts at C in its northern position and increases chromatically clockwise, wrapping around to C again. The mode is rendered on this circle.

The right circle starts at C at north and moves clockwise in a circle of fifths pattern. This is more of a helper for selecting adjacent, potentially complimentary keys.

Reference:

See [wikipedia](https://en.wikipedia.org/wiki/Diatonic_scale#Modes) for information about modes, along with the pitch constellation diagram that inspired the circular selector interface.




