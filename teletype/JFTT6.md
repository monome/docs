---
layout: default
nav_exclude: true
permalink: /teletype/jt-6/
redirect_from: /modular/teletype/jt-6/
---

<div class="vid"><iframe width="860" height="484" src="https://www.youtube.com/embed/cFkbs5Q57fc?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>

## Less is more

There's something fulfilling about digging in deep with smaller toolkits. Just Type allows for a wide range of styles and intentions -- from sprawling modulation to straightforward composition.

The commands and examples covered in this series are simplified starting points, begging to be chained together toward complex goals. Interacting with Just Type through both hardware and software will open even more doors, but much can be explored through coding alone.

**Just. Type.**

## Example: COUPLING

Featured in the banner video above.

Two modules: Teletype and Just Friends. JF is in *Synthesis* mode, *sound / cycle*. MIX out, gentle reverb applied.

In `I`: `JF.SHIFT` assigns the tonal starting point to G2 and a `DRUNK` walk's bounds are placed at -1 and 1, with wrapping.

In `M`: three variables are randomly assigned (`X`, `Y` and `Z`). Every five metro ticks, channel `X` is voiced at velocity `Y` and remains at that volume until re-assigned. `Z` provides software modulation to the RUN jack.

In *Synthesis*, RUN sets the frequency relationship between the modulation & carrier oscillators for FM. The shifts between `V -250` and `V 1` uncover a melody.

The numbered scripts are just chord shapes and performative changes.

```
#1
JF.VOX 1 N -5 V 5
JF.VOX 2 N 0 V 5
JF.VOX 3 N 7 V 5
JF.VOX 4 N 12 V 5
JF.VOX 5 N 16 V 5
JF.VOX 6 N 19 V 5

#2
JF.VOX 1 N 4 V 5
JF.VOX 2 N 9 V 5
JF.VOX 3 N 16 V 5

#3
JF.VOX 1 N 2 V 5
JF.VOX 2 N 5 V 5
JF.VOX 3 N 14 V 5
JF.VOX 6 N 24 V 5

#4
JF.VOX 1 N 2 V 0
JF.VOX 2 N 5 V 0
JF.VOX 3 N 28 V 3

#5
EVERY 2: JF.SHIFT N -5
OTHER: JF.SHIFT N 7

#6
JF.VOX 3 N 17 V 5

#7

#8

#M
X RAND 6; Y RRAND 3 6
Z DRUNK
EVERY 5: JF.VTR X V Y
IF EQ Z -1: JF.RUN VV -250
IF EQ Z 0: JF.RUN VV 0
IF EQ Z 1: JF.RUN V 1

#I
JF.MODE 1
JF.SHIFT N -5
DRUNK.MIN -1; DRUNK.MAX 1
DRUNK.WRAP 1
M 190
```

## Reference

Before we part, it might be helpful to provide a quick overview of all commands covered...

### Glossary

| OP  |  Description | nb |
|:------------- |:---------------|:---------------|
| `JF.TR x y`   | set channel `x` (`1`-`6`, `0` all) to state `y` (`1`/`0`)
| `JF.VTR x y`   | trigger channel `x` (`1`-`6`, `0` all) with velocity `y` | `y` expects `V 1`-`V 10`, mute with `V 0`
| `JF.RMODE x`	| non-zero `x` activates RUN mode, `0` deactivates
| `JF.RUN x`		| apply `x` volts to RUN | `y` expects `V -5` to `V 5`. requires `JF.RMODE 1`
| `JF.SHIFT x` | shift the base rate (TIME) by `x` volts/semitones
| `JF.TUNE x y z` | adjust the tuning ratio `y`:`z` of channel `x` (1-6). | recall defaults with `JF.TUNE 0 0 0`, save custom ratios across power cycles with `JF.TUNE -1 0 0`
| `JF.MODE x`  | non-zero `x` activates *Synthesis* / *Geode*, `0` deactivates
| `JF.GOD x`		| redefines C3; `0`: A=440Hz, `1`: A=432Hz | requires `JF.MODE 1`
| `JF.VOX x y z` | channel `x` (`1`-`6`, `0` all) receives note `y` at velocity `z` volts. | requires `JF.MODE 1`
| `JF.NOTE x y`	| polyphonically-allocated channel receives note `x` at `y` volts. | requires `JF.MODE 1`
| `JF.TICK x`   | set `x` bpm (`49`-`255`), tap-tempo (`1`-`48`) or reset (`0`). | requires `JF.MODE 1`, *Geode*
| `JF.QT x`		| quantize events 1-bar/`x` (`1`-`32`), `0` deactivates. | requires `JF.MODE 1`, *Geode*



## Just Type Studies

Part 6: Collaboration

[Part 5: Evens and Odds &larr;](../jt-5)

[Part 4: Personality Changes &larr;](../jt-5)

[Part 3: Freedom &larr;](../jt-3)

[Part 2: Nudge Nudge &larr;](../jt-2)

[Part 1: Practical Magic &larr;](../jt-1)

## Credits

This study was created by [Dan Derks](http://soundcloud.com/sound-and-process).
