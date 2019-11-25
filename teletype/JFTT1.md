---
layout: default
parent: teletype
title: just type studies
nav_order: 4
permalink: /teletype/jt-1/
redirect_from: /modular/teletype/jt-1/
---

## Whimsical Prelude

*monome's Teletype excites us. Writing simple scripts away from a computer; executing tiny morsels of musical composition. Just Type is a suggestion for how these ideas can be extended & deeply integrated with the elements of synthesis, using our Just Friends module.*

*At its most basic, Just Type (JT) is a set of invisible patch cords. Type a command to create a trigger on your desired channel, in parallel with IRL voltages in Just Friends (JF)'s TRIGGER ins. RUN mode & voltage can be set directly, not needing a dummy cable or negative-offset capable voltage source.*

*More than a cloaking device, Just Type extends the base functionality of JF into more complex territory. Use Teletype's `N` notation to easily transpose JF in 12-tone musical increments. Every output can be driven with a varying velocity, adding subtlety and movement to sequences. Even the INTONE relationship can be altered away from the default harmonic structure and instead taken in more experimental directions.*

*Beyond these general-purpose modifications, Just Type brings two entirely new modalities to JF. Synthesis allows independent polyphonic control over each channel, controlled directly, or dynamically allocated as a 6-voice polysynth. Geode instead pursues rhythmic manipulation of striated repetitions, creating polymetric bursts with dynamic decay.*

Enough! Just. Type.
--
<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/DfPADIGjATg?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## Don't burn the locals

The commands outlined in this tutorial build on established conventions in the Teletype language. If you’re new to or rusty with Teletype, it’d be best to start with a review of the original [Teletype Studies for 1.x](https://monome.org/docs/teletype/studies-1/).

Just Type comes pre-installed since Just Friends v3 (late 2017). Get the update [here](https://www.whimsicalraps.com/pages/jf-latest-version) if you have an early JF with the silver & green landscape backplate.

Just Type also requires [Teletype 2.0+](https://monome.org/docs/modular/update/). Any 2.x+ commands in the accompanying musical examples will be explained and hyperlinked to reference points in the [manual](https://monome.org/docs/teletype/manual/).

And of course you'll need to connect an [ii cable](https://market.monome.org/collections/other/products/ii-cable) between the TT and JF. If you have more than 3 modules on your [ii bus](/docs/modular/ii) you will likely need a [TT bus board](https://market.monome.org/collections/other/products/tt-busboard) to ensure the electrical levels are correct.

## Practical Magic

Let's start with some old pals: triggers.

In the Teletype language, triggers are controlled with the command `TR` and two parameters: the hardware output (*1* through *4*) and its on/off state (*1* or *0*).

Try this: with Just Friends switched to *shape/sustain* mode and all knobs at 12:00, patch a cable from Teletype’s *TR 1* to Just Friends's *6N TRIGGER* input. Execute this command in *LIVE* mode on Teletype:

```
TR 1 1
```

You should see the LEDs above each output illuminate as the envelopes blossom in response to the hardware stimulus.

Just Type can create this same response through software, using the ‘invisible cords’ mentioned in the Prelude.

To illustrate, remove the physical patch cable and execute:

```
JF.TR 0 1
```

The output LEDs should brighten again, as the envelopes re-open.

To close them:

```
JF.TR 0 0
```

Magic.

## What's this all about?

`JF.TR` takes two parameters, *channel* and *state*.

*channel*: sets the channel to be triggered

- `1` through `6` is *IDENTITY* through *6N*
- `0` will trigger all channels

*state*: sets the trigger high or low

- non-zero values are ‘high’
- `0` is ‘low’, if required (more on this in a bit)

Give it a try! Keeping Just Friends in *shape/sustain*, execute:

```
JF.TR 6 1
DEL 1000: JF.TR 6 0
```

## Cognitive dissonance

Due to hardware normalization, Just Friends allows *TRIGGERS* to cascade when provoked by hardware triggers. For example, if *6N* is the only physically-patched channel, an impulse sent to *6N* would automatically open the other five.

Just Type simply ignores this hardware normalization because every channel *is* patched to a source — Teletype. This allows for cross-talk between hardware and software triggers, as each trigger source will uniquely manifest.

## Enemy of the state

*sustain* is the only mode that will respond to (indeed, requires) a 'low' trigger. In *sustain*, every `JF.TR channel 1` command must have an accompanying `JF.TR channel 0` to release the envelope.

Implementation is up to the synthesist, but here are some starting points:

- `JF.TR channel TOSS` gives a 50/50 chance of the channel’s envelope changing states
- `DEL ms: JF.TR channel 0` gives a timed start to the channel’s release
- `JF.TR 0 0` releases all of JF’s envelopes simultaneously, which can be interrupted by additional single channel commands

## EXAMPLE: CONTROL ISSUES

Featured in the banner video above.

Just Friends is set to *shape/sustain*. Mangrove's *FORMANT* is sent through *6N* while its *SQUARE* is providing subtle FM.

This scene makes heavy use of two features from Teletype 2.x, [EVERY](https://monome.org/docs/teletype/manual/#every) and [Turtle (@)](https://monome.org/docs/teletype/manual/#turtle).

- `EVERY x:` is a control flow mod that runs a command every `x` times it’s called.
- `@` is a two-dimensional movable index of pattern values on the *TRACKER* screen.

The `I` script:

- builds a fence for Turtle (`@F 0 0 4 4`)
- sets Turtle's speed (`@SPEED 300`)

The `M` script:

- clocks Turtle's steps (`@STEP`)
- randomizes Turtle's direction (`@DIR RRAND -180 180`)
- passes the value in Turtle’s current position to CV 1 (`CV 1 N @`)
- executes `SCRIPT 1`, which sends high triggers/resets to a number of JF channels.

Toggle Turtle visualizer on/off with `@SHOW 1`/`@SHOW 0` in *LIVE* mode.

The scene is pretty minimal, using only one numbered script.
`M` and `I` feature [subcommands](https://monome.org/docs/teletype/manual/#sub-commands-1) tied together with a `;`, condensing commands into a single line.

Lots of room for expansion!

```
#1
EVERY 3: JF.TR 1 1
EVERY 5: JF.TR 3 1
EVERY 4: JF.TR 4 1
EVERY 2: JF.TR 5 1
EVERY 7: JF.TR 6 1
EVERY 2: JF.TR 0 0

#2

#3

#4

#5

#6

#7

#8

#M
@STEP; @DIR RRAND -180 180
CV 1 N @; SCRIPT 1
EVERY 30: CV 2 V RAND 10

#I
M 120
@F 0 0 4 4; @SPEED 300
CV.SLEW 2 3000

#P
4   16  19  11
7   7   0   12
0   12  11  16
11  7   4   23
19  23  7   19
```

## Reference

OP | Description | nb
------------- | ------------- | -------------
`JF.TR x y`   | set channel `x` (`1`-`6`, `0` all) to state `y` (`1`/`0`) | *sustain* requires `JF.TR x 0` to release

## Just Type Studies Continued

[Part 2: Nudge Nudge&rarr;](../jt-2)

Part 1: Practical Magic
