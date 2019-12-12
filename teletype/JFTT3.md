---
layout: default
nav_exclude: true
permalink: /teletype/jt-3/
redirect_from: /modular/teletype/jt-3/
---

<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/PQ4xUgWUlQQ?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## Mr. Sandman

Depending on the mode, TIME adjusts the rate of *shape* or the pitch of *sound*. Without external control, the boundaries are set from 4 seconds up to 6.2khz.

External CV broadens this range significantly, allowing for "languid undulations" of 30 seconds to near-ultrasonic audio at 24khz.

Just Type provides familiar points of entry with Teletype's `N`, `V` and `VV`:

`JF.SHIFT pitch`

- *pitch*: amount to shift the base rate (TIME) by, eg `JF.SHIFT V 3` or `JF.SHIFT N -2`

## Rational thinking

INTONE provides a compass to navigate a landscape of factory-set ratios. In *shape*, these are demarcated by the numbered *N* outputs; eg *2N* & *3N* provide two:three ratios or rhythms. In *sound*, these are the first six elements of the harmonic series. At INTONE's CCW and CW extremes, the outs pulse or sing this ratio low or high, with various detunings available along the curve.

Just Type allows the synthesist to free these voices from their metropolitan assumptions and explore new tuning ratios:

`JF.TUNE channel numerator denominator`

- *channel*: selects which channel's tuning to redefine
- *numerator*: set the multiple for the tuning ratio
- *denominator*: set the divisor for the tuning ratio

Following this convention, the defaults for each channel are:

*IDENTITY*: `JF.TUNE 1 1 1`
*2N*: `JF.TUNE 2 2 1`
*3N*: `JF.TUNE 3 3 1`
*4N*: `JF.TUNE 4 4 1`
*5N*: `JF.TUNE 5 5 1`
*6N*: `JF.TUNE 6 6 1`

If things get too weird, you can quickly recall these defaults with: `JF.TUNE 0 0 0`.

Permanently save changes to `JF.TUNE` across power cycles with: `JF.TUNE -1 0 0`.

Reading up on just intonation will help guide experimentation and illustrate the 'why' behind the results. [A starting point](http://www.kylegann.com/tuning.html).

## Add it up

It feels worthwhile (though perhaps obvious) to note that `JF.SHIFT` causes global change across each channel, just as CV sequencing the v/8 jack would.

Without Just Type, one could dial INTONE modulation in tandem with v/8 and FM sequencing to achieve shifting relationships between the outputs.

`JF.TUNE` really shines by removing immediate barriers and allowing single-channel modulation with straightforward maths. When sequenced alongside `JF.SHIFT`, minimal material can create complex melodies or rhythmic patterns.

## Example: INDEPENDENCE DAY

Featured in the banner video above.

Just Friends is set to *sound/sustain* for *PLUME*. INTONE is turned fully CW. *IDENTITY*, *3N*, *5N* and *6N* are all sent to Three Sisters, which partitions blends of each into sweepable bands.

The first script begins by cycling through a simple six note sequence. The cascading `JF.TUNE` modulations that follow provide unique translations and transpositions of the sequence. A semi-contrapuntal choir is born from only a few lines of code and three modules.

`M` provides TRIGGERS to all channels, as well as a variable release (`DEL / M X: JF.TR 0 0`). Adjust `X` to taste or map it to the parameter knob.

Expansions on this scene could include RUN modulation through `JF.RUN state`, volume automation with `JF.VTR channel velocity`, or more adventurous tuning ratios.

```
#1
JF.SHIFT N PN.NEXT 0
EVERY 7: JF.TUNE 5 10 3
EVERY 10: JF.TUNE 5 20 3
EVERY 19: JF.TUNE 5 10 2
IF TOSS: JF.TUNE 3 3 1
ELSE: JF.TUNE 3 4 1

#M
SCRIPT 1
JF.TR 0 1
DEL / M X: JF.TR 0 0

#I
JF.SHIFT N 0
JF.RMODE 1
X 5

#P
-2	0	0	0
-3	0	0	0
-2	0	0	0
5	0	0	0
3	0	0	0
2	0	0	0
```

## Reference

| OP | Description | nb |
| ------------- | ------------- | ------------- |
|`JF.SHIFT x` | shift the base rate (TIME) by `x` volts/semitones |
|`JF.TUNE x y z` | adjust the tuning ratio `y`:`z` of channel `x` (1-6). | recall defaults with `JF.TUNE 0 0 0`, save custom ratios across power cycles with `JF.TUNE -1 0 0` |

## Just Type Studies Continued

[Part 4: Personality Changes &rarr;](../jt-4)

Part 3: Freedom

[Part 2: Nudge Nudge &larr;](../jt-2)

[Part 1: Practical Magic &larr;](../jt-1)
