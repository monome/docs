---
layout: default
nav_exclude: true
permalink: /aleph/lines/
---

# lines

lines is a dual delay line with complex modulation matrix possibilities.

## Architecture

### Routing

Each delay line accepts input from any hardware input channel and from any delay line output.

Each delay line output is routed through a state variable filter with an arbitrary mix of lowpass, bandpass, highpass and notch outputs.

Each filter output is mixed arbitrarily with the unfiltered delay line output to an output bus.

Each output bus is mixed arbitrarily to each hardware output channel, and also to each delay line input.

### Delay Line Implementation

It is beneficial to understand each delay line as a combination of three elements:

- An audio buffer of a certain length
- A “write head”
- A “read head”

Each “head” is actually a phasor: a *position* value which is updated each sample. When the position reaches the end of the buffer (or the position specified by the `loop` parameter, if that comes first), it will wrap to the start of the buffer.

Setting the “delay” parameter, asks the read head to move to a position behind the write head by a given offset. This results in an echo.

The `run` parameters tell the read/write heads to start or stop moving completely.

The `pos` parameters set the position of the read/write heads directly.

The `loop` parameter tells the read and write heads where to wrap to zero.

Additionally, the `writeN` and `preN` parameters specifify amplitudes with which to write new content and preserve old content.

Manipulating these last parameter sets allows one to create all sorts of looping / overdubbing algorithms.

A final note on implementation: these delay lines are currently uninterpolated. This means that the rate of each phasor can only be an integer division of the sample rate. we're working on proper interpolation (it's a minor numerical challenge on the blackfin,) and for now there is a weird system where you can specify arbitrary “mul” and “div” rates, which respectively cause the read phasor to jump by intervals of “mul” samples, and/or hold/interpolate each value for “div” samples. this allows for a limited form of lo-fi pitch-shifting by low-order harmonic ratios.

### Parameters: per Delay Line

#### delayN

Delay time in seconds
Setting this moves the read position to the specified offset behind the write position.

- Param type: Fix
- Range: [0, 32]

#### loopN

Position, in seconds, at which read/write positions will wrap.
Use this for looping applications, or for weird stuff if you set loop < delay.

- Param type: Fix
- Range: [0, 32]

#### rMulN

Multiplies the speed of the read phasor, for a sort of lo-fi upwards pitch shift.

- Param type: Fix
- Range: [1, 8] (integers only)

#### rDivN

Multiplies the speed of the read phasor, for a sort of lo-fi downwards pitch shift.

- Param type: Fix
- Range: [1, 8] (integers only)

#### writeN

Amplitude at which new data is written to the delay line at the write position.
- Param type: Amp
- Range: [0, 1] (bees displays decibels)

#### preN

Amplitude at which old data is preserved in the delay line at the write position.

- Param type: Amp
- Range: [0, 1] (bees displays decibels)

#### pos_writeN

Sets the position (in seconds) of the write head.
- Param type: Fix
- Range: [0, 32]

#### pos_readN

Sets the position (in seconds) of the read head.

- Param type: Fix
- Range: [0, 32]

#### run_writeN

Flag to enable/disable writing to the delay line.

- Param type: Bool
- Range: [0, 1]

#### run_readN

Flag to enable/disable reading from the delay line.

- Param type: Bool
- Range: [0, 1]

### Parameters: per Filter

#### cutN

Filter cutoff frequency for filter N

- Parameter type: SvfFreq
- Range: [ ~8hz, ~16000hz ]

#### rqN

Reciprocal of Q for filter N
Zero equals full resonance

- Parameter type: Fixed
- Range: [0, 2]

#### lowN

Lowpass output amplitude for filter N

- Parameter type: Amp
- Range: [0, 1.0] (bees will display dB)

#### highN
Highpass output amplitude for filter N

- Parameter type: Amp
- Range: [0, 1.0] (bees will display dB)

#### bandN

Bandpass output amplitude for filter N

- Parameter type: Amp
- Range: [0, 1.0] (bees will display dB)

#### notchN

Notch output amplitude for filter N

- Parameter type: Amp
- Range: [0, 1.0] (bees will display dB)

### Paramaters: per Input -> Delay Pair

#### adcX_delY

Amplitude of mix point between hardware input channel X and delay input Y

- Param type: Amp
- Range: [0, 1] (bees displays decibels)

### Parameters: per Input -> Output Pair

#### adcX_dacY

Amplitude of mix point between hardware input channel X and output channel Y

- Param type: Amp
- Range: [0, 1] (bees displays decibels)

### Parameters: per Delay -> Delay Pair

#### delX_delY

Amplitude of mix point between delay output X and delay input Y
X and Y can be equal for feedback.

- Param type: Amp
- Range: [0, 1] (bees displays decibels)

### Parameters: per Delay -> Output Pair

#### delX_dacY

Amplitude of mix point between delay output X and hardware output channel Y

- Param type: Amp
- Range: [0, 1] (bees displays decibels)
