---
layout: default
nav_exclude: true
permalink: /norns/study-4/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/289755493?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# physical
{: .no_toc }

norns studies part 4: grids, MIDI, clock syncing

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## terminology

Before we dive in, here is some terminology which is mentioned throughout this study:

- **callback function**: A function that norns is aware of, but leaves open to a script redefining. In this study, we'll use callback functions to assign actions to grid + MIDI key presses.
- **decoupling**: The fundamental design principle of the grid, where keypresses and LEDs are independent from each other -- this allows the grid to display a playhead on a step sequencer, while also displaying each step's note, while also allowing you to change notes before or after the playhead passes.
- **coroutine**: A powerful concept in Lua, coroutines execute an event in collaboration with other processes. With norns, you'll mainly use coroutines for clock-based events -- to establish a step sequencer in collaboration with the main clock process, which can be driven by internal clock, MIDI, Ableton Link, or a modular synth via [crow](/docs/crow).

## tactile numbers

It's finally time to turn button pushing into piles of numbers, and numbers into blinking lights. Plug in a monome grid and clear any currently running script (hold **K1** on the `SELECT / SYSTEM / SLEEP` menu and, while holding **K1**, press **K3** when `CLEAR` appears).

Let's start off with the command line to introduce the basics:

```lua
>> g = grid.connect()
```

This creates a device table `g`,  which has a collection of methods (demarcated with `:`) and functions designed to handle grid + norns communication. We'll use methods to send commands to the grid and we use functions to parse what comes back.

Let's light things up with two methods, `:led` and `:refresh`:

```lua
>> g:led(1,8,15)
>> g:refresh()
```

You'll see a light at x/y coordinate (1,8) go to full brightness. Like the norns screen, (1,1) is the top left and numbers increase to the right and downwards.

If you have a grid plugged in and this didn't work, check **SYSTEM > DEVICES > GRID** and make sure your grid is attached to port 1 (more on this later).
{: .label .label-grey}

The grid device table also has callback functions for what happens when you push a key. Let's assign an action to any grid key press:

```lua
>> g.key = function(x,y,z) print(x,y,z) end
```

You'll now see the `x`,`y`, and `z` of each key event, where `z` is the key press/down (1) and release/up (0). Let's put these basic things together for something slightly more inspiring.

**If you've gone through the previous studies:**

- open your uniquely-named study folder in the maiden file browser
- create a new file in your study folder: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor

<details closed markdown="block">
  <summary>
    <i>If you haven't gone through the previous studies</i>
  </summary>
  {: .text-delta }
- create a new folder in the `code` directory: click on the `code` directory and then click the folder icon with the plus symbol to create a new folder
  - name your new folder something meaningful, like `my_studies` (only use alphanumeric, underscore and hyphen characters when naming)
- create a new file in the folder you created: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor
</details>

The file is blank. Full of possibilities. Type the text below into the editor:

```lua
-- study 4
-- code exercise
-- tactile numbers

engine.name = 'PolyPerc'

g = grid.connect()

g.key = function(x,y,z)
  if z==1 then engine.hz(100+x*4+y*64) end
  g:led(x,y,z*15)
  g:refresh()
end
```

Experience the magic of microtonal mashing. Try changing the numbers in the `engine.hz` function for different intervals and ranges. The grid is simply lighting up a key on press and turning it off on release, with `15` as the brightness level.

### expanding

While it's fairly exciting to have made an outer-space instrument with just a couple of lines of code, possibilities are somewhat constrained by only using `g.key` for both sound and grid refreshes. Let's decouple key presses, lights, and sound (one of the fundamental design principles of the grid).

First, let's create a separate `grid_redraw` function and maintain a table of steps. Clear any previous code in the editor and start anew with:

```lua
-- study 4
-- expanding

engine.name = 'PolyPerc'

steps = {}

function init()
  for i=1,16 do
    table.insert(steps,1) -- every step starts at position 1
  end
  grid_redraw()
end

g = grid.connect() -- connect to our grid

g.key = function(x,y,z)
  if z == 1 then -- if a key is pressed...
    steps[x] = y -- store its vertical position (y) for that step (x)
    grid_redraw() -- redraw the grid
  end
end

function grid_redraw()
  g:all(0) -- turn all the LEDs off...
  for i=1,16 do
    g:led(i,steps[i],4) -- set step positions to brightness 4
  end
  g:refresh() -- refresh the grid
end
```

