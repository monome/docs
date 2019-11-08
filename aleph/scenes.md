---
layout: default
nav_exclude: true
permalink: /aleph/scenes/
---

# Bees: Included Scenes

A number of scenes are included in the offical Aleph software package. Below is a brief description of the functionality of these scenes and the interface to control them.

These are ideal starting points to modify and extend functionality by changing the Bees network.

### skitter

Cross-delayed speed-modulated position-cutting granular echo line!

Audio into input 1, out 1/2.

Audio goes into the delay line 0, pitched down half speed. The output of delay 0 goes into delay 1.

- SW0-3 - Speed multiply for delay line 1: x1 x2 x4 x8
- FS0 - Cut delay 0 to realtime, on pedal lift. Since this is halving playback speed, you can retrigger this for an interesting effect. Try triggering while playing a note simultaneously.

- ENC0 - Feedback delay 1 into delay 0
- ENC1 - Filter cutoff for delay 1
- ENC2 - Output level of delay 0 to dac 1/2
- ENC3 - Position cut for delay line 1, a granular stutter thing

### space

A sort of space echo simulation with weird scattered octaves

Audio into input 1, out 1/2

- SW0 - Toggle high octaves (input to delay1)
- SW1-3 - Speed multiply for delay line 1: x2 x4 x8
- FS1 - Toggle mute for main delay line (delay0)

- ENC0 - Speed for octave grains on delay1
- ENC1 - Filter cutoff for delay 0
- ENC2 - Feedback for delay 0
- ENC3 - Speed for delay 0

### this

Arpeggiating synthesizer with grid control. Use this with [Tutorial 0](../tutorial-0) to get familiar with the type of controls the Aleph provides.

Audio out 1/2

- SW0 - Toggles arpeggiators on/off
- SW1 - Manually advance arpeggiator by one step
- SW2 - Randomize sequence length
- SW3 - Mute output of oscillator 2

- ENC0 - Arpeggiator speed
- ENC1 - Amount of waveform modulation (osc0→osc1)
- ENC2 - Resonant lowpass filter cutoff of osc1
- ENC3 - Transpose for both oscillators

Attach a grid to shift the pitch of both oscillators, and add waveform modulation (osc1&rarr;osc0).

### stepwaves

Grid controlled dual step sequencer.

Audio out 1/2

- SW0 - (Normal) step +1
- SW1 - Step +2
- SW2 - Step +3
- SW3 - (Reverse) step -1

- ENC0 - Metro speed
- ENC1 - Amount of waveform modulation (osc0→osc1)
- ENC2 - Pitch slew for both oscs
- ENC3 - Transpose for both oscillators

Grid controls:

- Row 1 - Progress bar for first timeline. Push to cut position in time and move loop position.
- Row 2 - Set loop end.
- Row 3-4 - Same as 1-2 but for second timeline.
- Row 5-8 - Step values. These are converted to pitch.

### crickets

Micro-repeating echo with octave jumps, controllable read/write rates.

Audio in 1, audio out 1/2

- ENC0 - Micro loop speed playback
- ENC1 - Bandpass filter for loop1
- ENC2 - Micro loop resample frequency
- ENC3 - Feed loop 1 to loop2, which adds a bunch of sonic residue

This is a similar sound achieved by using mlr as a live-sampler, with tiny inner-loops playing.

### stepwavescv

Grid controlled dual step sequencer with delay input!

Audio in 1 audio out 1/2

- SW0 - (Normal) step +1
- SW1 - Step +2
- SW2 - Step +3
- SW3 - (Reverse) step -1

- ENC0 - Metro speed
- ENC1 - Amount of waveform modulation (osc0→osc1)
- ENC2 - Pitch slew for both oscs
- ENC3 - Transpose for both oscillators

Grid controls:

- Row 1 - Progress bar for first timeline. Push to cut position in time and move loop position.
- Row 2 - Set loop end.
- Row 3-4 - Same as 1-2 but for second timeline.
- Row 5-8 - Step values.

- cv_out0 - Pitch output for timeline 1
- cv_out1 - Pitch output for timeline 2
- cv_out2 - Trigger from timeline 1, transitions on first data row (row 5)
- cv_out3 - Trigger from timeline 1, transitions on second data row (row 6)

This works well on an 8×8 or 16×8 grid. To change the size, go into EDIT mode, on INPUTS page, change the STEP/SIZE param (8 and 16 are the only options.)

### drum_test

- SW0-SW3 - Trigger drum sounds!

Drum parameters can be changed via EDIT mode. See the [dsyn](../dsyn) reference.

### mpdrumssss

Grid: mp (meadowphysics)

- SW0-SW3 - Trigger drums manually

See [meadowphysics](http://monome.org/docs/modular/meadowphysics/) for a description of grid functionality. NB: the Aleph version does not include Mute & Freeze functions.
