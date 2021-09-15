---
layout: default
nav_exclude: true
permalink: /norns/reference/pattern_time
---

## pattern_time

### functions

| Syntax                                  | Description                                                       |
| --------------------------------------- | ----------------------------------------------------------------- |
| my_pattern = pattern_time.new()         | Assign a variable to record and play back a pattern               |
| my_pattern.process = `name_of_function` | A script-defined function which parses the recorded pattern data  |
| my_pattern:watch({events})              | Commits a table of events to the pattern, if recording is enabled |
| my_pattern:rec_start()                  | Begin recording pattern data                                      |
| my_pattern:rec_stop()                   | Stop recording pattern data                                       |
| my_pattern:start()                      | Start playback of pattern data                                    |
| my_pattern:stop()                       | Stop playback of pattern data                                     |
| my_pattern:set_overdub(`int`)           | Enable (`1`) or disable (`0`) overdubbing                         |
| my_pattern:set_time_factor(`f`)         | Adjust the rate of playback                                       |
| my_pattern:clear()                      | Clear recorded pattern data                                       |

### variables

| Syntax             | Description                                     |
| ------------------ | ----------------------------------------------- |
| my_pattern.rec     | Returns the current record state (`1` or `0`)   |
| my_pattern.play    | Returns the current play state (`1` or `0`)     |
| my_pattern.overdub | Returns the current overdub state (`1` or `0`)  |
| my_pattern.count   | Returns the total event count                   |
| my_pattern.event   | Returns a table of the recorded event data      |
| my_pattern.time    | Returns a table of the recorded event durations |

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
