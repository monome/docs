---
layout: default
nav_exclude: true
permalink: /aleph/tutorial-6/
---

# Aleph Tutorial 6

## Presets, Presets, Presets (Part 2)

Herein lies part 2 of the preset tutorial! there will be less explaining of how to actually store values in a given preset, and more focus on interesting ways to create useful mechanisms for switching between settings. If you’re having trouble storing values to the correct preset, or things not working as expected it might make sense to spend some more time with the intro to presets in Tutorial 5.

### Connections

This tutorial will simply use the aleph-waves module so make sure you’re running the most up-to-date bees bundle. Attach your headphones or speakers to outputs 1 & 2.

- *Load a fresh scene by pressing CLEAR (SW2) on the SCENES page.*
- *Load aleph-waves in the DSP page with SW0.*

### Preset Switch Bank

The first structure we’ll discuss is using the aleph’s four switches to toggle between four sets of preset values. This is the method used in the ‘skitter’ scene included with the main SD card distribution.

The idea is to set each switch to a sequentially higher SW/MUL value, and then ignore all of the zeroes that are sent on releasing the key.

![](../images/t6-our-sw.jpg)

After you’ve built the above network, using the THRESH to discard the 0 values, and passing the output to recall the given preset, you can map some values to each preset. Start by first recalling preset ‘001_’ (you’ll note we’ve skipped preset ‘000_’), then setting hz0 to your desired value, and finally hitting STORE twice. Then navigate to presets 002_ through 004_ and store a new hz0 for each preset.

Pressing the switches in play mode you should now be able to play a melody with 4 different notes. Of course there’s a second oscillator who’s pitch can be controlled too, so let’s add some extra notes.

- *Recall preset 001_, store a value for hz1.*
- *Recall preset 002_, store a value for hz1.*

Before you add hz1 values to presets 3 & 4, go back to play mode and experiment with what you’ve got so far. Depending on the values you’ve chosen you’ll either have two bass pedal notes with melody on top, or two held melody notes with a walking bass underneath. More generally though what you’ve created is a split preset system where hz0 and hz1 are being controlled semi-independently despite being accessed by the four switches. You can expand this technique by adding waveshape values to presets 3 & 4:

- *Recall preset 003_, store a value for wave0.*
- *Recall preset 004_, store a value for wave0.*

Now you’ll find that the sound of the pedal tones (SW0 & 1) changes depending on whether you just played SW2 or SW3. These kinds of interactions can be built up in many layers of preset parameter changes such that a resulting sound is drastically different depending on what has come before it…

### Sequencing Presets

*Note: this technique is mostly for demonstrative purposes. If you just want a cycle of 8 values, use a LIST8 operator instead.*

Scrolling through presets with an encoder or a pair of switches is simple enough that we won’t bother explaining how to hook up the network. Instead what we’ll do here is have the machine scroll through it’s own presets to create a sort of meta sequencer. While it’s definitely easier to make a sequencer in bees using the LIST8 operator (because you can see all the different values simultaneously in a list), there are some cases where you might want to use the preset system.

The first reason is that you actually want to change operator routings rather than simply set values. The second reason would be having multiple parameters preset but not wanting to recall a value on some particular steps (in LIST8 you’d have to copy ‘duplicate’ values). Thirdly you might want to sequence more than a handful of parameters simultaneously, such that it would require too many LIST8 operators. In this way you could build a 30+ channel sequencer if you so desired, but that would take a long time to set all the values! here’s the patch:

![](../images/t6-seq-pre.jpg)

Before enabling the METRO, step through each of the first 16 presets and store a value for hz0 and/or hz1. You can skip some steps if you’d like. Now enable the METRO and hear your sequence play out.

Also shown is an alternate method of stepping through presets with a footswitch which might suit you more if you’re controlling aleph-lines parameters. The trick here is that you’ll need to enter values for the sequencer by manually storing each one while accessing the right step. As such this kind of sequencer is far more suited as a higher-level, longform sequencer where you play ‘inside’ of each step. Think of it like a chord progression or a song structure. Of course in these cases it may make more sense to manually, or programmatically trigger advancing the sequence, rather than a fixed time METRO. *Or…*

### Sequencing the sequencer

