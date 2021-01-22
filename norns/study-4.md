---
layout: default
nav_exclude: true
permalink: /norns/study-4/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/289755493?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# physical

norns studies part 4: grids + midi

## tactile numbers

it's finally time to turn button pushing into piles of numbers and numbers into blinking lights. plug in a monome grid. let's start off with the command line to introduce the basics:

```lua
g = grid.connect()
```

this creates a device table `g`. let's light it up:

```lua
g:led(1,8,15)
g:refresh()
```

you'll see a light at x,y (1,8) go to full brightness. like the norns screen, (1,1) is the top left and numbers increase to the right and downwards.

_NOTE_: if you have a grid plugged in and this didn't work, check **SYSTEM > DEVICES > GRID** and make sure your grid is attached to port 1. (more on this later.)

Let's see what happens when you push a key:

```lua
g.key = function(x,y,z) print(x,y,z) end
```

you'll now see the x,y,z of each key event, where z is the key press/down (1) and release/up (0). this is how we attach a function with a grid key event. let's put these things together for something slightly more inspiring:

```lua
engine.name = 'PolyPerc'

g = grid.connect()

g.key = function(x,y,z)
  if z==1 then engine.hz(100+x*4+y*64) end
  g:led(x,y,z*15)
  g:refresh()
end
```

experience the magic of microtonal mashing. try changing the numbers in `engine.hz` for different intervals and ranges. the grid is simply lighting up a key on press and turning it off on release. `15` is the brightness level.

## expanding

while it's fairly exciting to have made an outer-space instrument with just a couple of lines of code, possibilities are somewhat constrained by only using `g.key` for both sound and grid refreshes. let's decouple key, light, and sound (one of the fundamental design principles of the grid).

first, let's create a separate `grid_redraw` function and maintain a table of steps.

```lua
engine.name = 'PolyPerc'

steps = {}

function init()
  for i=1,16 do
    table.insert(steps,1)
  end
  grid_redraw()
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
    g:led(i,steps[i],4)
  end
  g:refresh()
end
```

introduced here is `g:all()` which sets every grid light to a set brightness. `g:all(0)` clears the grid.

