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

- Install seamstress on your computer: [GitHub](https://github.com/ryleelyman/seamstress/#installation)
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

`g = grid.connect()` creates a device table `g`, which inherits a collection of methods (demarcated with `:`) and functions designed to handle grid communication. We use *methods* to send commands to the grid and we use *functions* to parse what comes back.

### key input

The `g` device table has callback *functions* for what happens when you push a key. We can assign an action to any grid key press, where `x` and `y` are the coordinates (1-indexed) and `z` is the keypress state (down: `1`, up: `0`):

```lua
function g.key(x, y, z)
  -- do something with x, y and z
end
```

### LED output

In our example script, we use two *methods* to light up the grid:

- `g:led(x, y, val)`, where `x` and `y` are the coordinates (1-indexed) and `val` is the brightness (whole numbers from `0` to `15`)
- `g:refresh()`, which draws any `:led` command to the connected grid

If we're simply interested in displaying presses, this is fine enough. But for scripts where we want to display more layers of information, this approach of directly addressing and redrawing each individual LED isn't very efficient. Let's improve upon our approach in the next section!

## 2. Further

Now we'll show how basic grid applications are developed by creating a step sequencer. We will add features incrementally:

- Use all the rows above the last two as toggles. We *could* assume this is the first 6 rows, but since grid sizes can vary (eg. zero's have 16 rows and 16 columns), we'll write our code to be adaptable to any canvas.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end. Again, we'll write this to be adaptable to both 64's (with 8 columns) and 128/256's (with 16 columns).
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.

### Structure {#structure}

Moving forward, we'll refresh the grid display on a timer, which will later also serve as the play head. We also want to ensure two things are true about our application:

- the action should start when a grid is plugged in for the first time
- if the grid is disconnected, the action should continue without error

Below is the basic structure that facilitates this criteria:

```lua
-- grid studies: seamstress
-- grid-study-2-1.lua

g = grid.connect(1) -- '1' is technically optional.
-- without an argument, seamstress will always connect to the first-registered grid.

function init()
  playhead = clock.run(play)
  grid_dirty = true
  grid_redraw = metro.init(
    draw_grid, -- function to execute
    1/60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  grid_redraw:start() -- start the timer
  if g then
    cols = g.cols
    rows = g.rows
    grid_connected = true
  else
    cols = 16
    rows = 8
    grid_connected = false
  end
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
    clock.sync(1/4)
    -- perform actions
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

So, we have our boilerplate -- let's take things further by building a bank of toggles for the sequencer.

## 3.1 Toggles {#toggles}

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
    play_position = util.wrap(play_position+1,1,cols)
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

When the playhead advances to a new column we want something to happen which corresponds to the toggled-on values. We'll do two things: we'll show separate visual feedback on the grid in the second-to-last (trigger) row, and we'll print something to the command line.

Drawing the trigger row happens entirely in the `draw()`:

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
      -- trigger bar
      local trig_bar = sequencer_rows + 1
      g:led(x, trig_bar, 4)
      -- // NEW

      for y = 1, sequencer_rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end
    end

    -- NEW //
    for y = 1, sequencer_rows do
      local trig_bar = sequencer_rows+1
      if step[y][play_position] == 1 then
        g:led(play_position, trig_bar, 15)
      end
    end
    -- // NEW
    
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end

```

First we create a dim glow underneath our sequencer canvas with level `4`. Then we search through the `step` array at the current play position, showing a bright (level 15) indicator for each *on* state. This displays a sort of horizontal correlation of the "channel"'s current state.

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
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end
```

Which references `trigger()`:

```lua
function trigger(i)
  screen.clear()
  screen.move(math.random(256), math.random(128))
  screen.color(math.random(255), math.random(255), 255)
  screen.circle(i * 10)
  screen.circle_fill(i * 5)
  screen.refresh()
end
```

This could of course do something much more exciting, such as generate MIDI notes, animate robot arms, set off fireworks, etc.


<!--## Closing

We've created a minimal yet intuitive interface for rapidly exploring sequences. We can intuitively change event triggers, loop points, and jump around the data performatively. Many more features could be added, and there are numerous other ways to think about interaction between key press and light feedback in completely different contexts.

### Suggested exercises

- If you have access to a 256 grid, try adapting the 3.x patches to accommodate this larger size.
- Display the loop range with dim LED levels.
- "Record" keypresses in the "trigger" row to the toggle matrix.
- Display the playhead position as a dim column behind the toggle data.
- Use the rightmost key in the "trigger" row as an "alt" key.
	- If "alt" is held while pressing a toggle, clear the entire row.
	- If "alt" is held while pressing the play row, reverse the direction of play.

### Bonus

See `grid-studies-3-5.maxpat` for a JavaScript implementation of this patch.

## Credits

*Max* was originally designed by Miller Puckette and is actively developed by [Cycling '74](http://cycling74.com).

This tutorial was created by [Brian Crabtree](https://nnnnnnnn.org) and maintained by [Dan Derks](https://dndrks.com) for [monome.org](https://monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail `help@monome.org`.
-->