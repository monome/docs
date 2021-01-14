---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/lattice
title: lattice
---

## lattice

### control

| Syntax                                 | Description                                                    |
| -------------------------------------- | -------------------------------------------------------------- |
| my_lattice = lattice:new{args}         | Create a new lattice.                                          |
| my_lattice:stop()                      | Stop the lattice.                                              |
| my_lattice:start()                     | Start the lattice.                                             |
| my_lattice:toggle()                    | Start or stop the lattice.                                     |
| my_lattice:destroy()                   | Destroy the lattice.                                           |
| my_lattice:set_meter(number)           | Change the meter.                                              |
| my_lattice:pulse()                     | Advance the lattice manually, if `my_lattice.auto` is `false`. |
| my_pattern = lattice:new_pattern{args} | Create a new pattern in this lattice.                          |
| my_pattern:stop()                      | Stop the pattern.                                              |
| my_pattern:start()                     | Start the pattern.                                             |
| my_pattern:toggle()                    | Start or stop the pattern.                                     |
| my_pattern:destroy()                   | Destroy the pattern.                                           |
| my_pattern:set_division(number)        | Change division of the pattern.                                |
| my_pattern:set_action(function)        | Change the action of the pattern.                              |

### query

A `lattice` has no formal getter functions. Here are the arguments `lattice:new{args}` and `lattice:new_pattern{args}` utilize, which can be queried with the following syntax:

| Syntax                        | Description                                               |
| ----------------------------- | --------------------------------------------------------- |
| my_lattice.auto               | State of auto advance, default `true` : boolean           |
| my_lattice.enabled            | State of lattice, default `true` : boolean                |
| my_lattice.meter              | Amount of quarter notes per measure, default `4` : number |
| my_lattice.ppqn               | Pulses per quarter note, default `96` : number            |
| my_lattice.patterns           | Patterns spawned by this lattice, by ID : table           |
| my_lattice.pattern_id_counter | Last-spawned pattern ID : number                          |
| my_lattice.transport          | Current transport position : number                       |
| my_pattern.action             | Function assigned to pattern : function                   |
| my_pattern.division           | Division of the pattern, default `1/4` : number           |
| my_pattern.enabled            | State of pattern, default `true` : boolean                |
| my_pattern.id                 | Auto-assigned pattern ID : number                         |

### example

```lua
lattice = require("lattice")

function init()

  -- default lattice usage, with no arguments
  default_lattice = lattice:new()

  -- default lattice usage, showing default arguments
  my_lattice = lattice:new{
    auto = true,
    meter = 4,
    ppqn = 96
  }

  -- make some patterns
  pattern_a = my_lattice:new_pattern{
    action = function(t) print("whole notes", t) end,
    division = 1,
    enabled = true
  }
  pattern_b = my_lattice:new_pattern{
    action = function(t) print("half notes", t) end,
    division = 1/2
  }
  pattern_c = my_lattice:new_pattern{
    action = function(t) print("quarter notes", t) end,
    division = 1/4
  }
  pattern_d = my_lattice:new_pattern{
    action = function(t) print("eighth notes", t) end,
    division = 1/8,
    enabled = false
  }

  -- start the lattice
  my_lattice:start()

  -- demo stuff
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

function key(k, z)
  if z == 0 then return end
  if k == 2 then
    my_lattice:toggle()
  elseif k == 3 then
    pattern_a:toggle()
    pattern_b:toggle()
    pattern_c:toggle()
    pattern_d:toggle()
  end

  -- lattice controls
  -- my_lattice:stop()
  -- my_lattice:start()
  -- my_lattice:toggle()
  -- my_lattice:destroy()
  -- my_lattice:set_meter(7)

  -- individual pattern controls
  -- pattern_a:stop()
  -- pattern_a:start()
  -- pattern_a:toggle()
  -- pattern_a:destroy()
  -- pattern_a:set_division(1/7)
  -- pattern_a:set_action(function() print("change the action") end)

end

function enc(e, d)
  params:set("clock_tempo", params:get("clock_tempo") + d)
  screen_dirty = true
end

function cleanup()
  my_lattice:destroy()
end

-- screen stuff

function redraw_clock()
  while true do
    clock.sleep(1/15)
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.aa(0)
  screen.font_size(8)
  screen.font_face(0)
  screen.move(1, 8)
  screen.text(params:get("clock_tempo") .. " BPM")
  screen.update()
end
```

### description

The `lattice` allows you to quickly create simple and extensible sequencers.

By default, lattices are synced to the norns clock. Lattices are built on the concept of "pulses per quarter note" or PPQN.  For most scripts, the default `96` PPQN (which is something of an industry standard) will be sufficient. Lattices default to a `meter` of `4`. Since lattices are built on pulses per **quarter note** this describes how many quarter notes are in a measure.

Each lattice contains multiple patterns. A pattern's `division` describes how frequently its `action` is called. An `action` is simply any user-defined function. Actions can trigger notes, play samples, manipulate variables, or even call other functions.

A default lattice (`meter` of `4`, a division of `1`) will result in "whole notes." To arrive at `1`: 1/4 (quarter notes) * 4 (the meter) = 1 (division). The math is relatively intuitive when the meter is `4`, but what about other signatures?

```lua
-- a lattice in 5/4
five_four_lattice = lattice:new{
  meter = 5
}

-- whole notes
-- .25 (quarter notes) * 5 (meter) = 1.25 (division)
whole_notes = five_four_lattice:new_pattern{
  action = function(t) print("whole notes in 5/4", t) end,
  division = 1.25
}

-- eighth notes
-- same as a lattice in 4/4!
eighth_notes = five_four_lattice:new_pattern{
  action = function(t) print("eighth notes in 5/4", t) end,
  division = .125
}

five_four_lattice:start()
```

Under the hood, a single fast "superclock" automatically runs all the patterns at the frequency of the PPQN to ensure synchronization. If you wish to advance the lattice on your own (maybe for an LFO?), set `auto` to `false` and call `:pulse()` manually.

A pattern's `action` is passed the lattice's transport position. This can be useful to determine a relative or absolute position in a work.

Multiple lattices can be run simultaneously. Multiple patterns in different lattices can call the same action. Patterns can be added and destroyed while lattices are running.

Contributed by Tyler Etters and Ezra Buchla