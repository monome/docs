---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/ui/message
---

## Message

### control

| Syntax                                  | Description                                            |
| --------------------------------------- | ------------------------------------------------------ |
| UI.Message.new (text_array)      | Create a new instance of message using the `text_array` which is a table of strings                               |
| my_message:redraw()             | Displays the `text_array` with one line per string |

### query

| Syntax        | Description                               |
| ------------- | ----------------------------------------- |
| my_messsage.text     | Returns original text array : table |
| my_message.active    | Returns active (true) or inactive (false) : boolean |

### example

```lua
UI = require("ui")

-- create the various text arrays
text_array = {}
text_array[1] = {'the end', 'and the beginning', 'they are', 'the same'}
text_array[2] = {'the relationship between', 'what we can see', 'and what we know'}
text_array[3] = {'do you know', 'that icarus', 'flew too close to the sun?'}

-- creates instances of messages
message ={}
for i=1,3 do
  message[i] = UI.Message.new(text_array[i])
end

function redraw()
  screen.clear()
  screen.font_size(8)
  screen.level(15)
  screen.move(0,34)
  screen.text('press K2 or K3 or turn E2')
  if message[1].display == true then -- redraws with message[1] if message[1] is to be displayed
    screen.clear()
    message[1]:redraw()
    message[1].display = false
  end
  for i = 2,3 do -- redraws with message[2] or [3] if either is to be displayed
    if message[i].display == true then
      screen.clear()
      message[i]:redraw()
    end
  end
  screen.update()
end

function show_message(msg,dur) -- generic function to display message of number 'msg' and for duration (in seconds) 'dur'
  message[msg].display = true
  redraw()
  clock.run(function()
    clock.sleep(dur)
    message[msg].display = false
    redraw()
  end)
end

function key(n,z)
  if n == 2 and z == 1 then
    message[1].display = true -- display a message upon a key press
  elseif n == 3 and z == 1 then
    show_message(2,2) -- display message 2 for 2 seconds upon a key press
  end
redraw()
end

icarus = 0

function enc(n,d) -- a message can be displayed upon a condition being met
  if n == 2 then
    icarus = icarus + d
    if icarus > 10 then
      show_message(3,5) -- display message 3 for 5 seconds
    end
  end
end

```

### description

Provides a way of displaying a message on the screen. `UI.Message.new` takes a table of strings, with each entry in the table (ie, each string) being displayed on a new line in the message. Messages are useful for indicating to the user that certain operations are finished, or for displaying error messages.

The message is drawn using the `redraw()` function, which needs to be called to display the message.

`UI.Message.new` returns a table which should be stored in a variable `my_message`. The `redraw` function can then be called using `my_message` in the manner described above.

In the example above, we show three possible ways messages can be used. `K2` displays a message for as long as `K2` is held. `K3` displays a message for two seconds. When `E2` is turned and reaches a certain value, a message is displayed for five seconds. We also define a generic function `show_message` which we can call whenever we want to display a certain message for a particular duration. 



