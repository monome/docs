---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/er
---

## er

A library for generating Euclidean rhythms.

### control

| Syntax          | Description                                                                                                                                                                                                                                       |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| er.gen(k, n, w) | Creates a Euclidean rhythmic sequence.<br>`k` is the number of desired pulses: integer <br>`n` is the total number of steps: integer <br>`w` is the shift amount or rotation: integer <br>**Returns** a table of `true` and `false` values: table |

### example

```lua
ER = require("er")
engine.name = "PolyPerc"

current_step = 1
freq = 220
octave = 1

function init()
  engine.release(0.5)

  -- setting the number of pulses using params
  params:add{type = "number", id = "pulses", name = "number of pulses", 
    min = 1, max = 16, default = 4, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence

  -- setting the number of steps using params
  params:add{type = "number", id = "steps", name = "number of steps", 
    min = 1, max = 16, default = 8, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence

  -- setting the shift amount using params
  params:add{type = "number", id = "shift", name = "shift amount",
    default = 0, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence

  generate_sequence() -- generate the initial sequence

end

function generate_sequence() 
  er_table = ER.gen(params:get("pulses"), params:get("steps"), params:get("shift")) -- storing the returned table in a variable
end

function play_sequence()
  while true do
    clock.sync(1/4)
    if er_table[current_step] then -- play a note only if there is a pulse in that step
      engine.hz(octave *freq)
    end
    current_step = util.wrap(current_step + 1,1,#er_table) -- uses a built-in helper to wrap the step-counter to the length of the sequence
    redraw()
  end
end

function stop_play() -- stops the coroutine playing the sequence
  clock.cancel(play)
  playing = false
end

function key(n,z)
  if n == 2 and z == 1 then
    if not playing then
      play = clock.run(play_sequence) -- starts the clock coroutine which plays the euclidean sequence
      playing = true
    elseif playing then
      stop_play()
    end
  elseif n == 3 then
    if z == 1 then
      -- a bit of a fun performative gesture
      octave = math.random(1,4)
      engine.release(2)
    elseif z == 0 then
      octave = 1
      engine.release(0.5)
    end
  end
  redraw()
end

function enc(n,d)
    -- use encoders to change the variables for the euclidean rhythm
  if n == 1 then
    params:delta("pulses", d)
  elseif n == 2 then
    params:delta("steps", d)
  elseif n == 3 then
    params:delta("shift", d)
  end
  redraw()
end

function redraw()
  screen.clear()
  for n = 1,#er_table do -- draws a number of squares equal to the number of steps
    screen.rect(8*(n-1)+1,10,5,5)
    local l = 1
    if n == current_step then l = 15
    elseif er_table[n] then l = 8 -- highlights where there is a pulse
    end
    screen.level(l)
    screen.stroke()
  end
  screen.move(60,50)
  screen.level(15)
  if not playing then
    screen.text_center("press k2 to play")
  elseif playing then
    screen.text_center("press k2 to stop")
  end
  screen.update()
end
```

### description

A library for creating Euclidean rhythms. To generate Euclidean rhythms, three pieces of information are needed: (a) the number of pulses in the sequence; (b) the number of steps in the sequence; and (c) the shift amount, also known as the rotation amount or offset. These are the variables `k`, `n`, and `w` needed for `er.gen`. 

`er.gen` returns a table of `true` and `false` values -- the number of `true` entries is equal to `k`, and the total number of entries in the table equal to `n`. For example, with a pulse number of `2`, steps of `4`, and shift amount of `0` (ie, `er.gen(2,4,0)`), `er.gen` returns: `{true, false, true, false}`. The distribution of `true` and `false` gives a Euclidean rhythm.

The table returned by `er.gen` needs to be stored in a variable -- in the example above, we use `er_table`. Since this is a static variable, every change to a rhythm's `k`, `n`, or `w` values requires re-generation in order to affect the table -- this is why we call `generate_sequence()` after any change in the example.
