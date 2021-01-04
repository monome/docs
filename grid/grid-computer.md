---
layout: default
parent: grid
title: + computer
nav_order: 2
has_children: true
has_toc: false
---

# grid + computer

## first steps

While grid is a completely open tool, it helps to begin exploring from a few fixed points.

### serialosc

grid uses serialosc to communicate back and forth with applications on your computer. Once you install it, it runs in the background and converts serial communication (over USB) into Open Sound Control (OSC). Applications query serialosc to connect to grid and arc, so while you'll never interact with serialosc directly, it's necessary to have installed before we do anything else.

[&rarr; download serialosc](https://github.com/monome/serialosc/releases/latest)

Running into trouble? [Check out the serialosc docs](/docs/serialosc/setup).

Want to get into the guts of serialosc? [Check out the OSC protocol docs](/docs/serialosc/osc).

### Mark Eats Sequencer

Mark Eats Sequencer is a fantastic first foray into grid + (MacOS) computer play. It's a completely standalone step sequencer application, which can pipe MIDI to Ableton Live, Logic Pro, or any other DAW. With eight channels and sixteen sixteen-step patterns, it's a sequencing powerhouse that will help orient you to the flexibility of grid.

[→ download Mark Eats Sequencer](https://www.markeats.com/sequencer/)

### Max for Live

If you have access to Ableton Live Suite (or the Max for Live add-on for Live Standard), there are a number of Max for Live devices which integrate grid into your Live Sets.

- [gridlab](https://github.com/stretta/gridlab): a suite of devices which collect a number of unique sequencers and utilities

- [grainfields](https://github.com/kasperskov/monome_grainfields_m4l-v1.1): eight-voice granulator with grid control

- [re:mix](https://github.com/el-quinto/mix): realtime sampling, slicing and re-sequencing based on MLR

- [control](https://github.com/benjaminvanesser/control): transforms grid into a collection of assignable MIDI controls

### scripting

The grid is *intended* to be reimagined. You give it purpose and meaning that's all your own: instrument, experiment, tool, toy... choose your own adventure!

To start with some introductory knowledge, please visit [grid studies](../studies).

## further

Here are open source projects others have scripted using the above environments. Many require [Max](http://cycling74.com) which can be downloaded and run for free, without a license.

In this list, you'll also find many Max for Live devices, which can be run in Max for free (just drag the `.amxd` file directly into a patcher) or within Ableton's Live Suite (or using Ableton's Max for Live add-on).

Contact `help@monome.org` to have your project listed. We suggest [github](http://github.com) for hosting your project.

### audio

* [re:mix](https://github.com/el-quinto/mix) -- extended mlr.
* [grainfields](https://github.com/kasperskov/monome_grainfields_m4l-v1.0) -- 8 voice granular synthesizer.
* [anaphora](https://github.com/AndrewShike/anaphora) -- simple, live-input focused mlr variant.
* [anachronism](https://github.com/AndrewShike/anachronism) -- asynchronous digital tape looping interface.
* [versos](https://llllllll.co/t/31326) -- multi-track looper and sampler for grids with 64 keys.
* [mlr](https://github.com/monome-community/mlr) -- the original live sample-cutting platform.
* [meadowphysics](https://github.com/monome/meadowphysics) -- rhizomatic cascading counter.
* [straw](https://github.com/monome-community/straw) -- grid-based FM synthesizer.
* [inkblot](https://github.com/monome-community/inkblot) -- additive synthesis with rorschach patterns.
* [life](https://github.com/monome-community/life) -- conway's game of life.
* [the party van](http://www.rodrigoconstanzo.com/the-party-van) -- live sampling performance instrument.
* [mlrv](https://github.com/trentgill/mlrv2/releases/latest) -- the quintessential grid-based sampling instrument (requires Max 6).

### midi

* [max package](/docs/grid/app/package) -- several patchers and tools for use within Max, rolled by monome.
* [gridlab](https://github.com/stretta/gridlab) -- a deep suite of Max for Live grid devices (requires 128 grid).
* [conway music](https://llllllll.co/t/32818) -- conway's game of life, midi-fied.
* [markov music](https://l.llllllll.co/markov/) -- make music with a simple Markov chain.
* [elements](https://github.com/benjaminvanesser/elements) -- a collection of Max for Live midi controls for grids.
* [mark eats sequencer](http://markeats.com/sequencer) -- rapid performance sequencer.
* [terms](/docs/grid/app/terms) -- a collection of Max for Live devices rolled by monome.
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

### arc

* [capstarc](https://github.com/mhetrick/capstarc) -- tactile sample scrubbing for arc.
* [cascades](https://l.llllllll.co/cascades/) -- 65,536 combinations of 16th note patterns across seven tracks.
* [pear](https://llllllll.co/t/32699) -- dual manual tape player for arc and Max.

### utilities

* [control](https://github.com/benjaminvanesser/control) -- open midi control surface for grids.
* [pages](https://code.google.com/p/monome-pages) -- extremely in-depth java-based multi-instrument, with integration with Ableton Live.
* [mesh](https://github.com/monome/mesh) -- inter-app meta-gesture recorder.

### archives

[collected](https://github.com/monome-community/collected) is a large unsorted repository of applications contributed over the years. We've also collected numerous [old monomeserial applications](https://github.com/monome-community/collected-ms) which are basically obsolete, but could be updated easily given some small ambition.

### no grid or arc?

While we believe that grid and arc help inspire interesting and idiosyncratic design, we value the perspectives that lead to unique music-making experiences above all else. Here are some of the free projects that have been born out of the [lines community](https://llllllll.co) that can be run on your computer using Max / Max for Live without any additional hardware:

* [confetti](http://www.rodrigoconstanzo.com/confetti/) -- a library of audio processing devices based on Rodrigo Constanzo's Max projects.
* [prosody](https://github.com/AndrewShike/prosody) -- a modular collection audio effects with minimal design and maximal impact.
* [geneseq](https://llllllll.co/t/32237) -- a Max external that implements a genetic algorithm for simple 8 step melodies using scale degrees.
* [grainshifter](https://llllllll.co/t/32261) -- an highly playable granulator for live input or prerecorded samples.
* [less concepts](https://llllllll.co/t/31294) -- an elementary cellular automata sequencer.