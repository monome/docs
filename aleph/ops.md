---
layout: default
nav_exclude: true
permalink: /aleph/ops/
---

# Aleph: Operators

Descriptions of operators available in a Bees network, including list of inputs and outputs.

If you're interested in developing new operators using the C language, head to the bees [development page](../dev) for tutorials on getting started.

## Current Operators

### ACCUM

Accumulates input values to a stored number. Can be set to wrap the count around the MIN and MAX values.

#### Inputs

- INC: receives the number to add to the current VAL.
- VAL: sets the stored number's current state.
- MIN: sets the minimum value for the stored number.
- MAX: sets the maximum value for the stored number.
- WRAP: if set, the output will wrap to opposing boundary when passing the MAX/MIN limit.

#### Outputs

- VAL: outputs the current stored number whenever it changes.
- WRAP: when WRAP input is 1, sends a 0 whenever the count wraps to the opposing boundary. when WRAP input is 0, will output the amount by which the input exceeded the limit (aka overflow).

### ADC

*See CV-IN*

### ADD

Adds input A and input B. outputs the sum.

#### Inputs

- A: added to input B and causes output.
- B: sets the value to be added to input A. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- SUM: outputs the sum of A + B.

### ARC

Allows input from monome arc devices. Provides rudimentary led feedback for further expansion. All outputs occur for any arc movement.

#### Inputs

- FOCUS: when 1 operator is active. when 0 operator ignores arc.
- LOOP: loopback mode. when set, rotating the encoder will set and display an internal value [0, 255]. when disabled, the leds and encoders are decoupled.
- RING: input selects which ring to send led data to [0, 2/4].
- POS: input selects which led to address in the selected ring [0, 63].
- VAL: input sends brightness value to selected led [0, 15].

#### Outputs

- NUM: outputs which ring has been rotated.
- DELTA: rotation amount for input to an ACCUM op.
- VAL: internally stored value between 0 and 255.

### BARS

Display four horizontal bar graphs in PLAY mode
Values are from 0-127, so some pre-scaling (using MUL or DIV) may be necessary.

#### Inputs

- ENABLE: toggle on/off
- PERIOD: refresh rate
- MODE: unused currently (for future development)
- A/B/C/D: values displayed, top to bottom

#### Outputs

(none)


### BIGNUM

Display a large number in PLAY mode

#### Inputs

- ENABLE: toggle on/off
- PERIOD: refresh rate
- VAL: number to display in PLAY mode
- X/Y: display position on screen

#### Outputs

(none)

### BITS

Convert a single decimal to many bits, and many bits to one decimal

#### Inputs

- IN: decimal input to covert to bits
- I0-I7: bits to convert to decimal

#### Outputs

- OUT: decimal from input bits
- O0-O7: bits from decimal input

This op is useful for using decimal numbers as “storage” for many binary numbers (on/off) which could be considered triggers, ie. for drums. So decimal 3 is binary 00000011, which could mean play note 0 and note 1– decimal 13 is binary 00001101… note 0,2,3. etc.

### CV-IN

Receives control input from the CV input jacks.

#### Inputs

- ENABLE: a value of 1 begins polling of the ADC inputs. 0 turns off polling
- PERIOD: sets number of milliseconds between each poll of the inputs
- MODE: 0 is continuous input. 1 is trigger input which only changes on transition, threshold is set around 2.5V

#### Outputs

- VAL0-VAL3: outputs a stream of values from the respective input, corresponding to the received input voltage. range is [0,4095] when mode=0, and 0/1 when mode=1.

### DELAY

Delay a value by a specified time. Each input is sent to the output after TIME (ms). If an input arrives while another input is being delayed, this old value will be overwritten and the delay restarted.

#### Inputs

- VAL: the input value to delay
- TIME: amount of time in ms
- CLEAR: cancel any values currently waiting.

#### Outputs

- VAL: output after set time

### DIV

Divides input A by input B. Outputs the quotient.

#### Inputs

- A: divided by input B and causes output.
- B: sets the B value. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- VAL: outputs the quotient of A / B.

