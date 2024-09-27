---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/timeline
title: timeline
---

## timeline

A library designed to sequence events in time.

If you find yourself writing out the same clock routines to get a basic rhythm going, there is a better way! timeline is built on top of clock, so all the usual details for controlling tempo and clock source apply here as well.

Originally designed by `@trentgill` for use with [crow](/docs/crow/reference/#sequins), the norns version of `timeline` uses the exact same syntax and provides the same features.

This document will provide an introduction to the basics of `timeline`. To learn more advanced techniques, including *pre-methods* and *post-methods*, see [the `timeline` extended reference](/docs/crow/timeline).

### Flavors

The library has 3 flavors, each with its own purpose, though they can be combined in interesting ways too.

- `loop` is for (short) *clock-synchronized* loops in terms of *beat durations*.
- `score` creates longer form sequences of events for *song structure*.
- `real` is free from the clock, calling events over time, and is best for effects and *real-world time*.

All the events are, by default, automatically launched quantized to the clock.

| Syntax                                                  | Description                                                                                            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| my_beat = timeline.loop{duration, event, ...}           | Create and automatically launch (at the next beat) a looping sequence of events using beat durations   |
| my_song = timeline.score{beats_timestamp, event, ...}   | Create and automatically launch (at the next beat) a sequence of events using beat timestamps          |
| my_stream = timeline.real{second_timestamp, event, ...} | Create and automatically launch (at the next beat) a sequence of events using seconds-based timestamps |

### Change Launch Quantization

If you want to change the default quantization for all timelines you can set the `launch_default` variable in timeline:

```lua
timeline.launch_default = 4 -- switch to every 4th beat, eg. 1 bar in 4/4 time
```

But sometimes you may want a specific timeline to use a custom quantization setting. Perhaps you want your `score` to be quantized to 16, but you want your `real` to start immediately with no delay. For these cases, you can use the `launch` *pre-method*:

```lua
-- force the score to wait until the next multiple of 16 beats:
my_song = timeline.launch(16):score{...}
-- no quantization! begins the first element of 'real' immediately:
my_stream = timeline.launch(0):real{...}
```

See the [`timeline` crow docs](/docs/crow/timeline/#launch-quantization) for more examples.

### Queuing

To queue a `timeline`, rather than launching at creation, we can use *pre-* and *post-methods*:

| Syntax                                                 | Description                                                                                             |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| my_song = timeline.queue():score{timestamp,event, ...} | Queue up a `loop`, `score` or `real` sequence (swap `score` in the syntax example for any other flavor) |
| my_song:play()                                         | Play a queued sequence                                                                                  |
| my_song:stop()                                         | Stop a playing sequence                                                                                 |

### Resetting `score` and `real`

If you have a `score` or `real` that you would like to repeat endlessly, add the string `"reset"` to the event table. This will immediately jump to the beginning of the timeline and start again.

```lua
my_song = timeline.score{
    0, intro
  , 32, verse
  , 64, 'reset' -- will jump to beat 0, aka intro (single or double quotes ok)
  }
```

See [the crow docs](/docs/crow/timeline/#reset-keyword) for more examples.

### `loop` Post-Methods

**Note: as of now, only `loop` functions can have post-methods applied.**

Post-methods determine how a `loop` runs, or when it will stop.

By default, `loop` will repeat the time-event table endlessly. You can stop the timeline at any moment with the `:stop()` method, but you can also make the looping programmatic with the following post-methods:

| Syntax                                                          | Description                                                                    |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| my_loop = timeline.loop{duration, event, ...}:unless(predicate) | A `loop` with an `unless` *post-method* will run until the predicate is `true` |
| my_loop = timeline.loop{duration, event, ...}:times(count)      | A `loop` with a `times` *post-method* will run until the count has been met    |

See [the crow docs](/docs/crow/timeline/#loop-post-methods) for more examples.

## Example:  Thirty Second Song

In this example, we'll showcase the following `timeline` syntax:

- `simple`: a `loop` which switches between two notes every beat

- `one`: a `queue`'d `score`,  which adds note flourishes on beat-centric timestamps
  
  - we also use our `'reset'` keyword to loop the `score`

- `two`: a `queue`'d `loop`, which adds note flourishes on divisions of the clock

- `cutoffs`: a `queue`'d `loop`, which increases our engine's cutoff value every quarter-of-a-beat, until it performs this task 100 `times`

- `flourishes`:  a `real` `timeline` which schedules changes to our song with seconds-centric timestamps

```lua
tl = require 'timeline'
s = require 'sequins'
mu = require 'musicutil'

engine.name = 'PolyPerc'

function init()
  root = 48
  cutoff = 900
  engine.cutoff(cutoff)

  -- alternate between two notes:
  simple = tl.loop{
    1, {send_note, root},
    1, {send_note, root+11}
  }

  -- let's queue up some flourishes:
  one = tl.queue():score{
    0, {send_note, root+7},
    5, {send_note, root+19},
    8, 'reset'
  }
  two = tl.queue():loop{
    1.5, {send_note, root+9},
    0.75, {send_note, root+14},
  }
  cutoffs = tl.queue():loop{
    0.25, function() cutoff = cutoff+20 engine.cutoff(cutoff) end
  }:times(100)

  -- and schedule them with 'real' timing:
  flourishes = tl.real{
    0, {print, 'song starting'},
    4, function() one:play() cutoffs:play() end,
    9, function() one:stop() two:play() engine.release(2) end,
    30, function() one:stop() two:stop() simple:stop() print('song ended') end
  }

end

function send_note(note)
  engine.hz(mu.note_num_to_freq(note))
end
```
