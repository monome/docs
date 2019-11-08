---
layout: default
nav_exclude: true
permalink: /aleph/tutorial-3/
---

# Aleph Tutorial 3

## Connecting a Controller

After Tutorial 2 you’re hopefully getting a feel for how the bees work. This tutorial will expand upon the ‘ssyn’ SCENE by adding control from a separate controller – either a monome grid, or a USB/MIDI device.

A level of familiarity with basic tasks like adding OPS, making connections, and setting values is assumed. If you’re not quite comfortable with these tasks yet, open the summary section of [Tutorial 1](../tutorial-1) which describes these processes at a glance. Networks will hopefully look much clearer this way and it will be easier to understand what’s going on.

### Connections

Make sure you have your audio output hooked up to OUTPUT1 & 2 or the headphone out. You will need either a monome grid, or a USB/MIDI keyboard. If you have neither, jump through to the next tutorial!

If you’re wanting to use a MIDI keyboard with no USB output, you can use a single-cable USB-to-MIDI converter which are available quite cheaply.

This tutorial focusses on a keyboard-style MIDI device, but any device that sends MIDI note messages will work (eg. Drum pad).

### USB/MIDI Keyboard

The aleph is capable of many strange and wonderful things, but it can also play host to the humble MIDI keyboard. While your controller might be covered with knobs and buttons and blinking lights we’ll start with the basics and map each key to it’s pitch, and the velocity of each press to the volume.

To talk to a MIDI keyboard on the USB port we can use the MIDINOTE operator. The NUM output tells us the MIDI note number. Again we need to process this value so that it addresses the waves MODULE correctly. As discussed in the last tutorial, the pitch of the waves oscillator increases by 1 semitone every increase of 256.

Multiply the MIDI note number by 256, and then add it to the value of ENC3 so it will function as a transpose for the whole synth. First make the 3 operators:

- *Create a MIDINOTE operator.*
- *Create a MUL operator.*
- *Create an ADD operator.*

Then connect the new ops together to first multiply, then add to ENC3, and finally send the value to the hz PARAM:

- *Connect 014.MIDINOTE/NUM to 15.MUL/A.*
- *Connect 015.MUL/VAL to 16.ADD/A.*
- *Connect 016.ADD/SUM to 012.Y/X.*

For now ENC3 is still pointing directly to 012.Y and so it will over-ride the MIDI value. Instead, send it to 016.ADD to add to the effect of the keyboard:

- *Connect 003.ENC/VAL to 016.ADD/B.*

Finally we need to set some values in the INPUTS page so our OPS work as desired. First we set the MUL object to multiply by 256 to map the keyboard to semitone increases. It’s also important to know that all arithmetic based operators will only send their output when the /A input changes. In this way ENC3 would only work for the next note, and we couldn’t bend the pitch directly. Instead we can set TRIG to 1 which means a message sent to either input will trigger the calculation.

- *Set 015.MUL/B to 256.*
- *Set 016.ADD/TRIG to 1.*

Enter PLAY mode and play some notes on the keyboard. Remember to hit ENC0 to unmute the oscillators if you’re not getting any sound. You should be able to transpose up and down with ENC3. Great! but having the notes always on is not all that desirable, so the next step is to add a ‘trigger’ of sorts for each key pressed. To do so we’ll use the MIDINOTE/VEL, or velocity, output to trigger the amplitude PARAM.

- *Create a MUL operator.*

First we’ll send our VEL to the MUL operator to multiply it up to a more useable level. MIDI velocity is in the range 0-127 and we want to control the 0-32767 range. With a little math (32767/127) we find that a value of 256 will work pretty well. Then we just need to send the MUL/VAL to the same destination as SW0 as we’re controlling the same parameters.

- *Connect 014.MIDINOTE/VEL to 017.MUL/A.*
- *Connect 017.MUL/VAL to 013.Y/X.*
- *Set 017.MUL/B to 256.*

### Further Explorations

Now that your MIDI keyboard is triggering notes and controlling velocity it would be a good idea to experiment with a few variations of the ideas above. Here’s a few things to try and patch together with the OPS we’ve discussed so far:

- *Change ENC3 to jump in octaves rather than semitones (hint: 12semitones * 256 steps).*
- *Change the sensitivity of MIDINOTE/VEL (hint: use an ADD before the MUL).*
- *Map the 'amp'litude slew rate to ENC0 to change envelope settings.*

### Connecting a monome grid

Aleph integrates seamlessly with monome grid devices- no drivers, and plug and play ready. While it’s only a basic use, we’ll use the grid to create a pitch map in the popular ‘fourths’ setup. We’ll map each column to semitones, and each row to 4ths for a sort of guitar-style layout.

Firstly we need to create a GRID operator which is how you talk to the device.

- *Create a GRID operator.*

Now jump to the GRID’s INPUTs (double-press SW0) to see 3 INPUTs. For now you should simply note that FOCUS is set to 1, meaning the connection to the grid is active. Now have a look at the GRID’s outputs, namely COL (column), ROW (row) and VAL (value), which should be self-explanatory.

A little lesson about how bees works is in order here: when an OP outputs multiple values at the same time (eg. A grid press) they will be sent in the order of highest to lowest on outputs page. Bees always executes top to bottom. For example the GRID OP always sends COL then ROW and finally VAL. For those familiar with MaxMSP this might seem ‘backward’ but it should make sense in time!

To make our pitch map work we’ll first need to multiply each COL and ROW value by a given number (the ‘interval’) and then add them together:

