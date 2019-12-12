---
layout: default
nav_exclude: true
permalink: /teletype/studies-6/
redirect_from: /modular/teletype/studies-6/
---
<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/139376775?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## Tell the truth

And what is truth anyway? Fortunately Teletype (and pretty much all digital systems) have a reductive view on the matter:

* 0 &rarr; FALSE
* EVERYTHING ELSE &rarr; TRUE

And why do we care about truth? Because sometimes we need to ask hard questions... like, is variable `X` greater than 2?

    GT X 2

Teletype will tell you. If `X` is greater than 2, the value `1` (TRUE) will be returned. Otherwise you'll get `0` (FALSE).

Here's a list of [relational operators](https://en.wikipedia.org/wiki/Relational_operator) that can let you test a condition:

    EQ x y
    NE x y
    GT x y
    LT x y

Represented are **EQ**uals *(x == y)*, **N**ot **E**quals *(x != y)*, **G**reater **T**han *(x > y)*, and **L**ess **T**han *(x < y)*. All return true or false, represented as 1 or 0.

And what shall we compare? How about we check if CV input `IN` is greater than 3V, and then output that as a gate on TR output A:

    TR A GT IN V 3

There are some helper operators for comparing to zero:

    EZ x
    NZ x

These are **E**quals **Z**ero and **N**ot **Z**ero. Both take only one argument: the number to be compared to zero.

There ends up being a neat trick for flipping a variable between 0 and 1:

    X EZ X

Here, when X is 0, it will become 1. And conversely, if 1, will become 0. Having this in a script will create a toggle. For example, you could use a trigger input to toggle the metronome:

    M.ACT EZ M.ACT

## The moment of decision

Now that we're full of truths and falsehoods, let's conditionally execute some commands. Introducing a new word: *PRE*. It's basically a short command that comes ahead of another command, separated by a **:** (colon). Here's a simple example:

    IF X : TR.TOG A

The *PRE* `IF` takes one argument which is evaluated as true or false. If true, the remaining command after the separator (:) will be executed. So, according to our understanding of truth:

* if X is 0, nothing happens
* if X is anything but 0, TR output A gets toggled

We can expand the command within a *PRE* to become more complicated, however:

    IF GT PARAM V 5 : CV 1 PARAM

Here knob input `PARAM` is read and compared to 5 volts. If greater, CV output 1 is assigned to `PARAM`, basically limiting the lower bound of the knob-to-cv-output assignment. (Note that this could more effectively be accomplished with `CV 1 LIM PARAM V 5 V 10`.)

We like randomness, right?

    IF TOSS : P.NEXT

Here we maybe (50/50 chance) advance the pattern sequence.

    IF LT RAND 100 75 : P.NEXT

Here we have a 75% chance of advancing the sequence. Given this is the sort of thing some of us like to do a lot, we created a simplified *PRE* just for probabilities:

    PROB 75 : P.NEXT

This command is identical to the one above. The argument is a number from 0-100, representing chance to execute.

## Followup

Sometimes the inquiry must continue.

    IF X : TR 1 0
    ELIF Y : TR 1 1
    ELSE : TR 1 TOSS

When an `IF` gets a false argument (and the command is bypassed) we have the opportunity to match a new condition (with `ELIF`), or just have a fallback command (with `ELSE`). Let's trace this script given some assumed values of `X` and `Y`:

* X = 0, Y = 0 &rarr; TR 1 TOSS
* X = 0, Y = 1 &rarr; TR 1 1
* X = 1, Y = 1 &rarr; TR 1 0

Note that in the last condition (where X is 1) it simply doesn't matter what value is in `Y` as the `ELIF` and `ELSE` will be skipped. Similarly, if an `ELIF` is successfully executed, the following `ELSE` will not be executed.

You can stack up several `ELIF` statements in a row:

    IF EQ X 0 : CV 1 V RAND 5
    ELIF EQ X 1 : CV 1 0
    ELIF EQ X 2 : CV 1 V RAND 10
    ELIF EQ X 3 : CV 1 V 10
    ELSE : TR.TOG 1

This script checks the variable `X` against the values 0-3 and has a "default" action if it isn't within range.

