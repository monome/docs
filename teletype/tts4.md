---
layout: default
nav_exclude: true
permalink: /teletype/studies-4/
redirect_from: /modular/teletype/studies-4/
---
<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/137005129?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## One knob (feel all right)

By now you may suspect there are some rituals to be followed before the tele-knowledge will rain down. Yes, I mean load a blank scene. (Hit **ESC**, navigate with **]** until you find a blank scene, hit **ENTER**). Then get into *LIVE* mode.

Read the knob value. Type:

    PARAM

Turn left and right and repeat the command (remember **UP ARROW**). You'll quickly discover that the range is 0-16384, the same as how 0-10v is represented. This is convenient in some cases, but requires conversion in others. Let's start with the convenient. Get into *EDIT* mode:

    M:
    CV 1 PARAM

Yes, that's it. Now you have a sample and hold. The sampling interval is the interval of the metronome. For example, change the metronome time to 100ms:

    M 100

Instead of reading the knob value, we can also read a CV input. The range is limited from 0-10v. It's protected, so don't worry about sending bipolar voltages. It can handle it.

    IN

This reads the jack marked *in*, next to the *param* knob. The range is 0-16384 for 0-10v. Let's do a sample and hold that's triggered by an input:

    1:
    CV 1 IN

Each time input 1 is triggered, the voltage on *in* is read and CV output 1 is assigned this value.

*TRY &rarr;* Give CV 1 some slew. Yeah?

## So smooth too smooth

Let's break up the continuum of numbers. [Quantization](https://en.wikipedia.org/wiki/Quantization) is the procedure of constraining a number to a smaller set. Teletype has a quantization operator:

    QT (input) (quantization)

Say we wanted to get only multiples of 1000 from `PARAM`:

    QT PARAM 1000

Now when the the knob is read, we'll get values like this:

**2000 &rarr; 3000 &rarr; 4000 &rarr; 4000 &rarr; 5000 &rarr; 6000 &rarr; 6000 &rarr; 7000**

Here are some more useful variations for driving CV:

    CV 1 QT PARAM N 1
    CV 1 QT PARAM N 2
    CV 1 QT PARAM DIV N 1 2
    CV 1 QT PARAM V 1

The first line quantizes to semitones. Second line quantizes to a whole tone scale. Third line quantizes to quarter-tones (a semitone divided by two). Final line quantizes to whole volts (octaves).

`QT` will return the closest matching value to the interval. If the value is squarely in the middle, it will round up.

* `QT 40 10` &rarr; 40
* `QT 44 10` &rarr; 40
* `QT 47 10` &rarr; 50
* `QT 45 10` &rarr; 50

## Shifting

Often we'll want to shrink the range of values we're using-- this will come up commonly when using the *param* knob. Of course we could simply divide:

    DIV PARAM 256

The result is a new range of 0-64.

