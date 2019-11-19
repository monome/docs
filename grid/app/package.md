---
layout: default
nav_exclude: true
---

# monome package for max

We've created a collection of applications and tools that can be downloaded directly via Max's package manager (in version 7 and above).

## Get package

First, you'll need [Max](https://cycling74.com/downloads/#.VxjsRhMrLdQ). There is a free runtime.

Open it up, and go to the Package Manager via the dropdown menu:

**File &rarr; Package Manager**

Use the seach bar at the top: "monome" and the click *Install*.

![Package](images/monomepackage.png)

## Patchers

You can launch individual patchers directly from this screen. Click the dropdown arrow for *patchers* on the bottom right. Double-click *meadowphysics.maxpat* to load it up.

![MP](images/package-mp.png)

Your grid will be auto-detected and selected when plugged in. (Provided you've already installed [serialosc](/docs/serialosc/setup)).

Meadowphysics generates notes. To get sound you'll need to click the *plugin* dropdown to select an internal synth plugin. You can likewise change the *output* to MIDI and change the *midi* dropdown to either an external or internal MIDI device (for example, on Mac the AU DLS Synth will make piano sounds.)

Be sure to check out the other patchers!
