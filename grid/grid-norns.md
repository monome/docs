---
layout: default
parent: grid
title: + norns
nav_order: 2
---

# grid + norns

## compatability

All editions of grid are compatible with norns. Playability is dictated by two factors, size and varibright capability.

### size

Most norns apps are built with 128 grids in mind, which means that critical actions may extend the full 16x8 range of keys.

Since 256 is a 16x16 grid, it will be able to interact with any app built for a 128 grid. There will be a lot of unused real-estate.

Since 64 is a 8x8 grid, an app's critical functions may not be displayed or executable.

Addressing playability due to size is straightforward -- since norns apps are coded in Lua, modifications can be made which either expand or constrict the app's grid interactions.

If you want to adapt a script's grid size, [norns study 4](../norns/study-4) is a good place to start.

### varibrightness

Over the years, the brightness of the grid's LEDs has also evolved. From 2007 - 2010 they were all mono-bright, which meant that the lights were either on or off. Starting in 2011 four stages of "in between" brightness were possible, which opened up new ways of representing data -- eg. a dim light could signal a modifier key whereas a bright light could signal a performative key.

Since 2012, grids have had 16 steps of varibrightness.

Most norns apps are built with 16-step varibright grids in mind. While 4-step and mono-bright grids will still function with these apps, there may be indicators or special functions that require 16 steps of brightness to display.

If you want to adapt a script's LED brightness, [norns study 4](../norns/study-4) is a good place to start.

## applications

After you [learn how to import apps into your norns](../norns/maiden), here are a few starting points for exploring grid + norns.

- [mlr](https://llllllll.co/t/mlr-norns/21145): The original live sample-cutting platform. Load samples or record live audio, then re-pitch + chop + record gestures.

## troubleshooting