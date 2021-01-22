---
layout: default
parent: grid
title: + norns
nav_order: 1
has_toc: false
---

# grid + norns

## compatibility

All editions of grid are compatible with norns. Playability is dictated by two factors, size and varibright capability.

### size

Most norns apps are built with 128 grids in mind, which means that critical actions may utilize the full 16x8 range of keys.

Since 256 is a 16x16 grid, it will be able to interact with any app built for a 128 grid. However, there will be a lot of unused real-estate.

Since 64 is a 8x8 grid, an app's critical functions may not be displayed or executable.

Addressing playability due to size is straightforward -- since norns apps are coded in Lua, modifications can be made which either expand or constrict the app's grid interactions.

If you want to adapt a script's grid size, [norns study 4](/docs/norns/study-4) is a good place to start.

### varibrightness

Over the years, the brightness of the grid's LEDs has also evolved. From 2007 - 2010 they were all mono-bright, which meant that the lights were either on or off. Starting in 2011 four stages of "in between" brightness were possible, which opened up new ways of representing data -- eg. a dim light could signal a modifier key whereas a bright light could signal a performative key.

Since 2012, grids have had 16 steps of varibrightness.

Most norns apps are built with 16-step varibright grids in mind. While 4-step and mono-bright grids will still function with these apps, there may be indicators or special functions that require 16 steps of brightness to display.

If you want to adapt a script's LED brightness, [norns study 4](/docs/norns/study-4) is a good place to start.

## applications

After you [learn how to import apps into your norns](/docs/norns/maiden), here are a few starting points for exploring grid + norns.

- [mlr](https://llllllll.co/t/mlr-norns/21145): The original live sample-cutting platform. Load samples or record live audio, then re-pitch + chop + record gestures.
- [loom](https://llllllll.co/t/loom/21091): Surprisingly controllable generative sequencer. Think flin-meets-snake; notes are played when threads moving across the X and Y axis collide.
- [takt](https://llllllll.co/t/takt/21032): Elektron-inspired parameter locking step sequencer. Independent lengths / time dividers per track, step retriggers, song sequencing.
- [zellen](https://llllllll.co/t/zellen/21107): A generative sequencer based on Conway's Game of Life. Uses a standard norns synth engine to make sound on its own, but can also speak MIDI and CV.
- [boingg](https://llllllll.co/t/boingg/26536): Bouncing balls make notes, with probability. Speaks to an internal synth engine, speaks to Just Friends through crow.
- [less concepts](https://llllllll.co/t/less-concepts/21109): 1-d cellular automata generative playground, with built-in sequence-able varispeed delay (`~r e f r a i n`).