- *Create two MUL operators.*
- *Create an ADD operator.*
- *Connect GRID/COL to the first MUL/A.*
- *Connect GRID/ROW to the second MUL/A.*
- *Connect the first MUL/VAL (from COL) to ADD/B.*
- *Connect the second MUL/VAL (from ROW) to ADD/A.*

Note that you need to connect the 1st output from the GRID op (COL) to the ‘B’ input of the ADD command so it won’t trigger it’s output until the ROW value is also received.

Now that the COL and ROW are being multiplied and added together we need to again multiply the SUM by 256 to prepare it for waves, and then send it to the frequency inputs of each oscillator. If you’re following on from above you can simply do this by connecting the 021.ADD/SUM to 15.MUL/A just as you did for the MIDINOTE output. For those new to this though, here’s the process:

- *Create a MUL operator.*
- *Create an ADD operator.*
- *Connect ADD/SUM (from the GRID) to the new MUL/A.*
- *Connect MUL/SUM to the new ADD/A.*
- *Connect ADD/SUM to 012.Y/X (to the oscillator hz PARAM).*
- *Connect 003.ENC/VAL to the new ADD/B.*
- *Set the new MUL/B to 256.*
- *Set the new ADD/TRIG to 1.*

Enter PLAY mode and press some buttons on your grid. You may need to press SW0 to turn up the volume. You should be able to control the pitch in both directions on the grid, however you’ll note that both dimensions result in a semitone of change. This is where the MUL operators after the GRID outputs come into play.

Your SCENE is probably getting quite large now so it’s good to know a tip about how to navigate your way through a patch. As we’re looking for the MUL operators that follow the GRID outputs, and there’s only one GRID op right now, find the GRID in the OUTPUTS page. Select GRID/ROW and hold SW3 – you’ll see the ALT menu appear. Simply press FOLLOW and it will take you to the INPUTS page highlighting the destination of the OUTPUT. This should be pointing at a MUL operator.

- *Increase GRID/ROW’s MUL/B value to 5.*

This will set the ROWs to 5 semitones, or a perfect fourth. By changing these values further you’re able to alter the pitch map of the grid. You’ll notice that releases of buttons also trigger the released note, and there’s no control of note velocity. As such we’ll make a small network of objects, first to stop releases triggering notes, and second to trigger the envelope by each press.

SPLIT is used to send the GRID/VAL output to two locations. The first location will trigger the envelope on each press, but first we need to MUL it by 30000 (again that -5dB volume) then send to our previously created SPLIT which is attached to the amplitude PARAMS:

- *SPLIT the GRID/VAL OUTPUT (ALT + SW1)*
- *Create a MUL operator.*
- *Set MUL/B to 30000.*
- *Connect Y/A to MUL/A.*
- *Connect MUL/A to 013.Y/X.*

Ignore the ROW & COL values of releases by gating the input to only respond to presses. This is again where execution order is important as we know the GRID/VAL comes out after the ROW and COL values. Using GATE in ‘STORE 1’ mode we can store the most recent VAL sent to the GATE and trigger it’s output by sending a ‘0’ to the GATE/GATE input. Thus we store every ‘note location’ but only send the ones we know are presses. To do so, intercept the output of the ADD operator which receives the MUL’d ROW and COL values, inserting the GATE operator. If you need, go back to the GRID object’s COL output and follow the signal through the MUL operator and into the ADD operator to find the number index appropriate.

- *Create a GATE operator.*
- *Set the GATE/STORE value to 1.*
- *Connect the ADD/SUM (from the ROW & COL) to GATE/VAL.*
- *Connect the GATE/GATED to the MUL/A that sends to hz0 (via ADD and SPLIT).*

Finally we need to take the Y/B from our SPLIT operator and trigger the output of the GATE. To do so GATE requires that it receives a 0 to trigger the output (when in STORE 1 mode). The GRID/VAL only sends 1 on a press, and 0 on a release, so first we need to ignore the presses then change the ‘1’ of a press to a 0. Using the THRESH object we split an input to 2 outputs based on the incoming value: less than x out LO and greater than or equal to x out HI. Set the THRESH/LIM to 1 and ignore the ‘0’ of a release, and then SUB 1 from the press to create a 0 to trigger the GATE.

- *Create a THRESH operator.*
- *Create a SUB operator.*
- *Connect Y/B (from GRID/VAL) to THRESH/IN.*
- *Connect THRESH/HI to SUB/A.*
- *Connect SUB/DIF to GATE/GATE.*
- *Set THRESH/LIM to 1.*
- *Set SUB/B to 1.*

Enter PLAY mode and you should have a working pitch map controlling your waves synthesizer patch. You’ll notice that playing fast notes gets a little messy because we’re not really dealing with the note-stealing properly, but a solution to that ‘legato’ style playing will come in a future tutorial.

### Further explorations

- *Setup ENC0 and ENC2 to control the pitch map intervals (MUL/B from the GRID/COL & ROW operators). Hint: you’ll want to limit the ENC/MAX values to about 12 or so.*
- *SPLIT the COL and ROW outs and attach them to wave0 or pm01 PARAMs.*

### Next Steps

[Tutorial 0: Getting Started with Bees](../tutorial-0)

[Tutorial 1: Making a Network](../tutorial-1)

[Tutorial 2: A Simple Synthesizer](../tutorial-2)

Tutorial 3: Connecting a Controller

[Tutorial 4: Sequencing & Modulation &rarr;](../tutorial-4)
