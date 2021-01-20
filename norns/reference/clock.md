---
layout: default
nav_exclude: true
permalink: /norns/reference/clock
---

## clock

### control

| Syntax                         | Description                                                                                      |
| ------------------------------ | ------------------------------------------------------------------------------------------------ |
| my_clock = clock.run(function) | Create a coroutine from the given function, assign it `id` =  "my_clock", and immediately run it |
| clock.cancel(my_clock)         | Cancel an `id`-assigned coroutine                                                                |
| clock.sleep(time)              | Resume in `time` seconds                                                                         |
| clock.sync(beats)              | Resume at next sync quantum of `beats`, per global tempo                                         |

### query

| Syntax               | Description                                                                |
| -------------------- | -------------------------------------------------------------------------- |
| clock.get_beats()    | Returns current time in beats : number                                     |
| clock.get_tempo()    | Returns current global tempo : number                                      |
| clock.get_beat_sec() | Returns length of single beat at current global tempo, in seconds : number |

### example

```lua
-- start a clock which calling function [loop]
function init()
  clock.run(loop)
end
-- this function loops forever, printing at 1 second intervals 
function loop()
  while true do
    print("so true")
    clock.sleep(1)
  end
end
```

### description

Coroutine system which executes functions on beat-synced and free-running schedules. Coroutines can be set to loop (using `while`), execute once, or run conditionally.
