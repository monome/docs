---
layout: default
nav_exclude: true
permalink: /teletype/studies-7/
redirect_from: /modular/teletype/studies-7/
---
<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/139730521?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## Misfits

Teletype has a few bits that are somewhere between *OPS* and *VARS*. They perform functions, and they have memory.

    O

`O` (the letter, not zero) resembles a normal variable. You can set it to a value. And then you can read it. But when you read it *again*, it will auto-increment. And each time you read it after that, it'll increase by 1.

    O 2
    O
    O
    O

Here we set `O` to 2. Then the following three reads are: **2 &rarr; 3 &rarr; 4**.

Furthermore, there is `Q` which implements a [queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)), which is similar to a shift register.

    Q 2

Puts the number `2` into the queue. At startup the queue is only 1 element long, so it's exactly like a normal variable. However, let's change the length of the queue:

    Q.N 2

Now when we read `Q`, we'll be reading the value we assigned two stages ago.

    Q.N 2
    Q 3
    Q 4
    Q

The final command `Q` returns `3`. The length of the queue can be dynamically changed and the contents will be preserved. As a bonus feature, we can get the average of the elements in the queue:

    Q.N 3
    Q 0
    Q 25
    Q 5
    Q.AVG

The result is 10. (0 + 25 + 5) / 3

This can be used as a smoother.

    Q PARAM
    CV 1 Q.AVG

Try putting this in a metro script. Each time the script is executed the "history" is pushed along and the average is an overall smoothing of the input. Given a short queue length `Q.N 3` smoothing would be minor, or you can do extreme smoothing with `Q.N 16`. The queue can be up to 16 stages in length.

## We do this all the time

