---
layout: default
nav_exclude: true
permalink: /norns/reference/controlspec
---

## controlspec

### functions

| Syntax                                                                            | Description                                                                                                         |
| --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| my_control = controlspec.new(min, max, warp, step, default, units, quantum, wrap) | Create a control specification for a parameter (if building via specific parameter template)                        |
| my_control = controlspec.def{min, max, warp, step, default, units, quantum, wrap} | Create a control specification for a parameter (if building via generic parameter constructor) -- note the braces!! |
| my_control:map(value)                                                             | Transform an incoming value between 0 and 1 through this controlspec                                                |
| my_control:unmap(value)                                                           | Un-transform a transformed value into its original value                                                            |
| my_new_control = my_control:copy()                                                | Copy a controlspec's definitions to another controlspec                                                             |
| my_control:print()                                                                | Print out the configuration of this controlspec                                                                     |

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

### description

A class which helps defines the range of a parameter. You can either construct your own controls or use any of the supplied presets.

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
    min = 0.00, -- the minimum value
    max = 5.0, -- the maximum value
    warp = 'lin', -- a shaping option for the raw value
    step = 0.01, -- output value quantization
    default = 2.5, -- default value
    units = 'khz', -- displayed on PARAMS UI
    quantum = 0.01, -- each delta will change raw value by this much
    wrap = false -- wrap around on overflow (true) or clamp (false)
  }
 params:add_control("filter_frequency_L","filter frequency L",freq_L)

 freq_R = freq_L:copy()
 freq_R.default = 3
 params:add_control("filter_frequency_R","filter frequency R",freq_R)

end
```

### rounding values with 'step' and 'quantum'

`Controlspec`'s `step` and `quantum` arguments are very useful, but perhaps opaque at first glance. 

The `step` argument determines how the raw value's output should be quantized, eg.

```lua
function init()
  params:add{
    type = "control",
    id = "freq",
    name = "freq",
    controlspec = controlspec.def{
      min = 30,
      max = 400,
      warp = 'lin',
      step = 1, -- round to nearest whole number
      default = 200,
      units = "hz"
    }
  }
  params:set_action('freq', function(x) print(x) end )
end
```

With `step = 1`, deltas of +1 or -1 to the parameter value will be rounded to the nearest whole number.

The way deltas increment or decrement the parameter value is subject to `quantum`, which defaults to 0.01 -- this means 1/100th of the full range (`min` to `max`). That's why deltas will, for example, jump the `freq` parameter value from `200` to `204` then `207` then `211` -- we are simply adding `3.7` to the raw value and rounding by the specified `step`.

If you want to quantize the raw values differently, then we can specify our own `quantum`. If we wanted whole-step changes in the example above, we would rewrite it as:

```lua
function init()
  params:add{
    type = "control",
    id = "freq",
    name = "freq",
    controlspec = controlspec.def{
      min = 30,
      max = 400,
      warp = 'lin',
      step = 1, -- round to nearest whole number
      quantum = 1/(400-30), -- for whole raw values, use 1/(max-min)
      default = 200,
      units = "hz"
    }
  }
  params:set_action('freq', function(x) print(x) end )
end
```

So, generally, if you want to quantize a `controlspec`'s output to whole numbers, both of these conditions must be true:

- `step = 1`

- `quantum = 1/(max-min)` (replacing `max` and `min` with your chosen values)