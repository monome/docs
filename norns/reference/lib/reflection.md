---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/reflection
---

## reflection

### functions

The following assumes a script has invoked `reflection` via:

```lua
reflection = require 'reflection'
```

| Syntax                                             | Description                                                                                                                                                                                                                                  |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| my_pattern = reflection.new()                      | Assign a variable to record and play back a pattern                                                                                                                                                                                          |
| my_pattern.process = `name_of_function`            | A script-defined function which parses the recorded pattern data                                                                                                                                                                             |
| my_pattern:watch({events})                         | Commits a table of events to the pattern, if recording is enabled                                                                                                                                                                            |
| my_pattern:set_rec(rec_state, duration, beat_sync) | Enable / disable record head. `rec_state` is `1` for recording, `2` for queued recording or `0` for not recording. `duration` (optional) is duration in beats for recording. `beat_sync` (optional) is a beat value to sync recording start. |
| my_pattern:start(beat_sync, offset)                | Start playback. `beat_sync` (optional) is a beat value to sync playback start. `offset` (optional) will be added to the `beat_sync` value.                                                                                                   |
| my_pattern:stop()                                  | Stop playback.                                                                                                                                                                                                                               |
| my_pattern:set_loop(loop)                          | Enable (`1`) / disable (`0`) looping                                                                                                                                                                                                         |
| my_pattern:set_quantization(q)                     | Set quantization of pattern data playback, defaults to `1/48`                                                                                                                                                                                |
| my_pattern:set_length(beats)                       | Set length of pattern                                                                                                                                                                                                                        |
| my_pattern:undo()                                  | Undo previous overdub                                                                                                                                                                                                                        |
| my_pattern:clear()                                 | Clear recorded pattern data                                                                                                                                                                                                                  |
| my_pattern:save(filepath)                          | Save a pattern to disk                                                                                                                                                                                                                       |
| my_pattern:load(filepath)                          | Read a pattern from disk                                                                                                                                                                                                                     |

### variables

| Syntax              | Description                                          |
| ------------------- | ---------------------------------------------------- |
| my_pattern.rec      | Returns the current record state (`1` or `0`)        |
| my_pattern.play     | Returns the current play state (`1` or `0`)          |
| my_pattern.event    | Returns a table of the recorded event data           |
| my_pattern.count    | Returns the total event count                        |
| my_pattern.step     | Returns the current pattern step                     |
| my_pattern.loop     | Returns the current loop state (`1` or `0`)          |
| my_pattern.quantize | Returns the pattern data playback quantization value |

### user script callbacks

| Syntax                          | Description                               |
| ------------------------------- | ----------------------------------------- |
| my_pattern.start_callback       | Executes whenever the pattern starts      |
| my_pattern.step_callback        | Executes with every pattern step          |
| my_pattern.end_of_loop_callback | Executes at the end of every pattern loop |
| my_pattern.end_of_rec_callback  | Executes when recording has finished      |
| my_pattern.end_callback         | Executes when the pattern stops           |

### example