the `grid_redraw` function draws each step on the grid and is called each time we have a key down(in this case, there's no point to refresh on key up). we also call `grid_redraw` on `init` for a nice startup.

let's take this decoupling a step further by implementing a complete step sequencer.

```lua
engine.name = 'PolyPerc'

steps = {}

function init()
  for i=1,16 do
    table.insert(steps,1)
  end
  grid_redraw()
  position = 1
  counter = metro.init()
  counter.time = 0.1
  counter.count = -1
  counter.event = count
  counter:start()
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
    g:led(i,steps[i],i==position and 15 or 4)
  end
  g:refresh()
end

function count()
  position = (position % 16) + 1
  engine.hz(steps[position]*100)
  grid_redraw()
end
```

we've added a metro (see study 3). now `grid_redraw` also gets called by the metro counter callback function, which also sounds a note.

a bonus trick is demonstrated in `grid_redraw`:

```lua
g:led(i,steps[i],i==position and 15 or 4)
```

see that last part? it takes this form:

_(condition)_ **and** _a_ **or** _b_

here the condition is `i==position` which checks if we're drawing the step of the current position. if true, we use 15 (bright), otherwise 4 (dim).

## long live (parts of) the 80's

MIDI is still around and it's still fun. plug in a usb midi controller and get to the command line:

```lua
m = midi.connect()
m.event = function(data) tab.print(data) end
```

push a midi key and you'll see something like:

```
1    144
2    72
3    127
1    128
2    72
3    64
```

what? MIDI is a [series of bytes](http://www.gweep.net/~prefect/eng/reference/protocol/midispec.html) which need to be decoded to become useful. we've built some helpers into the library:

```lua
m.event = function(data) tab.print(midi.to_msg(data)) end
```

using `midi.to_msg` we see that (144,72,127) is converted to:

```
ch    1
vel    127
note    72
type    note_on
```

which makes more sense. so let's hook up a midi input to the PolyPerc engine:

```lua
engine.name = 'PolyPerc'

m = midi.connect()
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    engine.amp(d.vel / 127)
    engine.hz((440 / 32) * (2 ^ ((d.note - 9) / 12)))
  end
end
```

we set the engine amplitude to the key velocity (midi is 0-127, so we scale it 0-1), and then trigger a note. that's it! (we'll look at cleaning up that ugly `engine.hz` line later.) how do we get cc input? try adding this:

```lua
if d.type == "cc" then
  print("cc " .. d.cc .. " = " .. d.val)
end
```

you can also sort data by midi channel, ie `d.ch`. the types of midi that get turned into messages:

- `note_on`
- `note_off`
- `cc`
- `pitchbend`
- `key_pressure`
- `channel_pressure`

remember to use `tab.print(midi.to_msg(data))` for decoding any confusing midi input.

sending midi means sending out bytes. we can certainly send raw values:

```lua
m.send{144,60,127}
```

note the braces, as this is a syntax we haven't seen yet. it's equivalent to `m.send({144,60,127})`. if an argument is a single table, you can skip typing the parens.

this sends note on for note 60 at velocity 127 but it's much easier to use the helper function:

```lua
m:note_on(60,127)
```

here's a list of the helper functions for midi out:

- `:note_on(note,velocity,ch)`
- `:note_off(note,velocity,ch)`
- `:cc(cc,val,ch)`
- `:pitchbend(val,ch)`
- `:key_pressure(note,val,ch)`
- `:channel_pressure(val,ch)`

in each case, channel will default to 1 if left off. for note on/off, velocity is optional (100 will be used if none provided).

## keeping track of little boxes

*DEVICES* (currently grids and midi, but will be expanded in the future) use a virtual port system. physical devices are assigned to a virtual port via the **SYSTEM > DEVICES** menu. new devices are automatically assigned to remaining empty ports.

by default for grids and midi, when calling `connect()` with no argument, port 1 is used.

this means we can attach multiple devices (again, grids and midi both apply here) and set up multiple device tables for each:

```lua
keys = midi.connect(1)
ctrl = midi.connect(2)
transport = midi.connect(2)
```

with the sample setup above we could have a keyboard input on port 1, and a cc controller on port 2. these would each get their own `event` functions. but we also made a second device table for port 2, called `transport`. all three of these device tables will work at once. the idea behind the last case being: say you have some cut-paste code you want to use from another script for doing transport control (start/stop/cc). instead of hacking up your midi event functions, you can simply copy the entire unit and it will work alongside other connections to the same port.

port assignment can also happen at runtime, within a script. say we want to disable the keyboard input above:

```lua
keys:disconnect()
```

_NOTE_ the colon, not a period. `disconnect` leaves the device table `keys` floating without input or output connections.

```lua
keys:reconnect(2)
```

above, we've just re-assigned the `keys` table to port 2. these functions are useful if you want/need to do dynamic port switching: for example, selecting which midi port to use incoming midi sync. (which could easily be a PARAMETER).

lastly, a script may want to find out if a DEVICE is physically connected:

```lua
keys.attached()
```

this will return `true` or `false`, based on the physical device being attached or not.

## support your local library

in one of the above examples we use a complex transformation to turn a note number into a frequency (something we demonstrated in study 3). it's a pretty standard musical function, so @markeats put it in a library, and here's how we use it:

```lua
music = require 'musicutil'
hz = music.note_num_to_freq(60)
```

the library is imported with the `require` command, whereafter all of the functions within the library are available. check out the [norns function reference](https://norns.local/doc) for the default libraries (the libraries are in upper and lower case like `MusicUtil`). Additional user libraries are also available, but are maintained by individual users. See the lines [Library category](https://llllllll.co/c/library) for more.

## midi sync, Ableton Link, modular clocks

an often-used feature of midi is the ability to sync devices to a tempo. one device can send clock to another.

this is accomplished using a series of bytes: 248 (clock tick), 250 (clock start), 251 (clock continue), and 252 (clock stop).

instead of sorting these bytes out by hand, we can just use the global clock inside of norns, which has handlers built in for internal clocking as well as midi, Ableton Link, and clock signals through crow. the `CLOCK` menu is available in the `PARAMETERS` screen. see the [dedicated clock study](../clocks/) for more detail.

### source

this sets the sync source for the global tempo.

- `internal` sets norns as the clock source
- `midi` takes any external midi clock via connected USB midi devices
- `link` enables ableton link sync for the connecting wifi network
- `crow` takes sync from input 1 of a connected crow device

link has a `link quantum` parameter to set the quantum size.

crow additionally has a `crow in div` parameter to specify the number of sub-divisions per beat.

the `tempo` parameter sets the internal and link tempos. this tempo will be automatically updated if set by an external source (midi, crow, or remote link device).

you can set the tempo in your script by the normal method of setting parameters:

```lua
params:set("clock_tempo",100)
```

### out

clock signals can be transmitted via midi or crow.

`midi out` sets the port number (which midi device, via SYSTEM > DEVICES) on which to transmit.

`crow out` sets the output number, and also has a `crow out div` setting for beat subdivisions.

## example: physical

putting together concepts above. this script is demonstrated in the video up top.

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
beatclock = require 'beatclock'

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
  clock.run(count)
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

## continued

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: physical
- part 5: [streams](../study-5/) // system polls, osc, file storage

## community

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to this study welcome, see [monome/docs](http://github.com/monome/docs)
