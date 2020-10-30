---
layout: default
parent: legacy
title: walk
nav_order: 4
redirect_from: /modular/walk/
---

# Walk

*Territory.*

## Installation

Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the top edge of the module.

Be careful not to misalign the connector left-to-right either – while Walk is protected against incorrect connection, doing so may damage other modules in your Eurorack case.

Secure the module with two included screws, hiding under the tape in the box lid.

*Power consumption:*

- 12mA @ +12V
- No -12V required
- No +5v required


## Getting Started

Attach the included footswitches to the 1/4" jacks on the front of the module. These switches are the primary interface into the module and it won't do much of anything without them.

If you want to use different switches with the module, they should be momentary & normally-closed for standard behaviour.

Once you've powered up the module press the footswitches to see the lights change on the module, reflecting the current state of the output jacks.

The panel is arranged with two identical blocks, one for each footswitch, plus a unifying middle section responding to the state of both switches in tandem. The independent blocks have *Momentary* and *Toggle* outs, while the central section performs *Logic* functions based on the switch states. Walk is particularly powerful because all six outputs are available simultaneously, allowing the simple gesture of *on/off* to impart a great deal of change.

Walk was developed as an ideal companion to [Teletype](http://monome.org/docs/teletype), though also pairs well with [White Whale](http://monome.org/docs/whitewhale) for manually stepping through sequences, becoming a 16-stage memory bank.


## Momentary

The simplest use of Walk is as a pair of foot-controlled gates, corresponding directly to the state of the footswitches. These outputs are available at the outputs marked **M** on the panel.

Use these outputs when you want to manually clock another module, or trigger an event to occur. These events could include triggering an envelope or percussion module, advancing a sequencer one step at a time, or triggering an event in *Teletype*.

Additionally, because the output is a *gate* and not just a *trigger* it can also be used to hold open voltage-controlled gates, or modulate other parameters. The output level is +8v so you will likely need an attenuator in order to fine-tune the amount of change.


## Toggle

Converse to the *Momentary* outputs, the *Toggles* only responded to pressing-down on the switches, changing state each time the switch is pressed. The current state of the two toggles are shown next to the **T** labeled outputs, where the gate outputs are available.

These *Toggles* are identical to the function of a guitar effects pedal switch, where the output *cycles* through each time you stomp. This is a great way to use the toggles, by controlling the dry/wet mix of an effects module. Of course there are many other functions where this can come in handy, such as start/stopping a sequencer, or simply changing between two timbral states of a patch with the press of a switch.

## Two Footed Logic

Unifying the two footswitches is a set of *Two Footed Logic* functions. These outputs count how many switches are held:

- *Neither switch held*: Both XOR & AND are low (0v).
- *1 switch held*: XOR is high (8v) while AND is low (0v).
- *Both switches held*: XOR is low (0v) while AND is high (8v).

The XOR function flashes the panel led WHITE, while the AND function sets the led YELLOW. The two functions are exclusive so only one function is ever high at the same time.

These outputs reflect how much foot interaction is currently occurring, and respond to the *Momentary* state of the switches (not toggles). The utility of these functions is much less prescriptive than the above independent functions, instead encouraging exploration and experimentation.

Rhythmic pressing of the footswitches will be highly responsive to these logic functions, with the AND output being responsive to the amount of overlap between alternate presses. Patching with both *Momentary* outputs and these *Logic* functions can create some very interesting patterns that are well suited to triggering rhythmic generators.

## Techniques

### Edge detection

While Walk is designed for both switches to be used simultaneously, some interesting behaviour happens when only one switch is attached.

- Remove one footswitch from the front panel.
- When the remaining switch is not depressed, the XOR output is HIGH.
- When the switch is pressed, XOR goes low, while AND goes HIGH.

XOR can now be thought of as being an inverted version of the *Momentary* output.

Attaching the XOR & AND outputs to *Teletype* a different event can now be triggered on both press & release!
