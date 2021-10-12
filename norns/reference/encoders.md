---
layout: default
nav_exclude: true
permalink: /norns/reference/encoders
---

## encoders

### functions

| Syntax                   | Description                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| norns.enc.accel(n,accel) | Set encoder n's acceleration value, which adds resistance to an encoder's initial turn delta (default 1) |
| norns.enc.sens(n,sens)   | Set encoder n's sensitivity value, which adds uniform resistance to an encoder's turn delta (default 1)  |
| enc(n,d)                 | Pass encoder delta events to a script : function                                                         |

### example

```lua
function init()
  
  level_control = controlspec.def{
    min=0, -- 'min' is the minimum value this control can reach
    max=100, -- 'max' is the maximum value this control can reach
    warp='lin', -- 'warp' shapes the incoming data (options: 'exp', 'db', 'lin')
    step=0.01, -- 'step' is the multiple this control value will be rounded to
    default=66, -- 'default' is the control's initial value (clamped to min / max and rounded to 'step')
    quantum=0.01, -- 'quantum' is the fraction to apply to a received delta (eg. 0.01 will increase/decrease value by 1% of the min/max range)
    wrap=false, -- 'wrap' will wrap increments/decrements around the min / max, rather than stop at min / max
    units='%' -- 'units' is a string to display at the end of the control
  }
  
  -- we'll use our defined level_control spec to create three unique parameters:
  params:add_control('level_1','level 1',level_control)
  params:add_control('level_2','level 2',level_control)
  params:add_control('level_3','level 3',level_control)
  
  -- common redraw metronome utility:
  screen_dirty = false
  redraw_screen = clock.run(
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
  
  key1_down = false -- we'll use key1's state to send either coarse or fine-tune changes
  norns.enc.accel(1,5) -- add resistence to encoder 1's initial turn
  norns.enc.sens(3,10) -- add resistence to encoder 3's turns
  
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(128,10)
  screen.text_right("enc 1: "..params:string('level_1'))
  screen.move(0,60)
  screen.text("enc 2: "..params:string('level_2'))
  screen.move(128,60)
  screen.text_right("enc 3: "..params:string('level_3'))
  screen.update()
end

function key(n,z)
  
  -- short way:
  if n == 1 then
    key1_down = z == 1 and true or false -- fine-tune when holding KEY 1
  end
  
  -- long way:
  -- if n == 1 and z == 1 then
  --   key1_down = true
  -- elseif n == 1 and z == 0 then
  --   key1_down = false
  -- end
    
 end

function enc(n,d)
  
  -- short way:
  params:delta('level_'..n,key1_down and d/10 or d)
  
  -- long way:
  -- if n == 1 then
  --   if key1_down then
  --     params:delta('level_1',d/10)
  --   else
  --     params:delta('level_1',d)
  --   end
  -- elseif n == 2 then
  --   if key1_down then
  --     params:delta('level_2',d/10)
  --   else
  --     params:delta('level_2',d)
  --   end
  -- elseif n == 3 then
  --   if key1_down then
  --     params:delta('level_3',d/10)
  --   else
  --     params:delta('level_3',d)
  --   end
  -- end
  
  screen_dirty = true
  
end
```

### description

Deciphers the norns hardware encoders for script use. Acceleration and sensitivity can be defined per-script, for unique control over interactions.

#### common scripting patterns

- the example script's 'fine-tune when holding KEY 1' mechanism is useful for providing a finer grain for the same encoder
- `params:delta` is useful for changing parameter values without needing to query the current value
- see the [`enc_wait.lua`](https://github.com/northern-information/athenaeum/blob/main/enc_wait.lua) example from `@tyleretters` for advanced cases where you'd like to know when an encoder *starts* or *stops* turning