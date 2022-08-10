---
layout: default
nav_exclude: true
permalink: /norns/reference/midi
---

## midi

### control

| Syntax                              | Description                                                                                                              |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| my_midi = midi.connect(n)           | Assign the connected MIDI device at this port to a script, defaults to port 1 unless `n` is specified                    |
| my_midi.event = function(data)      | User script callback when this connected device receives MIDI message data                                               |
| my_midi:send(data)                  | Send MIDI data to this connected device, eg. `{144,60,127}` = note on event for note 60 with velocity 127                |
| my_midi:note_on(note, vel, ch)      | Send note on event to this connected device, unspecified velocity defaults to 100 and unspecified channel defaults to 1  |
| my_midi:note_off(note, vel, ch)     | Send note off event to this connected device, unspecified velocity defaults to 100 and unspecified channel defaults to 1 |
| my_midi:cc(cc, val, ch)             | Send cc event to this connected device, unspecified channel defaults to 1                                                |
| my_midi:pitchbend(val, ch)          | Send pitchbend message to this connected device, unspecified channel defaults to 1                                       |
| my_midi:key_pressure(note, val, ch) | Send key pressure event to this connected device, unspecified channel defaults to 1                                      |
| my_midi:channel_pressure(val, ch)   | Send channel pressure event to this connected device, unspecified channel defaults to 1                                  |
| my_midi:program_change(val, ch)     | Send program change event to this connected device, unspecified channel defaults to 1                                    |
| my_midi:start()                     | Send start event to this connected device                                                                                |
| my_midi:stop()                      | Send stop event to this connected device                                                                                 |
| my_midi:continue()                  | Send continue event to this connected device                                                                             |
| my_midi:clock()                     | Send clock event to this connected device (*nb. norns global clock can transmit MIDI clock without scripting*)           |
| my_midi:song_position(lsb, msb)     | Send song position event to this connected device                                                                        |
| my_midi:song_select(val)            | Send song select event to this connected device                                                                          |
| midi.remove(id)                     | User script callback when any midi device is removed, passes ID of the removed device                                    |
| midi.to_msg                         | Convert MIDI data (bytes) to specific messages, eg. channel, velocity, note, type                                        |
| midi.to_data                        | Convert MIDI messages to data (bytes)                                                                                    |

### query

| Syntax          | Description                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| midi.devices    | Returns any presently-connected MIDI devices : table                                            |
| midi.devices[x] | Returns information about this presently-connected MIDI device (`.name`, `.dev`, `.id`) : table |
| midi.vports     | Returns all remembered MIDI devices : table                                                     |
| midi.vports[x]  | Returns information about this remembered MIDI device (`.name` and control functions) : table   |

### example: targeting a selectable device

```lua
function init()
  midi_device = {} -- container for connected midi devices
  midi_device_names = {}
  target = 1
  key3_hold = false
  random_note = math.random(48,72)

  for i = 1,#midi.vports do -- query all ports
    midi_device[i] = midi.connect(i) -- connect each device
    table.insert( -- register its name:
      midi_device_names, -- table to insert to
      "port "..i..": "..util.trim_string_to_width(midi_device[i].name,80) -- value to insert
    )
  end

  params:add_option("midi target", "midi target",midi_device_names,1)
  params:set_action("midi target", function(x) target = x end)
end

function enc(n,d)
  if n == 2 then
    if #midi_device > 0 then
      params:delta("midi target",d)
      redraw()
    end
  end
end

function key(n,z)
  if n == 3 then
    if z == 1 then
      midi_device[target]:note_on(random_note) -- defaults to velocity 100 on ch 1
      key3_hold = true
      redraw()
    elseif z == 0 then
      midi_device[target]:note_off(random_note)
      random_note = math.random(50,70)
      key3_hold = false
      redraw()
    end
  end
end

function redraw()
  screen.clear()
  screen.move(0,10)
  screen.text(params:string("midi target"))
  screen.move(0,30)
  if not key3_hold then
    screen.text("press K3 to send note "..random_note)
  else
    screen.text("release K3 to end note "..random_note)
  end
  screen.update()
end
```

### example: targeting multiple devices