```lua
-- reflection scripting example

_r = require 'reflection' -- import the library
my_pattern = _r.new() -- make a pattern

g = grid.connect() -- connect a grid

function init()
  lit = {} -- lit keys for grid presses
  my_pattern.process = process_press -- the process which the pattern will execute upon playback
  initialize_parameters() -- init params
  grid_redraw() -- redraw the connected grid
end

function my_pattern.start_callback() -- user-script callback
  print('playback started', clock.get_beats())
  playback_queued = false
  grid_redraw()
end

function my_pattern.end_of_rec_callback() -- user-script callback
  print('recording finished', clock.get_beats())
  grid_redraw()
end

function my_pattern.end_of_loop_callback() -- user-script callback
  print('loop ended', clock.get_beats())
  grid_redraw()
end

function my_pattern.end_callback() -- user-script callback
  print('playback ended')
  if my_pattern.loop == 0 then
    overdubbing = false
  end
  lit = {}
  grid_redraw()
end

-- bottom-left grid key: initialize recording / playback
-- above that: loop toggle
-- above that: overdub toggle
function g.key(x,y,z)
  if x == 1 and y == g.rows then
    if z == 1 then
      if my_pattern.rec == 0 and my_pattern.queued_rec == nil and my_pattern.count == 0 then
        my_pattern:set_rec(hold_rec and 2 or 1, record_duration > 0 and record_duration or nil, rec_sync_value)
      elseif my_pattern.count > 0 and my_pattern.play == 0 then
        if play_sync_value ~= nil then
          playback_queued = true
          my_pattern:start(play_sync_value)
        else
          my_pattern:start()
        end
      elseif my_pattern.play == 1 then
        my_pattern:stop()
      else
        my_pattern:set_rec(0)
      end
    end
  elseif x == 1 and y == g.rows - 1 then
    if z == 1 then
      params:set("loop", params:get("loop") == 1 and 2 or 1)
    end
  elseif x == 1 and y == g.rows - 2 then
    if z == 1 then
      if my_pattern.count > 0 and my_pattern.play == 1 then
        overdubbing = not overdubbing
        my_pattern:set_rec(overdubbing and 1 or 0)
      end
    end
  else
    local event = {
      id = x*8 + y,
      x = x,
      y = y,
      z = z
    }
    my_pattern:watch(event)
    process_press(event)
  end
  grid_redraw()
end

function process_press(e)
  if e.z == 1 then
    lit[e.id] = {
      x = e.x,
      y = e.y
    }
  else
    if lit[e.id] ~= nil then
      lit[e.id] = nil
    end
  end
  grid_redraw()
end

function grid_redraw()
  g:all(0)
  if my_pattern.queued_rec ~= nil and my_pattern.queued_rec.state then
    g:led(1,g.rows,7)
  elseif playback_queued then
    g:led(1,g.rows,8)
  elseif my_pattern.rec == 1 then
    g:led(1,g.rows,15)
    g:led(1,g.rows-1,15)
  elseif my_pattern.play == 1 then
    g:led(1,g.rows,10)
  elseif my_pattern.play == 0 and my_pattern.count > 0 then
    g:led(1,g.rows,5)
  else
    g:led(1,g.rows,2)
  end
  g:led(1,g.rows-1, my_pattern.loop == 1 and 10 or 2)
  g:led(1,g.rows-2, overdubbing and 10 or 2)
  for i,e in pairs(lit) do
    g:led(e.x, e.y, 15)
  end
  g:refresh()
end

function initialize_parameters()
  params:add_option(
    "demo",
    "demo",
    {"all synced: loop","unsynced: loop", "unsynced: 1-shot"},
    1
  )
  params:set_action("demo",
    function(x)
      if x == 1 then
        params:set("record_duration", 4)
        params:set("hold_rec", 1)
        params:set("rec_sync_value", 3)
        params:set("play_sync_value", 3)
        params:set("loop", 2)
      elseif x == 2 then
        params:set("record_duration", 0)
        params:set("hold_rec", 2)
        params:set("rec_sync_value", 0)
        params:set("play_sync_value", 0)
        params:set("loop", 2)
      elseif x == 3 then
        params:set("record_duration", 0)
        params:set("hold_rec", 2)
        params:set("rec_sync_value", 0)
        params:set("play_sync_value", 0)
        params:set("loop", 1)
      end
      grid_redraw()
    end
  )
  
  record_duration = 0
  params:add_number(
    "record_duration",
    "record duration",
    0,
    128,
    record_duration,
    function(param) return (
      param:get() == 0 and 'free' or
      param:get()..' beats'
    ) end
  )
  params:set_action("record_duration", function(x) record_duration = x end)
  
  hold_rec = true
  params:add_option(
    "hold_rec",
    "hold rec for first event?",
    {"no","yes"},
    hold_rec and 2 or 1
  )
  params:set_action("hold_rec", function(x) hold_rec = x == 2 end)
  
  rec_sync_value = nil
  params:add_option(
    "rec_sync_value",
    "sync record start",
    {"free","next beat", "next bar"},
    1
  )
  params:set_action("rec_sync_value",
    function(x)
      if x == 1 then
        rec_sync_value = nil
      elseif x == 2 then
        rec_sync_value = 1
      elseif x == 3 then
        rec_sync_value = 4
      end
    end
  )
  
  play_sync_value = nil
  params:add_option(
    "play_sync_value",
    "sync play start",
    {"free","next beat", "next bar"},
    1
  )
  params:set_action("play_sync_value",
    function(x)
      if x == 1 then
        play_sync_value = nil
      elseif x == 2 then
        play_sync_value = 1
      elseif x == 3 then
        play_sync_value = 4
      end
    end
  )
  
  params:add_option(
    "loop",
    "loop playback?",
    {"no", "yes"},
    1
  )
  params:set_action("loop", function(x) my_pattern:set_loop(x-1) grid_redraw() end)
  
  params:add_trigger(
    "erase_rec",
    "erase recording?"
  )
  params:set_action("erase_rec", function(x) my_pattern:clear() lit = {} grid_redraw() end)
  
  params:add_trigger(
    "double_rec",
    "double recording"
  )
  params:set_action("double_rec", function(x) my_pattern:double() end)
  
  overdubbing = false
  playback_queued = false
  
  params:bang()
end
```

### description

Record clock-synced changes to data over time, with variable-rate playback, overdubbing, and pattern management tools.

The basic architecture of the `reflection` library includes:

- a `watch` method, which ingests a table of data and assigns it a beat-timestamp for future playback

- a `process` function, which parses the recorded data into meaningful action within a script

### saving + loading patterns

Included in the library are save + load helpers:

- save: `my_pattern:save(filepath)`
- load: `my_pattern:load(filepath)`

Use `norns.state.data` to access the `data` filepath for the currently-running script.

When a pattern is loaded to an instance of `reflection`, the previous data will stop playing and clear.
