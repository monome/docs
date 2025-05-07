---
layout: default
title: erosion
has_children: false
nav_exclude: true
has_toc: false
---

# erosion

[cool maritime](https://coolmaritime.org) / [tehn](https://nnnnnnnn.co/) collaborative vision

for iii arc

_four meta-knobs controlling four MIDI CC each_

## media

- performance: [vimeo.com/1072397621](https://vimeo.com/1072397621)
- howto: [vimeo.com/1082217606](https://vimeo.com/1082217606)


## download

- [erosion.lua](https://raw.githubusercontent.com/tehn/erosion/refs/heads/main/erosion.lua) -- most recent version

## instructions

*erosion* starts in **PLAY**.

*Note: throughout this document we'll refer to knob turns as DELTA N, where N represents one of the four knobs.*

### PLAY

- DELTA N: each knob outputs up to four CC values
- KEY / LONG PRESS: go to EDIT
- KEY / SHORT PRESS: go to SCENE

### EDIT

Holding the KEY for a few seconds from PLAY will pulse each knobs' LEDs, to ask which knob's values you'd like to edit. Select by slightly turning the chosen knob in either direction. The LEDs around this knob will brighten and short timeout will confirm your selection.

Now you are editing parameters for the four elements of the knob you've selected.

The PARAMETER CYCLE is: **min**, **max**, **slew**, **CC number**, **MIDI channel**, **active**

- KEY / SHORT: change parameter (min, max, slew, CC, CH, active)
- KEY / LONG: SAVE, returns to PLAY
- DELTA N: change selected parameter's value

Each knob displays the parameter's value. An indicator of which parameter is shown underneath each knob as three tick marks (CCW moves towards zero, CW moves towards max):

- left: **min**
- right: **max**
- center: **slew**

Changes to **min** and **max** for each CC will send its value via MIDI. This is helpful not only to to help tune your instruments to the ranges you see, but for mapping mechanisms which look for incoming values. When changing parameter modes, all CC positions will be sent.

Pressing the key again will display the **CC number** on the left side as pixel-numbers from top-to-bottom: 1, 1-9, 1-9. To get the CC number, assemble the digits (or see the diii screen for a numeric!)

Pressing the key again will display the **MIDI channel** on the right side as a pixel number from bottom-to-top: 1-16.

Pressing the key again will display **active** as a half-circle above the ring. Turn the knob CCW to deactivate. Deactivated positions cease to display the three ticks at the bottom, as a reminder of this off-state.

After editing be sure to save your SCENE so it will return next time.

### SCENE

Loads, saves, and erases scene data. A scene consists of the settings and current positions of the knobs, as well as configuration per knob (including min, max, slew, CC, CH, active state).

Scenes are organized into 8 BANKS, each with 8 SCENES.

- DELTA 1: select the BANK (position highlighted)
- DELTA 2: select the SCENE (position highlighted, slots with data are rendered wider than empty slots)
- DELTA 3: CW changes action to CLEAR (CCW resets to LOAD)
- DELTA 4: CW changes action to SAVE (CCW resets to LOAD)

If rings 3/4 are not lit, action is LOAD (default).

- KEY / SHORT PRESS: abort, return to PLAY
- KEY / LONG PRESS: execute queued action
  - if the SCENE slot is not empty, LOAD'ing will return you to PLAY

*Note: a SCENE will be saved with current positions of each knob, so resuming in the exact state is assured.*

When booting up, the last-saved SCENE will be active.