### DIVr

Divides input A with input B. outputs the quotient and remainder. A combination of DIV and MOD.

#### Inputs

- A: divided by input B and causes output.
- B: sets the B value. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- VAL: outputs the quotient of A / B.
- R: outputs the integer remainder of A / B.

### ENC

Allows the aleph's encoders to be routed in the bees network.

#### Inputs

- MIN: sets the minimum output value.
- MAX: sets the maximum output value.
- STEP: sets the increment/decrement value for each step.
- VAL: sets the internally stored value.

#### Outputs

- VAL: outputs the current internally stored value.
- DELTA: outputs rotational values when the encoder is turned. can be routed to numerous ACCUM operators for multi-modal encoders.

### FADE

Crossfades between inputs A and B according to input X using a linear curve. All inputs cause output to be updated.

#### Inputs

- A: sets the A input value.
- B: sets the B input value.
- X: fades between input A (X=0) and input B (X=128). values outside the 0-128 range are clamped to the range.

#### Outputs

- VAL: the output of the crossfader.

### FS [1-2]

Allows the footswitch inputs to be routed in the control network.

#### Inputs

- TOG: when 0, output is momentarily high when held. when 1, output will toggle between states on each press.
- MUL: this value is output when the footswitch is active. 0 when inactive.

#### Outputs

- VAL: the current state value of the footswitch (0 or MUL).

### GATE

Pass or block the input value to the output.

#### Inputs

- VALUE: the value to be passed or blocked.
- GATE: 1 passes all values to output. 0 blocks input.
- STORE: when 1, a value of 0 sent to the GATE input will trigger output of the most recent value (aka sample and hold).

#### Outputs

- GATED: echoes the VALUE input when GATE is set to 1.

### GRID

Receives key data from a monome grid. Displays the current state on the device.

#### Inputs

- FOCUS: when 1, operator is active. when 0, operator ignores grid.
- TOG: when 0, all keys are momentary. when 1, cells toggle between states on each press.
- MONO: when 1, only 1 led will be lit at a time.

#### Outputs

- COL: on each event, sends the column value (0-15).
- ROW: on each event, sends the row value (0-15).
- VAL: on each event, sends the state (1: press, 0: release).

### HID

Connect a Human Interface Device over USB. Multiple operators are required to monitor different bytes. Connect a gamepad, shnth or manta.

#### Inputs

- BYTES: sets which HID byte to monitor
- SIZE: sets the bytesize of the parameter to 8/16 bits.

#### Outputs

- VAL: the output value received from the HID.

### HISTORY

Stores a running list of the last 8 values input, provides the average.

#### Inputs

- IN: the input.

#### Outputs

- AVG: average of the last 8 values.
- O0-7: O0 is the input, O1 the previous, O2 … O7. a queue.

### IS

Comparisons. Equals, not equals, greater than, less than.

#### Inputs

- A: sets first value.
- B: sets second value. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.
- EDGE: when 1, output triggered only on transition between states.

#### Outputs

- EQ: 1 if A == B (A equals B)
- NE: 1 if A != B (A does not equal B)
- GT: 1 if A > B (A is greater than B)
- LT: 1 if A < B (A is less than B)

### LIFE

Conway's game of life. With monome grid support.

#### Inputs

- NEXT: non-zero input triggers algorithm.
- XSIZE: size of field, 8 or 16
- YSIZE: size of field, 8 or 16
- X: postion for edit by SET, output of VAL
- Y: position for edit by SET, output of VAL
- SET: 0/1 set at X/Y
- NOISE: (not yet implemented)
- RULES: 0=normal, 1=nodeath, 2=nobirth (weird/fun)
- FOCUS: set 1 to focus monome

#### Outputs

- VAL: the value at X/Y
- POP: total population
- DELTA: change in population this round

### LIST2

Storage for two values, recallable by index. Good for use with a binary (0-1) input, for setting individual values.

#### Inputs

- INDEX: (0-1) get value at given index, sent to output
- I0-I1: set input values to store

#### Outputs

- VAL: the value at given index

### LIST8

