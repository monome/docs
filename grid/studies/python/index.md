---
layout: default
nav_exclude: true
redirect_from: /grid-studies/python/
---

# Grid Studies: Python

Python is a widely used general-purpose, high-level programming language. Its design philosophy emphasizes code readability, and its syntax allows programmers to express concepts in fewer lines of code than would be possible in languages such as C++ or Java. The language provides constructs intended to enable clear programs on both a small and large scale. (from [Wikipedia](http://en.wikipedia.org/wiki/Python_(programming_language)))

## Prerequisites

This tutorial assumes a basic familiarity with the Python langauge and its programing workflow. If you're very new to Python, check out the [Python Tutorial](https://docs.python.org/3/tutorial/).

This tutorial has been updated to reflect changes in **Python 3.11.1**. For the previous **Python 3.5** tutorial, [click here](https://github.com/monome/docs/blob/1c564edfc2986177452df34144820267b9a57b9c/grid/studies/python/index.md). See [python.org](https://www.python.org/) for downloads and more information about different versions.

Once Python is installed, you can install the *pymonome* library through your terminal of choice by executing: `pip3 install pymonome`

Download the code examples here: [github.com/monome/grid-studies-python/releases/latest](https://github.com/monome/grid-studies-python/releases/latest)

## 1. Connect and Basics {#connect}

*See grid-studies-1.py for this section.*

```python
#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.GridApp):
    def __init__(self):
        super().__init__()

    def on_grid_key(self, x, y, s):
        print("key:", x, y, s)
        self.grid.led_level_set(x, y, s * 15)

async def main():
    loop = asyncio.get_running_loop()
    grid_studies = GridStudies()

    def serialosc_device_added(id, type, port):
        print('connecting to {} ({})'.format(id, type))
        asyncio.ensure_future(grid_studies.grid.connect('127.0.0.1', port))

    serialosc = monome.SerialOsc()
    serialosc.device_added_event.add_handler(serialosc_device_added)

    await serialosc.connect()
    await loop.create_future()

if __name__ == '__main__':
    asyncio.run(main())
```

The *pymonome* library simplifies communication with the grid by communicating directly with serialosc. For a detailed description of how the serialosc mechanism and protocol work, see [the serialosc protocol docs](/docs/serialosc/osc/).

Note that the preceding example consists of two parts. First, we describe the class `GridStudies`, which inherits `monome.GridApp`. This class defines the behavior and properties of our grid-based application. Next, we set up the *serialosc* client, instantiate the application, and start the main loop.

Python programs using `asyncio` require explicitly starting the event loop, so creating the loop is actually the first step our program takes:

```python
	loop = asyncio.get_running_loop()
```

Next, we create the application instance:

```python
	grid_studies = GridStudies()
```

In the next lines we define a callback to execute when serialosc detects a monome device. In this example the callback prints the device type and connects the grid port of the application to the newly discovered device. Note that opening a connection to the grid is an *asynchronous* operation. The `grid.connect` method returns a _coroutine_, so we can't call it directly. Instead, we schedule the coroutine execution using `asyncio.ensure_future()`:

```python
def serialosc_device_added(id, type, port):
	print('connecting to {} ({})'.format(id, type))
	asyncio.ensure_future(grid_studies.grid.connect('127.0.0.1', port))
```

The next step is to create a serialosc client and attach the callback for new devices:

```python
serialosc = monome.SerialOsc()
serialosc.device_added_event.add_handler(serialosc_device_added)
```

The next line establishes a connection to serialosc, which is also an asynchronous operation. We'll use Python's `await` keyword to wait for this connection to be established:

```python
await serialosc.connect()
```

Then, we [create a Future object](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.create_future) for our loop:

```python
await loop.create_future()
```

After the loop is started in the script's final two lines, the library connects the first discovered device to our `GridStudies` object which is the primary definition of this application.

For additional information on the 'name-main' idiom employed in the final two lines of all the study scripts, [see this article](https://realpython.com/if-name-main-python/)

Let's take a look at our application class:

```python
class GridStudies(monome.GridApp):
	def __init__(self):
		super().__init__()
```

The constructor here simply calls the parent constructor without arguments. Because there is no additional code in the constructor, it can be omitted entirely, but we still have it declared in case we'll want to add some additional initialization logic to the application later.

### 1.1 Key Input {#key-input}

The library calls the method `on_grid_key()` upon receiving input from the grid. It has three parameters.

    x : horizontal position (0-15)
    y : vertical position (0-7)
    s : state (1 = key down, 0 = key up)

Below we define the key function and simply print out incoming data.

```python
def on_grid_key(self, x, y, s):
	print("key:", x, y, s)
```

### 1.2 LED Output {#led-output}

`GridStudies` is inherited from `monome.GridApp` which is a base class for grid-based applications. It exposes the grid via the `grid` property so we can actually do something with the hardware, such as setting an LED value by calling `self.grid.led_level_set()`.

```python
self.grid.led_level_set(x, y, s * 15)
```

Here we send a new LED update per key event. Since `s` is either 0 or 1, when we multiply it by 15 we get off or full brightness. We set the LED location according to the position incoming key press, `x` and `y`.

If we're simply interested in displaying presses, this is fine enough. But for scripts where we want to display more layers of information, this approach of directly addressing and redrawing each individual LED isn't very efficient. Let's improve upon our approach in the next section!

## 2. Further {#further}

Now we'll show how basic grid applications are developed by creating a step sequencer. We will add features incrementally:

- Use all the rows above the last two as toggles. We *could* assume this is the first 6 rows, but since grid sizes can vary (eg. 256's have 16 rows and 16 columns), we'll write our code to be adaptable to any canvas.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end. Again, we'll write this to be adaptable to both 64's (with 8 columns) and 128/256's (with 16 columns).
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.

### Structure {#structure}

Moving forward, we'll refresh the grid display on a timer, which will later also serve as the play head. We also want to ensure a few things are true about our application:

- the action should start when a grid is plugged in for the first time
- if the grid is disconnected, the action should continue without error
- variables managed by the grid should persist for the application's life, even if the grid connection is lost (like when changing applications or hot-swapping to another device)

Below is the basic structure that facilitates this criteria:

```python
#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.GridApp):
    def __init__(self):
        super().__init__()
        # .. initialize other instance variables ..
        self.width = 0
        self.height = 0
        # build a task to further the action:
        self.play_task = asyncio.ensure_future(self.play())

    # when grid is plugged in via USB:
    def on_grid_ready(self):
        # .. update instance variables ..
        self.width = 0
        self.height = 0
        self.connected = True
        # draw our interface:
        self.draw()

    # when grid is physically disconnected:
    def on_grid_disconnect(self, *args):
        self.connected = False

    async def play(self):
        while True:
            await asyncio.sleep(0.1)
            # .. perform actions ..
            self.draw()

    def on_grid_key(self, x, y, s):
        # .. define grid press action ..

    def draw(self):
        buffer = monome.GridBuffer(self.width, self.height)

        # .. change display state ..

        # update grid
        if self.connected:
            buffer.render(self.grid)
```

`on_grid_ready` and `on_grid_disconnect` are two callback functions built into the *pymonome* library, which respond when a grid is physically connected or disconnected to the host computer.

We establish `self.connected` so we can use the grid's connected state as a variable for other parts of our script.

### Schedule, Process, Display {#schedule-process-display}

In our application's initialization, we schedule `play()` for execution using `self.play_task = asyncio.ensure_future(self.play())`,

The body of the `while True:` loop within the `play` function will be executed every `0.1` seconds. `self.draw()` is where we refresh the grid display.

Key presses will be processed as they come in:

```python
def on_grid_key(self, x, y, s):
        # .. define grid press action ..
```

Finally, we'll use a subclass called `GridBuffer` for managing the display state. This section creates a buffer based on grid size (which is queried and stored as `width` and `height` in our `on_grid_ready` function):

```python
def draw(self):
	buffer = monome.GridBuffer(self.width, self.height)
```

Instead of updating single LEDs at a time, we'll draw the entire grid and then render that to the hardware at the end of our `draw` function:

```python
# update grid
if self.connected:
    buffer.render(self.grid)
```

Buffer-based rendering is *much* more efficient than addressing LEDs directly, because it collects individual LED messages into a single `map` array, which refreshes the display by 8x8 quadrants. For a 16x8 grid, two `buffer`-collected `map` messages takes the place of 128 individual `self.grid.led_level_set` messages.

Let's begin by building a bank of toggles for the sequencer.

### 2.1 Toggles {#toggles}

*See grid-studies-2-1.py for this section.*

First we'll establish what should happen when a grid is connected, via `on_grid_ready()`:

```python
# when grid is plugged in via USB:
def on_grid_ready(self):
    self.width = self.grid.width
    self.height = self.grid.height
    self.sequencer_rows = self.height-2
    self.connected = True
    self.draw()
```

- we create instance variables for `width`, `height`, and `sequencerRows`, which will determine the range of keys which can be toggled
- we assign `sequencerRows ` to the height of the grid, excepting the last two rows
- we track the grid's connected state with `connected`
- we redraw the grid interface

On key input we'll look for key-down events in every row besides the last two, log their state, and draw the LED display:

```python
def on_grid_key(self, x, y, s):
    # toggle steps
    if s == 1 and y < self.sequencer_rows:
        self.step[y][x] ^= 1
        self.draw()
```

Inside of `draw()`, we build the LED display from scratch each time we need to refresh. Below we simply copy the `step` data to the `led` array, doing the proper multiplication by 11 in order to get almost-full brightness. Note that we're initializing `buffer` on each redraw, which gives us a blank canvas. This'll be useful later on, when we want to display our playhead's movements.

```python
def draw(self):
    buffer = monome.GridBuffer(self.width, self.height)

    # display steps
    for x in range(self.width):
        for y in range(self.sequencer_rows):
            buffer.led_level_set(x, y, self.step[y][x] * 11)

    # update grid
    if self.connected:
        buffer.render(self.grid)
```

That'll get us started.

### 2.2 Play {#play}

*See grid-studies-2-2.py for this section.*

On each iteration inside `play()` we wait for `0.1` seconds to pass before we increment `play_position` to move onto the next step. This value must be wrapped to 0 if it's at the end.

```python
async def play(self):
    while True:
        await asyncio.sleep(0.1)

        if self.play_position == self.width - 1:
            self.play_position = 0
        else:
            self.play_position += 1

        if self.connected:
            self.draw()
```

In `draw`, we add highlighting for the play position:

```python
# display steps
for x in range(self.width):
    # highlight the play position
    if x == self.play_position:
        highlight = 4
    else:
        highlight = 0

    for y in range(self.sequencer_rows):
        buffer.led_level_set(x, y, self.step[y][x] * 11 + highlight)
```

While copying steps to the grid in a loop, we check if we're updating a column that is the play position. If so, we increase the highlight value. By adding this value during the copy we'll get a nice effect of an overlaid translucent bar.

### 2.3 Triggers {#triggers}

*See grid-studies-2-3.py for this section.*

When the playhead advances to a new column we want something to happen which corresponds to the toggled-on values. We'll do two things: we'll show separate visual feedback on the grid in the second-to-last (trigger) row, and we'll print something to the command line.

Drawing the trigger row happens entirely in the `draw()`:

```python
# draw trigger bar and on-states
for x in range(self.width):
    buffer.led_level_set(x, self.sequencer_rows, 4)

for y in range(self.sequencer_rows):
    if self.step[y][self.play_position] == 1:
        buffer.led_level_set(self.play_position, self.sequencer_rows, 15)
```

First we create a dim glow underneath our sequencer canvas with level `4`. Then we search through the `step` array at the current play position, showing a bright indicator for each *on* state. This displays a sort of horizontal correlation of the "channel"'s current state.

For the screen drawing, we create a function `trigger()` which gets passed values of activated steps. This is what we do, inside `play()` right after we change `play_position`:

```python
# TRIGGER SOMETHING
for y in range(self.sequencer_rows):
    if self.step[y][self.play_position] == 1:
        self.trigger(y)
```

Which references `trigger()`:

```python
def trigger(self, i):
    print("triggered", i)
```

This could of course do something much more exciting, such as generate MIDI notes, animate robot arms, set off fireworks, etc.

### 2.4 Dynamic Cuts {#dynamic-cuts}

*See grid-studies-2-4.py for this section.*

We will now use the bottom row to dynamically cut the playback position. First let's add a position display underneath our sequencer canvas, which will be inside `draw()`:

```python
# draw play position
buffer.led_level_set(self.play_position, self.sequencer_rows+1, 15)
```

Now we look for key presses in the last row, in the `on_grid_key` function:

```python
# cut
elif y == height-1: # want 0-index!
	# cut
	if s == 1:
		self.cutting = True
		self.next_position = x
```

We've added two variables, `cutting` and `next_position`. Check out the changed code where we check the timer:

```python
async def play(self):
    while True:
        await asyncio.sleep(0.1)
        
        if self.cutting:
            self.play_position = self.next_position
        elif self.play_position == self.width - 1:
            self.play_position = 0
        else:
            self.play_position += 1
```

Now, when pressing keys on the bottom row it will cue the next position to be played.

### 2.5 Loop {#loop}

*See grid-studies-2-5.py for this section.*

Lastly, we'll implement setting the loop start and end points with a two-press gesture: pressing and holding the start point, and pressing an end point while still holding the first key. We'll need to add a variable to count keys held, one to track the last key pressed, and variables to store the loop positions.

```python
def on_grid_ready(self):
    # ...
    self.loop_start = 0
    self.loop_end = self.width - 1
    self.keys_held = 0
    self.key_last = 0
```

We count keys held on the bottom row thusly:

```python
# cut and loop
elif y == self.height-1:
    self.keys_held = self.keys_held + (s * 2) - 1
    ...
```

By multiplying `s` by 2 and then subtracting one, we add one on a key down and subtract one on a key up.

We'll then use the `keys_held` counter to do different actions:

```python
# cut
if s == 1 and self.keys_held == 1:
    self.cutting = True
    self.next_position = x
    self.key_last = x
# set loop points
elif s == 1 and self.keys_held == 2:
    self.loop_start = self.key_last
    self.loop_end = x
```

We then modify the position change code:

```python
async def play(self):
    while True:
        await asyncio.sleep(0.1)

        if self.cutting:
            self.play_position = self.next_position
        elif self.play_position == self.width - 1:
            self.play_position = 0
        elif self.play_position == self.loop_end:
            self.play_position = self.loop_start
        else:
            self.play_position += 1
```

Done!


## Closing

### Suggested Exercises

- Repurpose the `on_grid_disconnect` method to stop playback and reset variables when the grid is disconnected.
- "Record" keypresses in the "trigger" row to the toggle matrix.
- Display the loop range on the bottom row of the grid.
- Use the rightmost key in the "trigger" row as an "alt" key.
    - If "alt" is held while pressing a toggle, clear the entire row.
    - If "alt" is held while pressing the play row, reverse the direction of play.

## Credits

Python was designed by Guido van Rossum and is maintained by the [Python Software Foundation](https://python.org).

*pymonome* was written and is maintained by [Artem Popov](https://github.com/artfwo/pymonome).

This tutorial was created by [Brian Crabtree](http://nnnnnnnn.org) and [Dan Derks](https://dndrks.com) for [monome.org](https://monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail [help@monome.org](mailto:help@monome.org).
