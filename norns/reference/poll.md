---
layout: default
nav_exclude: true
permalink: /norns/reference/poll
---

## poll

### functions

| Syntax                           | Description                                                                                                                                                         |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| poll.list_names()                | Returns a list of available polls. System default polls include `amp_in_l`, `amp_in_r`, `amp_out_l`, `amp_out_r`, `cpu_avg`,` cpu_peak`,` pitch_in_l`, `pitch_in_r` |
| my_poll = poll.set(name)         | Assign a poll to a variable by named string                                                                                                                         |
| my_poll.callback = function(val) | User script callback which passes the poll value to perform additional actions                                                                                      |
| my_poll.time                     | Set the refresh rate of the poll (number)                                                                                                                           |
| my_poll:start()                  | Start the poll                                                                                                                                                      |
| my_poll:stop()                   | Stop the poll                                                                                                                                                       |
| my_poll:update()                 | Request a single immediate value from the poll                                                                                                                      |
| poll.clear_all()                 | Stops all polls and clears their callback definitions                                                                                                               |

### example

```lua
function init()

  last_pitch = 0
  last_amp = 0

  pitch_tracker = poll.set("pitch_in_l") -- create a poll to detect pitch of the left input
  pitch_tracker.callback = function(x)
    if x > 0 then -- poll returns `-1` without a signal present
      last_pitch = x
      screen_dirty = true
    end
  end

  amplitude_tracker = poll.set("amp_in_l") -- create a poll to detect amplitude of the left input
  amplitude_tracker.callback = function(x)
    if x > last_amp then
      last_amp = x
    elseif util.round(x,0.0001) == 0 then
      last_amp = 0
    end
    screen_dirty = true
  end
  amplitude_tracker:start() -- automatically poll amplitude

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

function key(n,z)
  if n == 2 and z == 1 then
    pitch_tracker:update() -- manually poll pitch
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,20)
  screen.text("press K2 to sample pitch")
  screen.move(0,30)
  screen.text("incoming pitch: "..string.format("%.2f",last_pitch).." Hz")
  screen.move(0,50)
  screen.text("incoming amplitude: "..string.format("%.2f",last_amp*100).."%")
  screen.update()
end
```

### description

`poll`s report basic data from the audio subsystem, for use within a script. Trigger script events based on incoming amplitude, or capture the pitch and match it with a synth engine. See [study 5](/docs/norns/study-5/#numerical-superstorm) for additional examples.

Available polls:

- `amp_in_l` -- returns the amplitude of the incoming signal as a percentage of the largest amplitude that can be captured before clipping

- `amp_in_r`

- `amp_out_l` -- returns the amplitude of the outgoing signal as a percentage of the largest amplitude that can be captured before clipping

- `amp_out_r`

- `cpu_avg`

- `cpu_peak`

- `pitch_in_l` -- returns pitch value in Hz

- `pitch_in_r`
