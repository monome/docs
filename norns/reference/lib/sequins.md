---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/sequins
title: sequins
---

## sequins

A library designed to build sequencers and arpeggiators with very little scaffolding, using Lua tables. Originally designed by `@trentgill` for use with [crow](/docs/crow/reference/#sequins), the norns library uses the exact same syntax and provides the same features.

This document will provide an introduction to the basics of `sequins`. To learn more advanced techniques, including *transformers* and live-code friendly assignment of events to strings, see [the `sequins` v2 extended reference](/docs/crow/sequins2).

### control

| Syntax                          | Description                                                                                                                      |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| my_seq = sequins{a,b,c...x,y,z} | Create a sequins of values (any data type is allowed, including more sequins)                                                    |
| my_seq()                        | Call the sequins, advancing by its step size (default 1) then returning the new value. Wraps at edges.                           |
| my_seq:step(x)                  | Change the step size from default 1 to `x`                                                                                       |
| my_seq:select(n)                | At the next `my_seq()`, index `n` will be selected and returned                                                                  |
| my_seq[x] = y                   | Update the value of table index `x` to `y` (does not change the length of the sequins)                                           |
| my_seq:settable(new_table)      | Swap the current sequins values with an entirely `new_table` (changes the length of the sequins and preserves the current index) |

### flow-modifiers

Flow-modifiers are exclusively supported in nested-sequins and can only be modified by recompiling that nested sequins. See example below.

| Syntax          | Description                                                                         |
| --------------- | ----------------------------------------------------------------------------------- |
| my_seq:every(n) | Produce a value every `n`th call                                                    |
| my_seq:times(n) | Only produce a value the first `n` times it's called                                |
| my_seq:count(n) | Produce `n` values from inner-sequins before releasing focus to the outer-sequins   |
| my_seq:all()    | Iterate through all values in inner-sequins before releasing focus to outer-sequins |
| my_seq:reset()  | Reset all flow modifiers and table indices                                          |

### example

```lua
s = require 'sequins'

engine.name = 'PolyPerc'

function init()
  hz_vals = s{400,600,200,350}
  sync_vals = s{1,1/3,1/2,1/6,2}
  clock.run(iter)
end

function iter()
  while true do
    clock.sync(sync_vals())
    hertz = hz_vals()
    engine.hz(hertz)
  end
end

function coin_toss(n)
  if math.random(0,1) == 1 then
    return n
  else
    return n*1.5
  end
end

-- uncomment (CMD-/ or CTL-/) + live-execute (CMD+ENTER or CTL-ENTER) these commands:
-- sync_vals:step(2) -- change step size for 'sync_vals'
-- hz_vals:step(2) -- change step size for 'hz_vals'
-- hz_vals:settable({400,600,200,350,800,1200,700}) -- retains previously-declared 'step' size
-- hz_vals = s{400,600,200,350,s{800,1200,700}} -- nested sequins plays one note from inner sequins after outer sequins
-- hz_vals = s{400,600,200,350,s{800,1200,700}:every(3)}:step(3) -- advance by 3, play inner sequins every 3rd iteration
-- hz_vals = s{400,600,200,350,s{800,1200,700}:count(10)} -- inner sequins will iterate 10x and return to outer
-- hz_vals = s{400,600,200,350,s{1600,1400,950}:times(6)} -- inner sequins will iterate as normal, but will not return after 6 iterations
-- hz_vals = s{400,600,200,350,s{1600,1400,950}:map(coin_toss)} -- inner sequins will check `coin_toss` for pattern manipulation
-- sync_vals:step(-4) -- step sizes can be negative or positive
-- hz_vals = s{400,600,200,350,s{1600,1400,950,950,950,700}:all()} -- inner sequins will take focus and play all of its notes before it releases focus to outer sequins
```

### description

The `sequins` library is designed for building sequencers and arpeggiators with very little scaffolding required.

Originally designed as a [component for crow scripts](/docs/crow/reference/#sequins), `sequins` helps reduce complex data structures and their manipulation into a terse function call with special modifiers.

Any datatype is allowed, eg:

```lua
s = require 'sequins'

engine.name = 'PolyPerc'

function init()
  to_print = s{"hello","we're","glad","to","see","you"}
  to_do = s{first,second,third}
  to_pass = s{10000,500,3000,8170,1200}

  screen_dirty = false
  word = "hold K1"
  cutoff = "press K2 = "

  clock.run(
    function()
      while true do
        clock.sleep(1/15)
        if screen_dirty then
          redraw()
          screen_dirty = false
        end
      end
    end
    )
end

function first()
  engine.release(3)
  engine.hz(300)
end

function second()
  engine.release(0.1)
  engine.hz(1200)
end

function third()
  engine.release(2)
  engine.hz(900)
end

function key(n,z)
  if n == 3 then
    if z == 1 then
      -- one approach:
      local execute_this = to_do()
      execute_this()
    else
      -- another approach that might look odd:
      to_do()()
      -- but both approaches are the same!
    end
  elseif n == 2 and z == 1 then
    cutoff = to_pass() -- sequins iterate every call, so if you need to reuse the current value, store it as a variable
    engine.cutoff(cutoff)
    screen_dirty = true
  elseif n == 1 and z == 1 then
    word = to_print()
    screen_dirty = true
  end
end

function redraw()
  screen.clear()
  screen.move(10,10*to_print.ix)
  screen.text(word)
  screen.move(64,10)
  screen.text(cutoff.."hz")
  screen.move(128,64)
  screen.text_right("K3: PLAY NOTE")
  screen.update()
end
```

Complexity can be quickly achieved by nesting multiple `sequins`, as outlined in the top example.

Note that when using `my_seq()` with nested sequins, the call will "cascade" down and return the innermost value. Example:

```lua
my_seq = sequins{sequins{3,6,9},12,15}
```

In this example, `my_seq()` will return 3, then 12, then 15. Next, it will return 6, then 12, then 15. Then 9, 12, 15, etc.

To reference the inner sequin as a table, use its literal key. Example:

```lua
my_seq[1][3]
```

will return `9`, regardless of how many times you've called `my_seq()`.

Flow-modifiers can be applied to inner- `sequins` to vary output even more. When calling a sequins object it will *always* return a result, but when a flow-modifier *doesn’t* return a value (eg. `every(2)` only returns a value every second time), the outer-`sequins` will simply request the next value immediately until a value is returned.

Contributed by Trent Gill + Tyler Etters
