---
layout: default
nav_exclude: true
permalink: /norns/reference/metro
---

## metro

### instance control

| Syntax                                    | Description                                                                                                                                                                                                                      |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| my_metro = metro.init(event, time, count) | Initialize a metro to execute an `event`, after a specified `time` (in seconds), for the total of `count` (use -1 for infinite). Auto-assigns the metro's ID to the next unused value, 1 through 30. All arguments are optional. |
| my_metro:start(time, count, init_stage)   | Start executing the metro's `event`, using either the pre-defined `time`, `count` , and the default `init_stage` (1) *or* the arguments passed with its invocation (note the `:`)                                                |
| my_metro:stop()                           | Stop executing the metro (note the `:`)                                                                                                                                                                                          |

### module control

| Syntax           | Description                                                                                                                                                                |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| metro.free(id)   | Module-level function to stop executing a specific metro, making its ID available for re-assignment                                                                        |
| metro.free_all() | Module-level function to stop executing all script-level metros, making them all available for re-assignment                                                               |
| metro.new(id)    | Module-level function to create a metro with the specified `id`, utilizing default values for all other values (`time` = 1, `count` = -1, `event` = nil, `init_stage` = 1) |

### instance query

| Syntax              | Description                                                                |
| ------------------- | -------------------------------------------------------------------------- |
| my_metro.id         | Returns the specified metro's ID : number                                  |
| my_metro.init_stage | Returns the specified metro's initial stage index : number                 |
| my_metro.count      | Returns the specified metro's number of ticks to execute : number          |
| my_metro.time       | Returns the specified metro's time period between ticks (seconds) : number |

### module query

| Syntax          | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| metro.available | Returns whether an ID is available for script metro assignment : table |
| metro.assigned  | Returns whether an ID is assigned by the script : table                |

### example: countdown timer

The `metro` module is designed to count accurate time, so let's use it as a countdown timer:

```lua
-- countdown timer

engine.name = "PolyPerc"

function init()
  countdown_timer = metro.init()
  -- let's break up the metro invocation
  --   into explicit declarations:
  countdown_timer.event = countdown -- call the 'countdown' function below,
  countdown_timer.time = 1 -- every second,
  countdown_timer.count = 10 -- 10 times

  -- we'll use 'current' to keep track of the elapsed time:
  current = countdown_timer.count

  -- start our countdown timer:
  countdown_timer:start()
  -- ping the countdown sound:
  engine.hz(330)
end

function countdown(stage)
  -- if we haven't hit the count, then...
  if stage ~= countdown_timer.count then
    -- current = total count - stage
    current = countdown_timer.count - stage
    engine.hz(330)
  else -- if we *have* hit the total count...
    current = "done"
    -- play a little ring:
    clock.run(
      function()
        for i = 2,4 do
          engine.hz(330*i)
          clock.sleep(0.1)
        end
      end
    )
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.move(64,42)
  screen.font_size(35)
  screen.text_center(current)
  screen.update()
end
```

### description

The `metro` module provides a script with **30** high-resolution counters, useful for event execution on a high-resolution tick, for either a fixed number of ticks or to run without end.

`meteo` provides high-resolution counting, accurately representing time over many cycles with little to no jitter. This makes it the perfect time-tracking mechanism for modules like [`pattern_time`](/docs/norns/reference/lib/pattern_time), where events are expected to record and play back exactly as entered.

So when should a script use the [`clock` module](/docs/norns/reference/clock) and when should it use a `metro`? 

Typically, `clock` is used for working within musical time, where the overall sense of accuracy is defined by the cohesion of multiple devices rather than by any one device's independent adherence to a strict tick -- since musical time benefits from all devices fluidly accommodating for their individual timing jitters through MIDI, Link, or crow (see the [control + clock](/docs/norns/control-clock/) section of the main norns docs for more detail), then consider `clock` the flexible, syncable timing module for syncing events to musical beats.

Though `clock` *does* have a time-based mode with `clock.sleep(seconds)`, that is best used for short-term scheduling (like in our example above), where the prolonged repeated execution of an event on a regular time interval is not necessary (or is fine to slightly drift over time). Again, `clock` is absolutely timing-reliable for syncing to *beats* -- eg. `clock.sync(1)` will *always* sync an event's execution to the next beat-tick. `metro` should be used for situations where events needs to be executed at high-resolution regardless of musical time -- eg. screen / grid redraws, or scripting your own free-running LFOs.
