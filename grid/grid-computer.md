---
layout: default
parent: grid
title: + computer
nav_order: 3
---

# grid + computer

## serialosc
grid uses serialosc to communicate back and forth with applications on your computer. Once you install it, it runs in the background and converts serial communication (over USB) into [OSC](/docs/serialosc/osc). Applications can query serialosc to connect to grid and arc.

[&rarr; download serialosc](https://github.com/monome/serialosc/releases/latest)

Running into trouble? [Check out the serialosc docs](../serialosc/setup).

## applications

Here are open source applications others have scripted using the above environments. Many of the applications require [Max](http://cycling74.com) which includes a free runtime.

Contact `help@monome.org` to have your application listed. We suggest [github](http://github.com) for hosting your project.

### featured applications

* [max package](/docs/grid/app/package) -- several patchers and tools for use within Max.
* [mark eats sequencer](http://markeats.com/sequencer) -- rapid performance sequencer.
* [the party van](http://www.rodrigoconstanzo.com/the-party-van) -- live sampling performance instrument.
* [control](https://github.com/benjaminvanesser/control) -- open midi control surface for grids.
* [grainfields](https://github.com/kasperskov/monome_grainfields-v1.0) -- granular instrument for grids (also a [max for live version](https://github.com/kasperskov/monome_grainfields_m4l-v1.0))
* [re:mix](https://github.com/el-quinto/mix) -- extended mlr within ableton live.
* [mlrv](https://github.com/trentgill/mlrv2/releases/latest) -- the quintessential grid-based sampling instrument.
* [sum](/docs/grid/app/sum) -- a collection of essential monome apps synced together to work as one flexible tool for creating music.
* [terms](/docs/grid/app/terms) -- sum, pulled apart, as max for live plugins for ableton
* [capstarc](https://github.com/mhetrick/capstarc) -- tactile sample scrubbing for arc

### audio

* [mlr](https://github.com/monome-community/mlr) -- the original live sample-cutting platform.
* [meadowphysics](https://github.com/monome/meadowphysics) -- rhizomatic cascading counter.
* [straw](https://github.com/monome-community/straw) -- grid-based FM synthesizer.
* [inkblot](https://github.com/monome-community/inkblot) -- additive synthesis with rorschach patterns.
* [life](https://github.com/monome-community/life) -- conway's game of life.

### midi

* [flin](https://github.com/monome-community/flin) -- a cyclic poly-rhythm music box.
* [polygome](https://github.com/monome-community/polygome) -- arpeggiating pattern instrument.
* [decisions](https://github.com/monome-community/decisions) -- generative maze run. trigger scripts to make midi note and cc data.
* [plane](https://github.com/monome-community/plane) -- scrolling monophonic diatonic step sequencer with MIDI and CV outputs.
* [arpshift](https://github.com/monome-community/arpshift) -- a melodic, interval based, poly-rhythmic arpeggiator.
* [corners](https://github.com/monome-community/corners) -- gravity and friction. velocities and positions mapped to sound parameters and events.
* [parc](https://github.com/monome-community/parc) -- probabilistic sequencer/arpeggiator.
* [cygnet](https://github.com/monome-community/cygnet) -- real-time eight-track performance recorder.
* [muon](https://github.com/monome-community/muon) -- emergent feedback sequencer.
* [press cafe](https://github.com/monome-community/presscafe) -- real-time rhythmic pattern performance.
* [soyuz](https://github.com/monome-community/soyuz) -- scrolling step sequencer.
* [residue](https://github.com/monome-community/residue) -- TR-style step sequencer.
* [xor](https://github.com/monome-community/xor) -- cross-influenced event generator.
* [quantum](https://github.com/monome-community/quantum) -- generative sequencer based on siteswap, a juggling notation.


### max for live

* [re:mix](https://github.com/el-quinto/mix) -- extended mlr.
* [grainfields](https://github.com/kasperskov/monome_grainfields_m4l-v1.0) -- granular instrument for grids
* [gridlab](https://github.com/stretta/gridlab) -- a suite of maxforlive monome devices.
* [elements](https://github.com/benjaminvanesser/elements) -- a collection of midi controls for grids.
* [anaphora](https://github.com/AndrewShike/anaphora) -- simple, live-input focused mlr variant.
* [anachronism](https://github.com/AndrewShike/anachronism) -- asynchronous digital tape looping interface
* [prosody](https://github.com/AndrewShike/prosody) -- a modular collection of effects for grids & no grids


### utilities

* [pages](https://code.google.com/p/monome-pages) -- extremely in-depth java-based multi-instrument, with integration with ableton live.
* [mesh](https://github.com/monome/mesh) -- inter-app meta-gesture recorder.

### archives

[collected](https://github.com/monome-community/collected) is a large unsorted repository of applications contributed over the years. We've also collected numerous [old monomeserial applications](https://github.com/monome-community/collected-ms) which are basically obsolete, but could be updated easily given some small ambition.

## scripting

The grid is *intended* to be reimagined. You give it purpose and meaning that's all your own: instrument, experiment, tool, toy... choose your own adventure! Let's start with some introductory knowledge: potential energy for radical creative freedom.

The following tutorials show how to use different languages and environments to achieve the same goal: a playable step sequencer which interfaces with the grid.

- [Max](/docs/grid/studies/max) -- a highly refined graphical patching environment.
- [Arduino](/docs/grid/studies/arduino) -- embedded programming to connect grids to external hardware.
- [Processing](/docs/grid/studies/processing) -- integrated development environment for visual experimentation.
- [Puredata](/docs/grid/studies/pd) -- open-source graphical patching for audio processing.
- [SuperCollider](/docs/grid/studies/sc) -- synthesis engine and programming environment.
- [Python](/docs/grid/studies/python) -- general purpose programming language.
- [Node.js](/docs/grid/studies/nodejs) -- web-centric script programming platform.

### libraries

* [libmonome](https://github.com/monome/libmonome) -- C
* [serialosc.maxpat](https://github.com/monome/serialosc.maxpat) -- Max
* [monomehost](https://github.com/monome/MonomeHost) -- Arduino Due
* [monome-processing](https://github.com/monome/monome-processing) -- Processing
* [monom](https://github.com/catfact/monom) -- SuperCollider
* [monome-grid](https://www.npmjs.com/package/monome-grid) -- node.js
* [pymonome](https://github.com/artfwo/pymonome) -- Python