---
layout: default
title: midi
parent: ansible
nav_order: 6
redirect_from: /modular/ansible/midi/
---

## MIDI/voice

By plugging a USB MIDI device into the [Ansible](/docs/ansible) Eurorack module, you can access various MIDI-to-CV tools. These tools are available with a standalone Ansible, as well as an Ansible paired with Teletype through [dedicated Teletype commands](/docs/ansible/teletype/#midi).

The mode LED will show orange when running.

### Interface

  * `Key 1`: Panic (clear all TR/CV)
  * `In 1`: Panic

  * `Key 2`: Change allocation style
  * `In 2`: (nothing currently)

### Allocation style 1: POLY

CV/TR output pitch and gate respectively for incoming MIDI notes. CV/TR pairs rotated per MIDI note as a shift register, allowing polyphonic voice mapping.

MIDI sustain and +/- 1 octave pitch bend supported.

### Allocation style 2: MONO

One voice, monophonic. With extra parameter mappings:

```
CV 1: Pitch
CV 2: Velocity
CV 3: Aftertouch/channel pressure
CV 4: Mod
TR 1: Gate
TR 2: Damper/sustain (cc64)
TR 3: Generic (cc80)
TR 4: MIDI clock (16th note timing as of firmware 1.4)
```

+/- 1 octave pitch bend supported.

### Allocation style 3: MULTI

4 pairs of CV/TR mapped in simple MONO pitch/gate outputs responding to MIDI channels 1-4.

### Allocation style 4: FIXED

TR mapped to notes C4, D4, E4, F4 (60,62,64,65).

CV mapped to CC 16,17,18,19

Enter learning mode by holding `Key 1` and pressing `preset` (all CV/TR will clear). As unique notes and/or CC messages are received they are mapped to the next available CV/TR output respectively. Once all outputs are mapped all LEDs will go out. Press `Key 1` (panic) to cancel learning.

### Preset

_as of Ansible firmware 1.4_

Holding `Key 2` and a short press on `preset` saves the current value for the following to flash as the default (mode light blinks once):

  * selected voice allocation mode
  * pitch slew (set via teletype)
  * pitch offset (set via teletype)
  * fixed mapping

Holding `Key 2` and a long press on `preset` will clear the stored configuration and reset back to default values (mode light blinks twice).

The default pitch offset is -2 octaves which is the equivalent of issuing the following Teletype command `MID.SHIFT N -24`.

## MIDI/arp

The mode LED will show white when running.

### Interface

  * `Key 1`: tap tempo / force internal clock (press twice)
  * `In 1`: sync / ext clock

  * `Key 2`: arp style:
     * as played       _(as of firmware 1.4)_
     * up
     * down
     * up/down (tri)
     * up and down (repeat high/low note)
     * converge
     * diverge
     * random

  * `In 2`: reset

Each CR/TR pair is a voice playing the arpeggio at a different divisions of the clock, initially divisions of `1,2,3,4` respectively.

Additional parameters can be controlled via CC input:

  * CC 16: Internal tempo (when not clocked by in 1 or MIDI clock)
  * CC 17: Gate length (course divisions sync'd to the clock)
  * CC 18: Scale clock division for voices 2-4:
      * `1,2,3,4`
      * `1,4,6,8`
      * `1,6,9,12`
      * `1,8,12,16`

 If MIDI clock is received it will be used as the clock source when no external clock is present.

### Preset

_as of Ansible firmware 1.4_

Holding `Key 2` and a short press on `preset` saves the current value for the following to flash as the default (mode light blinks once):

  * clock period
  * selected arp style
  * hold mode (on/off)
  * pitch slew values
  * pitch shift values
  * pattern repeat values
  * euclidean rhythm parameters ([accessible through Teletype](/docs/ansible/teletype/#midi))

Holding `Key 2` and a long press on `preset` will clear the stored configuration and reset back to default values (the mode light blinks twice).
