---
layout: default
nav_exclude: true
---

# seamstress and norns {#opening}

[*seamstress*](https://github.com/ryleelyman/seamstress/) is a Lua scripting environment for musical communication. It was inspired by [*norns*](/docs/norns) and makes use of much of its library, but it is **not** a direct port as it was intended to be run on normal computers whereas *norns* is tailored for specific hardware.

This document will examine the differences between these two environments, to help those familiar with *norns* get comfortable with *seamstress*.

If you are new to Lua or new to *norns* scripting, we highly recommend checking out the [other learning resources we've developed](/docs/norns/studies/).

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### software

- Install serialosc: [/docs/serialosc/setup](/docs/serialosc/setup)
- Install [*seamstress*'s dependencies](https://github.com/ryleelyman/seamstress/#installation)
- Install *seamstress* by either:
  - [downloading a prebuilt binary via GitHub](https://github.com/ryleelyman/seamstress/releases)
  - using [homebrew](https://brew.sh/):  
    `brew tap ryleelyman/seamstress`  
    `brew install seamstress`
  - [building from source](https://github.com/ryleelyman/seamstress/#building-from-source)

The [grid studies: seamstress](/docs/grid/studies/seamstress/) are recommended if you have a grid.

## running code

*seamstress* is run from the terminal by executing the command `seamstress`. If it is not given any filename, *seamstress* looks for and runs a file called `script.lua` in either the current directory or in `~/seamstress/`.

We recommend exploring the examples bundled with *seamstress*. Execute `seamstress -e` to see a list, and run any with `seamstress -e SCRIPTNAME`.

## navigating the library

The fundamental comparison of functions and syntax can be seen by cross-referencing the libraries (API) of each environment:

- [norns API](https://monome.org/docs/norns/api/)
- [seamstress API](https://ryleealanza.org/docs/)

You'll notice they are formatted very similarly and include many of the same modules. Generally if modules are represented in both places they are compatible, but keep in mind that `screen` and `psets` are substantially different, as noted below.


## audio

*seamstress* has **no audio engine** and **does not output any audio on its own**.

as a result, the *norns* audio modules do not apply. this includes [`engine` ](https://monome.org/docs/norns/api/modules/engine.html), [`softcut`](https://monome.org/docs/norns/api/modules/softcut.html), [`tape`](https://monome.org/docs/norns/api/modules/audio.html#Tape_Functions), [effects](https://monome.org/docs/norns/api/modules/audio.html#Effects_functions), and [`poll`](https://monome.org/docs/norns/api/modules/poll.html).

alternatively, *seamstress* can communicate via OSC or MIDI with various software including SuperCollider to achieve similar results.


## keys and encoders

*norns* was designed specifically with keys and encoders as an interface, which are not present on computers. hence, *seamstress* does not have this functionality.


## grids, MIDI, and OSC

Both systems follow the same syntax for grids, MIDI, and OSC.

A simple grid example:

```lua
g = grid.connect()

function g.key(x,y,z)
  g:led(x,y,z*15)
  g:refresh()
end
```

For an example of MIDI usage, execute `seamstress -e hello_midi.lua` ([source](https://github.com/ryleelyman/seamstress/blob/main/examples/hello_midi.lua)).


## screen

norns has a 128x64 monochromatic screen with sixteen levels of brightness (0-15), whereas seamstress has a full-color, resizable, clickable display with magnification.

- [norns screen API](https://monome.org/docs/norns/api/modules/screen.html)
- [seamstress screen API](https://ryleealanza.org/docs/modules/screen.html)

**syntax difference alert** --- *seamstress* uses `screen.refresh()` to draw the buffer to the screen, whereas *norns* uses `screeen.update()`

instead of *norns* monochromatic `screen.level(v)`, *seamstress* uses full-color with the with `screen.color(r, g, b, a)` and can also resize the screen with `screen.set_size()`, for example:

```lua
function init()
  width = 200
  height = 30
  screen.set_size(width, height)
end
```

## mouse

the *norns* [`hid` module](https://monome.org/docs/norns/api/modules/hid.html) can interface with a mouse, but *seamstress* combines this functionality into its screen-based functions:

- `screen.click(x, y, state, button)`: callback executed when the user clicks the mouse on the GUI window ([API](https://ryleealanza.org/docs/modules/screen.html#click))
- `screen.mouse(x, y)`: callback executed when the user moves the mouse with the GUI window focused ([API](https://ryleealanza.org/docs/modules/screen.html#mouse))
- `screen.wheel(x, y)`: callback executed when the user scrolls with the mouse wheel on the GUI window ([API](https://ryleealanza.org/docs/modules/screen.html#wheel))

For example:

```lua
function screen.click(x, y, state, button)
  print("x: "..x, "y: "..y, "state: "..state, "button: "..button)
end
```

## keyboard

*norns* has a [`keyboard` module](https://monome.org/docs/norns/api/modules/keyboard.html), but *seamstress* combines this functionality into its screen-based functions:

- `screen.key(char, modifiers, is_repeat, state)`: callback executed when the user types a key into the GUI window

For a fully-developed example, run `seamstress -e plasma`.  


## parameters, PSETs, PMAPs {#params}

Both environments offer parameters, each with a UI tailored for its hardware.

**syntax difference alert** --- *seamstress* adds new arguments to each parameter type, so be sure to check the [API](https://ryleealanza.org/docs/modules/paramset.html). *seamstress* offers many of the same parameter types as *norns*, excluding `:add_taper` (`:add_control` can be manipulated for non-linear control) and `add_file`.

- to learn more about PSET functionality, please run `seamstress -e hello_psets`
- to learn more about PMAP functionality, please run `seamstress -e hello_pmaps`


## credits

*seamstress* was developed and designed by [Rylee Alanza Lyman](https://ryleealanza.org/), inspired by [*matron* from norns](https://github.com/monome/norns/tree/main/matron/src). *matron* was written by [`@catfact`](https://github.com/ryleelyman/seamstress). norns was initiated by [`@tehn`](https://github.com/tehn).

This document was created by [Dan Derks](https://dndrks.com)

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail `help@monome.org`.
