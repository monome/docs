---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/lattice
title: lattice
---

## lattice

The `lattice` allows you to perform a function repeatedly, typically useful for building sequencers.

### control

| Syntax                                 | Description                                                    |
| -------------------------------------- | -------------------------------------------------------------- |
| my_lattice = lattice:new{args}         | Create a new lattice.                                          |
| my_lattice:stop()                      | Stop the lattice.                                              |
| my_lattice:start()                     | Start the lattice.                                             |
| my_lattice:toggle()                    | Start or stop the lattice.                                     |
| my_lattice:destroy()                   | Destroy the lattice.                                                                                     |
| my_lattice:pulse()                     | Advance the lattice manually, if `my_lattice.auto` is `false`. |
| my_sprocket = lattice:new_sprocket{args} | Create a new sprocket in this lattice.                          |
| my_sprocket:stop()                      | Stop the sprocket.                                              |
| my_sprocket:start()                     | Start the sprocket.                                             |
| my_sprocket:toggle()                    | Start or stop the sprocket.                                     |
| my_sprocket:destroy()                   | Destroy the sprocket.                                           |
| my_sprocket:set_division(number)        | Change division of the sprocket.                                |
| my_sprocket:set_action(function)        | Change the action of the sprocket.                              |
| my_sprocket:set_swing(swing)            | Change the swing percentage (0-100%)                           |
| my_sprocket:set_delay(delay)            | Change the delay of sprocket (0.0 - 1)                          |

### query

A `lattice` has no formal getter functions. Here are the arguments `lattice:new{args}` and `lattice:new_sprocket{args}` utilize, which can be queried with the following syntax:

| Syntax                        | Description                                               |
| ----------------------------- | --------------------------------------------------------- |
| my_lattice.auto               | State of auto advance, default `true` : boolean           |
| my_lattice.enabled            | State of lattice, default `true` : boolean                |
| my_lattice.ppqn               | The number of pulses per quarter cycle of this superclock, defaults to `96` : number            |
| my_lattice.sprockets           | sprockets spawned by this lattice, by ID : table           |
| my_lattice.sprocket_id_counter | Last-spawned sprocket ID : number                          |
| my_lattice.transport          | Current transport position : number                       |
| my_sprocket.action             | Function assigned to sprocket : function                   |
| my_sprocket.division           | Division of the sprocket, default `1/4` : number           |
| my_sprocket.enabled            | State of sprocket, default `true` : boolean                |
| my_sprocket.id                 | Auto-assigned sprocket ID : number                         |

### example

```lua
lattice = require("lattice")

function init()

  -- default lattice usage, with no arguments
  default_lattice = lattice:new()

  -- default lattice usage, showing default arguments
  my_lattice = lattice:new{
    auto = true,
    ppqn = 96
  }

  -- make some sprockets
  sprocket_a = my_lattice:new_sprocket{
    action = function(t) print("whole notes", t) end,
    division = 1,
    enabled = true
  }
  sprocket_b = my_lattice:new_sprocket{
    action = function(t) print("half notes", t) end,
    division = 1/2,
    delay = 0.5
  }
  sprocket_c = my_lattice:new_sprocket{
    action = function(t) print("quarter notes", t) end,
    division = 1/4,
    swing = 60
  }
  sprocket_d = my_lattice:new_sprocket{
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
    sprocket_a:toggle()
    sprocket_b:toggle()
    sprocket_c:toggle()
    sprocket_d:toggle()
  end

  -- lattice controls
  -- my_lattice:stop()
  -- my_lattice:start()
  -- my_lattice:toggle()
  -- my_lattice:destroy()

  -- individual sprocket controls
  -- sprocket_a:stop()
  -- sprocket_a:start()
  -- sprocket_a:toggle()
  -- sprocket_a:destroy()
  -- sprocket_a:set_division(1/7)
  -- sprocket_a:set_action(function() print("change the action") end)

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

By default, lattices are synced to the norns clock. Lattices are built on the concept of "pulses per quarter cycle", codified as `ppqn`.  For most scripts, the default `96` ppqn (which is something of an industry standard) will be sufficient. Lattices adheres to `4` pulses per cycle, since a "quarter note" is equal to "1/4".

Each lattice contains multiple sprockets. A sprocket performs a simple function repeatedly. A sprocket's `division` describes how frequently its `action` is called. An `action` is simply any user-defined function. Actions can trigger notes, play samples, manipulate variables, or even call other functions.

A default lattice (division of `1/4`) will result in quarter notes in 4/4. The math is simply `(1/4) * (4/4)`. We can arrive at sixteenth notes in 5/4 just as easily: `(1/16) * (5/4)`.

```lua
lattice = require("lattice")

