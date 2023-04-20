---
layout: default
nav_exclude: true
permalink: /norns/reference/keyboard
---

## keyboard

### control

| Syntax                     | Description                                                                                     |
| -------------------------- | ----------------------------------------------------------------------------------------------- |
| keyboard.code(key,value)   | User script callback for keypresses : function                                                  |
| keyboard.char(character)   | User script callback for printable characters (letters, numbers, punctuation, space) : function |
| keyboard.code_to_char(key) | Convert a keyboard code to a printable character : function                                     |

#### OSC

You can also transmit keyboard values to norns via OSC using `/remote/brd n val`.   
See the [OSC reference](/docs/norns/reference/osc) for more details.

### query

| Syntax                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| keyboard.alt()         | Returns state of ALT key : boolean                |
| keyboard.ctrl()        | Returns state of CTRL key : boolean               |
| keyboard.meta()        | Returns state of META key : boolean               |
| keyboard.shift()       | Returns state of SHIFT key : boolean              |
| keyboard.state[string] | Returns state of defined key, eg. ['A'] : boolean |

### typing example

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

Deciphers keyboard (typing, not piano) input and executes user-assignable callbacks based on key codes, character case, and held state. Specific functions are available to query modifier states: `shift`, `alt`, `ctrl`, and `meta`. Three key state values are reported as part of the `code` callback: 1 for initial press, 2 for press and hold, 0 for release.

### specific cases

Employment of the `keyboard` library can vary widely by intended use.

For basic text input (as demonstrated in the code snippet above), use `keyboard.char` for inputting characters and `keyboard.code` for handling entries like `"ENTER"`.

To use a keyboard as a matrix of buttons, where any key can be a modifier, use `keyboard.code` and `keyboard.code_to_char`.

#### code_to_char example

`keyboard.code_to_char` will return output based on the state of any modifier keys currently held (eg. `SHIFT`), as well as the keyboard's layout (under `SYSTEM > DEVICES > HID`). Many thanks to [`@niksilver`](https://github.com/niksilver) for the following example code:

```lua
-- keyboard.code_to_char(code) example

local state = {
    kcode = {
        key = nil,
        value = nil,
        code_to_char = nil
    },

    kchar = {
        ch = nil,
    }
}

function init()
    redraw()
end

function redraw()
    screen.clear()

    screen.move(0, 8)
    screen.text("Last calls to...")

    screen.move(0, 24)
    screen.text("keyboard.code(" ..
        stringify(state.kcode.key) .. ", " ..
        stringify(state.kcode.value) .. ")"
    )

    screen.move(0, 32)
    screen.text("    code_to_char(...) = " ..
        stringify(state.kcode.code_to_char)
    )

    screen.move(0, 48)
    screen.text("keyboard.char(" ..
        stringify(state.kchar.ch) .. ")"
    )

    screen.update()
end

function stringify(s)
    if type(s) ~= "string" then
        return tostring(s)
    end

    local prefix = (s == '\\' or s == "'") and '\\' or ''

    return "'" .. prefix .. s .. "'"
end

function keyboard.code(key, value)
    state.kcode.key = key
    state.kcode.value = value
    state.kcode.code_to_char = keyboard.code_to_char(key)
    redraw()
end

function keyboard.char(ch)
    state.kchar.ch = ch
    redraw()
end

```
