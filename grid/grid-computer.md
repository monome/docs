---
layout: default
parent: grid
title: + computer
nav_order: 2
has_children: false
has_toc: false
---

# grid + computer
{: .no_toc }

While grid is a completely open tool, whose use is intended to be designed by the artist who's using it, let's begin by exploring from a few fixed starting points.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## serialosc (required) {#serialosc}

grid uses serialosc to communicate back and forth with applications on your computer. Once you install it, it runs in the background and converts serial communication (over USB) into Open Sound Control (OSC). Applications query serialosc to connect to grid and arc, so while you'll never interact with serialosc directly, it's necessary to have installed before we do anything else.

[&rarr; download serialosc](https://github.com/monome/serialosc/releases/latest)

Running into trouble? [Check out the serialosc docs](/docs/serialosc/setup).

Want to get into the guts of serialosc for extension or re-programming? [Check out the serialosc protocol docs](/docs/serialosc/osc).

Serialosc uses [libmonome](https://github.com/monome/libmonome), which simplifies serial communication with the grid. Further details on the monome [serial protocol](/docs/serialosc/serial.txt) and a complete [libmonome tutorial](/docs/libmonome/tutorial).

## Mark Eats Sequencer (MacOS)

Mark Eats Sequencer is a fantastic first foray into grid + computer play. It's a completely standalone step sequencer application, which can pipe MIDI to Ableton Live, Logic Pro, or any other DAW. With eight channels and sixteen sixteen-step patterns, it's a sequencing powerhouse that will help orient you to the flexibility of grid.

[→ download Mark Eats Sequencer](https://www.markeats.com/sequencer/)

### integration with a DAW
{: .no_toc }

Mark Eats Sequencer's documentation is fantastic (be sure to go to `Help > User Guide` in the application), but since using a standalone music-making application outside of a DAW is less common these days, here are a few tips to help get MIDI out of Mark Eats Sequencer and into a DAW. These will apply to most any DAW, including Ableton Live and Logic Pro.

#### sync to DAW's clock

To sync Mark Eats Sequencer with a DAW's clock, open the Sequencer's preferences and ensure that `Sync > Clock source` is set to `To Mark Eats Sequencer`. This means that the Sequencer will be listening for start/stop/reset signals from another program on your computer.

In the DAW's clock settings, you'll just need to ensure that you are sending synchronization signals to the `To Mark Eats Sequencer` destination. In Ableton Live, this is the `Sync` setting under `Sequencer > Preferences > Link/Tempo/MIDI > MIDI Ports`:

![](/docs/grid/images/mark-eats_ableton-live.png)

In Logic Pro, choose `To Mark Eats Sequencer` as a destination under `Preferences > MIDI > MIDI Project Sync Settings` and enable `Clock`:

![](/docs/grid/images/mark-eats_logic-pro.png)

#### send MIDI to DAW

When you open Mark Eats Sequencer, it establishes itself as a virtual MIDI device for the rest of the applications on your computer, so very little setup is needed to direct the MIDI traffic from Sequencer to instruments in a DAW. By default, Sequencer sends data from Pages 1 - 6 on MIDI channels 1 - 6 and Drums 1 + 2 on MIDI channels 11 + 12.

Each DAW has slightly different workflows for selecting which MIDI device should control which instrument, but here are some quick tips for Ableton Live and Logic Pro:

**Ableton Live**

Under `Preferences Link/Tempo/MIDI > MIDI Ports`, ensure that `Track` is selected next to `In: From Mark Eats Sequencer`. Then, navigate to the `MIDI From` section of any track:

-  change `All Ins` to `From Mark Eats Sequencer`
-  change `All Channels` to whichever channel that corresponds to the Sequencer Page you want to use for this track
-  either change `Monitor` to `In` *or* leave it as `Auto` and Arm Recording for the track (see Live's manual for more details)

![](/docs/grid/images/mark-eats_ableton-live_routing.png)


**Logic Pro**

Under `Preferences > MIDI > Inputs`, ensure that `From Mark Eats Sequencer` is selected. Then, navigate to any track's Track inspector:

- change `MIDI In Port` from `All` to `From Mark Eats Sequencer`
- change `MIDI In Channel` from `All` to whichever channel that corresponds to the Sequencer Page you want to use for this track
- enable recording on any track you want to hear

![](/docs/grid/images/mark-eats_logic-pro_routing.png)

## Max for Live (MacOS + Windows)

If you have access to Ableton Live Suite (or the Max for Live add-on for Live Standard), there are a number of Max for Live devices which integrate grid into your Live Sets.

- [terms](/docs/grid/app/terms): a collection of essential monome applications, synchronized and integrated within Ableton Live Suite (works with Live 11 / Live 10 / Live 9)

- [gridlab](https://github.com/stretta/gridlab): a suite of devices which collect a number of unique sequencers and utilities

- [grainfields](https://github.com/kasperskov/monome_grainfields_m4l-v1.1): eight-voice granulator with grid control

- [control](https://github.com/benjaminvanesser/control): transforms grid into a collection of assignable MIDI controls

## scripting (all platforms)

The grid is *intended* to be reimagined. You give it purpose and meaning that's all your own: instrument, experiment, tool, toy... choose your own adventure!

To start with some introductory knowledge for scripting for grids on MacOS, Windows, or Linux visit [grid studies](../studies).

## Max/MSP (MacOS + Windows)

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/-1tTABS_Ugs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The grid was originally designed as a flexible, minimal interface to control Max/MSP patchers. Over the past 15+ years many artists have not only extended this simple purpose into full-blown performance tools -- and due to the communal nature inherent to Max/MSP, have generously shared these patchers + standalone applications with others. This exchange of enthusiasm and care for other artists has always been staggering to us.

While grid's compatibility + potential with Max/MSP remains current, computing has changed quite a bit over the last decade and a half. Therefore, the projects contained in this section may have different levels of stability as OS + host application updates introduce breaking changes. If you feel particularly drawn to a tool which could use a bit of tweaking to get back in working order, that is a fantastic place to learn Max from! 

Max can be [downloaded and run for free](http://cycling74.com), without a license (a license is required to save your changes, however). In this list, you'll also find many Max for Live devices, which can be run in Max for free (just drag the `.amxd` file directly into a patcher) or within Ableton's Live Suite (or using Ableton's Max for Live add-on).

### recent

#### audio
* [grainfields](https://github.com/kasperskov/monome_grainfields_m4l-v1.0) -- 8 voice granular synthesizer.
* [anaphora](https://github.com/AndrewShike/anaphora) -- simple, live-input focused mlr variant.
* [anachronism](https://github.com/AndrewShike/anachronism) -- asynchronous digital tape looping interface.
* [versos](https://llllllll.co/t/31326) -- multi-track looper and sampler for grids with 64 keys.

#### midi
* [max package](/docs/grid/app/package) -- several patchers and tools for use within Max, rolled by monome.
* [gridlab](https://github.com/stretta/gridlab) -- a deep suite of Max for Live grid devices (requires 128 grid).
* [conway music](https://llllllll.co/t/32818) -- conway's game of life, midi-fied.
* [markov music](https://l.llllllll.co/markov/) -- make music with a simple Markov chain.
* [control](https://github.com/benjaminvanesser/control) -- open midi control surface for grids.
* [elements](https://github.com/benjaminvanesser/elements) -- a collection of Max for Live midi controls for grids.

#### arc-enabled
* [capstarc](https://github.com/mhetrick/capstarc) -- tactile sample scrubbing for arc.
* [cascades](https://l.llllllll.co/cascades/) -- 65,536 combinations of 16th note patterns across seven tracks.
* [pear](https://llllllll.co/t/32699) -- dual manual tape player for arc and Max.

#### no grid or arc?

While we believe that grid and arc help inspire interesting and idiosyncratic design, we value the perspectives that lead to unique music-making experiences above all else. Here are some of the free projects that have been born out of the [lines community](https://llllllll.co) that can be run on your computer using Max / Max for Live without any additional hardware:

* [confetti](http://www.rodrigoconstanzo.com/confetti/) -- a library of audio processing devices based on Rodrigo Constanzo's Max projects.
* [prosody](https://github.com/AndrewShike/prosody) -- a modular collection audio effects with minimal design and maximal impact.
* [geneseq](https://llllllll.co/t/32237) -- a Max external that implements a genetic algorithm for simple 8 step melodies using scale degrees.
* [grainshifter](https://llllllll.co/t/32261) -- an highly playable granulator for live input or prerecorded samples.
* [less concepts](https://llllllll.co/t/31294) -- an elementary cellular automata sequencer.

### archive

[collected](https://github.com/monome-community/collected) is a large unsorted repository of applications contributed over the years. We've also collected numerous [old monomeserial applications](https://github.com/monome-community/collected-ms) which are basically obsolete, but could be updated easily given some small ambition.

#### audio

* [mlr](https://github.com/monome-community/mlr) -- the original live sample-cutting platform.
* [meadowphysics](https://github.com/monome/meadowphysics) -- rhizomatic cascading counter.
* [straw](https://github.com/monome-community/straw) -- grid-based FM synthesizer.
* [inkblot](https://github.com/monome-community/inkblot) -- additive synthesis with rorschach patterns.
* [life](https://github.com/monome-community/life) -- conway's game of life.
* [re:mix](https://github.com/el-quinto/mix) -- extended mlr.
* [the party van](http://www.rodrigoconstanzo.com/the-party-van) -- live sampling performance instrument.
* [mlrv](https://github.com/trentgill/mlrv2/releases/latest) -- the quintessential grid-based sampling instrument (requires Max 6).

#### midi

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

#### utilities

* [pages](https://code.google.com/p/monome-pages) -- extremely in-depth java-based multi-instrument, with integration with Ableton Live.
* [mesh](https://github.com/monome/mesh) -- inter-app meta-gesture recorder.