comparing_divisions = lattice:new{}

-- whole notes in 5/4
whole_fivefour = comparing_divisions:new_sprocket{
  action = function(t) print("~~~ whole notes in 5/4 ~~~", t) end,
  division = 5/4
}

-- whole notes in 4/4
whole_fourfour = comparing_divisions:new_sprocket{
  action = function(t) print("!! whole notes in 4/4 !!", t) end,
  division = 4/4
}

-- quarter notes in 4/4
quarter_fourfour = comparing_divisions:new_sprocket{
  action = function(t) print("< quarter notes in 4/4 >", t) end,
  division = 1/4
}

-- eighth notes in 5/4
eighth_fivefour = comparing_divisions:new_sprocket{
  action = function(t) print(">! eighth notes in 5/4 !<", t) end,
  division = (1/8) * (5/4)
}

comparing_divisions:start()
```

Under the hood, a single fast "superclock" automatically runs all the sprockets at the frequency of the PPQN to ensure synchronization. If you wish to advance the lattice on your own (maybe for an LFO?), set `auto` to `false` and call `:pulse()` manually.

A sprocket's `action` is passed the lattice's transport position. This can be useful to determine a relative or absolute position in a work.

A sprocket's `swing` allows you to control the swing of the emitted actions. The default swing is 50% (no swing). A swing above 50% will cause a long rest and then a short rest. A swing below 50% will create a short rest and then a long rest.

A sprocket's `delay` allows you to control how much the sprocket is delayed, as a fraction of the current `division`. For example, a `division` of `1/4` with a `delay` of `0.5` will cause the action to be emitted every quarter note, but delayed from the main clock by an eigth note (0.5 * quarter note). This is useful for controlling the duration of a note when using note-on and note-off functions. You can set two sprockets - one for note-on and one for note-off - with the same division, but the note-off sprocket is delayed from the note-on sprocket (and can be modulated).

Multiple lattices can be run simultaneously. Multiple sprockets in different lattices can call the same action. Sprockets can be added and destroyed while lattices are running.

### controlling order

As a lattice advances, it advances all of its sprockets by a pulse. In cases where the division of multiple sprockets are synchronized, it may be desirable to control the order in which their actions are called. By default, all sprockets are given a priority of `3` upon creation, which means that the order by which you build them determines the order by which they'll execute, eg:

```lua
lattice = require("lattice")

comparing_priorities = lattice:new{}

-- quarter notes in 4/4
quarter_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("< quarter notes in 4/4 >", t) end,
  division = 1/4
}

-- whole notes in 4/4
whole_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("!! whole notes in 4/4 !!", t) end,
  division = 4/4
}

comparing_priorities:start()
```

will print:

```bash
# script init
< quarter notes in 4/4 >	482
< quarter notes in 4/4 >	962
< quarter notes in 4/4 >	1442
< quarter notes in 4/4 >	1922
!! whole notes in 4/4 !!	1922
```

but this reordering:

```lua
lattice = require("lattice")

comparing_priorities = lattice:new{}

-- whole notes in 4/4
whole_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("!! whole notes in 4/4 !!", t) end,
  division = 4/4
}

-- quarter notes in 4/4
quarter_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("< quarter notes in 4/4 >", t) end,
  division = 1/4
}

comparing_priorities:start()
```

will print:

```bash
# script init
< quarter notes in 4/4 >	482
< quarter notes in 4/4 >	962
< quarter notes in 4/4 >	1442
!! whole notes in 4/4 !!	1922
< quarter notes in 4/4 >	1922
```

We can manage the order directly by specifying a sprocket's `order` upon creation, which determines the order of action execution on shared pulses, eg:

```lua
lattice = require("lattice")

comparing_priorities = lattice:new{}

-- whole notes in 4/4
whole_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("!! whole notes in 4/4 !!", t) end,
  division = 4/4,
  order = 2
}

-- quarter notes in 4/4
quarter_fourfour = comparing_priorities:new_sprocket{
  action = function(t) print("< quarter notes in 4/4 >", t) end,
  division = 1/4,
  order = 1
}

comparing_priorities:start()
```

will print:

```
< quarter notes in 4/4 >	480
< quarter notes in 4/4 >	960
< quarter notes in 4/4 >	1440
< quarter notes in 4/4 >	1920
!! whole notes in 4/4 !!	1921
```

Since the quarter note has `order = 1` and the whole note has `order = 2`, the quarter note's action will always execute *just* before the whole note's.

Contributed by Tyler Etters, Ezra Buchla, Zack Scholl, and Rylee Lyman
