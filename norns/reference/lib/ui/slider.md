---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/ui/slider
---

## Slider

### control

| Syntax                                                                                | Description                    |
| ------------------------------------------------------------------------------------- | ------------------------------ |
| UI.Slider.new (x, y, width, height, value, min_value, max_value, markers, direction) | Create a new slider            |
| my_slider:set_value (number)                                                         | Set value : number             |
| my_slider:set_value_delta (delta)                                                    | Set value using delta : number |
| my_slider:set_marker_position (id, position)                                         | Set marker positions : number  |
| my_slider:redraw ()                                                                  | Redraw slider                  |

### query

| Syntax        | Description                               |
| ------------- | ----------------------------------------- |
| my_slider.x         | Returns originating x-coordinate : number |
| my_slider.y         | Returns originating y-coordinate : number |
| my_slider.width     | Returns width : number                    |
| my_slider.height    | Returns height : number                   |
| my_slider.value     | Returns slider's current value : number   |
| my_slider.min_value | Returns slider's minimum value : number   |
| my_slider.max_value | Returns slider's maximum value : number   |
| my_slider.markers   | Returns marker positions : table          |
| my_slider.direction | Returns slider's direction : string       |
| my_slider.active    | Returns slider's active state : boolean   |

### example

```lua
UI = require("ui")

slider = {}

-- create 4 sliders:
slider[1] = UI.Slider.new(5,0,5,60,30,0,127,{0},"down")
slider[2] = UI.Slider.new(30,15,50,5,60,0,127,{},"left")
slider[3] = UI.Slider.new(30,40,50,5,72,0,127,{72},"right")
slider[4] = UI.Slider.new(100,0,5,60,72,0,127,{0,32,64,96,127})
-- set fourth slider to inactive:
slider[4].active = false

function redraw()
  screen.clear()
  -- sliders need to be redrawn to display:
  for i = 1,4 do
    slider[i]:redraw()
  end
  screen.update()
end

function key(n,z)
  -- manipulating slider states + values:
  if n == 3 and z == 1 then
    slider[3].active = not slider[3].active
    slider[4].active = not slider[3].active
  elseif n == 2 then
    slider[1]:set_value(z == 1 and 70 or 30)
    slider[2]:set_value(z == 1 and 30 or 60)
  end
  redraw()
end

function enc(n,d)
  -- adjusting slider + marker values:
  if n == 3 then
    if slider[3].active then
      slider[3]:set_value_delta(d)
      slider[3]:set_marker_position(1,slider[3].value)
    else
      slider[4]:set_value_delta(d)
    end
    redraw()
  end
end
```

### description

Draws a slider on the screen from the specified (x, y) pair. Width and height can extend beyond the screen's bounds. Value is clamped to the slider's min and max values and can be changed by direct assignment or incremental adjustment. Reference markers can be added, in the form of a table of floats or integers. Direction defaults to "up" if it is not specified.
