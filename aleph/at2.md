---
layout: default
nav_exclude: true
permalink: /aleph/tutorial-2/
---

# Aleph Tutorial 2

## A Simple Synthesizer

Following from Tutorial 1 we can construct a simple and fun synthesizer scene. This tutorial will also introduce a number of new OPERATORs that will be used to form each SCENE.

### Connections

Make sure you have your audio output hooked up to outputs 1 & 2 or the headphone out.

### Simple Synth

The SCENE that ships with the aleph called ‘this’ is a great little synth noise box, but it is a quite complicated SCENE with over 40 operators. Instead we’ll put together a far simplified version that can be expanded upon as you learn more about how OPERATORs work.

First we start with a blank scene then load aleph waves MODULE:

- *Navigate to SCENES page, and 'CLEAR' with SW2 twice.*
- *Navigate to MODULES page, and load aleph-waves.ldr with SW0 twice.*

You'll hear 2 tones a fifth apart to confirm the MODULE is loaded.

Now that waves is running, we’ll outline the functions we’re hoping to achieve:

- *ENC3 – controls pitch of oscillators 0 and 1.*
- *SW0 – triggers the note to sound with an 'envelope'.*

### Controlling Pitch

To start with let’s setup ENC3 to control the pitch of the oscillators. It might help to have a look at the waves description page so you know what each parameter does, but for now we can cheat a little. You want to control ‘073.hz0’ for oscillator0’s pitch, and ‘072.hz1’ for oscillator1’s pitch. As we’re sending the same value to two destinations, we’ll need a SPLIT operator, but otherwise the network is uncomplicated.

SPLIT is a special OP as it can be created without having to navigate to the OPERATORS page – this is because it is the most common OP needed in a scene. To SPLIT the ENC3 output to two destinations:

- *Navigate to OUTPUTS (ENC2) and select 003.ENC/VAL (ENC0).*
- *Hold 'ALT' (SW3) and press 'SPLIT' (SW1 twice).*

A SPLIT operator will be created and ENC3 will automatically route towards it. You'll now see '012.Y/A' selected showing that the SPLIT was successfully created.

Now we can connect our split output to the two frequency PARAM destinations:

- *Select 012.Y/A (ENC0), point to 073.hz0 (ENC3), double-press CONN (SW2).*
- *Select 012.Y/B (ENC0), point to 072.hz1 (ENC3), double-press CONN (SW2).*

Following from the last tutorial, we’ll again need to change the sensitivity of ENC3. To set each tick of the knob to a semitone we can use the STEP value of 256.

- *Navigate to INPUTS(ENC2), select 003.ENC/STEP (ENC0), set to 256 (ENC1 or 3, fine/coarse).*

Enter PLAY mode and turn ENC3 clockwise. It should sound something like you’re tinkering away in the background of a sci-fi movie.

We can make the sound more interesting by 'detuning' the two oscillators from each other- that is, slightly changing their pitch. This is set with '071.tune0' and '070.tune1', where '1.0' is no-detune.

- *Select 070.tune1(ENC1), set to about 0.5 (ENC3).*

### Adding a Volume Envelope

For our simple volume envelope, we'll use a gate with some ‘slew’ to ramp up and down the volume. Again we’re controlling two parameters from a single control so we’ll first SPLIT the SW0 value.

SPLIT SW0:

- *Navigate to OUTPUTS(ENC2), select 004.SW/VAL (ENC0), hold ALT (SW3) and double-press SPLIT (SW1).*

Connect SPLIT’s OUTPUTs to the volume ('amp') PARAMs:

- *Select 013.Y/A (ENC0), route to 069.amp0 (ENC3), double-press CONN (SW2).*
- *Select 013.Y/B (ENC0), route to 068.amp1 (ENC3), double-press CONN (SW2).*

SW0 will send a value of 0 or 1 only, so we need to increase the output value. Around 30,000 will give us -5dB which leaves just enough headroom to avoid unwanted distortion.

- *Navigate to INPUTS (ENC2), select 004.SW/MUL (ENC0), set to 30000 (ENC3).*

Now to add slew to the amplitude to create a simple envelope, you’ll need to set that PARAM as well:

- *Select 000.amp0Slew (ENC0), set to 25 (ENC3).*
- *Select 001.amp1Slew (ENC0), set to 12 (ENC3).*

Enter PLAY mode and tap SW0 while turning ENC3 to hear the results of our work so far. SW0 will add a soft attack to each press, and hold the volume up until you release.

Now you should have a good start on a simple synthesizer that can be expanded as you learn more. It’s probably a good time to save then!

- *Navigate to SCENES (ENC2), enter the name ‘ssyn’ (ENC3&1), double-press STORE(SW0).*

The next tutorial will continue with this same SCENE.

### Further Explorations

Before moving to the next tutorial, get to know the waves audio engine a bit better by playing with the following PARAMS, adding harmonic content to the oscillators. But first you’ll want to set SW0 to ‘toggle’ so you don’t have to keep jumping to PLAY mode to trigger the sound:

- *Navigate to INPUTS (ENC2), select 004.SW/TOG (ENC0), set to 1 (ENC3).*

Go to PLAY mode and press SW0 to turn on the oscillators. Return to EDIT mode and experiment with:

- *067.wave0 & 066.wave1 – controls waveshape of oscillators.*
- *065.pm01 & 064.pm10 – phase modulates each oscillator by the other.*
- *063.wm01 & 062.wm10 – each oscillator modulates the other’s waveshape.*

If you’re feeling adventurous, you can investigate the filter PARAMS. Start by setting resonance high, and changing the frequency:

- *Select 056.rq0, set to 0.1.*
- *Select 055.cut0, decrease value to emphasize different harmonics.*


### Next Steps

[Tutorial 0: Getting Started with Bees](../tutorial-0)

[Tutorial 1: Making a Network](../tutorial-1)

Tutorial 2: A Simple Synthesizer

[Tutorial 3: Connecting a Controller &rarr;](../tutorial-3)
