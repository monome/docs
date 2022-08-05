---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/lfo
---

## lfo

### functions

| Syntax                                            | Description                                                                                   |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| my_lfo = lfo:add{args}                            | Assign a variable to construct an LFO that adheres to the provided table of arguments         |
| my_lfo = lfo.new(args)                            | Alternative to `:add`, generic LFO constructor                                                |
| my_lfo:start()                                    | Start an assigned LFO                                                                         |
| my_lfo:stop()                                     | Stop an assigned LFO                                                                          |
| my_lfo:set(var, val)                              | Set a specified LFO variable                                                                  |
| my_lfo:get(var)                                   | Get a specified LFO variable                                                                  |
| my_lfo:reset_phase()                              | Reset an assigned LFO's phase                                                                 |
| my_lfo:add_params(id, separator_name, group_name) | Generate a parameters menu for an assigned LFO, with optional separator and group invocations |

### LFO attributes + defaults

Before we dive into code examples, let's cover the attributes associated with the LFO object, as well as its default values.

An LFO is made of the following attributes:

- `shape`: the shape of the LFO. options are `sine`, `saw`, `square`, `random` (default `sine`)

- `min`: number which represents the lowest value the LFO will reach at full depth (default `0`)

- `max`: number which represents the highest value the LFO will reach at full depth (default `1`)

- `depth`: number, 0.0 to 1.0, which affects the depth of the LFO's modulation between the min and max (default `1`)

- `offset`: number, -1.0 to 1.0, which will offset the LFO's values between full `min` (`-1.0`)  or full `max` (`1.0`) (default `0`)

- `mode`: how the LFO's period is synced, either `clocked` (connected to the norns clock) or `free` (default `clocked`)

- `period`: number, which in `clocked` mode represents beats or in `free` mode represents seconds (default `4`, assuming `clocked` mode by default)

- `baseline`: string which represents the base value from which the LFO's movement is calculated. options are `from min`, `from center`, or `from max` (default `from min`)

- `reset_target`: string which determines the LFO reset behavior. options are `floor` or `ceiling`, which determine whether the reset will return the LFO to its lowest or highest point (default `floor`)

- `ppqn`: number which represents the resolution of the LFO. defaults to `96` but can be brought down (ideally in equal divisions of 96) to reduce CPU consumption / sample rate

- `action`: function which is called with the LFO. this function receives both the scaled value (accounting for `min`, `max`, `depth`, and `offset`) and the *raw* value of the LFO before the scaling (returns values `0` to `1`). defaults to an empty function.

### invoking an LFO

There are two approaches to constructing an LFO, depending on your scripting style.

The first is a table-based format (note the colon operator!), similar to the `params:add` format, where we can cherry-pick which arguments we're assigning values:

```lua
_lfos = require 'lfo'
engine.name = 'PolyPerc'
s = require 'sequins'

function init()
  engine.gain(2.7)
  engine.release(1)
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
  
  -- establish an LFO variable for a specific purpose:
  cutoff_lfo = _lfos:add{
    shape = 'saw', -- shape
    min = 200, -- min
    max = 3200, -- max
    depth = 1, -- depth (0 to 1)
    mode = 'clocked', -- mode
    period = 6, -- period (in 'clocked' mode, represents beats)
    -- pass our 'scaled' value (bounded by min/max and depth) to the engine:
    action = function(scaled, raw) engine.cutoff(scaled) end -- action, always passes scaled and raw values
  }
  
  cutoff_lfo:start() -- start our LFO, complements ':stop()'
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
  end
end
```

The alternative dot operator format requires a specific order to arguments:

`LFO.new(shape, min, max, depth, mode, period, action)`

Any value can always be `nil` if you'd like to use the default, eg:

```lua
_lfos = require 'lfo'
engine.name = 'PolyPerc'
s = require 'sequins'

function init()
  engine.gain(2.7)
  engine.release(1)
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
  
  -- establish an LFO variable:
  -- LFO.new(shape, min, max, depth, mode, period, action)
  cutoff_lfo = _lfos.new(
    nil, -- shape will default to 'sine'
    200, -- min
    3200, -- max
    nil, -- depth will default to 1
    'free', -- mode
    2.4, -- period (in 'free' mode, represents seconds)
    -- pass our 'scaled' value (bounded by min/max and depth) to the engine:
    function(scaled, raw) engine.cutoff(scaled) end -- action, always passes scaled and raw values
  )
  
  cutoff_lfo:start() -- start our LFO, complements ':stop()'
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
  end
end
```

### advanced use
