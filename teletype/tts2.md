---
layout: default
nav_exclude: true
permalink: /teletype/studies-2/
redirect_from: /modular/teletype/studies-2/
---
<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/135609254?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## Clean sweep

Welcome to the second level! For an optimal experience first load up a blank scene. Let's try something new and load a scene without using the keyboard:

* Touch the front panel key next to the USB port and boom, you're in *SCENE* mode
* Turn the **param** knob to scroll through the scenes
* Touch and hold the same front panel key to load the scene
* (Alternatively, to exit without loading, just hit the key quickly)

Scene loading this way is particularly helpful if you're using precomposed scenes during performance and would rather not have a keyboard in front of your synth.

## What is a bit?

Before we make sounds, we have to have a talk. About numbers. I'll try to make it fast.

Eurorack modular uses control voltages in a range of 0 to 10 volts. This is a continuous, analog range. Computers (including Teletype) are generally not analog and represent values (numbers) as a [series of digital bits](https://en.wikipedia.org/wiki/Bit). ([Here's a better explanation](https://www.youtube.com/watch?v=RPl-wYIj6Xw?t=13m54s)). Teletype uses signed 16 bit numbers, so -16384 through 16384. Let us explain further:

The CV outputs 1-4 can create voltages between 0 and 10. Internally, Teletype sees this as 0 through 16384, which is 14 bit. But it's somewhat inconvenient to remember 16383 is equal to 10 volts-- so instead we use a lookup table. In *LIVE* mode, type:

    V 10

You'll see `16384` pop up. Try `V 5`. You'll get half that.

## Making volts

Let's actually hear it. Plug output CV 1 into the frequency input of an oscillator, and patch that so it makes sound. We change the CV value with with the `CV` command:

    CV 1 V 2

The first argument `1` is which CV output you're changing. This can be 1-4. We're then using the `V` command to look up the value of 2 volts. Effectively this is the same as typing `CV 1 3277`.

Oscillators should track one octave per volt, so right now the oscillator should be playing two octaves above wherever it is tuned. To return back to zero, type:

    CV 1 0

We don't really need to type `V 0` because it's the same as `0`, but you can if you want.

But you may want some value besides just octaves. (Though, if you are making octaves-only music, I want to hear it-- please e-mail [tehn@monome.org](mailto:tehn@monome.org)). Teletype only understands whole numbers-- you can't use decimal points. We designed it this way to keep it as simple as possible.

To get 2.5 volts, use the `VV` lookup:

    VV 250

You'll get 4096 (honestly it's not really important what the value is). But why did we type `250`? `VV` takes a range of 0 to 1000, where 1000 can be thought of as "10.00". So 250 actually means 2.50. You always need to specify two decimal places, otherwise it'll be a bug, so remember!

    2.5v  = VV 250
    1.25v = VV 125
    6.02v = VV 602
    0.22v = VV 22
    5v    = VV 500

Got it? Use `V` for single whole volts, and `VV` for fractional volts.

## Get temperamental

You may have tried this:

    CV 1 VV 250

That's a half octave above the second octave, which just happens to be a tritone-- a real note. But try:

    CV 1 VV 11

And you'll be in micro-tonal territory. Instead of dividing volts by 12 yourself, Teletype does it for you with the `N` lookup table.

    CV 2 N 7

