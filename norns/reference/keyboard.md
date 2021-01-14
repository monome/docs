---
layout: default
nav_exclude: true
permalink: /norns/reference/keyboard
---

## keyboard

### control

| Syntax                    | Description                                             |
| ------------------------- | ------------------------------------------------------- |
| keyboard.code(code,value) | User script callback for keypresses : function          |
| keyboard.char(character)  | User script callback for specific characters : function |

### query

| Syntax                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| keyboard.alt()         | Returns state of ALT key : boolean                |
| keyboard.ctrl()        | Returns state of CTRL key : boolean               |
| keyboard.meta()        | Returns state of META key : boolean               |
| keyboard.shift()       | Returns state of SHIFT key : boolean              |
| keyboard.state[string] | Returns state of defined key, eg. ['A'] : boolean |

### example

```lua
MU = require("musicutil")
engine.name = "PolySub"

my_string = ""

function init()
  engine.ampAtk(0)
  engine.ampDec(0.1)
  engine.ampSus(0.05)
  engine.ampRel(0.5)
end

function keyboard.char(character)
  my_string = my_string..character -- add characters to my string
  redraw()
end

function keyboard.code(code,value)
  if value == 1 or value == 2 then -- 1 is down, 2 is held, 0 is release
    if code == "BACKSPACE" then
      my_string = my_string:sub(1, -2) -- erase characters from my_string
    elseif code == "ENTER" then
      my_string = "" -- clear my_string
      note_on() -- play a bell
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(10,30)
  screen.text(my_string)
  screen.update()
end

function note_on()
  for i = 1,4 do
    engine.start(i,2500+(250*i/150))
  end
  clock.run(note_off)
end

function note_off()
  clock.sleep(0.1)
  for i = 1,4 do
    engine.stop(i)
  end
end
```

### description

Deciphers keyboard (typing, not piano) input and executes user-assignable callbacks based on key codes, character case, and held state. Specific functions are available to query modifier states: `shift`, `alt`, `ctrl`, and `meta`. Three key state values are reported as part of the `code` callback: 1 for initial press, 2 for hold, 0 for release.
