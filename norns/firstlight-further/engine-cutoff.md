---
layout: default
nav_exclude: true
permalink: /norns/firstlight-further/engine-cutoff
---

## planning

Prompt: *randomize `x` for `engine.cutoff(x)` on each wind chime*

Questions to consider:

- how do we generate meaningful random values to pass to `engine.cutoff()`?
- where in the code does the wind chime happen?

## making random values

In [play a random pitch](/docs/norns/study-0/#play-a-random-pitch), we modified our code to generate a random value between 100 and 600, which we passed as an argument to the `engine.hz()` function by embedding our random number generator *inside* of the command, where we'd usually have a static number:

```lua
-- static version:
engine.hz(542)
-- random version:
engine.hz(math.random(100,600)) -- math.random returns a number between 100 and 600 to engine.hz
```

*Remember: `math.random()` can accept either no arguments, one argument, or two arguments. See [the Lua docs](http://lua-users.org/wiki/MathLibraryTutorial) for more detail.*

`cutoff` is entirely different command, though -- in `PolyPerc`, `cutoff` represents the low-pass filter's cutoff value in Hz, which means spectral content above the cutoff value is dampened / reduced.

To find the right range for your `cutoff` values, make sure the wind-chimes are on (K3) and live-execute some values in the matron REPL:

```lua
>> engine.cutoff(5392)
>> engine.cutoff(170)
...etc etc
```

**During your exploration, take note of the minimum and maximum values you'd like to generate random values between. These will serve as our min and max for `math.random(min,max)`.**

## making chimes

In [make it so](/docs/norns/study-0/#make-it-so), we modified the `notes` table to change which notes our chime played. If we take a look at the lines above and below the `notes` table, we'll discover that we're modifying code inside of a `wind` function.

```lua
-- wind blows chimes play
-- this function plays all of the notes in a table, in a random order and
-- with random delay in between each. a new pattern is played periodically.
wind = function()
  while(true) do
    light = 15
    --[[ 0_0 ]]--
    notes = {400,451,525,555}
    while chimes and #notes > 0 do
      if math.random() > 0.2 then
        engine.hz(table.remove(notes,math.random(#notes)))
      end
      clock.sleep(0.1)
    end
    clock.sleep(math.random(3,9))
  end
end
```

This is where the chime-playing happens!

## putting it together

For this exercise, it might make the most sense to stack our `engine` commands in one place, so all we need to do is embed our random value generator as an argument for `engine.cutoff` and drop it in near our `engine.hz` command.

```lua
-- wind blows chimes play
-- this function plays all of the notes in a table, in a random order and
-- with random delay in between each. a new pattern is played periodically.
wind = function()
  while(true) do
    light = 15
    --[[ 0_0 ]]--
    notes = {400,451,525,555}
    while chimes and #notes > 0 do
      if math.random() > 0.2 then
        engine.cutoff(math.random(100,8000)) -- here it is!!
        engine.hz(table.remove(notes,math.random(#notes)))
      end
      clock.sleep(0.1)
    end
    clock.sleep(math.random(3,9))
  end
end
```