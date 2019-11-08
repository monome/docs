---
layout: default
nav_exclude: true
permalink: /aleph/dsyn/
---

# dsyn

dsyn is a 4-voice “percussion” synthesizer module. It is at once rather primitive and quite versatile.

It is in a fairly raw and preliminary state. Suggestions, modifications, and extensions are welcome.

## Architecture

All voices are identical. Each one simply consists of a noise generator and a state variable filter. Separate exponential ADSR envelopes control amplitude, filter cutoff frequency, and filter resonance. The envelopes are triggered/gated together, but have otherwise separate timing parameters.

Amplitude envelopes are always zeroed during the “off” state. Otherwise, all state values for envelopes (peak value, sustain value, and “off”) are arbitrary.

Envelope timing is determined by “slew” parameters. These are given in units of time for -40dB convergence of exponential integrators. In other words, every envelope section has an exponential curve, and the next section is applied when the value is deemed to have converged. This results in a pretty “fast” shape.

*NB: Sustain section durations are given in samples. this could easily changed to milliseconds if preferred.*

### Parameters

Each voice has 29 parameters:

#### Gate

- Type: Boolean

If trig == 0, setting gate > 0 opens all envelopes and gate ⇐0 closes them. sustain durations are ignored. If trig == 1, setting gate > 0 initiates 1-shot envelopes, with sustain duration applied. Setting gate ⇐ 0 is ignored.

#### Trig

- Type: Boolean

Sets the trigger mode as described above.

#### Amp

- Type: Amplitude

Set the peak value of the amplitude envelope (end of attack section / beginning of decay.) Unit is decibels.

#### AmpSus

- Type: Amplitude

Set the sustain value of the amplitude envelope. unit is decibels.

#### AmpAtkSlew
#### AmpDecSlew
#### AmpRelSlew

- Type: Integrator

Slew parameters for attack, decay, and release sections of amplitude envelope. Unit is seconds for (theoretical) -40dB convergence.

#### AmpSusDur

- Type: Short

Set duration of sustain section. unit is samples.

#### FreOff

- Type: SvfFreq

Cutoff frequency for filter in the filter envelope's “off” state. Unit is Hz.

#### FreqOn

- Type: SvfFreq

Peak value of filter cutoff envelope. unit is hz. If the “FreqEnv” parameter is zero, this sets the filter cutoff directly.

#### FreSus

- Type: SvfFreq

Sustain level for filter cutoff envelope. unit is hz.

#### FreqAtkSlew
#### FreqDecSlew
#### FreqRelSlew
#### FreqSusDur

Envelope timing parameters, same as amplitude envelope.

#### RqOff
#### RqOn
#### FreSus
#### RqAtkSlew
#### RqDecSlew
#### RqRelSlew
#### RqSusDur

Parameters for resonance envelope. These behave exactly like the frequency envelope, except output values are linear in [0,1), and are Fixed type. RQ stands for “reciprocal of Q,” so 0.99 is minimal resonance, and 0 is maximum resonance, which should sound pretty much like a sine wave.

#### Low
#### High
#### Band
#### Notch

- Type: Amplitude

Levels for each output mode of the state variable filter. Unit is dB. Note that mixing arbitrary modes can have weird effects on phase, which is sometimes good, and sometimes not.

#### SvfPre

- Type: Boolean

This toggles the routing of the state variable filter with respect to the amplitude envelope. If SvfPre == 0, the filter is applied first, followed by the amp envelope. If SvfPre > 0, the filter is applied last, which allows for different “ringing” effects.

#### FreqEnv

- Type: Boolean

This toggles the filter cutoff envelope on and off. If FreqEnv == 0, the FreqOn value is applied directly to the filter cutoff.

#### RqEnv

- Type: Boolean

This toggles the filter resonance envelope on and off. If RqEnv == 0, the RqOn value is applied directly to the filter resonance.

### TODO & Known Issues

- Voice calculation can be much more efficient. As it stands, frames may be dropped (or interleaved?) when multiple voices are played, producing a weird pitch shift.

- The default parameter values are pretty useless.

- No CV output.

- No pan / mix / route.
