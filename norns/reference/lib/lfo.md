---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/lfo
---

## lfo

`lfo` provides a single-clock framework for generating movement (beat-synced or free) inside of a script, using a syntax similar to [`pattern_time`](/docs/norns/reference/lib/pattern_time) and [`parameters`](/docs/norns/reference/parameters). It also includes easy methods to generate `PARAMETER` UI menu controls for any of the registered LFOs. This library is only accessible by a script -- since it uses a [`lattice`](/docs/norns/reference/lib/lattice) structure, it cannot currently be invoked in a mod.

{: .no_toc }

<details closed markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

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

- `baseline`: string which represents the base value from which the LFO's movement is calculated. options are `min`, `center`, or `max` (default `min`)

- `reset_target`: string which determines the LFO reset behavior. options are `floor` or `ceiling`, which determine whether the reset will return the LFO to its lowest or highest point (default `floor`)

- `ppqn`: number which represents the resolution of the LFO. defaults to `96` but can be brought down (ideally in equal divisions of 96) to reduce CPU consumption / sample rate

- `action`: function which is called with the LFO. this function receives both the scaled value (accounting for `min`, `max`, `depth`, and `offset`) and the *raw* value of the LFO before the scaling (returns values `0` to `1`). defaults to an empty function.

### invoking an LFO

There are two approaches to constructing an LFO, depending on your scripting style.

The first is a table-based format (note the colon operator!), similar to the `params:add` format, where we can cherry-pick which arguments we're assigning values.

*nb. the LFO library is only accessible by a script -- since it uses a `lattice` structure, it cannot currently be invoked in a mod*

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

To go further, there are additional `:set` and `:get` methods, which connect to the individual LFO's current state.

`:set` and `:get` options:

- `enabled`: number `1` or `0` for on/off state
- `shape`: string `sine`, `saw`, `square`, `random`
- `min`: number for established minimum value
- `max`: number for established maximum value
- `depth`: number `0.0` to `1.0` for depth
- `offset`: number `-1.0` to `1.0` for offset
- `mode`: string `clocked` or `free`
- `period`: number; if mode is 'clocked' then number represents beats; if mode is 'free' then number represents seconds
- `baseline`: string `min`, `center`, `max`
- `reset_target`: string `floor` or `ceiling`, determines whether the LFO returns to bottom or top of the shape
- `ppqn`: number representing the resolution of the LFO
- `action`: function for callback, which receives both the scaled (between min and max, adjusted by depth and offset) and raw value (`0` to `1`)

special `:get` options:

- `scaled`: returns number representing the scaled value of the LFO (scaled to min and max, adjusted by depth and offset)
- `raw`: returns the `0` to `1` raw value of the LFO, without considering the other adjustments

#### example

In this example, we'll use `:set` and `:get` to build out a more complex LFO interaction. Press `K3` to engage or disengage the LFO.

```lua
_lfos = require 'lfo' -- assign the library to a general variable
engine.name = 'PolyPerc'
s = require 'sequins'

function init()
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
  
  screen_dirty = true
  
  -- establish an LFO variable for a specific purpose:
  cutoff_lfo = _lfos.new()
  cutoff_lfo:set('shape', 'sine')
  cutoff_lfo:set('min', 200)
  cutoff_lfo:set('max', 5000)
  cutoff_lfo:set('depth', 0.3)
  cutoff_lfo:set('mode', 'free')
  cutoff_lfo:set('period', 2)
  cutoff_lfo:set('action', function(scaled,raw) engine.cutoff(scaled) screen_dirty = true end)
  
  redraw_screen = metro.init(check_dirty,1/15,-1)
  redraw_screen:start()
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
    cutoff_lfo:set('depth', math.random())
  end
end

function check_dirty()
  if screen_dirty then
    redraw()
    screen_dirty = false
  end
end

function redraw()
   screen.clear()
   screen.level(15)
   screen.move(64,40)
   screen.font_size(20)
   screen.text_center(util.round(cutoff_lfo:get('scaled'),0.01)..'hz')
   screen.update()
end

-- press K3 to start/stop:
function key(n,z)
  if n == 3 and z == 1 then
    if cutoff_lfo:get('enabled') == 1 then
      cutoff_lfo:stop()
    else
      cutoff_lfo:start()
    end
  end
end

-- turn E3 to adjust cutoff when LFO is inactive:
function enc(n,d)
  if n == 3 and cutoff_lfo:get('enabled') == 0 then
    local current = cutoff_lfo:get('scaled')
    local change = util.clamp(current + d*100, cutoff_lfo:get('min'), cutoff_lfo:get('max'))
    cutoff_lfo:set('scaled', change)
    engine.cutoff(cutoff_lfo:get('scaled'))
    screen_dirty = true
  end
end
```