Storage for eight values, recallable by index .

#### Inputs

- INDEX: (0-7) get value at given index, sent to output
- I0-I7: set input values to store

#### Outputs

- VAL: the value at given index

### LIST16

Storage for sixteen values, recallable by index.

#### Inputs

- INDEX: (0-15) get value at given index, sent to output
- I0-I15: set input values to store

#### Outputs

- VAL: the value at given index

### LOGIC

Logic comparisons. Takes binary input and outputs binary values.

#### Inputs

- A: first value 0/1
- B: second value 0/1
- B_TRIG: 0/1, execute on B change if 1
- EDGE: 0/1, if 1, only output on transitions
- INVERT: 0/1, if 1, invert output

#### Outputs

- AND: A && B (1 if A is 1 and B is 1)
- OR: A || B (1 if A is 1 or B is 1)
- XOR: A ^ B (1 if A is 1 or B is 1 but not both)

### MP

Meadowphysics, for grid. See [meadowphysics](http://monome.org/docs/modular/meadowphysics/)

#### Inputs

- FOCUS: when 1, operator is active. when 0, operator ignores grid
- SIZE: sets grid size ( 8 / 16 )
- STEP: move playhead ( + / - )

#### Outputs

- O0-O7: trigger outputs corresponding to descending rows

### METRO

Outputs a given value at a regular interval.

#### Inputs

- ENABLE: a value of 1 activates the output. 0 stops output.
- PERIOD: sets the time interval in milliseconds.
- VAL: sets the value that is sent on each tick.

#### Outputs

- TICK: outputs the VAL at the end of each interval.

### MIDICC

Receives MIDI cc events from a USB connected device.

#### Inputs

- CHAN: sets the MIDI channel to listen to. -1 responds to all channels.
- NUM: sets CC number to listen to.

#### Outputs

- VAL: outputs the cc value (0-127).

### MIDINOTE

Receives MIDI note events from a USB connected device.

#### Inputs

- CHAN: sets the MIDI channel to listen to. -1 responds to all channels.

#### Outputs

- NUM: outputs the MIDI note number (0-127).
- VEL: outputs the MIDI velocity (0-127, 0 is a release).

### MOUT_NOTE (MOUT_N)

Send MIDI note events to a USB connected device.

#### Inputs

- CHAN: sets the MIDI channel to send to.
- NUM: MIDI note number (0-127).
- VEL: MIDI velocity (0-127, 0 is a release).

#### Outputs

(none)

### MOD

Divides input A by input B, outputs the remainder.

#### Inputs

- A: sets the numerator and causes output.
- B: sets the denominator. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- VAL: outputs the remainder (mod) of A / B.

### MUL

Multiplies input A by input B. Outputs their product.

#### Inputs

- A: sets the number to be multiplied by input B and causes output.
- B: sets the number by which input A is multiplied. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- VAL: outputs the product of A * B.

### PRESET

Presets can be read or written in response to received input. Values and routings need to be 'included' in the preset system before they will be recalled.

#### Inputs

- READ: any received input recalls the state of the number PRESET received.
- WRITE: any received input writes the current state to the number PRESET received.

### RANDOM

Generates a random number after receiving any input.

#### Inputs

- TRIG: any input causes a new random number to output.
- MIN: sets the minimum value that can be output.
- MAX: sets the maximum value that can be output.

#### Outputs

- VAL: sends the random number.

### ROUTE (ROUTE4)

Direct an input to one of four outputs.

#### Inputs

- VAL: input value to route
- TO: which output to send VAL to (0-3)

#### Outputs

- O0-O3: outputs

### ROUTE8

Direct input to one of eight outputs.

#### Inputs

- VAL: input value to route
- TO: which output to send VAL to (0-7)

#### Outputs

- O0-O7: outputs

### SCREEN

Draw pixels on PLAY screen.

#### Inputs

- ENABLE: on/off
- PERIOD: refresh rate
- VAL: pixel value to draw (0-15)
- FILL: fill entire screen (0-15)
- X/Y: position to draw

### SERIAL

(Unknown)

### SPLIT (Y)

Receives one input and echoes it to two outputs.

#### Inputs

- VAL: receives an input value.

#### Outputs

- OUT1: sends out the input value first.
- OUT2: sends out the input value second.

#### SPLIT4 (Y4)

Receives one input and echoes it to four outputs.

#### Inputs

- VAL: receives an input value.

#### Outputs

- OUT1: sends out the input value first.
- OUT2: sends out the input value second.
- OUT3: sends out the input value third.
- OUT4: sends out the input value fourth.

### STEP

A step sequencer for monome grids.

#### Inputs

- FOCUS: when 1, operator is active. when 0, operator ignores grid
- SIZE: sets grid size ( 8 / 16 )
- STEP: move playhead ( + / - )

#### Outputs

- A : sends out value of button in row 4 at upper playhead position ( 0 / 1 )
- B : sends out value of button in row 5 at upper playhead position ( 0 / 1 )
- C : sends out value of button in row 6 at upper playhead position ( 0 / 1 )
- D : sends out value of button in row 7 at upper playhead position ( 0 / 1 )
- MONO1 : bitmapped value of column at upper playhead position (see below)
- POS1 : current step of upper playhead
- MONO2 : bitmapped value of column at lower playhead position (see below)
- POS2 : current step of lower playhead.

#### Grid

- row 0 = set position of upper playhead (also sets beginning of cycle)
- row 1 = set length of upper loop (if loop is longer than distance from playhead to end of row it will cycle around to beginning of row)
- row 2 = set position of lower playhead (also sets beginning of cycle)
- row 3 = set length of lower loop (if loop is longer than distance from playhead to end of row it will cycle around to beginning of row)

- row 4 - 7 = bitmapped values. MONO 1/2 outputs the sum of the 4 rows, the individual value for active buttons are as follows

- row 4 = 1
- row 5 = 2
- row 6 = 4
- row 7 = 8
e.g. to get the value 5 you would have row 4 and row 6 active, to get the value 9 you would have row 4 and row 7 active, and so on and so forth. it's a binary-to-decimal conversion with row 4-7 being bits 0-3 of the number.

### SUB

Subtracts input B from input A. outputs the difference.

#### Inputs

- A: sets the number from which to subtract input B and causes output.
- B: sets the number to subtract from input A. does not cause output.
- B_TRIG: when 1, a new value sent to input B will also cause output.

#### Outputs

- DIF: outputs the difference of A - B.

### SW [1-4]

Allows the aleph's keys to be routed in the control network.

#### Inputs

- TOG: when 0, switches are momentarily high when held. when 1, switches will toggle between states on each press.
- MUL: this value is output when the switch is active. 0 when inactive.

#### Outputs

- VAL: the current state value of the switch (0 or MUL).

### THRESH

Sends input through 1st outlet if below threshold, 2nd if not .

#### Inputs

- VAL: value to be tested
- LIM: the threshold (limit”)

#### Outputs

- LO: output was < threshold
- HI: output was >= threshold

### TIMER

Outputs the time interval between the last two received events in milliseconds.

#### Inputs

- EVENT: causes output, then restarts timer at zero

#### Outputs

- TIME: outputs time interval between last two received events

### TOG

Toggles between zero and a given number.

#### Inputs

- STATE: any positive input causes the state to change. <1 outputs 0.
- MUL: sets the value to be output when toggle is on.

#### Outputs

- VAL: outputs the current state of the toggle. 'off' outputs 0. 'on' outputs MUL.

### WHITE WHALE (WW)

White whale, for grid. see [white whale](http://monome.org/docs/modular/whitewhale/)

#### Inputs

- FOCUS: when 1, operator is active. when 0, operator ignores grid
- CLOCK: advances the step clock by 1. expects alternating 0/1 from a METRO op.
- PARAM: input parameter for setting CV values; range [0,4095].

#### Outputs

- TR0-TR3: trigger or gate outputs from the sequencer; [0,1].
- CVA-CVB: continuous outputs. for map mode MUL by 8 for CV output. For waves, MUL by 15, then DIV by 2.
