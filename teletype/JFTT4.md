---
layout: default
nav_exclude: true
permalink: /teletype/jt-4/
redirect_from: /modular/teletype/jt-4/
---

<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/5IoiERamfb8?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## <del>Reinvent the wheel</del>

So far, we've covered how to use Teletype commands to control Just Friends in ways that *are* possible with physical cables and knob fiddles, but made much easier through software control.

Now, we'll shift into the Teletype-specific modes of Just Type: *Synthesis* and *Geode*.

## Modal Personality

Until now, we've only been speaking of modifying or extending the base Just Friends behaviours. It is also possible to change some fundamentals of the JF system, leaning more heavily on the Teletype integration for configuration and control.

These alternate personalities are **Synthesis**, a polyphonic synthesizer; and **Geode**, a rhythm machine. `JF.MODE 1` will take you to these modes respective of the *sound / shape* setting. Beware that whilst in JT's alternate modes, things will behave differently to normal & will remain there until power-cycling or exiting with `JF.MODE 0`.

`JF.MODE mode`

- *mode*: non-zero activates JT alternate modes, `0` returns to standard functionality

## Synthesis (abstract)

*Synthesis* is a polyphonic synthesizer of six independent voices. Control is either explicitly *per voice*, or can be dynamically assigned in a traditional polysynth fashion.

Pitch is controlled digitally, via Teletype. Each voice is shaped by RAMP & CURVE as per normal, then passed to a Vactrol Low-Pass Gate model to impart velocity. The Vactrol model implements rudimentary envelope shaping of the velocity: TIME for envelope speed and INTONE for attack-release shaping. These envelopes are controlled by the *transient / sustain / cycle* mode, and may be excited either digitally or via the hardware TRIGGERS. We'll explore this in a bit.

Internally, each voice contains a linked sinewave oscillator providing frequency modulation over the function generator. FM amount or index, is controlled with the FM knob & CV input. The knob functions as normal with INTONE modulation CCW, and even modulation CW. CV input is a traditional CV-offset where positive voltage increases, and negative decreases modulation. The frequency relationship between the modulation & carrier oscillators is set via the RUN jack, though is matched at 1:1 with no cable attached. Positive voltages move toward 2:1 at 5V, while negative sweeps down to 1:2 at -5V giving many grumbles.

## Changes

When first activated, *Synthesis* rings out notes from all six channels -- this is just a friendly confirmation that you're in *Synthesis* versus standard functionality. All pitches begin on C3. All pitch programming is relative to C3, by default, but this can be adjusted with `JF.SHIFT pitch`. *pitch* is the number of semitones up or down from the reference C3.

eg:

```
JF.SHIFT N 4		<~~~~ retune the engine to E3
JF.SHIFT V -1		<~~~~ retune the engine to C2
JF.SHIFT N -7		<~~~~ retune the engine to F2
```

This mimics the frequency control that TIME normally has in standard-functionality Just Friends.

