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
-- !! polls should always be established within a script's 'init'!!

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

Polls report basic data from the audio subsystem, for use within a script. Trigger script events based on incoming amplitude, or capture the pitch and match it with a synth engine. See [study 5](/docs/norns/study-5/#numerical-superstorm) for additional examples.

Here are the pre-built polls, made available by the norns system:

- `amp_in_l`: returns the amplitude of the incoming signal as a percentage of the largest amplitude that can be captured before clipping
- `amp_in_r`
- `amp_out_l`: returns the amplitude of the outgoing signal (output from a loaded engine, *not* softcut, monitor, or the general norns output level) as a percentage of the largest amplitude that can be captured before clipping
- `amp_out_r`
- `cpu_avg`
- `cpu_peak`
- `pitch_in_l`: returns pitch value in Hz
- `pitch_in_r`

### writing your own polls

Writing your own polls is an incredibly useful technique for reporting information from a SuperCollider engine back to the Lua scripting layer.

Polls can be declared in an engine file using `this.addPoll`, eg.

```js
this.addPoll(\outputAmpL, {
	// 'getSynchronous' lets us query a SuperCollider variable from Lua
	var ampL = kernel.amplitude[0].getSynchronous;
	ampL
});
```

The above relies on a bit of coordination, so let's rewrite the `amp_in_l` and `amp_in_r` polls, but with additional control over each channel's gain:

- [`lib/ExamplePoll.sc`](/reference-files/poll/poll-example/lib/ExamplePoll.sc): a Class file which uses SuperCollider's `Amplitude.kr` UGen to track the incoming amplitude of both channels
- [`lib/Engine_ExamplePoll.sc`](/reference-files/poll/poll-example/lib/Engine_ExamplePoll.sc): wraps the `ExamplePoll.sc` Class file into the norns engine template, adding polls for each channel to report their amplitude back to the Lua scripting layer
- [`poll-example.lua`](/reference-files/poll/poll-example/poll-example.lua): initializes our polls and represents the incoming amplitude data as two independent circles on the screen

([download all files as a zip](/reference-files/poll/poll-example.zip) -- be sure to restart norns after!)