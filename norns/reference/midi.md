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
| midi.remove()                       | User script callback when any midi device is removed                                                                     |
| midi.to_msg                         | Convert MIDI data (bytes) to specific messages, eg. channel, velocity, note, type                                        |
| midi.to_data                        | Convert MIDI messages to data (bytes)                                                                                    |

### query

| Syntax          | Description                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| midi.devices    | Returns any presently-connected MIDI devices : table                                            |
| midi.devices[x] | Returns information about this presently-connected MIDI device (`.name`, `.dev`, `.id`) : table |
| midi.vports     | Returns all remembered MIDI devices : table                                                     |
| midi.vports[x]  | Returns information about this remembered MIDI device (`.name` and control functions) : table   |

### example

```lua
function init()
  midi_device = {} -- container for connected midi devices
  devices_with_names = {}
  target = 1
  key3_hold = false
  random_note = math.random(48,72)

  for i = 1,#midi.vports do -- query all ports
    midi_device[i] = midi.connect(i) -- connect each device
  end

end

function enc(n,d)
  if n == 2 then
    if #midi_device > 0 then
      target = util.clamp(target+d,1,#midi_device)
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
  screen.text("midi port "..target..": "..midi_device[target].name)
  screen.move(0,30)
  if not key3_hold then
    screen.text("press K3 to send note "..random_note)
  else
    screen.text("release K3 to kill note "..random_note)
  end
  screen.update()
end
```

### description

Connect a script to MIDI hardware. Provides MIDI message and event communication between norns and external MIDI boxes, dongles, and hubs. When a MIDI device is connected to norns, its identity is stored in two tables: `.vports` and `.devices`

The `.vports` table reflects the MIDI devices norns has stored under SYSTEM > DEVICES > MIDI. It can therefore reflect devices not currently connected.

The `.devices` table reflects presently-connected MIDI devices. The general order is reflected under SYSTEM > DEVICES > MIDI > port -- `my_midi.devices[1].name` will always return `virtual`, as its the first MIDI connection established by norns on boot. Subsequent device connections will consume sequential indices. However, if you remove and connect a device many times, each re-connect will increment the index. So, it is possible for a device to show up as the third item selectable under SYSTEM > DEVICES > MIDI > port, but it might occupy the fifth `.device` index.
