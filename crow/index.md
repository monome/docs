---
layout: default
title: crow
nav_order: 4
has_children: true
has_toc: false
---

![](images/crow.jpg)

crow speaks and listens and remembers bits of text. A scriptable USB-CV-ii machine.

crow connects to norns and computers running Max, Max for Live, and other serial-enabled applications. We've created various norns scripts and Max for Live devices which require no programming, and we've also created tutorials and studies to get you started quickly programming your own ideas into this tiny, powerful module.

crow also stores a complete script, so that without a USB connection it can continue to run, responding to CV input and ii/i2c messages.

A collaboration by [Whimsical Raps](https://www.whimsicalraps.com) and monome.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## specifications

- Eurorack, 2hp width, 41mm depth
- Power consumption: 60mA @ +12v, -15mA @ -12V, no 5V
- 2 input, 4 output, 16bit [-5V,10V] range
- Rear panel digital communication bus via [ii/i2c](/docs/ansible/i2c/#what-is-i2c--ii) (cables available [here](https://www.adafruit.com/product/266))
- full Lua scripting environment

## installation

Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the lower edge of the module.

If you would like to use the [ii/i2c](/docs/modular/ii) functionality, be sure to observe the orientation of the connector. The white stripe indicates GND.

## first

each crow has its own unique sound, in the form of a generative sequencer. [first](/docs/crow/first) is a starting point.

## environments


<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/362620801?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

### norns

crow integrates seamlessly with norns as a CV and [ii/i2c](/docs/modular/ii) interface. By default, crow can be a norns clocking source or destination. [Many scripts have additional crow functionality](https://norns.community/tag/crow). Please note that presently only a single crow is supported by the norns scripting API.

Want to script on your own? See the full [crow studies](norns) for a complete guide

### computer + druid

You can use your computer's terminal to access [druid](druid), a small utility for communicating with crow. druid helps you engage crow in realtime interaction and also upload full scripts (coded in Lua), providing an interactive platform for designing new patterns in a modular synth.

Want to see what others have scripted? Visit [bowery](https://github.com/monome/bowery), the druid script collection, and complete *stage one* of the [scripting tutorial](scripting) to learn how to upload scripts.

Learn to map your own flight paths with *stage two* and *stage three* of the [scripting tutorial](scripting).

### computer + Max 8 / Max for (Ableton) Live

[Max](https://cycling74.com) is a powerful visual coding language that has integrations with [Ableton Live](https://www.ableton.com/en/live/max-for-live/).

Using the custom `[crow]` object in Max 8, create your own Live-controllable devices or standalone utilities.

We have also created Max for Live devices to integrate crow with Ableton Live, including: synced clocks, MIDI-to-v/8, CC-to-voltage (which can be mapped to any software modulation source), ii/i2c communication with [Just Friends](https://www.whimsicalraps.com/products/just-friends?variant=5586981781533), executing Lua code directly in Live, parameter mapping your crow scripts, and triggering Lua chunks with MIDI.

Want to learn more? [Check out the docs](/docs/crow/max-m4l/).  
Afterward, visit the [Max and Max for Live repo on GitHub](https://github.com/monome/crow-max) to get started.

### scripting reference

If you are writing or modifying norns scripts, standalone druid snippets, or Max patches, you'll want to visit the [scripting reference](reference) to become fluent in the language of the birds.

## updates

To update crow, review [the step-by-step instructions](update).

## development

crow continues to evolve and you can follow development on GitHub: [https://github.com/monome/crow](https://github.com/monome/crow)  

crow is open-source and is built on the efforts of other open-source projects. Contributions are welcome.

## further

Answers to frequently asked questions can be found in [crow questions](faq).  
Community discussion happens at [llllllll.co](https://llllllll.co). Come say hello!  
Contact [help@monome.org](mailto:help@monome.org) for direct support.
