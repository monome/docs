---
layout: default
nav_exclude: true
permalink: /teletype/studies-3/
redirect_from: /modular/teletype/studies-3/
---
<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/136304442?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## How to talk COMPUTER

We've made it to part three without *really* explaining how commands work-- I appreciate your blind trust. But now it is time to talk about *syntax*. This sounds possibly boring but it's the key to understanding the great potential of the system, allowing us to make interesting and sophisticated interactions.

Before we begin, load up a new blank scene. We've described doing this in past studies (hint: hit **ESC**, navigate with **]** until you find a blank scene, hit **ENTER**).

### Right to Left

In many ways Teletype is just a fancy calculator. Syntax follows [prefix notation (aka Polish notation)](https://en.wikipedia.org/wiki/Polish_notation)-- the *operator* is to the left of the *operands*. Get into *LIVE* mode and try this:

    ADD 2 8

You'll see the result printed: 10. Here the *operator* is `ADD`, the *operands* (aka arguments) being `2` and `8`. `ADD` wants two arguments (values). And why did it print? Teletype is designed to display the returned value, if one is returned.

`ADD` returns a value. Let's use that fact to make a longer command:

    ADD 2 ADD 4 8

What? It looks weird but it'll feel better soon. Read *right to left*-- find the rightmost operator and give it arguments. Pulled apart, first we have

    ADD 4 8

which equals 12. Let's mentally substitute that value into the remaining command:

    ADD 2 (12)

which makes 14. Which should've been displayed as the result. Simple enough? Yeah! But things can get confusing:

    ADD ADD 1 2 3

Yes, this works. Think of it like this:

    ADD (ADD 1 2) 3

The rightmost operator uses the two closest arguments. Even this is legit:

    ADD MUL 2 ADD 7 8 9

This decodes to `ADD (MUL 2 (ADD 7 8)) 9` which is 39. Perhaps not the friendliest command at first glance, but not a monster after a closer look.

### Break it down, save it for later

You'd possibly rather make sounds than deciphering strange looking strings of text. We can make commands easier to read by using *variables*.

    X ADD 1 2

Instead of printing the value 3, `X` is now assigned 3. Type `X` alone on the command line and it'll print its value.

*KNOW THIS! &rarr;* A variable (such as `X`) or parameter (such as `CV 1`) gets *set* if it is the leftmost *WORD* of a command. Otherwise the *value* is read and returned.

Consider that complicated command we had earlier: `ADD ADD 1 2 3`

Here's a more readable way:

    X ADD 1 2
    ADD X 3

`X` is set to the result of `ADD 1 2`. Then `X` gets read and returns 3 in the second line. The first line is effectively substituted into the second, breaking apart the command into multiple lines. Sometimes this is helpful-- but you'll also quickly run out of lines in a script. So there's a balance to be found.

### Real talk

* Operators accept arguments.
* Operators typically return values.
* An argument is a value, so you can feed the returned value of an operator into another operator.
* Variables can be assigned values, and read as arguments.
* Parameters (CV, etc) can be read and used as arguments.

The takeaway: numbers are interchangeable. Once the *flow* of numbers makes sense, you'll be able to put commands together in different ways to achieve a wide range of musical goals.

## Elementary

Basic arithmetic operators are `ADD`, `SUB`, `MUL`, `DIV`, and `MOD`. These all take two arguments.

Addition and multiplication are commutative-- the order of the arguments don't matter: `ADD 1 3` and `ADD 3 1` are the same. But this is not the case for the others:

* `SUB 4 2` reads *4 - 2*
* `DIV 8 4` reads *8 / 4*
* `MOD 7 2` reads *7 % 2*

Reversing the arguments will mess with your calculation. And what the heck is *mod*? It'll give you the remainder after a division. So `MOD 7 2` is 1.

## Short term memory

Variables are good for much more than simplifying commands. They store values which can then be manipulated in various ways.

Available variables: `X`, `Y`, `Z`, and `T`. `T` is typically used for time-based operations but can be used freely.

Variables can be both set and read in the same command. Consider this:

    X 10
    X ADD X 1

First `X` gets set to 10. In the second line the `ADD` reads `X` and adds 1, returning 11. So `X` gets set to 11. Push the up arrow to re-execute that last line. `X` is counting up by 1 each time.

Variables are global-- they keep their value across scripts. For example `X` can be changed by script 1 and then read and further manipulated by script 2.

~~~
    1:
    X 0

    2:
    X ADD X 1

    3:
    Y N MUL X 2
    CV 1 Y
~~~

Here script 1 resets `X` to 0. Script 2 increments `X` by 1. Script 3 assigns CV output 1 to the note `X` multiplied by 2, using `Y` as a temp variable to break up the command (this could be easily combined, of course).

With various staggered triggering of these three scripts, you will likely find music!

### More is more

You may feel that four variables just isn't enough-- c'mon, a four-note melody? (Enough for me most days.) Fortunately there is a whole different system for saving tons of numbers: *patterns*. We'll cover this in a very-near-future part of this series.

In the meantime, if you're really desperate for more variables-- `A`, `B`, `C`, and `D` can be overwritten. By default these are initialized to 1-4 on startup.

As it happens,  `TR A` it is exactly the same as `TR 1`. So if you overwrite `A`, be sure to use `TR 1` instead.

### Save save save

Be warned that variables are not stored with scenes. You can load a new scene and the variables will remain the same. If you want to have a scene recall with specific variable values you'll need to use the `INIT` script. For example:

~~~
    I:
    X 8
    Y 22
~~~

Now we have some defined values for `X` and `Y` when the scene is loaded.

Lastly, variables aren't saved when powering down. On power-up memory is cleared, but the *INIT* script is called on powerup which allows you to define startup values.


## Here at the post office

A long time ago at the post office in Castaic, CA: the postmaster asked the lady ahead of us "How fast do you want this to ship?" There was a lot of confusion and shrugging and finally "I don't care." To which the postmaster responded resoundingly:

*"Here at the post office we only deal in absolutes."*

Teletype is not the post office. (OK, weird transition, sorry.)

~~~
    1:
    CV 1 N RAND 12
~~~

We've arrived at the moment you've been waiting for: random semitones streaming out your modular synth.

`RAND 12` will return a random number between 0 and 12.

Operators can have different numbers of arguments. The arithmetic operators so far have had two. `RAND` takes just one. This is important to remember when analyzing (and building) commands. Of course, the [command sheet](../TT_commands_card.pdf) will help!

Let's make this immediately more musical by creating a whole tone scale:

    CV 1 N MUL 2 RAND 12

Now we're creating a random number between 0 and 12, and multiply it by two. Recall that `N` does a note lookup for sending to CV outputs.

And what about this:

    CV 1 N MUL X RAND Y

Yeah? Now we can manipulate the range (Y) and interval (X) from some other script!

### Somewhere in between

    RRAND 4 8

A random value from 4 to 8 (inclusive) will be returned. `RRAND` (range random) takes two arguments.

Recall that a `TR` index can be set with 1-4 rather than A-D? So we can turn on `TR A 1` with the identical command `TR 1 1`. But how about this:

    TR RRAND 1 4 1
    TR RRAND 1 4 0

The first line turns ON a random trigger output. The second line turns OFF a random trigger output. We can do the same with CV.

### Infinite coins

    TOSS

This operator has no arguments! It returns a 0 or 1, randomly.

    TR RRAND 1 4 TOSS

This command sets a random TR output to a random state, on or off.

    CV 2 N MUL 5 TOSS

Here we're multiplying 5 by either zero or one, which gives us either zero or 5.

### The musical qualities of stumbling

    DRUNK

Appropriately, `DRUNK` isn't quite normal. It's a variable, but it changes by 1, 0, or -1 each time you read it. But you can also reset its position:

    DRUNK 5

However, next time you read the value:

    DRUNK

You may get 4, 5, or 6.

`DRUNK` does not have boundaries, so you may need to constrain it within a range to keep it useful:

    CV 3 V MOD DRUNK 5

Here we're creating single-volt steps between 0 and 4. You might get something like this:

**0 &rarr; 1 &rarr; 0 &rarr; 0 &rarr; 4 &rarr; 3 &rarr; 3 &rarr; 4 &rarr; 3 &rarr; 2 &rarr; 1 &rarr; 1 &rarr; 2**

The `MOD` operator wraps the edges.


## EXAMPLE: VIKING

This scene is featured in the banner video above.

Like the previous study, we're using two oscillators with frequencies controlled by CV outputs 1 and 2. Remember to tune them to the same note prior to plugging in CV.

* Input 1 will randomly select a note for the first oscillator. TR out A will be pulsed.
* Input 2 will choose between two notes for the second oscillator. I used this as a low root note.
* Input 3 advances a drunk walk of single volts between 0 and 2.
* Metro running at 1 second interval, randomly slewing CV output 4 between random voltages 0 to 5.

Values are initialized on startup.

![](../images/tts3.png)

[Printable Blank Scene Template](../TT_scene_RECALL_sheet.pdf)

### Suggested explorations

Get into *LIVE* mode and try changing some variables:

    X 2
    Y 12
    Z 12

`X` changes the note spread and `Y` the range for voice 1. `Z` the interval of the low tone for voice 2.


## Reference

### Commands

~~~
ADD x y         add x + y
SUB x y         subtract x - y
MUL x y         multiply x * y
DIV x y         divide x / y
MOD x y         modulus x % y (return remainder)

RAND x          return random value from 0 and x
RRAND x y       return random value from x to y
TOSS            return a random value 0 or 1

X,Y,Z,T         variables
A,B,C,D         variables, initialized to 1-4 on startup
DRUNK           variable that changes by -1, 0, or 1 when read
DRUNK x         set DRUNK value to x
~~~

[Full Command Chart](../TT_commands_card.pdf)

[Teletype Key Reference](../manual/#keys)

You can also browse help within Teletype by using ALT-H to toggle help mode.

## Teletype Studies Continued

[Part 4: Collect and transform &rarr;](../studies-4)

Part 3: Playing with numbers

[Part 2: Curves and repetition &larr;](../studies-2)

[Part 1: Navigating and making edges &larr;](../studies-1)