Here’s where things start to get a bit weird, but stick with it so you can learn a few nifty tricks about how to build control networks. I’ll leave it up to you to find musical use cases for these techniques..

The goal here is to have the presets that form the above sequence contain information about how the sequence itself will run. In our example this means the time scale of each element of our sequence. Similarly you could re-order the steps of the sequence by presetting the ACCUM/VAL input, but i digress!

![](../images/t6-scaler.jpg)

ENC0 is used to set the METRO/PERIOD driving the sequencer, except it is first being multiplied by MUL/B (with B_TRIG=1) where we apply our preset scale factor. By storing values of MUL/B to the relevant preset, you can double, triple or more the length of time before the next preset will be recalled. With some imaginative use of this technique you can create hard swing rhythms, musical rhythmic phrases, or totally arbitrary note lengths if you use extreme settings and small inputs to MUL/A.

Try setting every even preset to MUL/B=1, and all the odds to MUL/B=2, for a robotic swing effect.

### Triggering Events by a Preset

In addition to setting values / parameters, or changing output routings, it’s also possible to simply trigger events when a particular preset is recalled. This could mean incrementing an ACCUM, or in the following example triggering a new RANDOM calculation which sets the detune of the first oscillator. Any step can be set to trigger the calculation but we’ll just assign the change to preset 000_.

![](../images/t6-trig.jpg)

To cause the trigger, all you need to do is recall preset 000_ (stop the METRO to do this), then double-press STORE on ‘RANDOM/TRIG’. You should now hear one of the oscillators changing pitch each repeat of the pattern. Try changing the routing to tune1 instead and hear how the opposite oscillator is being affected.

A final way to expand on this idea would be to store the routing change to and from tune0 / 1 in two different steps. Then add an additional RANDOM/TRIG while it points at the other destination. Something like:

- *Preset0 triggers RANDOM/TRIG.*
- *Preset4 routes RANDOM/VAL &rarr; tune1.*
- *Preset6 triggers RANDOM/TRIG.*
- *Preset11 routes RANDOM/VAL &rarr; tune0.*

Weird.

### Indeterminacy and Presets

While the above deals with adding indeterminacy at a specific point, there are many other applications possible in bees, of which there are at least a few musical examples. The first diagram here shows how to make a probability function such that when the sequence gets half way through there is a 1 in 3 chance (33%) that the sequence will jump back to the beginning:

![](../images/t6-prob.jpg)

You’ll note that in order to work correctly the output actually needs to trigger the ACCUM/VAL input of the preset counter, rather than the PRESET/READ command itself. Extending the example you can use this technique to arbitrarily warp to a random step but only very unlikely. These techniques could form the basis of a stochastic compositional tool.

Another example is displayed below where instead of creating a probability of an event happening, it simply chooses a random network at random. The trick here is that the random event connects a number of destinations to the one source (using 2 SPLITs or a SPLIT4) rather than simply pointing it to one destination. This could be described as a random routing lookup table. Or something.

![](../images/t6-dest-mul.jpg)

And you’ll need this simple trigger patch to cause the envelope to trigger:

![](../images/t6-nested-trig.jpg)

Finally the METRO/ENABLE = 1 must be saved to preset 000_ to begin the metro (envelope) when the first stage is recalled. Note you’ll actually need to set ‘MUL/B = -1’ rather than ‘0’ for some inexplicable reason. This should now be making some rather horrible and raucous noise in your headphones and it’s probably time for a break!

### Going Further

There are so many places one could take these concepts so the best approach is probably to go back to the top of the tutorial and re-create the whole thing while using different values, destinations and sequence lengths. You’ll probably make some bizarrely interesting music in the process!

### Next Steps

[Tutorial 0: Getting Started with Bees](../tutorial-0)

[Tutorial 1: Making a Network](../tutorial-1)

[Tutorial 2: A Simple Synthesizer](../tutorial-2)

[Tutorial 3: Connecting a Controller](../tutorial-3)

[Tutorial 4: Sequencing & Modulation](../tutorial-4)

[Tutorial 5: Presets, Presets, Presets!](../tutorial-5)

Tutorial 6: More Presets

[Tutorial 7: Control Voltage &rarr;](../tutorial-7)
