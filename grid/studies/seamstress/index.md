---
layout: default
nav_exclude: true
redirect_from: /grid-studies-seamstress/
---

# Grid Studies: seamstress

seamstress is a Lua scripting environment for musical communication. It was inspired by [norns](/docs/norns) and makes use of its [scripting API](/docs/norns/reference), but it is **not** a port of the norns environment. Generally, though, seamstress is a fantastic complement to the norns scripting experience, as it has many syntactical similarities and many of the same scripting libraries.

This tutorial will show the basics of interfacing with seamstresss and the grid -- including how a simple, yet immediate sequencer platform can be made with a small amount of code.

## Prerequisites

This study assumes a basic understanding of Lua. If you're absolutely new to Lua it may be helpful to first go through some of [the resources listed in our norns documentation](/docs/norns/studies/#learning-lua).

Required:

- Install [seamstress's dependencies](https://github.com/ryleelyman/seamstress/#installation)
- Install seamstress by either:
  - [downloading a prebuilt binary via GitHub](https://github.com/ryleelyman/seamstress/releases)
  - using [homebrew](https://brew.sh/):  
    `brew tap ryleelyman/seamstress`  
    `brew install seamstress`
  - [building from source](https://github.com/ryleelyman/seamstress/#building-from-source)
- Install serialosc: [/docs/serialosc/setup](/docs/serialosc/setup)
- Download the code examples here: [files/grid-studies-seamstress.zip](files/grid-studies-seamstress.zip)

### Running Examples

seamstress is run from the terminal by executing the command `seamstress`. If it is not given any filename, seamstress looks for and runs a file called `script.lua` in either the current directory or in `~/seamstress/`.

For our purposes, we'll change directories to the code example folder you downloaded above and invoke seamstress by passing it script names, eg:

```bash
cd grid-studies-seamstress/files
seamstress grid-studies-1
```

## 1. Connect + Basics

*See [grid-studies-1.lua](files/grid-studies-1.lua) for this section.*

```lua
-- grid studies: seamstress
-- invoke with: seamstress grid-studies-1

g = grid.connect()

function g.key(x,y,z)
  g:led(x, y, z * 15)
  g:refresh()
end
```

To get started:

- connect a grid to your computer
- open a terminal window
- `cd` to your `grid-studies-seamstress/files` folder
- invoke `seamstress grid-studies-1`

This script is a very basic example of how to:

- connect a grid to seamstress
- parse that grid's key presses
- redraw the grid's LEDs

As you press keys on your grid, you'll see them light up for as long as they're held.

### connection

`g = grid.connect()` creates a device table `g`, which inherits a collection of methods (demarcated with `:`) and functions designed to handle grid communication. For grid, we'll use *methods* to send commands to the grid and we use *functions* to parse what comes back.

### key input

The `g` device table has callback *functions* for what happens when you push a key. We can assign an action to any grid key press, where `x` and `y` are the coordinates (1-indexed) and `z` is the keypress state (down: `1`, up: `0`):

```lua
function g.key(x, y, z)
  -- do something with x, y and z
end
```

### LED output

In our example script, we use two *methods* to light up the grid:

- `g:led(x, y, val)` queues an LED for drawing, where `x` and `y` are the coordinates (1-indexed) and `val` is the brightness (whole numbers from `0` to `15`)
- `g:refresh()`, which draws any queued LED to the connected grid

If we're simply interested in displaying presses, this is fine enough. But for scripts where we want to display more layers of information, this approach of directly addressing and redrawing each individual LED isn't very efficient. Let's improve upon our approach in the next section!

## 2. Building a script {#scripting}

When you first approach writing a grid-enabled script in seamstress, it can be helpful to start with a basic structure that has a few different components:

- how you want to handle grid presses + releases
- a methodology for drawing grid LEDs
- what, if anything, you want to happen when a grid is connected or removed
- a timing mechanism (or two!)

Moving forward, we'll refresh the grid display on a timer, which will also serve as the playhead later on.

### 2.1 Basic script {#basic-script}

Below is a basic script that facilitates this structure:

```lua
-- grid studies: seamstress
-- grid-study-2.lua

g = grid.connect(1) -- '1' is technically optional.
-- without an argument, seamstress will always connect to the first-registered grid.

function init()
  if g then
    cols = g.cols
    rows = g.rows
    grid_connected = true
  else
    cols = 16
    rows = 8
    grid_connected = false
  end

  playhead = clock.run(play)
  grid_dirty = true
  grid_redraw = metro.init(
    draw_grid, -- function to execute
    1 / 60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  grid_redraw:start() -- start the timer
  
end

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  grid_connected = true
end

function grid.remove(dev)
  grid_connected = false
end

function play()
  while true do
    -- perform actions
    clock.sync(1 / 4)
    grid_dirty = true
  end
end

function g.key(x, y, z)
  -- define grid keypress action
  grid_dirty = true
end

function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
```

`grid.add` and `grid.remove` are two callback functions built into seamstress, which respond when a grid is physically connected or disconnected to the host computer. The `dev` table each function returns holds the following information:

- `cols` and `rows` for the grid
- `id` of the grid (also printed at script boot)
- `port` the grid is connected to
- `name` and `serial` of the grid

So we can write a responsive interface for our step sequencer, we establish a few variables:

- `cols`, which we'll use to set the maximum number of steps
- `rows`, which we'll to set the maximum number of tracks
- `grid_connected`, which we'll use to query whether there's a grid to communicate with

### Schedule, Process, Display {#schedule-process-display}

In our script's `init`, we schedule two functions to be executed at regular intervals.

#### clock

The first is done with the `clock` library, which allows tempo-synced scheduling:

```lua
playhead = clock.run(play)

[...]

function play()
  while true do
    -- perform actions
    grid_dirty = true
    clock.sync(1/4)
  end
end
```

In `play`, we perform our actions and then sync to the clock at a quarter pulse (which is a 1/16th note in 4/4).

#### metro

The second is done with the `metro` library, which allows scheduling with high-accuracy timers:

```lua
grid_redraw = metro.init(
  draw_grid, -- function to execute
  1/60, -- how often (here, 60 fps)
  -1 -- how many times (here, forever)
)
grid_redraw:start() -- start the timer
[...]

function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
```

Since we want the grid to draw at a steady 60 frames-per-second, we opt for the higher-resolution `metro`, rather than the 'musical timing' `clock`.

### 2.2 Add something to the screen {#screen}

Let's add a very small indicator to the screen which tells us whether a grid is connected or not:

```lua
-- NEW //
function redraw()
  screen.clear()
  screen.move(10, 10)
  screen.color(255, 255, 255, 255) -- RGBA, A is optional
  screen.text("grid connected: " .. tostring(grid_connected))
  screen.refresh()
end
-- // NEW

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  grid_connected = true
  redraw() -- NEW
end

function grid.remove(dev)
  grid_connected = false
  redraw() -- NEW
end
```

So, we have our boilerplate -- let's take things further by building a bank of toggles for the sequencer.

## 3. Making a step sequencer {#step}

To show how basic grid-enabled seamstress scripts are developed, let's create a step sequencer. We will add features incrementally:

- Use all the rows above the last two as toggles. We *could* assume this is the first 6 rows, but since grid sizes can vary (eg. zero's have 16 rows and 16 columns), we'll write our code to be adaptable to any canvas.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end. Again, we'll write this to be adaptable to both 64's (with 8 columns) and 128/256's (with 16 columns).
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.

### 3.1 Toggles {#toggles}

*See [grid-studies-3-1.lua](files/grid-studies-3-1.lua) for this section.*

We use our `cols` and `rows` variables to determine the range of keys which can be toggled. We use `rows` to assign `sequencer_rows` to the height of the grid, excepting the last two rows. This occurs at script initialization and whenever the grid is connected (in case it happens after the script is running).

On key input we'll look for key-down events in every row besides the last two, log their state, and draw the LED display:

```lua
function g.key(x, y, z)
  -- NEW //
  if z == 1 and y <= sequencer_rows then
    -- when step value is 0, set it to 1 ; when step value is 1, set it to 0
    step[y][x] = math.abs(step[y][x] - 1)
  end
  -- // NEW
  grid_dirty = true
end
```

Inside of `draw_grid()`, we build the LED display from scratch each time we need to refresh. Below we simply iterate the `step` data to the grid LEDs, doing the proper multiplication by 11 in order to get almost-full brightness. 

```lua
function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs:
    -- NEW //
    for x = 1, cols do
      for y = 1, rows do
        g:led(x, y, step[y][x] * 11)
      end
    end
    -- // NEW
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
```

That'll get us started.

### 3.2 Play {#play}

*See [grid-studies-3-2.lua](files/grid-studies-3-2.lua) for this section.*

On each iteration inside `play()` we execute our action and wait for a sixteenth note to pass before we increment `play_position` and move onto the next step. This value must be wrapped to 1 if it's at the end.

```lua
function play()
  while true do
    -- perform actions
    -- NEW //
    play_position = util.wrap(play_position + 1, 1, cols)
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end
```

In `draw_grid()`, we add highlighting for the play position:

```lua
function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs:
    for x = 1, cols do
      -- NEW //
      local highlight
      if x == play_position then
        highlight = 4
      else
        highlight = 0
      end
      for y = 1, rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end
      -- // NEW
    end
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end

```

While iterating over the steps in a loop, we check if we're updating a column that is the play position. If so, we increase the highlight value. By adding this value during the iteration we'll get a nice effect of an overlaid translucent bar.

### 3.3 Triggers {#triggers}

*See [grid-studies-3-3.lua](files/grid-studies-3-3.lua) for this section.*

When the playhead advances to a new column we want something to happen which corresponds to the toggled-on values. We'll do two things: we'll draw in our bottom row (reserved for jumping around the sequence later), and we'll print something to the command line.

Drawing the jump bar on the grid happens entirely in the `draw()`:

```lua
function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs
    -- display steps:
    for x = 1, cols do
      local highlight
      if x == play_position then
        highlight = 4
      else
        highlight = 0
      end
      
      -- NEW //
      -- jump row
      local jump_row = sequencer_rows + 1
      g:led(x, jump_row, 4)

      -- sequencer rows:
      for y = 1, sequencer_rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end
      
      -- // NEW
    end
    
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end

```

First we create a dim glow underneath our sequencer canvas with level `4`. Then we adjust the way our sequencer's rows redraw.

For the screen drawing, we create a function `trigger()` which gets passed values of activated steps. This is what we do, inside `play()` right after we change `play_position`:

```lua
function play()
  while true do
    -- perform actions
    play_position = util.wrap(play_position + 1, 1, cols)
    -- NEW //
    for y = 1,rows do
      if step[y][play_position] == 1 then
        trigger(y)
      end
    end
    screen_dirty = true
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end
```

Which references `trigger()`, where we queue a circle to be displayed with every 'note' event:

```lua
function trigger(i)
  table.insert(circle_queue,{
    x = math.random(256),
    y = math.random(128),
    r = math.random(40,190),
    g = math.random(255),
    b = math.random(128,255),
    outer_radius = i*10,
    inner_radius = i*5
  })
end
```

This `circle_queue` then gets iterated through and emptied out in our `redraw`:

```lua
function redraw()
  if screen_dirty then
    screen.clear()
    for k,v in pairs(circle_queue) do
      screen.move(v.x, v.y)
      screen.color(v.r, v.g, v.b)
      screen.circle(v.outer_radius)
      screen.circle_fill(v.inner_radius)
    end
    circle_queue = {}
    screen_dirty = false
    screen.refresh()
  end
end
```

Each 'step' could of course do something much more exciting -- animate robot arms, set off fireworks, etc. For now, we'll have to settle for generating MIDI notes and drawing colorful circles (though, they're much more fun than plain white text).

### 3.4 MIDI {#midi}

*See [grid-studies-3-4.lua](files/grid-studies-3-4.lua) for this section.*

seamstress's MIDI library is quite similar to norns -- there are virtual ports which handle MIDI connections, to which you can send and receive raw + formatted data.

Using MIDI in a script follows a pretty straightforward recipe:

We start with `my_midi_var = midi.connect(x)`, where `x` represents one of seamstress's 32 virtual ports (`1` is the built-in seamstress in/out port, which is useful for inter-application MIDI). From there, we can send different commands, eg:

- `my_midi_var:note_on(note,vel,ch)` to send a 'note on' message
- `my_midi_var:note_off(note,vel,ch)` to send a 'note off' message
- `my_midi_var:cc(cc,val,ch)` to send a MIDI cc

[More commands are listed in the API](https://ryleealanza.org/docs/modules/midi.html).

For this revision, we'll load [the `musicutil` library](https://ryleealanza.org/docs/modules/lib.MusicUtil.html) using the variable `MU`, which provides utilities for building musical scales. Then, we'll connect to the first virtual port and build up our parameters to control our musical scale:

```lua
-- NEW //
-- we'll connect to virtual port 1, which is seamstress's MIDI device:
m = midi.connect(1)
-- for a more robust example of MIDI scaffolding,
--   check out the 'hello_midi' example!

active_notes = {} -- to keep track of 'note on' messages, for paired 'note off'

-- build scales for quantized note selection:
scale_names = {}
for i = 1, #MU.SCALES do
  table.insert(scale_names, string.lower(MU.SCALES[i].name))
end

params:add_control(
  "root_note", -- scripting ID
  "root note", -- UI name
  controlspec.new(0, 127, "lin", 1, 72, nil, 1 / 127), -- controlspec
  function(param) -- UI formatter
    return MU.note_num_to_name(param:get(), true)
  end
)
params:set_action("root_note", function()
  build_scale()
end)
params:add_option("scale", "scale", scale_names, 5)
params:set_action("scale", function()
  build_scale()
end)

-- important! since our script relies on the output of our parameter actions,
--   we'll want to fire them off in the init:
params:bang()
-- // NEW
```

You may have noticed that we assigned our parameters' actions to `build_scale()`. This is a helper function which builds two octaves of note data from our root note, in our selected scale. We define this function further down:

```lua
function build_scale()
  all_notes = MU.generate_scale(params:get("root_note"), params:get("scale"), 2)
  screen_dirty = true
end
```

Now that we've created a scale, let's add some MIDI note activity to `trigger()`:

```lua
-- NEW //
local maximum_count = sequencer_rows + 1
local note = all_notes[maximum_count - i]
m:note_on(note, 127, 1)
table.insert(active_notes, note)
-- // NEW
```

In the above, we:

- get the note at the inverted index of the triggered row (so the note at row 1 is our *highest* note)
- send the note to our midi device (notice velocity is 127 and channel is 1 -- these can be adjusted!)
- add the 'note on' to our `active_notes` table so we can turn it off later

Let's schedule our 'note off' in the downtime right before the next step:

```lua
function play()
  while true do
    -- perform actions
    play_position = util.wrap(play_position + 1, 1, cols)
    for y = 1,rows do
      if step[y][play_position] == 1 then
        trigger(y)
      end
    end
    screen_dirty = true
    clock.sync(1 / 4)

    -- NEW //
    for active = 1, #active_notes do
      m:note_off(active_notes[active], nil, 1)
    end
    active_notes = {}
    -- // NEW

    grid_dirty = true
  end
end
```

As the sequencer runs, it automatically turns off the notes held during each step. Looking ahead, though, there's a chance we might close seamstress before this note off mechanism is able to execute. To ensure that all notes are turned off when we quit seamstress, we'll take advantage of the `cleanup` callback, which executes at every script exit:

```lua
-- NEW //
function all_notes_off()
  m:cc(123, 1)
  active_notes = {}
end

function cleanup()
  all_notes_off()
  g:all(0)
  g:refresh()
end
-- // NEW
```

### 3.5 dynamic cuts {#dynamic-cuts}

*See [grid-studies-3-5.lua](files/grid-studies-3-5.lua) for this section.*

We will now use the bottom row to dynamically cut the playback position. First let's add a position display underneath our sequencer canvas, inside of `draw_grid()`:

```lua
-- NEW //
-- draw play position
g:led(play_position, rows, 15)
-- // NEW
```

Now we look for key presses in the last row, in the `on_grid_key` function. We've added two variables, `cutting` and `next_position`:

```lua
-- NEW //
-- grid presses on bottom row cut playhead:
elseif y == rows and z == 1 then
  cutting = true
  next_position = x
-- // NEW
```

Now, when pressing keys on the bottom row it will cue the next position to be played.

### 3.6 loop {#loop}

*See [grid-studies-3-6.lua](files/grid-studies-3-6.lua) for this section.*

Lastly, we'll implement setting the loop start and end points with a two-press gesture: pressing and holding the start point, and pressing an end point while still holding the first key. We'll need to add a variable to count keys held, one to track the last key pressed, and variables to store the loop positions.

```lua
-- NEW //
keys_held = 0
key_last = 0
loop_start = 1
loop_end = cols
-- // NEW
```

To count keys held on the bottom row, we'll multiply each keypress (where `z` is `1` for down and `0` for up) by 2 and subtract 1 from it -- so we add one on a key down, subtract one on a key up:

```lua
-- NEW //
elseif y == rows then
  keys_held = keys_held + (z * 2) - 1
  ...
```

We'll then use the `keys_held` counter to do different actions:

```lua
-- cut:
if z == 1 and keys_held == 1 then
  cutting = true
  next_position = x
  key_last = x
-- set loop:
elseif z == 1 and keys_held == 2 then
  loop_start = key_last
  loop_end = x
end
```

We then modify the position-change code:

```lua
-- NEW //
--  press + hold to set loop points!
elseif y == rows then
  keys_held = keys_held + (z * 2) - 1
  -- cut:
  if z == 1 and keys_held == 1 then
    cutting = true
    next_position = x
    key_last = x
  -- set loop:
  elseif z == 1 and keys_held == 2 then
    loop_start = key_last
    loop_end = x
  end
  -- // NEW
end
```

## 4. Transport {#transport}

*See [grid-studies-4.lua](files/grid-studies-4.lua) for this section.*

As a bonus round, let's extend our script by:

- adding transport controls so we can start and stop our sequencer
- tying incoming transport start/stop messages to the script's sense of place and time

### adding transport actions {#transport-actions}

If you're used to highly-structured Digital Audio Workstations, then you might be looking for ways to create meaningful 'start' and 'stop' functionality within a seamstress script.

The clock in seamstress, like norns, is *always-on*. You can reset it back to 0, but you cannot turn it off. This allows for a lot of freedom, but if you're writing a pretty straightforward step sequencer like the one in this study, you'll want to be able to start and stop the action. To do this, we introduce a `transport` function which manages our playhead's state, position, and anything else that we want to occur at the sequencer's 'start' or 'stop':

```lua
-- here, we define what a 'start' and 'stop' mean for this script:
function transport(action)
  if action == "start" then
    playhead = clock.run(play)
    grid_dirty = true
    screen_dirty = true
  elseif action == "stop" then
    if playhead ~= nil then
      clock.cancel(playhead)
    end
    -- reset play position:
    play_position = 0

    -- release any held notes:
    all_notes_off()

    -- redraw interfaces:
    grid_dirty = true
    screen_dirty = true
  end
end
```

We'll also give ourselves a little parameter UI entry:

```lua
-- NEW //
params:add_binary(
  "transport_control", -- ID
  "start/stop", -- display name
  "toggle", -- type
  0 -- default
)

params:set_action("transport_control", function(x)
  if x == 1 then
    if params:string("clock_source") == "internal" then
      clock.internal.start()
    else
      transport("start")
    end
  else
    transport("stop")
  end
end)
-- // NEW
```

### transport callbacks {#transport-callbacks}

There are two system-level callbacks which can be assigned in your script to perform specific actions whenever the seamstress clock receives a 'start' and 'stop' message: `clock.transport.start` and `clock.transport.stop`.

```lua
-- this is a system callback, which executes whenever seamstress's
--   clock receives a 'transport start' message
function clock.transport.start()
  params:set("transport_control", 0) -- stop our sequencer
  params:set("transport_control", 1, true) -- flip transport UI in params
  -- ^ 'true' at the end means 'silent', which doesn't trigger the action
  transport('start') -- start our sequencer
end

-- this is a system callback, which executes whenever seamstress's
--   clock receives a 'transport stop' message
function clock.transport.stop()
  params:set("transport_control", 0) -- stop our sequencer
end
```

## Closing

We've created a minimal yet intuitive interface for rapidly exploring sequences. We can intuitively change event triggers, loop points, and jump around the data performatively. Many more features could be added, and there are numerous other ways to think about interaction between key press and light feedback in completely different contexts.

### Suggested exercises

- Display the loop range with dim LED levels.
- "Record" keypresses in the "jump" row.
- Use the rightmost key in the "jump" row as an "alt" key.
  - If "alt" is held while pressing a toggle, clear the entire column.
  - If "alt" is held while pressing the play row, reverse the direction of play.

## Credits

seamstress was developed and designed by [Rylee Lyman](https://ryleealanza.org/), inspired by [*matron* from norns](https://github.com/monome/norns/tree/main/matron/src). *matron* was written by [`@catfact`](https://github.com/ryleelyman/seamstress). norns was initiated by [`@tehn`](https://github.com/tehn).

This tutorial was created by [Dan Derks](https://dndrks.com) for [monome.org](https://monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail `help@monome.org`.