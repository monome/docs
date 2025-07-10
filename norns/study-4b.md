---
layout: default
nav_exclude: true
permalink: /norns/study-4b/
---

# physical tangent: arc
{: .no_toc }

norns studies part 4b: arc

*Note: if you do not wish to script for arc, you can return to [part 4: physical](/docs/norns/study-4/) without worry.*

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
- **decoupling**: The fundamental design principle of arc, where LEDs are independent from the physical interaction of encoder turns and keypresses  -- this allows arc to (for example) display a cycling position while also allowing you to influence the speed at which that cycling progresses.
- **coroutine**: A powerful concept in Lua, coroutines execute an event in collaboration with other processes. With norns, you'll mainly use coroutines for clock-based events -- to collaborate with the main clock process, which can be driven by internal clock, MIDI, Ableton Link, or a modular synth via [crow](/docs/crow).

## tactile numbers

It's finally time to turn hardware interaction into piles of numbers, and numbers into light. Plug in a monome arc and clear any currently running script (hold **K1** on the `SELECT / SYSTEM / SLEEP` menu and, while holding **K1**, press **K3** when `CLEAR` appears).

Let's start off with the command line to introduce the basics:

```lua
>> a = arc.connect()
```

This creates a device table `a`,  which has a collection of methods (demarcated with `:`) and functions (demarcated with `.`) designed to handle arc + norns communication. We'll use methods to send commands to arc and we use functions to parse what comes back.

Let's light things up with two methods, `:led` and `:refresh`:

```lua
>> a:led(1,1,15)
>> a:refresh()
```

You'll see the north-most LED on the first ring go to full brightness.

If you have an arc plugged in and this didn't work, check **SYSTEM > DEVICES > ARC** and make sure your arc is attached to port 1 (more on this later).
{: .label .label-grey}

The arc device table also has callback functions for what happens when you turn an encoder (known as a 'delta'). Let's assign an action to any encoder turn:

```lua
>> a.delta = function(n,d) print(n,d) end
```

You'll now see the `n` and `d` of each encoder turn print to maiden's REPL, where `n` is the encoder identifier and d is the direction. Notice that gentle turns yield small deltas, and more robust turns yield larger deltas. Let's put these basic things together for something slightly more inspiring.

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
-- study 4b
-- code exercise
-- tactile numbers: arc

a = arc.connect()
position = {1,17,33,49}

a.delta = function(n,d)
  -- each encoder turn increments/decrements its position
  position[n] = position[n] + d
  -- wrap position to the 64 LED range:
  if position[n] >= 65 then
    position[n] = 1
  elseif position[n] <= 0 then
    position[n] = 64
  end
  redraw_arc()
end

function redraw_arc()
  a:all(0)
  for i = 1,#position do
    a:led(i, position[i], 15)
  end
  a:refresh()
end

function init()
  redraw_arc()
end
```

Behold, arc is simply lighting up an LED in response to encoder changes. Boring, perhaps, but the road to exciting things is paved with boring things.

Note:

- `a:all(val)` sets the level of every LED on every ring to a provided value. In our example, we're using it to clear all the rings by providing an argument of `0`.
- `a:led(ring, led, val)` sets the level of a specific LED on a specific ring. In our example, we're using it to draw the current position.
- `a.delta` is a callback function which reports which encoder has been turned and in which direction. Nudges will provide deltas of +/- 1, while larger turns will delta larger values.
 
Now, let's _do_ something with our position changes.

### expanding: notes {#expanding-notes}

Let's try adding some sound to these interactions! Maybe when the position of our tick crosses over at 12:00, we'll strike a tone. Since we're already separating clockwise and counter-clockwise movement, we can also specify different notes for each direction.

Clear any previous code in the editor and start anew with:

```lua
-- study 4b
-- tactile numbers: arc
-- expanding: notes

engine.name = 'PolyPerc'
MU = require 'musicutil'

a = arc.connect()

position = {62, 62, 62, 62}
cw_hz = MU.note_nums_to_freqs({67, 70, 74, 77})
ccw_hz = MU.note_nums_to_freqs({62, 65, 69, 72})

a.delta = function(n,d)
  position[n] = position[n] + d
  -- when moving CW:
  if position[n] >= 65 then
    position[n] = 2
    engine.hz(cw_hz[n])
  -- when moving CCW:
  elseif position[n] <= 1 then
    position[n] = 64
    engine.hz(ccw_hz[n]) -- drop a fifth
  end
  redraw_arc()
end

function redraw_arc()
  a:all(0)
  for i = 1,#position do
    a:led(i, 1, 5)
    a:led(i, position[i], 15)
  end
  a:refresh()
end

function init()
  engine.release(2)
  redraw_arc()
end
```

Behold! We have eight notes which trigger when any 'playhead' passes our 'north' position.

Note:

- We draw a low-level marker for this with `a:led(i, 1, 5)`.
- We never allow the 'playhead' to occupy the north position, forcing it either behind or ahead to simulate a 'pluck'.

This is a very simple and fun interaction, so what if we want to automate our play?

### expanding: cycle {#expanding-cycle}

Let's take this decoupling a step further by allowing our encoder turns to cycle independently:

```lua
-- study 4b
-- tactile numbers: arc
-- expanding: cycle

engine.name = 'PolyPerc'
MU = require 'musicutil'

a = arc.connect()

speed = {0,0,0,0} -- NEW
position = {950,950,950,950} -- NEW

cw_hz = MU.note_nums_to_freqs({67, 70, 74, 77})
ccw_hz = MU.note_nums_to_freqs({62, 65, 69, 72})

a.delta = function(n,d)
  speed[n] = util.clamp(speed[n] + d/8, -48, 48)
end

