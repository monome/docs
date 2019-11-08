---
layout: default
nav_exclude: true
permalink: /aleph/param-scaling/
---

# Aleph Parameter Scaling

A technical note on the system of parameter representation and scaling in aleph/BEES.

###Architecture

PARAMETERS on the Aleph DSP are quantities that directly affect the running audio algorithm. Examples are oscillator frequency, amplitude, and position in a buffer. These values are all represented with 32 bits, although the exact representation may vary. They are not necessarily in a human-friendly unit; instead they represent the “native” unit which can be immediately used in the algorithm, with a minimum of conversion. Each paremeter has a defined TYPE which very specifically describes how it is used. (e.g., the Integrator type is the raw coefficient in a 1-pole lowpass filter running at the sampling rate.)

CONTROL values in the BEES application are linear, 16-bit signed values. Expressed as integers, they range from -32768 to 32767. We chose this range partly to speed calculation, and (more so) because a higher resolution also has limitations, which in a way are harder to make transparent to the user.

In any case, bees has to solve a fundamental problem in computer music: the mapping from linear control signals, to the physical parameters of sound, which are likely to be nonlinear (for example, pitch and volume are both perceived by humans as lying on an exponential scale) - and to do so in a way that is computationally efficient in real time.

When a given module is loaded, Bees searches for the corresponding .dsc file containing a list of parameter descriptors. Bees then creates an instance of a parameter SCALER class for each param, appropriate to its type. Each class implements customized methods for converting to/from CV values, as well as for displaying the parameter value in a human-readable form.

For example, the Amplitude class receives 16b input, scales it down to 10 unsigned bits, and uses these bits to look up separate use-values (in raw 31-bit amplitude) and display values (in 16.16 decibels.) neither the use-values nor the display-values are perfectly linear or perfectly exponential, since they follow a perceptually-tuned audio taper between 0.0 (-inf dB) and 1.0 (0 dB).

Note that in the lookup process, the scaler greatly reduces the resolution of the input and ignores negative numbers. This is important to understand when using such a parameter in a network!

*NOTE: it would not be difficult to increase the resolution by interpolating on the table. For cases like osc hz, this might not be a great idea since the intermediate values will not be “in tune.”*

###Customization

Some scalers use offline tables for use-values and display-values, while some can use the same table for both, and others can calculate all values on the fly with reasonable efficiency.

Scaler types that use tables can be customized without rebuilding bees:

- In the source repository, the tables (.dat) and supercollider scripts for building them (.scd) can be found in aleph/utils/param_scaling/.
- Files called “scaler_foo_val.dat” contain the raw values to be sent to the parameter, and those called “scaler_foo_rep.dat” contain human-readable representations of the same values.
- Each data file is a raw table of 1024 entries of 4 bytes each in big-endian byte order.
- Tables should be places on the sdcard in /data/bees/scalers/
- They will be loaded into internal flash on a firstrun (after flashing firmware or while holding down SW2 on powerup.)

To perform customizations at the code level (no tables, bigger tables, whatever…) see aleph/bees/src/param_scaling.c and src/scalers/* .

###Types

Parameter types, and the data structure describing them, can be found in the sources at aleph/common/param_common.h

The data structure fields are:

- Type - an enumeration.
- Min - 4-byte minimum value
- Max - 4-byte maximum value
- Radix - for params of Fixed type, this specifies how many bits in the integer part of the representation; needed for display.

The types are:

- Bool : boolean value; can only assume the values 0 and 1.
- Fix : “generic” linear value. The 32 bits of data are used arbitarily to represent integer and fractional parts. The “radix” field equals the number of bits in the integer part (including sign bit.) for example, a Fixed param with radix=1 can include the range [-1, 1.0), while radix=5 would be [-16.0,16.0) with a lower resolution, and radix=16 would mean the CV value is interpreted as an integer in its original range.
- Amp : amplitude from [0,1], displayed in decibels and using an arbitrary audio taper. This is table-based and can be customized by editing the data at aleph/utils/param_scaling/scaler_amp_*.dat
Integrator : raw coefficient for a 1-pole lowpass filter run at audio rate, commonly used for parameter smoothing. Displays seconds in [0, 64). Can be customized in aleph/utils/param_scaling/scaler_amp_*.dat
- Note : oscillator frequency in hertz. By default, this maps the CV input to 128 semitones in 12-tone equal temperament, with 8 tuned steps between each semitone. The range is midi 0 to midi 128+. Can be customized (for just intonation, etc!) at aleph/utils/param_scaling/scaler_note_val.dat . There is no separate table for representation.
- Freq: raw coefficient for a state variable filter. A lazy hack means that it re-uses the Note table for displaying hz, and uses a separate table for its own use-values.

There could be many more types added as DSP requirements expand!

###Future work

There has been a start of stub functions for “tuning” each scaler independently and programmatically, and this is one reason why each running parameter creates its own instance of a Scaler class (although they share static constant data of course.) so there is lots of room for new ideas here.
