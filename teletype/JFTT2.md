---
layout: default
nav_exclude: true
permalink: /teletype/jt-2/
redirect_from: /modular/teletype/jt-2/
---

<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/SczDW9WMDTA?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## Locomotion

One of the most notable aspects of Just Friends is its RUN jack. Simultaneously a switch and a lever, it shifts functionality and equations with the mere presence of a patch cable. Negative and positive voltages further affect behaviors. Modes are determined by the *sound / shape* and *transient / sustain / cycle* switches on the physical unit.

Just Type can activate and modulate the RUN jack without a physical connection:

`JF.RMODE mode`

- any non-zero values will activate RUN mode, e.g. `JF.RMODE 1` or `JF.RMODE 249` or `JF.RMODE 1837`
- `JF.RMODE 0` will deactivate RUN mode, unless a physical cable is present in the RUN jack

Just Friends v3 features new RUN mode behaviors and re-tooled classics ([documentation](https://cdn.shopify.com/s/files/1/0714/9931/files/JFv2-Manual-6x17-web.pdf?2566041409757484863)).

## Presence

Try this...

- Just Friends in *shape/cycle*
- all knobs ~12:00
- *CHANNEL* outputs to modulation points throughout your system

...and execute in *LIVE* mode:

```
JF.RMODE 1
JF.TR 0 1
```

Just Friends is now in *VOLLEY*, bursting forth six repetitions for each *TRIGGER* received.

## A little bit softer, now...

You might find reason to adjust the oomph of the envelopes (and later, audio output) from the Just Friends outs. For these occasions, Just Type reveals a volume control command, scaled in volts:

`JF.VTR channel velocity`

- *channel*: which channel to trigger. `0` sets all channels
- *velocity*: amplitude of output in volts. eg `JF.VTR 1 V 4`

Channels remember their latest *velocity* setting and apply it regardless of *TRIGGER* origin (digital or physical).

`JF.VTR` opens a new realm of dynamics without the need for physical attenuation.

## Ghost in the machine

When RUN behavior is enabled with `JF.RMODE 1`, Just Type can simulate voltage to the RUN input sans a physical patch cable or attenuverter with this command:

`JF.RUN state`

- *state*: standard Teletype voltage maths, eg `JF.RUN V -2`or `JF.RUN vv 350`

Expected range is `V -5` to `V 5`.

In *LIVE* mode, apply this again to *VOLLEY* (*shape/cycle*), where voltages affect the number of repetitions:

```
JF.RMODE 1		<~~~~ activate RUN mode
JF.RUN V 0		<~~~~ RUN voltage = 0V
JF.TR 0 1		<~~~~ TRIGGER all channels, 6 repetitions
JF.RUN V -1		<~~~~ RUN voltage = -1V
JF.TR 1 1		<~~~~ TRIGGER channel 1, 4 repetitions
JF.RUN V 4		<~~~~ RUN voltage = 4V
JF.TR 2 1		<~~~~ TRIGGER channel 2, 25 repetitions
JF.RUN vv -50		<~~~~ RUN voltage = -0.5V
JF.TR 3 1		<~~~~ TRIGGER channel 3, 5 repetitions
```

Notice that new `JF.RUN state` commands do not affect already-cycling channels without a re-TRIGGER. Sequencing these changes can open polyphasic fun.

## Example: SECRET HANDSHAKE

Featured in the banner video above.

Just Friends is set to *shape/transient* for *SHIFT*.

In the `M` script, we're again making use of `EVERY x:` commands. This time, to stagger the execution of CV note commands between two external oscillators against randomly selected sets of RUN voltage commands and CV offsets.

*I*, *4N*, *5N* and *6N* are all patched to control dynamics (VCA, LPG and VCF). The TIME knob changes the rhythmic divisions of each.

It might be worthwhile to expand SECRET HANDSHAKE by modulating TIME with a physical cable from one of Teletype’s free CV outputs.

```
#1
JF.RUN V -3
CV.OFF 1 N -7; CV.OFF 2 N 7

#2
JF.RUN V -1
CV.OFF 1 N 7; CV.OFF 2 N 7

#3
JF.RUN VV 1
CV.OFF 1 N 0; CV.OFF 2 N 0

#4
JF.RUN V 3
CV.OFF 1 N -7

#5
JF.RUN V 1
EVERY 2: CV.OFF 2 V 2
OTHER: CV.OFF 2 V 0

#6

#7

#8

#M
JF.TR 0 1
CV 2 N PN.NEXT 0
EVERY 4: CV 1 N PN.NEXT 1
EVERY 16: SCRIPT RRAND 1 5

#I
JF.RMODE 1

#P
0	7	0	0
4	11	0	0
7	14	0 	0
11	18	0	0
```

## Reference

| OP  |  Description | nb
|------------- | ------------- | -------------
| `JF.VTR x y`   | trigger channel `x` (`1`-`6`, `0` all) with velocity `y` | `y` expects `V 1`-`V 10`, mute with `V 0`
| `JF.RMODE x`	| non-zero `x` activates RUN mode, `0` deactivates
| `JF.RUN x`		| apply `x` volts to RUN | `y` expects `V -5` to `V 5`. requires `JF.RMODE 1`

## Just Type Studies Continued

[Part 3: Freedom &rarr;](../jt-3)

Part 2: Nudge Nudge

[Part 1: Practical Magic &larr;](../jt-1)