This command sets CV output 2 to 7 semitones up, in [equal temperament tuning](https://en.wikipedia.org/wiki/Equal_temperament). (We'll discuss custom tuning tables in a later study!)

Try changing that last value to hear some pretty clear tonal relationships:

    CV 2 N 0
    CV 2 N 9
    CV 2 N 12
    CV 2 N 16

The `N` table works for values above 12, with a full range of 0 to 127.

## Offset

In addition to setting a CV output directly with `CV`, we can change the final output value with an offset:

    CV.OFF 1 N 12

Here we've just set the `CV.OFF` for the first CV output to `N 12` which is equivalent to `V 1` or one octave. This is an offset added to all CV changes. So now:

    CV 1 V 1

With the offset, CV output 1 now has two volts showing.

This mechanism is helpful if you have a steady sequence of values going to the `CV` command, but want to modulate the entire channel. Think of this as a master "tuning" knob on an old synth (but with much greater range). Get into *EDIT* mode (hit **TAB**) and make a few scripts:

~~~
1:
CV 1 N 0

2:
CV 1 N 7

3:
CV.OFF 1 0

4:
CV.OFF 1 N 5
~~~

The first two scripts change the CV value, and the second two change the CV offset.

*THIS* &rarr; Trigger a script from the keyboard by pressing one of **F1**-**F8** (for example, **F1** to trigger script 1.) This is great for trying things out while writing scripts without having to patch inputs into Teletype.

Try triggering scripts 1-4 in various ways. Yeah?

## Bend and drift

Up until now all CV changes have been sharp-- both the `CV` and `CV.OFF` commands change the output immediately upon execution.

Each CV channel has a slew parameter which gives a transition time for value changes. Get into *LIVE* mode and type:

    CV.SLEW 1 1000

This sets the slew time of the first CV channel to 1000, which is 1000 ms, or 1 second. All future `CV` and `CV.OFF` commands will now smoothly transition to their target over this interval. Slew times can be up to 32 seconds long.

Try triggering scripts 1-4 now.

In *LIVE* mode you'll see the small diagonal line icon (in the top right) light up when a CV is actively slewing to a target.

## Fly direct

You can interrupt a mid-slewing CV in two ways:

1. Set `CV.SLEW` to 0, then issue a new `CV` value; or,
2. Use `CV.SET`

`CV.SET` stops the current transition and immediately sets the CV channel to the given value. This is useful in cases where you don't want to change the `CV.SLEW` value.

    CV.SET 1 N 10

This command will bypass slew and set CV output 1 to 10 semitones up. Try changing script 2 to `CV.SET`-- it'll change the vibe.

## Investigating and mirroring

`CV`, `CV.SLEW`, and `CV.OFFSET` can all be read as well as set. In *LIVE* mode you can do this:

    CV 1

Which will return the value of CV 1. This is going to be a straight number, so if you previously assigned CV 1 to `N 9` you'll get 1229, for example.

But we can also use `CV 1` as a value to set other values! Say you want to set CV 2 to the value of CV 1:

    CV 2 CV 1

CV 1 is "read" and then assigned to CV 2. It's important to note that `CV.OFF` is not taken into consideration here, so if one of the channels has an offset, the resulting voltage outputs will potentially be different. Of course, this may be the desired effect.

You can similarly read `CV.OFF` and `CV.SLEW` to use in other assignments.

## Repeat this: this this this this

You've probably stumbled upon the `M` script while in *EDIT* mode. This is the Metronome script. It is executed at a fixed interval. Get into *EDIT* mode and add this to the *M* script.

    TR.PULSE A

TR output A should be blinking at you, pretty fast. The metro time is determined by the variable `M`. Get back into *LIVE* mode and type:

    M

This will report the value of `M` which is the current metronome time, in ms. It should be 500, unless some other scene changed it for you prior to loading the blank scene. Let's set it to 200ms.

    M 200

That trigger output should be blinking faster. Notice that the M icon is lit up in *LIVE* mode. Let's disable the metronome script:

    M.ACT 0

Stopped. Now turn it back on:

    M.ACT 1

We can give `M` a long time, up to 32 seconds. We can also hard-reset the counting of the metronome:

    M.RESET

This will reset the count-down before the next execution of the M script.

Like the script 1-8 hot keys, you can manually execute the M script with **F9**, even if the script is disabled with `M.ACT`.

The metronome script is exactly the same as the other scripts-- it's simply triggered internally on a clock.

## Happy, predictable startups

Scenes only store script and pattern data-- the current state of variables (such as `M`) and CV parameters are unchanged. On hardware startup these will be initialized to 0, but when changing scenes whatever values were in memory will remain.

The Initialization script will help make scene startups predictable. Get into *EDIT* mode and navigate to the I script. This is executed on scene recall. You can manually execute it from the keyboard with **F10**.

Things that normally go in the `I` script are things like:

    M 700
    CV.SLEW 1 500

Metro timing, CV slews, and other variables. Perhaps you want to start with particular TR output values or CV levels. Put them here.

## EXAMPLE: COPYCAT FLIPS

This scene is featured in the banner video above.

Use two oscillators-- tune them to the same low note. Connect CV output 1 to the frequency input of one oscillator, and CV output 2 to the frequency input of the other. Use TR output B as a gate for the second oscillator. Hook CV 4 up to something in the sound path that changes timbre, like a wave folder or filter.

Inputs 1-3 change the root note of CV 1. Inputs 4-5 change the offset of CV 1. Inputs 6-8 change the offset of CV 2 (octaves) and modulate CV 4.

The metro script is running constantly, triggering the pulse and "sampling" CV 1, mirroring this to CV 2. It's similar to a sample and hold. By modulating the "drone" root note of CV 1, you'll have a following pulse stream with the other oscillator. As described above, modulating offsets doesn't change this CV mirroring, so we get different chordal combinations and progressions.

The init script makes sure the pulse width and slew times are all set up.

In the video above I'm driving some inputs with a step sequencer (White Whale) and others with A cyclic trigger generator (Meadowphysics). The first is more regular, while the second has some randomness in the pattern. The two overlapping paired with the configuration of the simple script create some nice musical shifts.

![](../images/tts2.png)


[Printable Blank Scene Template](../TT_scene_RECALL_sheet.pdf)

### Suggested explorations

* Change slew times dynamically with script triggering for interjection


## Reference

### Commands

~~~
V x             lookup volt value x (0-10)
VV x            lookup precision volt value x (0-1000, for 0.00 to 10.00 volts)
N x             lookup note value x (0-127)
CV x y          set CV output x to y
CV.OFF x y      set CV offset x to y
CV.SLEW x y     set CV slew x to y
CV.SET x y      set CV x to y, bypass slew

M x             set metro script clock time to x
M.ACT x         enable/disable metro script clock (0/1)
M.RESET         reset counter for metro script
~~~

[Full Command Chart](../TT_commands_card.pdf)

[Teletype Key Reference](../manual/#keys)

You can also browse help within Teletype by using ALT-H to toggle help mode.

## Teletype Studies Continued

[Part 3: Playing with numbers &rarr;](../studies-3)

Part 2: Curves and repetition

[Part 1: Navigating and making edges &larr;](../studies-1)
