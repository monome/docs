---
layout: default
nav_exclude: true
---

# orienting to seamstress {#opening}

[*seamstress*](https://github.com/ryleelyman/seamstress/) is a Lua scripting environment for musical communication. It was inspired by [*norns*](/docs/norns) and makes use of its [scripting API](/docs/norns/reference), but it is **not** a port of the *norns* environment. Generally, though, *seamstress* is a fantastic complement to the *norns* scripting experience, as it has many syntactical similarities and many of the same scripting libraries.

This article aims to provide someone already familiar with the *norns* scripting API an orientation to the unique gestures *seamstress* offers, by giving an overview of some of the differences between the environments. If you are new to Lua or new to *norns* scripting, we highly recommend checking out the [other learning resources we've developed](/docs/norns/studies/).

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## prerequisites

The rest of this text assumes a basic understanding of Lua. If you're absolutely new to Lua it may be helpful to first go through some of [the resources listed in our norns documentation](/docs/norns/studies/#learning-lua).

### software

- Install [*seamstress*'s dependencies](https://github.com/ryleelyman/seamstress/#installation)
- Install *seamstress* by either:
  - [downloading a prebuilt binary via GitHub](https://github.com/ryleelyman/seamstress/releases)
  - using [homebrew](https://brew.sh/):  
    `brew tap ryleelyman/seamstress`  
    `brew install seamstress`
  - [building from source](https://github.com/ryleelyman/seamstress/#building-from-source)
- Install serialosc: [/docs/serialosc/setup](/docs/serialosc/setup)

The [grid studies: seamstress](/docs/grid/studies/seamstress/) are optional, though highly recommended if you have a grid.

### running code

*seamstress* is run from the terminal by executing the command `seamstress`. If it is not given any filename, *seamstress* looks for and runs a file called `script.lua` in either the current directory or in `~/seamstress/`.

We highly recommend exploring the examples bundled with *seamstress*. Execute `seamstress -e` to see a list, and run any with `seamstress -e SCRIPTNAME`.

### navigating the API

While long-form documents are useful for conceptual on-boarding, a program's Application Programming Interface (henceforth 'API') is the easiest way to check for scripting syntax and built-in library usage.

- [norns API](https://monome.org/docs/norns/api/)
- [seamstress API](https://ryleealanza.org/docs/)

You'll notice they are formatted very similarly, and include many of the same modules -- however, do not assume anything about cross-compatible usage! Though they share contributors, *seamstress* and *norns* are developed and maintained very differently.

## big differences

It seems useful to start with the big differences between scripting for *seamstress* and *norns*.

### audio

*seamstress* has **no audio engine** and **does not output any audio on its own**.

- *seamstress* has no dedicated SuperCollider audio engine, so the entire *norns* [`engine` module](https://monome.org/docs/norns/api/modules/engine.html) does not apply to *seamstress* scripting
- *seamstress* does not natively support [`softcut`](https://monome.org/docs/norns/api/modules/softcut.html)
- *seamstress* has no [`Tape` module](https://monome.org/docs/norns/api/modules/audio.html#Tape_Functions)
- *seamstress* has no [effects](https://monome.org/docs/norns/api/modules/audio.html#Effects_functions)
- *seamstress* has no [`poll` module](https://monome.org/docs/norns/api/modules/poll.html) as it has no direct access to audio input

### MIDI

Device management and scripting between the two environments is the same, but its worth noting that *seamstress* has access to 32 virtual MIDI ports, whereas *norns* can only access 16.

For an example of MIDI usage, execute `seamstress -e hello_midi.lua` ([source](https://github.com/ryleelyman/seamstress/blob/main/examples/hello_midi.lua)).

### keys and encoders

As a dedicated standalone unit, *norns* offers three encoders and three keys for direct user input into scripts. While you could connect a MIDI device which offers buttons and encoders to *seamstress* and perform something similar, there is no scripting support for [encoder](https://monome.org/docs/norns/reference/encoders) or [key](https://monome.org/docs/norns/study-1/#use-the-hardware) interactions.

Instead, *seamstress* offers support for mouse + keyboard entry.

## parameters, PSETs, PMAPs {#params}

Both environments offer performance parameters within a dedicated UI. These are helpful for saving state, assigning meaningful MIDI control, and returning to a specific configuration.

**Important scripting difference**  
*seamstress* adds new arguments to each parameter type, so be sure to check the [API](https://ryleealanza.org/docs/modules/paramset.html). *seamstress* offers many of the same parameter types as *norns*, excluding `:add_taper` (since `:add_control` can be manipulated for non-linear control) and `add_file`. The latter was left out since seamstress has no coupled audio engine, and on *norns* the `file` parameter type is most often used for sample playback.

- to learn more about PSET functionality, please run `seamstress -e hello_psets`
- to learn more about PMAP functionality, please run `seamstress -e hello_pmaps`

## screen

norns has a 128x64 monochromatic screen with sixteen levels of brightness (0-15), whereas seamstress offers a full-color, resizable, clickable display with magnification.

- [norns screen API](https://monome.org/docs/norns/api/modules/screen.html)
- [seamstress screen API](https://ryleealanza.org/docs/modules/screen.html)

**Important scripting difference!**  
*seamstress* uses `screen.refresh()` to draw the buffer to the screen, whereas *norns* uses `screeen.update()`

### color + level {#color-level}

*norns* formats 'color' as sixteen values using `screen.level(value)` ([API](https://monome.org/docs/norns/api/modules/screen.html#Screen.level)), whereas *seamstress* can display RGBA colors using `screen.color(r, g, b, a)` ([API](https://ryleealanza.org/docs/modules/screen.html#color)).

*seamstress* example:

```lua
display_string = "hello!"

function redraw()
  screen.clear()
  screen.move(0, 10)
  for i = 1, 10 do
    screen.move_rel(screen.get_text_size(display_string), 0)
    local r = math.random(130, 255)
    local g = math.random(20, 195)
    local b = math.random(85, 200)
    screen.color(r, g, b) -- not possible with norns!
    screen.text(display_string)
  end
  screen.refresh() -- in norns: screen.update()
end
```

### size

The *norns* display is limited by its physical dimensions, whereas *seamstress* allows you to resize the window to better match your script's needs.

*seamstress* example:

```lua
function init()
  width = 200
  height = 30
  screen.set_size(width, height)
end

function screen.level(val)
  return screen.color(17 * val, 17 * val, 17 * val, 255)
end

function redraw()
  screen.clear()
  for i = 0, 15 do
    screen.level(i)
    screen.move(i * (width / 16), 0)
    screen.rect_fill((width / 16) + 3, height + 3)
    screen.level(15 - i)
    screen.move_rel(1, 0)
    screen.text(i)
  end
  screen.refresh()
end
```

## grid and arc

Both *seamstress* and *norns* fully support monome's [grid](/docs/grid/) and [arc](/docs/arc/), using the exact same API for each.

For example, this snippet (which ignites the LED of any held grid key) runs the same on *norns* and *seamstress*:

```lua
g = grid.connect()

function g.key(x,y,z)
  g:led(x,y,z*15)
  g:refresh()
end
```

## mouse

While *norns* offers an [`hid` module](https://monome.org/docs/norns/api/modules/hid.html) for detecting mouse interactions, *seamstress* bundles this functionality into its screen-based functions:

- `screen.click(x, y, state, button)`: callback executed when the user clicks the mouse on the GUI window ([API](https://ryleealanza.org/docs/modules/screen.html#click))
- `screen.mouse(x, y)`: callback executed when the user moves the mouse with the GUI window focused ([API](https://ryleealanza.org/docs/modules/screen.html#mouse))
- `screen.wheel(x, y)`: callback executed when the user scrolls with the mouse wheel on the GUI window ([API](https://ryleealanza.org/docs/modules/screen.html#wheel))

To test-drive these functions, we recommend running small snippets on your own, eg:

```lua
function screen.click(x, y, state, button)
  print("x: "..x, "y: "..y, "state: "..state, "button: "..button)
end
```

## keyboard

While *norns* does have a dedicated [`keyboard` module](https://monome.org/docs/norns/api/modules/keyboard.html) for typing keyboards, *seamstress* bundles this functionality into its screen-based functions:

- `screen.key(char, modifiers, is_repeat, state)`: callback executed when the user types a key into the GUI window

To test-drive these functions, we recommend running this small example script:

```lua
-- example: display keyboard input

function init()
  data = {
    modifier = 'none',
    char = 'none',
    is_repeat = 'false',
    state = 0
  }
end

function screen.key(char, modifiers, is_repeat, state)
  if #modifiers == 1 then
    data.modifier = modifiers[1]
  elseif #modifiers == 0 then
    data.modifier = "none"
  end
  if char.name ~= nil then
    data.char = char.name
  else
    char = char == " " and "space" or char
    data.char = char
  end
  data.is_repeat = tostring(is_repeat)
  data.state = state
  redraw()
end

function redraw()
  screen.clear()
  screen.color(255, 255, 255)
  screen.move(10,10)
  screen.text("last char: "..data.char)
  screen.move_rel(0,10)
  screen.text("current mod: " .. data.modifier)
  screen.move_rel(0,10)
  screen.text("repeat: " .. data.is_repeat)
  screen.move_rel(0,10)
  screen.text("state: " .. data.state)
  screen.refresh()
end
```

## closing + credits

We hope that this document helps illustrate a few of the key differences between *norns* and *seamstress*, so that you can quickly approach your next scripting adventure.

*seamstress* was developed and designed by [Rylee Alanza Lyman](https://ryleealanza.org/), inspired by [*matron* from norns](https://github.com/monome/norns/tree/main/matron/src). *matron* was written by [`@catfact`](https://github.com/ryleelyman/seamstress). norns was initiated by [`@tehn`](https://github.com/tehn).

This document was created by [Dan Derks](https://dndrks.com) for [monome.org](https://monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail `help@monome.org`.