Note that you might run into command length issues while doing conditional statements. You may need to break up the condition command. This command is too long:

    IF GT PARAM V 5 : CV 1 V RRAND 2 8

This is not:

    X GT PARAM V 5
    IF X : CV 1 V RRAND 2 8

## Later, dudes

For your scheduling needs, there is a *PRE* for postponing a command:

    DEL 250 : TR.TOG 1

`DEL` takes one argument: delay time in milliseconds. The command above will toggle TR output 1 after 250ms.

In *LIVE* mode the second icon (an upside-down U) will be lit up when there is a command in the `DEL` buffer. You can delay a command up to 16 seconds, and 8 commands can fit into the buffer.

You can clear the delay buffer (canceling the pending commands) with a single op:

    DEL.CLR

## A sort-of TODO list?

Teletype has a command [stack](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) which can lead to some musically interesting exploration. This might feel weird at first, but stick with us though it.

Say you want a command to execute later, not based on a time (where you'd use `DEL`) but rather by another command. We can achieve said desire thusly:

    S : TR.TOG 1

Now the command `TR.TOG 1` is on the stack-- it has not been executed. To execute the command:

    S.POP

This executes the *most recently added* command on the stack. Think of the stack as a pile of donuts-- the most recently added is the one on top. `S.POP` executes and removes the top command. If you're really hungry, though:

    S.ALL

This executes the entire stack, which leaves it empty. Why is this interesting, though? Take the following two scripts:

    1:  S : CV 1 N RAND 10

    2:  S.ALL
        TR.PULSE A

Say script 2 was executing on a regular interval, and script 1 was somewhat random. Given we're using the stack, musical events get time quantized to only happen on the execution of script 2. This is a great method to achieve sync when desired.

The stack can hold 8 commands. If you try to add more, and the stack is full, the command will simply be thrown away. We can read the stack length (height):

    S.L

This will return the number of commands waiting. We can also clear the stack:

    S.CLR

Another interesting use of the stack is the "not sure what'll come out" method:

    1:  S : TR.TOG A

    2:  S : CV 1 V RAND 5

    3:  S : TR.PULSE B

    4:  S.POP

If we're triggering scripts 1-4 at irregular intervals, the stack will fill up with commands while script 4 is executing and removing a single command at a time.

## EXAMPLE: PROBABLE SALVATION

This scene is featured in the banner video above.

A metronome triggers a pulse and executes the stack. Trigger inputs 1 and 3 add commands to the stack. All input scripts possibly modulate the tempo using a `PROB` *PRE*.

Script 2 conditionally changes CV output 4 based on the state of var `X`. `X` is toggled between 1 and 0 by script 3-- creating some additional dynamic behavior between the two scripts.

In the banner video, all inputs are driven by a WW sequence that has a few trigger-choice steps. TT is driving the frequency of an oscillator from CV out 1. CV out 2 controls an overtone timbre of this oscillator. CV out 4 controls the level of an additional sub oscillator. Trigger out 1 is connected to an envelope to spike the oscillator's level.


![](../images/tts6.png)


## Reference

### Commands

~~~
EQ x y          x == y
NE x y          x != y
GT x y          x > y
LT x y          x < y
EZ x            x == 0
NZ x            x != 0

IF x : ..       execute command if x is true
ELIF x : ..     execute command (else) if x is true
ELSE : ..       execute command after failed if

PROB x : ..     probability to execute command, 0-100

DEL x : ..      delay command by x milliseconds
DEL.CLR         clear in-process delays

S : ..          add command to stack
S.POP           execute and remove most recently added command
S.ALL           execute and remove all commands on stack
S.CLR           clear stack
S.L             read only, size of stack
~~~

[Full Command Chart](../TT_commands_card.pdf)

[Teletype Key Reference](../manual/#keys)

You can also browse help within Teletype by using ALT-H to toggle help mode.


## Teletype Studies Continued

[Part 7: Incantations &rarr;](../studies-7)

Part 6: Maybe later remembering

[Part 5: Pattern tracking &larr;](../studies-5)

[Part 4: Collect and transform &larr;](../studies-4)

[Part 3: Playing with numbers &larr;](../studies-3)

[Part 2: Curves and repetition &larr;](../studies-2)

[Part 1: Navigating and making edges &larr;](../studies-1)