```lua
s = require 'sequins'
MU = require 'musicutil'

engine.name = 'PolySub' -- just to auralize sequences

function init()
  -- set some engine params:
  engine.ampRel(0.1)
  engine.ampAtk(0.005)
  engine.hzLag(0)

  target_device_count = 3 -- target 3 connected devices, feel free to change!

  scale = "Major Pentatonic" -- for scale generation

  midi_device = {} -- container for connected midi devices
  midi_device_names = {} -- container for their names

  -- container for individual sequence parameters
  sequence = {
    target = {}, -- which MIDI port to target
    notes = {}, -- the note pool for the sequence
    sync_val = {}, -- the clock sync value
    clock = {}, -- the iterating clock
    selected = 1
  }

  for i = 1,target_device_count do
    sequence.target[i] = i -- target device slot (i)
    -- MU.generate_scale(base_note, scale_name, octaves)
    local this_scale = MU.generate_scale(50 - (math.random(-2,1) * 12), scale, 2)
    sequence.notes[i] = s.new(this_scale) -- build a sequins of generated notes
    sequence.sync_val[i] = 3/math.random(11) -- randomly assign tick value per sequence
  end

  refresh_midi_devices()

  params:add_separator("multiple midi device example")

  for i = 1,target_device_count do -- for each MIDI target...
    params:add_group("output "..i,4)

    -- create a parameter to change its target:
    params:add_option("target "..i, "device", midi_device_names, i)
    params:set_action("target "..i, function(x) sequence.target[i] = x end)
    -- and channel and velocity value
    params:add_number("channel "..i, "channel", 1, 16, 1)
    params:add_number("velocity "..i, "velocity", 0, 127, 63)

    -- sequins step size allows skipping within sequence
    params:add_number("sequins step size "..i, "sequins step size", -10, 10, 1)
    params:set_action("sequins step size "..i, function(x) sequence.notes[i]:step(x) end)
  end

  -- sequences start off
  transport_state = "off"

  -- common redraw mechanism
  redraw_timer = metro.init(draw_screen,1/15,-1)
  screen_dirty = true
  redraw_timer:start()

end

function start_sequences()
  if transport_state == "off" then
    transport_state = "on"
    for i = 1,#sequence.target do
      -- for each sequence, create a clock:
      sequence.clock[i] = clock.run(iterate_sequence, i)
    end
  end
end

function stop_sequences()
  if transport_state == "on" then
    transport_state = "off"
    for i = 1,#sequence.target do
      -- for each sequence, cancel its clock:
      clock.cancel(sequence.clock[i])
      -- reset the sequins index:
      sequence.notes[i].ix = 1
      -- stop the engine:
      engine.stop(i)
    end
  end
end

function iterate_sequence(i)
  while true do
    clock.sync(sequence.sync_val[i])
    local played_note = sequence.notes[i]()
    local velocity = params:get("velocity "..i)
    local channel = params:get("channel "..i)

    midi_device[i]:note_on(played_note, velocity, channel)
    engine.start(i,MU.note_num_to_freq(played_note))

    clock.sleep(0.1) -- after 100 ms, perform note off:
    midi_device[i]:note_off(played_note, 0, channel)
    engine.stop(i)

    screen_dirty = true
  end
end

function refresh_midi_devices()
  for i = 1,#midi.vports do -- query all ports
    midi_device[i] = midi.connect(i) -- connect each device
    table.insert( -- register its name:
      midi_device_names, -- table to insert to
      "port "..i..": "..util.trim_string_to_width(midi_device[i].name,40) -- value to insert
    )
  end
end

function enc(n,d)
  if n == 2 then
    -- change selected sequence
    sequence.selected = util.clamp(sequence.selected+d, 1, target_device_count)
  elseif n == 3 then
    -- change selected sequence's step size
    params:delta("sequins step size "..sequence.selected, d)
  end
  screen_dirty = true
end

function key(n,z)
  if n == 3 and z == 1 then
    -- toggle sequence on/off
    if transport_state == "off" then
      start_sequences()
    else
      stop_sequences()
    end
    screen_dirty = true
  end
end

function draw_screen()
  if screen_dirty then
    redraw()
    screen_dirty = false
  end
end

function redraw()
  screen.clear()
  for i = 1,target_device_count do
    screen.level(sequence.selected == i and 15 or 5)
    screen.move(0,10*i)
    screen.text("sequence "..i..": "..sequence.notes[i].data[sequence.notes[i].ix])
    screen.move(128,10*i)
    screen.text_right("step size: "..params:get("sequins step size "..i))
  end
  screen.move(128,58)
  screen.level(15)
  screen.text_right("K3: turn all "..(transport_state == "on" and "off" or "on"))
  screen.update()
end
```

### description

Connect a script to MIDI hardware. Provides MIDI message and event communication between norns and external MIDI boxes, dongles, and hubs. When a MIDI device is connected to norns, its identity is stored in two tables: `.vports` and `.devices`

The `.vports` table reflects the MIDI devices norns has stored under SYSTEM > DEVICES > MIDI. It can therefore reflect devices not currently connected.

The `.devices` table reflects presently-connected MIDI devices. The general order is reflected under SYSTEM > DEVICES > MIDI > port -- `my_midi.devices[1].name` will always return `virtual`, as its the first MIDI connection established by norns on boot. Subsequent device connections will consume sequential indices. However, if you remove and connect a device many times, each re-connect will increment the index. So, it is possible for a device to show up as the third item selectable under SYSTEM > DEVICES > MIDI > port, but it might occupy the fifth `.device` index.