function redraw_arc()
  a:all(0)
  for i = 1,#position do
    -- NEW: draw a segment for each 'playhead'
    local degree = (360/1024) * position[i]
    a:segment(i, math.rad(degree-10), math.rad(degree+10), 10)
    a:led(i, 1, 5)
  end
  a:refresh()
end

function init()
  engine.release(2)
  clock.run(tick)
end

-- NEW: 30fps tick to change position
function tick()
  while true do
    for i = 1,4 do
      position[i] = position[i] + speed[i]
      if position[i] >= 1025 then
        position[i] = 2
        engine.hz(cw_hz[i])
      elseif position[i] <= 1 then
        position[i] = 1024
        engine.hz(ccw_hz[i]) -- drop a fifth
      end
    end
    redraw_arc()
    clock.sleep(1/30)
  end
end
```

New things:

- We're using the full 1024-step resolution of arc to tune our interactions a bit and to draw an anti-aliased window around our 'playhead'.
- Our 'playhead' window is drawn with `a:segment(ring, from, to, level)`, which accepts radians for `from` and `to`. In-between values will automatically fade the LEDs, giving a very clean look. Note that if we want any additional LEDs drawn to the ring, we must draw them on top of the segment.
- We repurpose our encoder turns to set a `speed` variable for each ring, which is then added to each encoder's `position` value on a 30 frame-per-second `tick`. This is performed by a `clock` (more below).

#### clocks

norns has a [global clocking system](/docs/norns/control-clock/#clock), which affords internal + external clocking mechanisms, including MIDI, [crow](/docs/crow), and Ableton Link. Since there's an [extended study on scripting with clocks](/docs/norns/clocks), we won't go too deep here, but in our code above we cover a few basics to get you started.

At the end of our `init`, `clock.run(tick)` begins a clock coroutine which executes a function named `tick`.

```lua
function tick()
  while true do
    for i = 1,4 do
      position[i] = position[i] + speed[i]
      if position[i] >= 1025 then
        position[i] = 2
        engine.hz(cw_hz[i])
      elseif position[i] <= 1 then
        position[i] = 1024
        engine.hz(ccw_hz[i]) -- drop a fifth
      end
    end
    redraw_arc()
    clock.sleep(1/30)
  end
end
```

Note:

- The first line (`while true do`) simply loops the enclosed action
- The last line (`clock.sleep(1/30)`) is a seconds-based synchronization. It instructs to clock to hold its execution for the amount of time specified. Since we want 30 frames-per-second, we pass the argument `1/30`, which means the loop will wait 1/30 of a second before it refreshes.

## example: cycles (with key) {#example-cycle-key}

Our final example adds key interaction using the `a.key` callback function, which reports which key is pressed and its state (`1`/`0` for down/up)

Note:

- 2025 arc has one key (reporting as key `1`)
- 2011 arc has a key built into each encoder (reporting as keys `1` through `4`)
- 2012, 2016, and 2019 arcs do not have any keys

Let's add friction to our cycling for as long as the key is held. If you have a four-button arc, any key will execute our `a.key` function. If you don't have a push-button arc at all, try mapping the function to key 3 on norns.

```lua
-- study 4b
-- tactile numbers: arc
-- expanding: cycle (with key)

engine.name = 'PolyPerc'
MU = require 'musicutil'

a = arc.connect()

brake = false -- NEW
friction = 0.9 -- NEW
notch_level = {5,5,5,5} -- NEW

speed = {0,0,0,0}
position = {950,950,950,950}

cw_hz = MU.note_nums_to_freqs({67, 70, 74, 77})
ccw_hz = MU.note_nums_to_freqs({62, 65, 69, 72})

a.delta = function(n,d)
  speed[n] = util.clamp(speed[n]+d/8, -48, 48)
end

-- NEW: keypress!
a.key = function(n,z)
  brake = z == 1
end

function redraw_arc()
  a:all(0)
  for i = 1,#position do
    local degree = (360/1024) * position[i]
    a:segment(i, math.rad(degree-10), math.rad(degree+10), notch_level[i])
    a:led(i, 1, notch_level[i])
    notch_level[i] = 5
  end
  a:refresh()
end

function init()
  engine.release(2)
  clock.run(tick)
end

function tick()
  while true do
    for i = 1,4 do
      -- NEW:
      if brake then speed[i] = speed[i] * friction end
      
      position[i] = position[i] + speed[i]
      if position[i] >= 1025 then
        position[i] = 2
        engine.hz(cw_hz[i])
        notch_level[i] = 15
      elseif position[i] <= 1 then
        position[i] = 1024
        engine.hz(ccw_hz[i]) -- drop a fifth
        notch_level[i] = 15
      end
    end
    redraw_arc()
    clock.sleep(1/30)
  end
end
```

## reference
### norns-specific
- `arc` -- module to manage messages to/from a connected monome arc and send LED state data, see [`arc` API docs](../api/modules/arc) for detailed usage
- `musicutil` -- library to perform standard musical functions, see [`MusicUtil` API docs](../api/modules/lib.MusicUtil.html) for detailed usage
- `util` -- library to perform common utility functions, see [`Util` API docs](../api/modules/lib.util.html) for detailed usage

### general
- `require` -- a higher-level function, see [Lua docs](https://www.lua.org/pil/8.1.html) for more details but suffice to say you only need to use `require` when running and loading norns libraries outside of your script's folder (like we did with `musicutil`). When loading from inside of your script's folder, use `include`. See the `libraries` section of [the extended reference](/docs/norns/reference/#libraries) for more detail.

## continued
{: .no_toc }

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids, MIDI, clock syncing
  - part 4b: physical tangent: arc
- part 5: [streams](../study-5/) // system polls, OSC, file storage
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).