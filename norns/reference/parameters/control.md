---
layout: default
nav_exclude: true
permalink: /norns/reference/parameters/control
---

## control

The *control* parameter type provides granular control over values, leveraging an entire library of ['controlspec' presets](/docs/norns/reference/controlspec#presets). Scripts which need a filter cutoff parameter, for example, can just rely on `controlspec.FREQ`:

```lua
engine.name = "PolyPerc"
s = require 'sequins'

function init()
  params:add{
    type = "control",
    id = "filter_cutoff",
    name = "filter cutoff",
    controlspec = controlspec.FREQ,
    action = function(freq) engine.cutoff(freq) end
  }
  params:bang()
  
  notes = s{400,600,250,333}
  
  clock.run(play_notes)
end

function play_notes()
  while true do
    clock.sync(1)
    engine.hz(notes())
  end
end
```

If you don't wish to use a preset, you can also roll your own controlspec (see [the extended docs](/docs/norns/reference/controlspec) for more detail):

```lua
engine.name = "PolyPerc"
s = require 'sequins'

function init()
  
  filter_spec = controlspec.def{
    min = 1000,
    max = 6000,
    warp = 'exp',
    step = 0.01,
    default = 2031,
    units = 'hz'
    quantum = 0.01,
    wrap = false,
  }
  params:add_control("filter_cutoff","filter cutoff",filter_spec)
  params:set_action("filter_cutoff", function(freq) engine.cutoff(freq) end)
  params:bang()
  
  notes = s{400,600,250,333}
  
  clock.run(play_notes)
  
end

function play_notes()
  while true do
    clock.sync(1)
    engine.hz(notes())
  end
end
```

Or you can define the controlspec in-line:

```lua
engine.name = "PolyPerc"
s = require 'sequins'

function init()
  
  params:add_control("filter_cutoff","filter cutoff", controlspec.new(1000,6000,'exp',0.01,2031,'hz',0.01,false))
  params:set_action("filter_cutoff", function(freq) engine.cutoff(freq) end)
  params:bang()
  
  notes = s{400,600,250,333}
  
  clock.run(play_notes)
  
end

function play_notes()
  while true do
    clock.sync(1)
    engine.hz(notes())
  end
end
```

This parameter type responds to E3 in the `PARAMETERS` menu, with fine-tune by holding K3 while turning.