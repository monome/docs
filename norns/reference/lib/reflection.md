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
pattern_time = require 'pattern_time' -- use the pattern_time lib in this script

function init()
  enc_pattern = pattern_time.new() -- establish a pattern recorder
  enc_pattern.process = parse_enc_pattern -- assign the function to be executed when the pattern plays back

  enc_value = 0
  pattern_message = "press K3 to start recording"
  erase_message = "(no pattern recorded)"
  overdub_message = ""


  screen_dirty = true
  screen_timer = clock.run(
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

function record_enc_value()
  enc_pattern:watch(
    {
      ["value"] = enc_value
    }
  )
end

function parse_enc_pattern(data)
  enc_value = data.value
  screen_dirty = true
end

function key(n,z)
  if n == 3 and z == 1 then
    if enc_pattern.rec == 1 then -- if we're recording...
      enc_pattern:rec_stop() -- stop recording
      enc_pattern:start() -- start playing
      pattern_message = "playing, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = "hold K1 to overdub"
    elseif enc_pattern.count == 0 then -- otherwise, if there are no events recorded..
      enc_pattern:rec_start() -- start recording
      record_enc_value()
      pattern_message = "recording, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = ""
    elseif enc_pattern.play == 1 then -- if we're playing...
      enc_pattern:stop() -- stop playing
      pattern_message = "stopped, press K3 to play"
      erase_message = "press K2 to erase"
      overdub_message = ""
    else -- if by this point, we're not playing...
      enc_pattern:start() -- start playing
      pattern_message = "playing, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = "hold K1 to overdub"
    end
  elseif n == 2 and z == 1 then
    enc_pattern:rec_stop() -- stops recording
    enc_pattern:stop() -- stops playback
    enc_pattern:clear() -- clears the pattern
    erase_message = "(no pattern recorded)"
    pattern_message = "press K3 to start recording"
    overdub_message = ""
  elseif n == 1 then
    enc_pattern:set_overdub(z) -- toggles overdub
    overdub_message = z == 1 and "overdubbing" or "hold K1 to overdub"
  end
  screen_dirty = true
end

function enc(n,d)
  if n == 3 then
    enc_value = enc_value + d
    record_enc_value()
    screen_dirty = true
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,10)
  screen.text("encoder 3 value: "..enc_value)
  screen.move(0,40)
  screen.text(pattern_message)
  screen.move(0,50)
  screen.text(erase_message)
  screen.move(0,60)
  screen.text(overdub_message)
  screen.update()
end
```

### description

Record changes to data over time, with variable-rate playback and overdubbing.

The basic architecture of the `pattern_time` library includes:

- a `watch` method, which ingests a table of data and assigns it a relative timestamp for future playback

- a `process` function, which parses the recorded data into meaningful action within a script

As outlined in the example's `key` handling, `pattern_time` works similarly to an audio recorder, where certain functions and variables need to be coupled in the script for standard use-cases:

- combine `rec_stop()` and `start()` to loop data after recording

- use `.count == 0` to determine if a pattern is empty

- use `.play == 1` to determine is a pattern is currently playing

#### extended: saving + loading patterns

The most meaningful persistent data generated by `pattern_time` lives is in:

- `my_pattern.event`

- `my_pattern.time`

- `my_pattern.count`

- `my_pattern.time_factor`

Currently, saving and loading these pattern tables is up to the script to employ its own approach. Here's a starting point, using our previous example:

```lua
function save_pattern(filepath)
  local pattern_data = {} -- create a temp container
  pattern_data.event = enc_pattern.event
  pattern_data.time = enc_pattern.time
  pattern_data.count = enc_pattern.count
  pattern_data.time_factor = enc_pattern.time_factor
  tab.save(pattern_data,filepath) -- permanently save to disk
end

function load_pattern(filepath)
  enc_pattern:rec_stop() -- stops recording
  enc_pattern:stop() -- stops playback
  enc_pattern:clear() -- clears pattern
  local pattern_data = tab.load(filepath)
  for k,v in pairs(pattern_data) do
    enc_pattern[k] = v
  end
  pattern_message = "stopped, press K3 to play"
  erase_message = "press K2 to erase"
  overdub_message = ""
  screen_dirty = true
end
```
