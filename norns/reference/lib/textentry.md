---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/textentry
---

## textentry

### functions

| Syntax                                             | Description                                                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| textentry.enter(callback, default, heading, check) | Invokes `textentry` with the stated arguments. `callback` requires a function which receives the result of `textentry`. `default` is an optional default text presented to the user. `heading` is an optional header in the UI. `check` is an optional function which can check the entered text and display a warning or success : function |

### example

```lua
textentry = require('textentry')

my_string_1 = "replace me by pressing K3"
my_string_2 = "replace me in params"

function init()
  params:add_trigger('change_string_2', 'change string 2 here')
  params:set_action('change_string_2', function() textentry.enter(callback_2,my_string_2) end)
end

function callback_1(txt)
  if txt ~= nil and check(txt) ~= "too long" then
    my_string_1 = txt
  end
  redraw()
end

function callback_2(txt)
  if txt ~= nil then
    my_string_2 = txt
  end
  redraw()
end

function check(txt)
  if string.len(txt) > 10 then
    return "too long"
  else
    return ("remaining: "..10 - string.len(txt))
  end
end

function redraw()
  screen.clear()
  screen.move(0,30)
  screen.text(my_string_1)
  screen.move(0,40)
  screen.text(my_string_2)
  screen.update()
end

function key(n,z)
  if n == 3 and z == 1 then
    local default_text = my_string_1 ~= "replace me by pressing K3" and my_string_1 or ""
    textentry.enter(callback_1,default_text,"enter 10 chars or less", check)
  end
end
```

### description

`textentry` provides a handy utility for text input, either in your on-screen UI (`my_string_1` in the example) and within the parameters system (`my_string_2`). It's a helpful way to integrate text input into your script's interactions and has the advantage of familiarity since it's used in system-level screens like `TAPE` and `WIFI`.

Note that `textentry` provides its own handlers for screen redraw, encoders, and keys. `textentry` automatically redraws the screen when its `.enter` function is invoked. K3 becomes ENTER, K2 becomes EXIT. E3 switches between rows and E2 scrolls within each row.

`textentry` returns a string according to the input, which is then fed into the script-defined callback function. If the user exits the `textentry` ui without pressing `OK` then `textentry` returns `nil`, so it's a good practice to weed out the `nil` in your callback function.