By default, *Synthesis* assumes A=440Hz. [Want to align with the universe?](https://attunedvibrations.com/432hz/):

`JF.GOD state`

- *state*: `0` is A=440Hz, `1` is A=432Hz

## Play

Control in *Synthesis* is similar to MIDI -- assign a channel its pitch and velocity. This can be done one of two ways:

`JF.VOX channel pitch velocity`

Create a note at the specified *channel*, of defined *pitch* and *velocity*.

- *channel*: choose a channel (`1`-`6`), `0` sets all
- *pitch*: assign a pitch, relative to C3 (eg `N3` moves three semitones up from C3 to Eb3, `V1` yields C4)
- *velocity*: set the volume, as with `JF.VTR` (eg `V5` for 5V peak-to-peak)

`JF.NOTE pitch velocity`

Polyphonically allocated notes of defined *pitch* and *velocity*. Free channels will be taken first. If all channels are busy, allocation will steal from the channel which has been active longest.

- *pitch*: set the pitch, relative to C3
- *velocity*: set the volume, as with `JF.VTR`

The `JF.VOX` and `JF.NOTE` commands are designed to create complete notes in the General MIDI sense. They simultaneously set the pitch of a voice & begin / end an envelope cycle.

Physical TRIGGERS will only trigger the envelope, using whatever pitch & velocity are currently set for that voice, encouraging combinations of digital & voltage control.

## Testing...

Let's get our feet wet: TIME at 10, all others at noon,  *sound/cycle*. Listen to MIX.

Let's play with an Fmaj7 chord in *LIVE*:

```
JF.MODE 1		<~~~~ turns on *Synthesis* mode
JF.SHIFT N -7		<~~~~ retunes sound engine to F2
JF.VOX 2 N 4 V 7	<~~~~ note: ch 2, A2, 0.7 vel.
JF.VOX 3 N 7 V 6	<~~~~ note: ch 3, C3, 0.6 vel.
JF.VOX 4 N 11 V 5	<~~~~ note: ch 4, E3, 0.5 vel.
JF.NOTE N 12 V 5	<~~~~ note: free channel, F3, 0.5 vel.
JF.VOX 0 N 0 V 10 	<~~~~ note: all channels, F2, full vel.
```
I particularly love *cycle* in *Synthesis* mode because each note event will cycle independently, yet in the same timescale.

## Example: GROOVE LITE

Featured in the banner video above.

*Synthesis* is set to *sound/sustain*. Physical TRIGGERS are patched from an Ansible running Kria. The first four outs of Just Friends are patched through Cold Mac, which routes into Three Sisters.

Scripts 5 through 8 create sustained tones, picking pitches randomly from a pattern. Because physical TRIGGERS work with the envelope's digital settings, any sustained tone ignores the hardware re-TRIGGER.

Scripts 1 through 4 release the envelopes moments after a new pitch is assigned, allowing the physical TRIGGERS from Kria to ping the notes.

As of Teletype 2.x+, `I` can be a [local variable](https://monome.org/docs/teletype/manual/#new-operator-behaviour). Here, it's used as a way to accomplish an impossibility: `JF.VOX 1 N PN 0 RAND 9 V RRAND 4 8`.

(fwiw, the banner video is not sped up. I wondered the same when I watched the first time and it's weird.)

```
#1
I PN 0 RAND 9
JF.VOX 1 N I V RRAND 4 8
DEL 5: JF.VOX 1 N I V 0

#2
I PN 0 RAND 9
JF.VOX 2 N I V RRAND 3 8
DEL 30: JF.VOX 2 N I V 0

#3
I PN 0 RAND 9
JF.VOX 3 N I V RRAND 4 8
DEL 30: JF.VOX 3 N 0 V 0

#4
I PN 0 RAND 9
JF.VOX 4 N I V RRAND 4 7
DEL 30: JF.VOX 4 N 0 V 0

#5
I PN 0 RAND 9
JF.VOX 1 N I V 4

#6
I PN 0 RAND 9
JF.VOX 2 N I V 4

#7
I PN 0 RAND 9
JF.VOX 3 N - I 12 V 5

#8
I PN 0 RAND 9
JF.VOX 4 N - I 12 V 3

#M

#I
JF.MODE 1

#P

0	0	0	0
2	0	0	0
4	0	0	0
7	0	0	0
9	0	0	0
12	0	0	0
14	0	0	0
16	0	0	0
19	0	0	0
21	0	0	0
```

## Reference

| OP  |  Description | nb |
| --- | --- | --- |
| `JF.MODE x`  | non-zero `x` activates *Synthesis* / *Geode*, `0` deactivates |
| `JF.GOD x`		| redefines C3; `0`: A=440Hz, `1`: A=432Hz | requires `JF.MODE 1` |
| `JF.VOX x y z` | channel `x` (`1`-`6`, `0` all) receives note `y` at velocity `z` volts. | requires `JF.MODE 1` |
| `JF.NOTE x y`	| polyphonically-allocated channel receives note `x` at `y` volts. | requires `JF.MODE 1` |


## Just Type Studies Continued


[Part 5: Evens and Odds &rarr;](../jt-5)

Part 4: Personality Changes

[Part 3: Freedom &larr;](../jt-3)

[Part 2: Nudge Nudge &larr;](../jt-2)

[Part 1: Practical Magic &larr;](../jt-1)