### parameter UI

To simplify the process of changing variables during play, you can also instantiate a parameter menu entry for any of the LFOs you construct. In order for the parameter menu to scale appropriately, it simply needs the `min` and `max` bounds for the LFO set ahead of executing `:add_params`.

`:add_params` requires a parameter ID, but it can also instantiate its own separator and group, as demonstrated in the example below:

```lua
_lfos = require 'lfo' -- assign the library to a general variable
engine.name = 'PolyPerc'
s = require 'sequins'

function init()
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
  
  screen_dirty = true
  
  -- IMPORTANT! set your LFO's 'min' and 'max' *before* adding params, so they can scale appropriately:
  cutoff_lfo = _lfos:add{min = 200, max = 5000}
  -- now we can add params:
  cutoff_lfo:add_params('cutoff_lfo', 'cutoff', 'LFOs')
  
  cutoff_lfo:set('action', function(scaled, raw) engine.cutoff(scaled) end)
  
  redraw_screen = metro.init(check_dirty,1/15,-1)
  redraw_screen:start()
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
  end
end

function check_dirty()
  if screen_dirty then
    redraw()
    screen_dirty = false
  end
end

function redraw()
   screen.clear()
   screen.move(64,40)
   screen.font_size(20)
   screen.text_center(util.round(cutoff_lfo:get('scaled'),0.01)..'hz')
   screen.update()
end
```

### many LFOs

In this example, we'll establish two LFOs for our engine and house their parameter UIs under a group:

```lua
_lfos = require 'lfo' -- assign the library to a general variable
engine.name = 'PolyPerc'
s = require 'sequins'

function init()
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
  
  screen_dirty = true
  
  -- IMPORTANT! set your LFO's 'min' and 'max' *before* adding params, so they can scale appropriately:
  cutoff_lfo = _lfos:add{min = 200, max = 5000}
  -- 14 parameters for LFOs + 1 separator for each:
  params:add_group('LFOs',30)
  -- now we can add our params
  cutoff_lfo:add_params('cutoff_lfo', 'cutoff')
  cutoff_lfo:set('action', function(scaled, raw) engine.cutoff(scaled) screen_dirty = true end)
  
  release_lfo = _lfos:add{min = 0.03, max = 2}
  release_lfo:add_params('release_lfo', 'release')
  release_lfo:set('action', function(s,r) engine.release(s) screen_dirty = true end)
  
  redraw_screen = metro.init(check_dirty,1/15,-1)
  redraw_screen:start()
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
  end
end

function check_dirty()
  if screen_dirty then
    redraw()
    screen_dirty = false
  end
end

function redraw()
   screen.clear()
   screen.move(64,30)
   screen.font_size(8)
   local text_to_display = "cutoff lfo: "..(cutoff_lfo:get('depth') > 0 and (util.round(cutoff_lfo:get('scaled'),0.01)..'hz') or ("-"))
   screen.text_center(text_to_display)
   screen.move(64,50)
   screen.font_size(8)
   text_to_display = "release lfo: "..(release_lfo:get('depth') > 0 and (util.round(release_lfo:get('scaled'),0.01)..'s') or ("-"))
   screen.text_center(text_to_display)
   screen.update()
end
```