[Iteration](https://en.wikipedia.org/wiki/Iteration) is the repetition of a process. It sounds [like this](https://themaeshi.bandcamp.com/track/do-this).

The *PRE* `L` (which somewhat mundanely stands for "loop") allows you to execute a single command many times, with access to a counter variable per execution. Ahhhh, what does that mean?

    L 1 4 : P.PUSH 55

This is what happened:

    P.PUSH 55
    P.PUSH 55
    P.PUSH 55
    P.PUSH 55

`L` takes two arguments before the separator: a starting number and an ending number. This dictates how many times the command will execute, so in the case above `P.PUSH 55` happens four times: 1, 2, 3, 4. (Recall that `P.PUSH` adds a value to the current pattern-- so we just dumped a bunch of 55's into a pattern.)

What makes `L` more useful is that we have access to the counter, using the special variable `I`. Check this out:

    L 1 4 : CV I 0

Which effectively translates to:

    CV 1 0
    CV 2 0
    CV 3 0
    CV 4 0

With this one fancy command we zeroed all CV outputs. How this works is the variable `I` gets updated with the loop count on each iteration. This ends up being particularly helpful for INIT scripts setting up defaults:

    I:  L A B : TR.TIME I 20
        L 1 4 : CV.SLEW I MUL I 100

Recall that `A`-`D` are simply 1-4, so they work fine with a loop. And did you see that last trick? `I` can be used for more than indexing-- here it gets multiplied, effectively translating to:

    CV.SLEW 1 100
    CV.SLEW 2 200
    CV.SLEW 3 300
    CV.SLEW 4 400

Note that you can also count backwards, for example:

    L 4 1 : P.PUSH I

Which would push **4 &rarr; 3 &rarr; 2 &rarr; 1** onto the pattern.

### Automaticity

I just learned that is really a word. Loops are additionally great for generating pattern content.

    L 1 64 : P.PUSH RAND 1000

Jump over to *TRACKER* mode and you'll see a bunch of random numbers. Use `CV 1 VV P.NEXT` repeatedly and you'll have a 0-10V wiggly-something. If you want to re-randomize the pattern, you could re-execute the loop after first setting `P.L 0` (this is because `P.PUSH` adds after the pattern length). But you could also just overwrite everything directly this way:

    L 0 63 : P I RAND 1000

Here we're using the `I` as the pattern index.

### Microtonalicity

That, my friend, is not a word. Microtonality can be achieved using patterns and is most easily achieved using loops.Some scales are easy to implement. Let's check them out quickly before going to patterns.

**Quarter tone**

    CV 1 DIV N X 2

Given note `X` we're simply dividing a semitone by two.

**Eighth tone**

    CV 1 DIV N X 4

Basically the same as above. Extrapolate this to get even smaller semitone scales.

**100 tones per octave**

    CV 1 VV X

Just a different way of thinking about volts.

**5 tones per octave**

    CV 1 MUL X DIV V 1 5

We're just doing some multiplying and dividing at this point.

The reason these all work is because they're evenly spaced-- the distance between each pitch is the same.

*RELATED ASIDE &rarr;* One trick we can do with these sorts of scales is make a quantizer. First, let's set our desired quantization to the variable `X`, in the case below a whole tone scale:

    X N 2

And then process the `IN` jack and output it to `CV 1`:

    CV 1 QT IN X

Try executing this script on a metro, or manually trigger it with new note-ons. And then change `X` while playing notes.

### Tuning patterns

Let's start with an [equal temperament](https://en.wikipedia.org/wiki/Equal_temperament) scale as a foundation for making our new scale.

    L 1 64 : PN 0 I N I

Check the tracker view. We've basically copied the `N` note table to a pattern 0. Recall that `PN` takes an extra argument to specify which pattern to read or write.

We can now treat pattern 0 as our note map, rather than `N`. For example with note value `X`:

    CV 1 PN 0 X

Now we can go into pattern 0 and retune the table. This works well in tracker mode-- use the bracket keys to change by small values.

Let's now copy one entire pattern 0 to pattern 1:

    L 1 64 : PN 1 I PN 0 I

This looks a little funny, but it works!

Now with two "scales" in our pattern bank, we can easily (with a script) toggle between the two. Just use `Y` as a scale variable:

    CV 1 PN Y X

We still have pattern 2 and 3 for actual note-sequence data. Let's put something musical in there:

    P.N 3
    P.PUSH 5
    P.PUSH 0
    P.PUSH 4
    P.PUSH 0
    P.PUSH 2

And now we can use the "sequence" in pattern 3 to play the "scale" of pattern 0:

    CV 1 PN 0 P.NEXT

`P.NEXT` will read the active pattern specified by `P.N`. These note numbers get pushed through our custom scale.

The takeaway point is that patterns can be used for a variety of tasks. Note sequences, scales, timings, etc. They're just a bunch of numbers!

## Hidden workings

Teletype has psychic powers to control other grid-based modules, namely Ansible and the original "trilogy": White Whale, Meadowphysics, and Earthsea. (Though actually this requires an [extra ribbon cable](http://monome.org/docs/modular/iiheader) connected behind the modules).

With these commands you can remotely control parameters of Ansible and the trilogy modules. For example:

    WW.POS 5

With a White Whale connected, this command will cut to position 5 of the currently playing sequence. All commands are simply a key (such as `WW.POS`) and a secondary argument. Here's the full list:

**Ansible**

See the [Ansible docs](/docs/modular/ansible/) for the complete list.

**White Whale**

~~~
WW.PRESET       recall preset
WW.POS          cut to position
WW.SYNC         cut to position, hard sync clock (if clocked internally)
WW.START        set loop start
WW.END          set loop end
WW.PMODE        set play mode (0: normal, 1: reverse, 2: drunk, 3: rand)
WW.PATTERN      change pattern
WW.QPATTERN     change pattern (queued) after current pattern ends
WW.MUTE1        mute trigger 1 (0 = on, 1 = mute)
WW.MUTE2        mute trigger 2 (0 = on, 1 = mute)
WW.MUTE3        mute trigger 3 (0 = on, 1 = mute)
WW.MUTE4        mute trigger 4 (0 = on, 1 = mute)
WW.MUTEA        mute cv A (0 = on, 1 = mute)
WW.MUTEB        mute cv B (0 = on, 1 = mute)
~~~

**Meadowphysics**

~~~
MP.PRESET       recall preset
MP.RESET        reset positions
MP.STOP         reset channel x (0 = all, 1-8 = individual channels)
~~~

**Earthsea**

~~~
ES.PRESET       recall preset
ES.MODE         set pattern clock mode (0 = normal, 1 = teletype clock)
ES.CLOCK        (if teletype clocked) next pattern event
ES.RESET        reset pattern to start (and start playing)
ES.PATTERN      set playing pattern
ES.TRANS        set transposition
ES.STOP         stop pattern playback
ES.TRIPLE       recall triple shape (1-4)
ES.MAGIC        magic shape (1: halfspeed, 2: doublespeed, 3: linearize)
~~~

One highly requested feature was external clocking of the Earthsea. Here's how it works:

* Record a pattern using the grid, as normal.
* Send TT command `ES.MODE 1`
* Now the Earthsea is being clocked via TT.
* Use `ES.CLOCK 1` to send a clock pulse, via a script, live, metro, etc.

Note that the Earthsea needs a clock event for both note-on and note-off, so you will likely need to double your clock speed. Another possibility is to use a `DEL` to always send two `ES.CLOCK` messages:

    1:  ES.CLOCK 1
        DEL 100 : ES.CLOCK 1

This method has a couple issues. First, note length is always `100`. If you trigger script 1 faster than 100ms, you'll get a weird phase problem and the note on/offs will get unsync'd. There are various other ways of approaching this issue that may require slightly more logic.

## Sudden change of direction

Lastly (yes, we're at the end) you can load an entire scene from a command:

    SCENE 4

This will load scene 4. You can check the current scene number simply by reading `SCENE`.

So, you can quite simply make a scene-advance script thusly:

    SCENE ADD SCENE 1

This gets pretty close to the mythic patch-recallability feature much sought in modular. Teletype won't move the wires for you, however.

## EXAMPLE: LABYRINTH

This scene is featured in the banner video above.

There are two completely separate processes running in this scene. The first is a 5 step sequence which is gets dynamically written by various triggers:

* 1: Step forward in sequence, note on CV output 1
* 2: Reset pattern to 5-semitone spaced scale
* 3: Reset pattern to 7-semitone spaced scale
* 4: Module each step of pattern randomly by 0-2
* 5: Transpose each step of the pattern up by 2 semitones

In the video, the White Whale (controlled by the grid) is driving this section. The clock out advances the sequence, and trigger steps on the grid trigger the pattern-modifying scripts. So this is a sort of meta-sequence which is often changing, where curious emergent repetitions often arise.

The second section is an input smoother, which in the video controls a filter sweep. A simple footswitch output (full scale) is connected to the IN jack of the Teletype. The metro script reads this value into a Q buffer (which is set very long by the init script), and then the Q.AVG is sent to CV output 2. We've basically scripted a rudimentary slope limiter in just a few lines of code.

![](../images/tts7.png)


## Reference

### Commands

~~~
O               like a normal variable, but auto-increments on each read
Q               read or add value to shift register
Q.N             read of set length of shift register
Q.AVG           return average of contents of shift register

L a b : ...     loop command with I assigned a to b per iteration

SCENE           load stored scene
~~~

[Full Command Chart](../TT_commands_card.pdf)

[Teletype Key Reference](../manual/#keys)

You can also browse help within Teletype by using ALT-H to toggle help mode.


## Teletype Studies Continued

Part 7: Incantations

[Part 6: Maybe later remembering &larr;](../studies-6)

[Part 5: Pattern tracking &larr;](../studies-5)

[Part 4: Collect and transform &larr;](../studies-4)

[Part 3: Playing with numbers &larr;](../studies-3)

[Part 2: Curves and repetition &larr;](../studies-2)

[Part 1: Navigating and making edges &larr;](../studies-1)
