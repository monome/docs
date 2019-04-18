---
layout: page
permalink: /docs/norns/script-reference/
---

# norns script reference

Scripts are what make norns do things.
A script consists of at least a Lua file but can additionally also contain supporting Lua libraries, SuperCollider engines and data.
Scripts are located in `~/dust/code/`.

Follow the [studies](/docs/norns/study-1/) to learn how to write your own scripts.

## directory structure

```
myscript/
  myscript.lua -- main version, shows up as MYSCRIPT
  mod.lua -- alt version, shows up as MYSCRIPT/MOD
  README.md -- main docs/readme
  data/
    myscript-01.pset -- pset, loaded via params:read(1) or via menu
  lib/
    somelib.lua -- arbitrary lib, imported via require 'lib/somelib'
    some-engine.sc -- engine file
    some-engine.lua -- engine lib, require lib/some-engine'
  docs/ -- more documentation, won't be shown in SELECT
    more-docs.md
```

## basic form

```lua
-- scriptname: short script description
-- v1.0.0 @author
-- llllllll.co/t/22222

engine.name = 'PolySub'

function init()
  -- initialization
end

function key(n,z)
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
end

function redraw()
  -- screen redraw
end
```

## using libraries

Lua libraries can be used by using `include("path/to/library")`.

### script local libraries

`include()` will first look in the directory of the current script. This allows using relative paths to use libraries local to the script.
For example with the following structure:

```
myscript/
  myscript.lua
  lib/
    somelib.lua
```

`myscript.lua` can include `somelib.lua` using:

```lua
include("lib/somelib.lua")
```

### third party libraries

Third party libraries can be included using their full path starting from the `~/dust/code/` directory.
For example with the following structure in `~/dust/code/`:

```
myscript/
  myscript.lua
  lib/
    somelib.lua
otherscript/
  otherscript.lua
  lib/
    otherlib.lua
```

`myscript.lua` can include `otherlib.lua` using:

```lua
include("otherscript/lib/otherlib")
```

## functions

### softcut

- `softcut.level(voice, value)`
- `softcut.pan(voice, value)`
- `softcut.level_input_cut(ch, voice, value)`
- `softcut.level_cut_cut(src, dst, value)`
- `softcut.play(voice, state)`
- `softcut.loop_start(voice, value)`
- `softcut.loop_end(voice, value)`
- `softcut.loop(voice, state)`
- `softcut.fade_time(voice, value)`
- `softcut.rec_level(voice, value)`
- `softcut.pre_level(voice, value)`
- `softcut.rec(voice, state)`
- `softcut.rec_offset(voice, value)`
- `softcut.position(voice, value)`
- `softcut.buffer(i, b)`
- `softcut.voice_sync(src, dest, v)`
- `softcut.filter_fc(voice, value)`
- `softcut.filter_fc_mod(voice, value)`
- `softcut.filter_rq(voice, value)`
- `softcut.filter_lp(voice, value)`
- `softcut.filter_hp(voice, value)`
- `softcut.filter_bp(voice, value)`
- `softcut.filter_br(voice, value)`
- `softcut.filter_dry(voice, value)`
- `softcut.level_slew_time(voice, value)`
- `softcut.rate_slew_time(voice, value)`
- `softcut.phase_quant(voice, value)`
- `softcut.poll_start_phase()`
- `softcut.poll_stop_phase()`
- `softcut.enable(voice, state)`
- `softcut.buffer_clear()`
- `softcut.buffer_clear_channel(i)`
- `softcut.buffer_clear_region(start, stop)`
- `softcut.buffer_clear_region_channel(ch, start, stop)`
- `softcut.buffer_read_mono(file, start_src, start_dst, dur, ch_src, ch_dst)`
- `softcut.buffer_read_stereo(file, start_src, start_dst, dur)`
- `softcut.event_phase(f)`
- `softcut.reset()`
- `softcut.params()`


### engine

Specify an engine at the top of your script, ie:

```lua
engine.name = 'PolySub'
```

If you want to use an engine from another project make sure to install that project first.
If the engine comes with an accompanying Lua file make sure to import it, ie:

```lua
engine.name = 'R'

local R = require 'r/lib/r'
```

`engine.list_commands()` shows the commands.

For example to set the command `cutoff` to 500:

```lua
engine.cutoff(500)
```


### screen

- `screen.update()`
- `screen.aa(state)`
- `screen.clear()`
- `screen.level(value)`
- `screen.line_width(w)`
- `screen.line_cap(style)`
- `screen.line_join(style)`
- `screen.miter_limit(limit)`
- `screen.move(x, y)`
- `screen.move_rel(x, y)`
- `screen.line(x, y)`
- `screen.line_rel(x, y)`
- `screen.arc(x, y, r, angle1, angle2)`
- `screen.circle(x, y, r)`
- `screen.rect(x, y, w, h)`
- `screen.curve(x1, y1, x2, y2, x3, y3)`
- `screen.curve_rel(x1, y1, x2, y2, x3, y3)`
- `screen.close()`
- `screen.stroke()`
- `screen.fill()`
- `screen.text(str)`
- `screen.text_right(str)`
- `screen.text_center(str)`
- `screen.font_face(index)`
- `screen.font_size(size)`
- `screen.pixel(x, y)`
- `screen.display_png(filename, x, y)`

### metro

- `metro.init(arg, arg_time, arg_count)`
- `metro:start(time, count, stage)`
- `metro:stop()`


### params

The global `paramset` is named `params`

- `params:add_separator()`
- `params:add(args)`
- `params:add_number(id, name, min, max, default, formatter)`
- `params:add_option(id, name, options, default)`
- `params:add_control(id, name, controlspec, formatter)`
- `params:add_file(id, name, path)`
- `params:add_taper(id, name, min, max, default, k, units)`
- `params:add_trigger(id, name)`
- `params:print()`
- `params:get_name(index)`
- `params:string(index)`
- `params:set(index, v)`
- `params:set_raw(index, v)`
- `params:get(index)`
- `params:get_raw(index)`
- `params:delta(index, d)`
- `params:set_action(index, func)`
- `params:t(index)`
- `params:init()`
- `params:write(filename)`
- `params:read(filename)`
- `params:default()`
- `params:bang()`
- `params:clear()`


### paramset

- `paramset.new(id, name)`

### grid

`grid.connect(n)` to create device, returns object with handler, ie:

```lua
g = grid.connect()
```

- `g:led(x, y, val)`
- `g:all(val)`
- `g:refresh()`

- `g.key(x, y, state)`  key event handler function


### arc

`arc.connect(n)` to create device, returns object with handler, ie:

```lua
a = arc.connect()
```

- `a:led(ring, x, val)` set state of single LED on this arc device.
- `a:all(val)` set state of all LEDs on this arc device.
- `a:segment(ring, from, to, level)` create an anti-aliased point to point arc - segment/range on a specific LED ring.
- `a:refresh()` update any dirty quads on this arc device.

- `a.enc(n, delta)` encoder event handler function


### midi

TODO


### hid

TODO


### osc

- `osc.event(path, args, from)` handler function called when an osc event is received.
- `osc.send(to, path, args)` send osc event.

## crone

![](../image/crone-process-routing.png)

[pdf version](../crone-process-routing.pdf)


## further
- [Norns Lua docs](https://monome.github.io/norns/doc/)
- [https://monome.org/docs/norns](https://monome.org/docs/norns)
- [https://github.com/monome/norns](https://github.com/monome/norns)
