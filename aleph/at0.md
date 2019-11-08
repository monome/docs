---
layout: default
title: tutorial
parent: aleph
nav_order: 3
permalink: /aleph/tutorial-0/
---

# Aleph Tutorial 0

## Getting Started with Bees

The first time you turn on the Aleph it will be making a reedy arpeggiator sound, audible by attaching headphones or speakers to the outputs. While the sound is rich and evolving it will likely not fully satisfy your curiosity with the device.

This tutorial discusses how to begin your interaction with the aleph as a performance tool, and further into the patching world of bees.

If you have a new aleph, you're ready to go! otherwise, make sure you've got the 'this' scene loaded.

### Connections

Firstly, make sure you've got the SD card inserted in the aleph – it is required for all save and recall features in Bees.

In order to hear any sound out of the Aleph, you'll first need to attach headphones or some kind of speakers to the outputs. All audio outs are located on the rear of the Aleph, on the bottom row of 5 jacks. Starting from the left-edge of the device are the headphone output, followed by outputs 1 through 4. It's useful to note that in many patches the outputs are numbered from 0 to 3. The headphone out sends identical audio to outs 1 & 2.

After you've attached headphones or speakers to the output you'll need to turn the volume up, if it's not already. The small grey knobs with indication lines are the analog gain stage controls. The left most knob is for headphones. middle-left is for outs 1 & 2. Leave the other two knobs turned down for now.

Now you should be hearing the arpeggiator, and if you've turned up the outs 1 & 2 knob (even if listening on headphones) you'll see the white LED indicator start to glow showing there is sound coming out of the device.

### Play Mode

Bees always launches in PLAY mode, ready for a performance, at precisely the point where it was last turned off. It will take a few seconds to boot up from the SD card and be ready to go.

- *Turn the upper-left encoder (ENC0) to change the arp rate.*

You'll hear the rate start to increase as you turn clockwise, and decrease anti-clockwise. Each ENCoder and SWitch is mapped to its own function as listed below, so try them out!

~~~
ENC0 – Arp cycle time
ENC1 – Wave modulation
ENC2 – Osc2 filter
ENC3 – Overall pitch
SW0 – Start/stop arpeggiator
SW1 – Manual advance cycle for voice 2
SW3 – Randomize cycle lengths for each cycle
SW4 – Mute osc1
~~~

*Note: the switches and encoders are numbered left to right from 0 to 3*

### Adding a Grid

For those with a monome grid handy, this scene will demonstrate the simplest of use cases. For those without, jump ahead to the next section.

- *Attach your grid to the USB-A connection labeled 'HOST' on the aleph.*
- *Atop the arpeggiator by pressing SW0.*

Press some keys on the grid and listen to the pitch and timbre change. The y-axis is linked to the pitch of oscillator1 and the x-axis controls the amount of modulation from oscillator2-to-1. You'll hear this as a rich distortion of the lower oscillator.

Hot-swapping is fully supported, and the grid should jump to life immediately after being connected.

### Edit Mode

- *Press SW3 to turn off the higher note.*
- *Make sure the arpeggiator is running with SW0.*

Where PLAY mode lets you perform a range of functions and performative gestures, EDIT mode is the more technical building-block section of Bees. This is where you define the functions of PLAY mode, load new dsp MODULES, and save&recall your SCENEs.

To enter EDIT mode, press the MODE switch on the upper-right of the Aleph. The MODE LED will light, and the screen will display a page called SCENES.

EDIT mode is made up of a collection of lists. the ENCoders and SWitches are used for navigation and menu commands.

- *Using ENC0 scroll through the current list.*
- *Using ENC2 scroll through the active page.*

SW3 is an alt button and will display the functions available per page. This functions will hide on scrolling providing more viewable space. Scrolling clockwise through the EDIT pages you will see in order:

##### SCENES

Save and load SCENES. A SCENE includes a full description of the OPERATOR network, including PRESETS, essentially a complete set. A scene can be anything from a single sound generator, to a full performance setup.

##### MODULES

Load alternate dsp MODULES here. The list is populated from the SD card on power-up. MODULES create all sound that comes from the aleph.

##### OPERATORS

Manage the current pool of OPERATORS - the functional building blocks of Bees. Press SW0 or 1 to quickly jump to the selected OPS INPUTS or OUTPUTS page respectively. Create a new OPERATOR by selecting the name with ENC3, and double-pressing SW2 to CREATE.

##### INPUTS

A list of all INPUTs and PARAMeters displaying their current values. ENCODERs 1 & 3 (fine / course respectively) modify the selected value directly.

##### OUTPUTS

A list of all control-network OUTPUTs and their current routings. Select routing destination with ENC3, which can be either an OPERATOR-INPUT, or a MODULE-PARAM.

##### PRESETS

Manage PRESETs, each of which is a stored state of activated INPUT & PARAM values and OUTPUT routings. The system is very powerful and explained in a later tutorial.

### Editing

using ENC2 you can scroll in either direction through the pages, and you will quickly learn the fastest way to each page.

- *Navigate back to the INPUTS page.*
- *Scroll down to find '013.ACCUM/MAX'.*

'013' refers to the thirteenth OPERATOR. 'ACCUM' is the name of the OPERATOR type. 'MAX' refers to the selected VALUE of that OP - the maximum count. ACCUM is a counter which adds any input to it's output number, and can wrap between its MIN and MAX values. At present the MIN is 0 and MAX is 7, the count will be: 0,1,2,3,4,5,6,7.

- *Decrease '013.ACCUM/MAX' to '3' using ENC1.*

The bass sequence will now be 4 steps long (0,1,2,3) and will ignore the second half of the sequence.

- *Return to PLAY mode and turn on the upper arpeggiator (SW3).*

The upper and lower synths will now both be playing a 4 note sequence together.

- *Press SW2 to randomize the length of both sequences.*

### Further Explorations

The key to getting comfortable with any system is through repetition and exploration. We recommend you attempt the following before moving to the next tutorial:

- *Locate INPUT 016.LIST8 and change values I0-I7 to change the upper arpeggio.*
- *Locate INPUT 014.ACCUM/MAX and change the value between 1 and 7 to change the upper arpeggio length.*
- *Locate PARAM 030.hz1Slew (INPUTS page) to control portamento of Oscillator1.*

### Next Steps

Tutorial 0: Getting Started with Bees

[Tutorial 1: Making a Scene &rarr;](../tutorial-1)
