---
layout: default
title: max
parent: + computer
redirect_from: /app/package
nav_order: 3
---

# monome package for max

We've created a collection of applications and tools that can be downloaded directly via Max's package manager (in version 7 and above).

## get package

First, you'll need [Max](https://cycling74.com/downloads/#.VxjsRhMrLdQ). There are subscriptions, education discounts, and full licenses available -- to run applications, though, you just need the free runtime.

Once downloaded, open Max and go to the Package Manager via the dropdown menu:

**File &rarr; Show Package Manager**

Use the search bar at the top: "monome" and the click *Install*.

![Package](images/monomepackage.png)

## patchers

Once the monome package is installed, click "Show in Filebrowser" to open the package's contents. From here, sort by Description and find the group of Patchers.

To begin, double-click "meadowphysics.maxpat" to open the application.

![MP](images/package-mp.png)

Your grid will be auto-detected and selected when plugged in. (Provided you've already installed [serialosc](/docs/serialosc/setup)).

Meadowphysics generates notes. To get sound you'll need to click the *plugin* dropdown to select an internal synth plugin. You can likewise change the *output* to MIDI and change the *midi* dropdown to either an external or internal MIDI device (for example, on Mac the AU DLS Synth will make piano sounds.)

If you're looking for other quick ways to make sounds, load any of the other patchers:

- corners: physics curve cradle machine, creates MIDI notes when a "puck" hits a side of the **grid** and sends MIDI cc for position and acceleration
- flin: falling polyrhythm machine, 16 columns of notes which travel the **grid** at varying speeds and with adjustable length
- grid-midi: a simple **grid**-to-MIDI-note translator
- returns: use **arc** to control MIDI cc and generate MIDI cc LFO's with variable shapes + speeds
- step: a basic **grid**-based live step sequencer with note, velocity and duration per step