Introduced here is `g:all()` which sets every grid light to the brightness level provided -- `g:all(0)` clears the grid.

The `grid_redraw` function draws each step on the grid and is called each time we have a key down (in this case, there's no point to refresh on key up). We also call `grid_redraw` on `init` so the grid displays the starting data at startup.

Let's take this decoupling a step further by implementing a complete step sequencer, through modifications to our previous code:

```lua
-- study 4
-- expanding

engine.name = 'PolyPerc'

steps = {}

function init()
  for i=1,16 do
    table.insert(steps,1) -- every step starts at position 1
  end
  grid_redraw()
  position = 0
  counter = clock.run(count)
end

g = grid.connect()

g.key = function(x,y,z)
  if z == 1 then
    steps[x] = y
    grid_redraw()
  end
end

function grid_redraw()
  g:all(0)
  for i=1,16 do
    g:led(i,steps[i],i == position and 15 or 4)
  end
  g:refresh()
end

function count()
  while true do -- while the 'counter' is active...
    clock.sync(1) -- sync every 'beat'
    position = util.wrap(position+1, 1, 16) -- increment the position by 1, wrap it as 1 to 16
    engine.hz(steps[position]*100) -- play a note, based on step position
    grid_redraw() -- and redraw the grid
  end
end
```

Lots of exciting things to unpack, all centered on *clocks*!

#### clocks

norns has a [global clocking system](/docs/norns/control-clock/#clock), which affords internal + external clocking mechanisms, including MIDI, [crow](/docs/crow), and Ableton Link. Since there's an [extended study on scripting with clocks](/docs/norns/clocks), we won't go too deep here, but in our code above we cover a few basics to get you started.

At the end of our `init`, `counter = clock.run(count)` establishes:

- a clock coroutine named `counter`
- ...which executes the function `count`:

```lua
function count()
  while true do -- while the 'counter' is active...
    clock.sync(1) -- sync every 'beat'
    position = util.wrap(position+1, 1, 16) -- increment the position by 1, wrap it as 1 to 16
    engine.hz(steps[position]*100) -- play a note, based on step position
    grid_redraw() -- and redraw the grid
  end
end
```

`clock.sync(1)` will sync every 'beat' at the BPM listed under `PARAMETERS > CLOCK > tempo`. Try giving `clock.sync` a different argument to get different feels, like `1/16` or `1/3`.

#### bonus trick

A bonus trick is demonstrated in our `grid_redraw` function:

```lua
g:led(i,steps[i],i == position and 15 or 4)
```

That last part takes this form:

_(condition)_ **and** _a_ **or** _b_

In our code, the condition is `i == position` which checks if we're drawing the step of the current position. If true, we use 15 (bright) for that step's LED, otherwise 4 (dim).

## long live (parts of) the 80's

MIDI has outlived most of the 80's. It's still useful and, most importantly, it's still fun. Plug a USB MIDI controller into norns and head to `SYSTEM > DEVICES > MIDI` to confirm the port it occupies, 1-16. Once you've identified its port, get to the command line:

```lua
>> m = midi.connect(1) -- change 1 for whichever port you want to listen to
>> m.event = function(data) tab.print(data) end
```

Push a MIDI key or turn an encoder and you'll see something like:

```
1    144
2    72
3    127
1    128
2    72
3    64
```

You may be wondering what this is. MIDI is a [series of bytes](http://www.gweep.net/~prefect/eng/reference/protocol/midispec.html) which need to be decoded to become useful.

We've built some MIDI helpers into the library, which will help decipher the incoming MIDI data:

```lua
>> m.event = function(data) tab.print(midi.to_msg(data)) end
```

Using the `midi.to_msg` helper function, we see that (144,72,127) is converted to:

```
ch    1
vel    127
note    72
type    note_on
```

This format is a lot more legible.

### incoming MIDI

Let's hook up a MIDI keyboard to the PolyPerc engine. Clear any previous code in the editor and start anew with:

```lua
-- study 4
-- MIDI keyboard input

engine.name = 'PolyPerc'

m = midi.connect() -- if no argument is provided, we default to port 1

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    engine.amp(d.vel / 127)
    engine.hz(midi_to_hz(d.note))
  end
end
```

We set the engine amplitude to the key velocity (MIDI is 0-127, so we scale it 0-1 by dividing by 127), and then trigger a note. That's it!

Want to get CC input? Try adding this to our `m.event` function:

```lua
if d.type == "cc" then
  print("cc " .. d.cc .. " = " .. d.val)
end
```

That will print received CC number and CC value -- try specifying one of the CC values and use `util.linexp` to map the 0 to 127 range to useful values for our cutoff filter, eg.:

```lua
if d.type == "cc" then
  if d.cc == 33 then -- if CC number is 33 then...
    engine.cutoff(util.linexp(0,127,300,12000,d.val))
  end
end
```

You can also sort data by MIDI channel, ie `d.ch`.

Here are the types of incoming MIDI that get turned into messages:

- `note_on`
- `note_off`
- `cc`
- `pitchbend`
- `key_pressure`
- `channel_pressure`

Remember to use `tab.print(midi.to_msg(data))` for decoding any confusing MIDI input!

### sending MIDI

Sending MIDI means sending out bytes. We can certainly send raw values to a connected device:

```lua
>> out_midi = midi.connect(1) -- change 1 for whichever port you want to send to
>> out_midi:send{144,60,127}
```

Note the braces, as this is a syntax we haven't seen yet. It's equivalent to `out_midi:send({144,60,127})` -- if an argument is a single table, you can skip typing the parens.

`out_midi:send{144,60,127}` sends note on (MIDI raw data 0x90 is equal to 144) for note 60 at velocity 127 but it's much easier to use the helper function:

```lua
>> out_midi:note_on(60,127)
```

Here's a list of the helper methods for midi out:

- `:note_on(note, velocity, channel)`
- `:note_off(note, velocity, channel)`
- `:cc(cc, value, channel)`
- `:pitchbend(value, channel)`
- `:key_pressure(note, value, channel)`
- `:channel_pressure(value, channel)`

In each case, channel will default to 1 if left off. For note on/off, velocity is optional  -- 100 will be used if none provided.

### keeping track of little boxes

*DEVICES* (grids, arcs, MIDI, and HID) use a virtual port system. Physical devices are assigned to a virtual port via the **SYSTEM > DEVICES** menu. New devices are automatically assigned to remaining empty ports.

When calling `connect()` with no argument, port 1 is used. This is true of grids, MIDI devices, [arcs](/docs/arc), and HID devices.

This means we can attach multiple devices and set up multiple device tables for each:

```lua
keys = midi.connect(1)
ctrl = midi.connect(2)
transport = midi.connect(2)
```

With the sample setup above we could have a keyboard input on port 1, and a CC controller on port 2. These would each get their own `event` functions. But we also made a second device table for port 2, called `transport`. All three of these device tables will work at once. The idea behind the last case being: say you have some cut-paste code you want to use from another script for doing transport control (start/stop/CC). Instead of hacking up your MIDI event functions, you can simply copy the entire unit and it will work alongside other connections to the same port.

This type of device management is workable when scripting on your own, but what if you want to dynamically allocate and reassign handling of data to each port? Check out [the norns midi API reference](../reference/midi#example) for an example of flexible assignment.

## support your local library

In one of the above examples we use a complex transformation to turn a note number into a frequency (something we demonstrated in study 3). It's a pretty standard musical function, so `@markeats` put it in a library, and here's how we use it:

```lua
music = require 'musicutil'
hz = music.note_num_to_freq(60)
```

The library is imported with the `require` command, whereafter all of the functions within the library are available. Check out the [norns function reference](../api) for the default libraries. Additional user libraries are also available, but are maintained by individual users. See the lines [Library category](https://llllllll.co/c/library) for more.

## MIDI sync, Ableton Link, modular clocks

An often-used feature of MIDI is the ability to sync devices to a tempo. One device can send clock to another.

This is accomplished using a series of bytes: 248 (clock tick), 250 (clock start), 251 (clock continue), and 252 (clock stop).

Instead of sorting these bytes out by hand, we can just use the global clock inside of norns, which has handlers built in for internal clocking as well as MIDI, Ableton Link, and clock signals through crow. The `CLOCK` menu is available in the `PARAMETERS` screen. see the [dedicated clock study](../clocks/) for more detail.

### source

This sets the sync source for the global tempo.

- `internal` sets norns as the clock source
- `midi` takes any external MIDI clock via connected USB-MIDI devices
- `link` enables ableton link sync for the connecting wifi network
- `crow` takes sync from input 1 of a connected crow device

Link has a `link quantum` parameter to set the quantum size.

crow additionally has a `crow in div` parameter to specify the number of sub-divisions per beat.

The `tempo` parameter sets the internal and link tempos. This tempo will be automatically updated if set by an external source (MIDI, crow, or remote Link device).

You can set the tempo in your script by the normal method of setting parameters:

```lua
>> params:set("clock_tempo",100)
```

### out

Clock signals can be transmitted via MIDI or crow.

**MIDI**

norns can send a MIDI clock signal out to any port, regardless of the current clock source. This means norns can be a Link-to-MIDI-clock or CV-pulse-to-MIDI converter.

- norns will automatically populate the currently-connected MIDI devices in this list
- use <kbd>K3</kbd> to toggle clock out on/off for each entry
- see `SYSTEM > DEVICES` to manage devices

**crow**

`crow out` sets the output number, and also has a `crow out div` setting for beat subdivisions.

## example: physical

Putting together concepts above. This script is demonstrated in the video up top.

```lua
-- physical
-- norns study 4
--
-- grid controls arpeggio
-- midi controls root note
-- ENC2 = bpm
-- ENC3 = scale

engine.name = 'PolyPerc'

music = require 'musicutil'

steps = {}
position = 1
transpose = 0

mode = math.random(#music.SCALES)
scale = music.generate_scale_of_length(60,music.SCALES[mode].name,8)

function init()
  for i=1,16 do
    table.insert(steps,math.random(8))
  end
  grid_redraw()
  counter = clock.run(count)
end

function enc(n,d)
  if n == 1 then
    params:delta("clock_source",d)
  elseif n == 2 then
    params:delta("clock_tempo",d)
  elseif n == 3 then
    mode = util.clamp(mode + d, 1, #music.SCALES)
    scale = music.generate_scale_of_length(60,music.SCALES[mode].name,8)
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,20)
  screen.text("clock source: "..params:string("clock_source"))
  screen.move(0,30)
  screen.text("bpm: "..params:get("clock_tempo"))
  screen.move(0,40)
  screen.text(music.SCALES[mode].name)
  screen.update()
end

g = grid.connect()

g.key = function(x,y,z)
  if z == 1 then
    steps[x] = 9-y
    grid_redraw()
  end
end

function grid_redraw()
  g:all(0)
  for i=1,16 do
    g:led(i,9-steps[i],i==position and 15 or 4)
  end
  g:refresh()
end

function count()
  while true do
    clock.sync(1/4)
    position = (position % 16) + 1
    engine.hz(music.note_num_to_freq(scale[steps[position]] + transpose))
    grid_redraw()
    redraw() -- for bpm changes on LINK, MIDI, or crow
  end
end

m = midi.connect()
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    transpose = d.note - 60
  end
end
```

## reference
### norns-specific
- `grid` -- module to manage messages to/from a connected monome grid and send LED state data, see [`grid` API docs](../api/modules/grid) for detailed usage
- `midi` -- module to manage messages to/from connected MIDI devices, see [`midi` API docs](../api/modules/midi) and [MIDI API reference](../reference/midi) for detailed usage
- `musicutil` -- library to perform standard musical functions, see [`MusicUtil` API docs](https://monome.org/docs/norns/api/modules/lib.MusicUtil.html) for detailed usage

### general
- `and` / `or` -- a terse combination of binary operators, see [this tutorial](http://lua-users.org/wiki/TernaryOperator) for detailed usage
- `require` -- a higher-level function, see [Lua docs](https://www.lua.org/pil/8.1.html) for more details but suffice to say you only need to use `require` when running and loading norns libraries outside of your script's folder (like we did with `musicutil`). When loading from inside of your script's folder, use `include`. See the `libraries` section of [the extended reference](/docs/norns/reference/#libraries) for more detail.

## continued
{: .no_toc }

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: physical
  - part 4b: [physical tangent: arc](../study-4b) // arc
- part 5: [streams](../study-5/) // system polls, OSC, file storage
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).