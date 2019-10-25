---
layout: page
permalink: /crow/
---

![](images/crow.jpg)

# crow

crow speaks and listens and remembers bits of text. A scriptable USB-CV-ii machine.

crow connects to norns and computers running Max, Max for Live, and other serial-enabled applications. We've created various norns scripts and Max for Live devices which require no programming, and we've also created tutorials and studies to get you started quickly programming your own ideas into this tiny, powerful module.

crow also stores a complete script, so that without a USB connection it can continue to run, responding to CV input and ii messages.

A collaboration by [Whimsical Raps](https://www.whimsicalraps.com) and monome.


## Specifications

- Eurorack, 2hp width, 41mm depth
- Power consumption: 60mA @ +12v, -15mA @ -12V, no 5V
- 2 input, 4 output, 16bit [-5V,10V] range
- Rear panel digital communication bus (ii)
- full Lua scripting environment


## Installation

Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the lower edge of the module.

If you would like to use the [ii](/docs/modular/ii) functionality, be sure to observe the orientation of the connector. The white stripe indicates GND.


## First

*First* is the default script that runs on a new crow. It's a phasing rhythm & harmony sequencer. Each crow generates its own unique set of musical content to be scanned and played with voltage control.

It requires an oscillator, VCA, and some sort of control voltage generator (for clocks, LFOs, random voltage, etc) as company.

![](images/crow-first.png)

Start by patching crow's outputs into your synthesizer. Outputs 1+2 and 3+4 are pitch+volume pairs, each representing one voice of the sequence. Outputs 1+3 are volt-per-octave melodies, and outputs 2+4 are attack-release envelope outputs.

Example patch:
- Output 1+2 -> Mangrove v8 & air
- Output 3+4 -> VCO frequency & VCA level

Start the sequence by patching a clock or LFO into input 1. Each time the voltage rises above 1V *First* will take a step forward. As the patch comes alive, slow the clock down to hear long gentle swells, then ramp it up into snappy arpeggios.

To influence the melodic content, attach a control voltage to input 2. As voltages rise up from 0V, the melodies will spread out to take up more harmonic space. Positive voltages play a pentatonic scale, while below 0V two notes are added to enter the ionian mode, similarly widening the melody toward -5V.

For the code-curious, see the implementation [on github](https://github.com/monome/crow/blob/master/lua/First.lua).

## Next steps

While *First* is a compelling instrument on its own, crow collects all manner of objects: other Eurorack synthesizer modules, computers, and norns.

We have trained crow to navigate the following landscapes:

### norns

- crow integrates seamlessly as a CV and [**ii**](/docs/modular/ii) interface
- on October 1st 2019, we released an [**update**](../norns/#update) that allows scripts to communicate with crow
- [**community-made norns apps with crow integration**](https://llllllll.co/search?expanded=true&q=tags%3Acrow%2Bnorns%20order%3Alatest) on lines
- want to script on your own? See the full [**crow studies**](norns) for a complete guide

### computer + druid

- you can use your terminal to access [**druid**](https://github.com/monome/druid), a small utility for communicating with crow
- druid helps you engage crow in realtime interaction and also upload full scripts (coded in Lua), providing an interactive platform for designing new patterns in a modular synth
- want to see what others have scripted? visit [**bowery**](https://github.com/monome/bowery), the druid script collection, and complete *stage one* of the [**scripting tutorial**](scripting) to learn how to upload scripts
- learn to map your own flight paths with *stage two* and *stage three* of the [**scripting tutorial**](scripting)

### computer + Max 8 / Max for (Ableton) Live

- crow can speak with Max, a powerful visual coding language that has integrations with Ableton Live
- we have created Max for Live devices to integrate crow with Live, including: Live-synced clocks, MIDI-to-v/8, CC-to-Voltage, LFO's, executing Lua code directly in Live, parameter mapping your crow scripts, and triggering Lua chunks with MIDI
- using the [crow] object in Max 8, create your own Live-controllable devices or standalone utilities
- visit the [**Max and Max for Live repo on GitHub**](https://github.com/monome/crow-max)

### birdsong (reference)

- if you are writing or modifying norn apps, standalone scripts, or Max patches, you will want to become fluent in the language of the birds...
- visit the [**scripting reference**](reference) to become a crow whisperer 

## Resources

Please visit the [resources](resources) page for a bullet-point overview of currently available crow resources.

## Updates

We are working all the time. Check out the [newest firmware version](https://github.com/monome/crow/releases/latest).

To update, see the step by step [bootloader instructions](update) to update the crow firmware.


## Technical

There are also a subset of commands for managing the state of the device and contents of flash memory. crow ships pre-calibrated, but it is possible to re-run the automatic calibration.
See the [technical](technical) page for further details.


## Help

Answers to frequently asked questions can be found in the [FAQ](faq).

Community discussion happens at [llllllll.co](https://llllllll.co). Come say hello!

Contact *help@monome.org* with further questions.


## Development

crow continues to evolve and you can follow development on github:

[https://github.com/monome/crow](https://github.com/monome/crow)

crow is open-source and is built on the efforts of other open source projects. Contributions are welcome.
