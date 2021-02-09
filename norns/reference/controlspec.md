---
layout: default
nav_exclude: true
permalink: /norns/reference/controlspec
---

## controlspec

### functions

| Syntax                                                                            | Description                                                                                    |
| --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| my_control = controlspec.new(min, max, warp, step, default, units, quantum, wrap) | Create a control specification for a parameter (if building via specific parameter template)   |
| my_control = controlspec.def(min, max, warp, step, default, units, quantum, wrap) | Create a control specification for a parameter (if building via generic parameter constructor) |
| my_control:map(value)                                                             | Transform an incoming value between 0 and 1 through this controlspec                           |
| my_control:unmap(value)                                                           | Un-transform a transformed value into its original value                                       |
| my_new_control = my_control:copy()                                                | Copy a controlspec's definitions to another controlspec                                        |
| my_control:print()                                                                | Print out the configuration of this controlspec                                                |

### presets

| Syntax                   | Description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| controlspec.UNIPOLAR     | converts values to a unipolar range                          |
| controlspec.BIPOLAR      | converts values to bipolar range                             |
| controlspec.FREQ         | converts to a frequency range                                |
| controlspec.LOFREQ       | converts to a low frequency range                            |
| controlspec.MIDFREQ      | converts to a mid frequency range                            |
| controlspec.WIDEFREQ     | converts to an exponential frequency range from 0.1 to 20khz |
| controlspec.PHASE        | maps into pi for controlling phase values                    |
| controlspec.RQ           | converts to an exponential RQ range                          |
| controlspec.MIDI         | converts to a MIDI range (default 64)                        |
| controlspec.MIDINOTE     | converts to a range for MIDI notes (default 60)              |
| controlspec.MIDIVELOCITY | converts to a range for MIDI velocity (default 64)           |
| controlspec.DB           | converts to a dB range                                       |
| controlspec.AMP          | converts to a linear amplitude range (0-1)                   |
| controlspec.PAN          | converts to a panning range (-1 - 1)                         |
| controlspec.DETUNE       | converts to a detune range                                   |
| controlspec.RATE         | converts to a sensible range for playback rate               |
| controlspec.BEATS        | convert to a good range for beats                            |
| controlspec.DELAY        | converts to a good range for delay                           |

### example

```lua
-- nb. no on-screen script interaction!
-- open PARAMETERS > EDIT to see the result of this code

function init()
  amp = controlspec.AMP
  params:add_control("amplitude","amplitude",amp)

  pan = controlspec.PAN
  params:add_control("panning","panning",pan)

  del = controlspec.DELAY
  params:add_control("delay_time","delay time",del)

  freq_L = controlspec.def{
    min=0.00,
    max=5.0,
    warp='lin',
    step=0.01,
    default=2.5,
    quantum=0.01,
    wrap=false,
    units='khz'
  }
 params:add_control("filter_frequency_L","filter frequency L",freq_L)

 freq_R = freq_L:copy()
 freq_R.default = 3
 params:add_control("filter_frequency_R","filter frequency R",freq_R)

end
```

### description

A class which helps defines the range of a parameter. You can either construct your own controls or use any of the supplied presets.