Another way to scale down a value is with [bit shifting](https://en.wikipedia.org/wiki/Bitwise_operation#Bit_shifts). A shift right divides by powers of two:

* `RSH PARAM 1` &rarr; 0-8192
* `RSH PARAM 5` &rarr; 0-512
* `RSH PARAM 10` &rarr; 0-16

The first argument is the value to be shifted, the second how many places to shift. Shifting by 10 is equivalent of dividing by the 10th power of 2 is equivalent to dividing by 1024.

Shifting left multiplies rather than divides:

* `LSH 1 4` &rarr; 16

Consider this command:

    CV 1 N LSH 1 X

We're outputting CV notes that are shifted according to `X`. If a script is modulating `X` from 0 to 5, we'll get exponential note values:

**1 &rarr; 2 &rarr; 4 &rarr; 8 &rarr; 16 &rarr; 32**

## Setting boundaries

Sometimes you need to keep your numbers in line, to prevent them from wandering into unmusical territory. There are some authoritarian operators for this:

    LIM DRUNK 4 10

The result will be from 4 to 10 despite where `DRUNK` might end up. `LIM` is saturating, so in this case if `DRUNK` is 1, we'll get 4.

    LIM PARAM V 2 V 8

This will limit the *param* knob to 2-8 volts, creating "dead zones" at the top and bottom of the range.

If we're only interested in creating an upper or lower limit and not both, we can use `MIN` and `MAX`:

* `MAX 2 8` &rarr; 8
* `MIN 2 8` &rarr; 2
* `MIN 8 2` &rarr; 2

`MAX` returns the greater of two arguments. `MIN` returns the lesser. It follows that the argument order doesn't matter, 'cause greater is greater, mate.

We can also limit without saturating at the edges: wrap around a range:

    WRAP PARAM 200 500

A value within the range 200 to 500 will always be returned. When `PARAM` goes above 500, it will wrap to 200 and keep climbing until it wraps again. (Aside: you could do this same thing with `ADD 200 MOD PARAM 300`.)

This will make a strange-feeling knob:

    CV 1 WRAP PARAM 0 V 1

And this too:

    X WRAP RSH PARAM 9 0 4
    CV 1 N LSH 1 X

## TICK TICK TICK

Teletype has a readable internal timer. Read the timer in *LIVE* mode:

    TIME

The timer counts in milliseconds. As it lives within the Teletype datatype range, it rolls over at 32 seconds, and starts counting up from -32. This is a little weird. To set/reset the time:

    TIME 0

You can set TIME to any value, not simply zero.

The timer can be started and stopped:

    TIME.ACT 0

`TIME` will now halt and no longer be incremented.

    TIME.ACT 1

The timer is now re-enabled. With `TIME.ACT` you can implement a start/stop mechanism similar to a stop-watch.

While variable `T` can be used for generally, it's helpful for code readability to use `T` when manipulating time-oriented numbers. For example:

    1:
    T TIME
    TIME 0
    M T

This script measures the time interval between triggers to input 1, and then assigns this interval to the metro script. Add trigger pulses to both script 1 and the metro script for an interesting synchronized but not phase-correct pulse machine.

With `TIME`, `PARAM`, and `IN` values you'll often want to smooth them out a bit. You can do a two-stage fundamental "smoother" by simply averaging. We do have an average operator:

    AVG 3 6

This will return the average of 3 and 6, which is (3 + 6) / 2 = 4. So to create a simple smoother:

    1:
    M AVG T TIME
    T TIME
    TIME 0

Now the metro time is getting assigned a smoothed value. `T` is the previously read `TIME` value, so the order of these commands is important to have the intended effect.


## EXAMPLE: SLOW READER

This scene is featured in the banner video above.

A clock input has its time interval measured. This interval is smoothed with the previous reading and then applied to the metronome script. Triggers are generated both for the metro and incoming clock. The effect is a sort of lagging synchronization where the phase likely does not align, creating interesting rhythms when the incoming clock is modulated.

On each metronome pulse the CV in jack is sampled and assigned to CV output 2. When the next clock to trigger input 1 arrives CV output 1 is also assigned this value, creating a following motion in most situations.

In the video above Earthsea is generating a melody, serving as the CV input. White Whale is being heavily underutilized simply as a clock out.

* 1: Clock input
* in: CV input

CV/TR output paired for voices 1 and 2. CV 4 outputs a smoothed drunk 0-5v, changed on the metro interval.

![](../images/tts4.png)



## Reference

### Commands

~~~
PARAM           read param knob
IN              read input CV jack

QT x y          quantize input x to nearest value y

RSH x y         shift x by y bits to the right
LSH x y         shift x by y bits to the left

LIM x y z       limit x to range y to z
MIN x y         return lesser of x and y
MAX x y         return greater of x and y

WRAP x y z      wrap input x to range y to z

TIME            read time interval in milliseconds
TIME x          set current time
TIME.ACT x      set timer active/inactive (1 or 0)

AVG x y         average x and y
~~~

[Full Command Chart](../TT_commands_card.pdf)

[Teletype Key Reference](../manual/#keys)

You can also browse help within Teletype by using ALT-H to toggle help mode.


## Teletype Studies Continued

[Part 5: Pattern tracking &rarr;](../studies-5)

Part 4: Collect and transform

[Part 3: Playing with numbers &larr;](../studies-3)

[Part 2: Curves and repetition &larr;](../studies-2)

[Part 1: Navigating and making edges &larr;](../studies-1)
