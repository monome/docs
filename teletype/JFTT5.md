---
layout: default
nav_exclude: true
permalink: /teletype/jt-5/
redirect_from: /modular/teletype/jt-5/
---

<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/PF7gS-sXw_k?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## Geode (abstract)

*Geode* is a rhythmic engine for polymetric & polyphasic patterns. This is fundamentally a 'clocked' mode, whether internally or via Teletype. TIME & INTONE maintain their standard free-running influence.

Notes are a combination of a standard trigger along with a repeat count & subdivision. The former sets the number of envelope events to create, while the latter chooses the rhythmic relation of those repeats to the master timebase. *transient / sustain / cycle* chooses how the repeats' amplitude is modified over time. *sustain* decays to zero-level over the duration of the repeats. *cycle* adds a rhythmic undulation to the envelope level, controlled via the RUN jack. Experiment!

Once these rhythmic streams are moving, their pattern can be locked to a quantize amount. Using odd-subdivisions with even quantize or vice-versa will enable patterns to break out of the evenly-spaced repeat model.

## Tick-tock

The timebase for *Geode* can be established through two different uses of one command:

`JF.TICK clock/bpm`

- *clock/bpm*: `49` to `255` directly sets tempo to 49-255 bpm
- *clock/bpm*: `1` to `48` define how many ticks equal one measure, sent repeatedly through tap-tempo from Teletype. eg `JF.TICK 4` meaning four notes per measure

`JF.TICK 0` resets the timebase to the start of the measure.

## Look who's talking, as well!

(These movie title references are almost over.)

Cut from the same cloth as *Synthesis*, *Geode* also utilizes `JF.VOX` and `JF.NOTE` in its own tongue. Instead of lush grumbles and glassy tones, *Geode* speaks in streams of rhythmic envelopes on a named channel, dutifully repeating at a rhythm defined by a division of the clock's measure.

`JF.VOX channel division repeats`

Create a stream at the specified channel, of defined rhythm and duration.

- *channel*: select the channel (`1`-`6`) to assign this stream, `0` sets all
- *division*: set the rhythmic division of a measure
- *repeats*: set the number of repeats in the stream, `-1` repeats indefinitely

`JF.NOTE division repeats`

Dynamic allocation. Assigns the rhythmic stream to the oldest unused channel, or if all channels are busy, the longest running channel.

- *division*: set the rhythmic division of a measure
- *repeats*: set the number of repeats in the stream, `-1` repeats indefinitely

## Flow

Though streams use *division* to determine their rhythm, events can be queued and delayed using a division of the master timebase. Using a quantization that doesn't align with `JF.VOX` / `JF.NOTE`'s *division* of rhythmic streams will cause irregular patterns to unfold.

`JF.QT division`

- *division*: `1` to `32` sets the subdivision and activates quantization, `0` deactivates

Think of `JF.QT` as a performative glue rather than a rigid gridlock. It will slightly affect the timing and 'swing' of events. This is especially wonderful when executing scripts manually or with a fuzz-timed source.

## Example: JUNG LOVE

Featured in the banner video above.

*Geode* is set to *shape/cycle*. *IDENTITY* through *6N* are modulating a resonator (Rings), which is processing (and being sequenced in parallel with) a filtered mix of Mangrove's Square and Formant outs.

Scripts 1-7 are triggered from the keyboard. Script 7 randomly assigns a velocity between 3V and 7V to *6N*.

Teletype's metronome, which is sequencing the v/8, is bit slower than `JF.TICK`. `JF.VOX` commands span even and odd divisions, which `JF.QT` attempts to wrangle.

Honestly, I'm not even sure what's really going on here. But it's fun.

```
#1
JF.VOX 1 5 2

#2
JF.VOX 2 4 4

#3
JF.VOX 3 3 9

#4
JF.VOX 4 1 9

#5
JF.VOX 5 10 19

#6
JF.VOX 6 2 4

#7
JF.VTR 6 V RRAND 3 7

#8

#M
CV 1 N PN.NEXT 0
CV 2 N PN.HERE 0
CV.OFF 1 V * 1 TOSS
CV.OFF 2 V * 2 TOSS

#I
JF.MODE 1
JF.TICK 99
JF.QT 6

#P

12	0	0	0
19	0	0	0
3	0	0	0
7	0	0	0
0	0	0	0
```

## Reference

| OP  |  Description | nb |
|:------------- |:---------------|:---------------|
| `JF.TICK x`   | set `x` bpm (`49`-`255`), tap-tempo (`1`-`48`) or reset (`0`). | requires `JF.MODE 1`, *Geode*
| `JF.QT x`		| quantize events 1-bar/`x` (`1`-`32`), `0` deactivates. | requires `JF.MODE 1`, *Geode*


## Just Type Studies Continued

[Part 6: Collaboration &rarr;](../jt-6)

Part 5: Evens and Odds

[Part 4: Personality Changes &larr;](../jt-4)

[Part 3: Freedom &larr;](../jt-3)

[Part 2: Nudge Nudge &larr;](../jt-2)

[Part 1: Practical Magic &larr;](../jt-1)
