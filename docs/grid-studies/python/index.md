---
layout: page
permalink: /docs/grid-studies/python/
---

# Grid Studies: Python

By design the monome grid does nothing on its own. You the user assign it purpose and meaning: instrument, experiment, tool, toy... choose your own adventure. This grid is *intended* to be reimagined. Here we set forth to impart some introductory knowledge: potential energy for radical creative freedom.

Python is is a widely used general-purpose, high-level programming language. Its design philosophy emphasizes code readability, and its syntax allows programmers to express concepts in fewer lines of code than would be possible in languages such as C++ or Java. The language provides constructs intended to enable clear programs on both a small and large scale. (from [Wikipedia](http://en.wikipedia.org/wiki/Python_(programming_language)))

## Prerequisites

This tutorial assumes a basic familiarity with the Python langauge and its programing workflow. If you're very new to Python, check out the [Python Tutorial](https://docs.python.org/3/tutorial/).

Python 3.4 is required. See [python.org](https://www.python.org/). Python 3.3 with the `asyncio` module will also work.

Install asyncio (for Python 3.3): `pip3 install asyncio`

Install pymonome: `pip3 install pymonome`

Download the code examples here: [files/grid-studies-python.zip](files/grid-studies-python.zip)

## 1. Connect and Basics

*See grid-studies-1.py for this section.*

```python
#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.Monome):
    def __init__(self):
        super().__init__('/monome')

    def grid_key(self, x, y, s):
        print("key:", x, y, s)
        self.led_level_set(x, y, s*15)

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    asyncio.async(monome.create_serialosc_connection(GridStudies))
    loop.run_forever()
```

The `pymonome` library simplifies communication with the grid.

Here the first monome device found is attached, the important line being within the `__main__` code towards the bottom:

```python
asyncio.async(monome.create_serialosc_connection(GridStudies))
```

The library queries *serialosc* and connects the first found device to our class `GridStudies` which is the primary definition of this application.

For a detailed description of how the *serialosc* mechanism and protocol work, see [monome.org/docs/tech:osc](http://monome.org/docs/tech:osc).

We initialize our class:

```python
class GridStudies(monome.Monome):
    def __init__(self):
        super().__init__('/monome')
```

The only argument specifies the *prefix* (in this case, `/monome`) which is attached to all OSC messages exchanged with serialosc. For most cases we simply use `/monome` as a default.

### 1.1 Key input

The library calls the function `grid_key()` upon receiving input from the grid. It has three parameters.

    x : horizontal position (0-15)
    y : vertical position (0-7)
    s : state (1 = key down, 0 = key up)

Below we define the key function and simply print out incoming data.

```python
def grid_key(self, x, y, s):
    print("key:", x, y, s)
```

### 1.2 LED output

We can set an LED value with the `led_level_set()` function. Below we set (0,0) to full brightness (15).

```python
self.led_level_set(x, y, s*15)
```

Here we send a new LED update per key event. Since `s` is either 0 or 1, when we multiply it by 15 we get off or full brightness. We set the LED location according to the position incoming key press, x and y.

## 2. Further

Now we'll show how basic grid applications are developed by creating a step sequencer. We will add features incrementally:

- Use the top six rows as toggles.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end.
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.

### 2.1 Structure

We will have grid display refresh on a timer, which will later also serve as the play head. Below is the basic structure that our code will fit into:

```python
def ready(self):
    # ...
    asyncio.async(self.play())

@asyncio.coroutine
def play(self):
    while True:
        # ...
        self.draw()
        yield from asyncio.sleep(0.1)
```

The while loop within the `play()` function will be executed every `0.1` seconds. `self.draw()` is where we refresh the grid display.

Key data will be processed as it comes in.

Furthermore, we'll use a subclass called `LedBuffer` for managing the display state. This section creates a buffer based on grid size:

```python
def ready(self):
    self.buffer = monome.LedBuffer(self.width, self.height)
```

Instead of updating single LEDs at a time, we'll draw the entire grid and then render that to the hardware:

```python
# update grid
buffer.render(self)
```

First let's make a bank of toggles for the sequencer.

### 2.1 Toggles

*See grid-studies-2-1.py for this section.*

First we'll create a new array called `step` that can hold 6 rows of step data, inside `ready()`:

```python
self.step = [[0 for col in range(self.width)] for row in range(6)]
```

On key input we'll look for key-down events in the top six rows:

```python
def grid_key(self, x, y, s):
    # toggle steps
    if s == 1 and y < 6:
        self.step[y][x] ^= 1
        self.draw()
```

We will build the LED display from scratch each time we need to refresh. This will be done inside of `draw()`. Below we simply copy the `step` data to the `led` array, doing the proper multiplication by 11 in order to get almost-full brightness. Also note that we initialize `buffer` on each redraw, which gives us a blank canvas.

```python
def draw(self):
    buffer = monome.LedBuffer(self.width, self.height)

    # display steps
    for x in range(self.width):
        for y in range(6):
            buffer.led_level_set(x, y, self.step[y][x] * 11)
```

That'll get us started.

### 2.2 Play

*See grid-studies-2-2.py for this section.*

On each iteration inside `play()` we process the next step, which in this case simply means incrementing `play_position`. This value must be wrapped to 0 if it's at the end.

```python
def play(self):
    while True:
        if self.play_position == self.width - 1:
            self.play_position = 0
        else:
            self.play_position += 1
```

The playback rate is controlled by the time interval between `play()` iterations:

```python
yield from asyncio.sleep(0.1)
```

For the redraw we add highlighting for the play position:

```python
# display steps
for x in range(self.width):
    # highlight the play position
    if x == self.play_position:
        highlight = 4
    else:
        highlight = 0

    for y in range(6):
        buffer.led_level_set(x, y, self.step[y][x] * 11 + highlight)
```

During this loop which copies steps to the grid, we check if we're updating a column that is the play position. If so, we increase the highlight value. By adding this value during the copy we'll get a nice effect of an overlaid translucent bar.

### 2.3 Triggers

*See grid-studies-2-3.py for this section.*

When the playhead advances to a new row we want something to happen which corresponds to the toggled-on rows. We'll do two things: we'll show separate visual feedback on the grid in the second-to-last (trigger) row, and we'll print something to the command line.

Drawing the trigger row happens entirely in the `draw()`:

```python
# draw trigger bar and on-states
for x in range(self.width):
    buffer.led_level_set(x, 6, 4)

for y in range(6):
    if self.step[y][self.play_position] == 1:
        buffer.led_level_set(self.play_position, 6, 15)
```

First we create a dim row (level 4 is fairly dim). Then we search through the `step` array at the current play position, showing a bright indicator for each on state. This displays a sort of horizontal correlation of rows (or "channels") 1-6 current state.

For the screen drawing, we create a function `trigger()` which gets passed values of activated steps. This is what we do, inside `draw()` right after we change `play_position`:

```python
# TRIGGER SOMETHING
for y in range(6):
    if self.step[y][self.play_position] == 1:
        self.trigger(y)
```

And then `trigger()` itself:

```python
def trigger(self, i):
    print("triggered", i)
```

This could of course be something much more exciting-- MIDI notes, robot arms, explosions, etc.

### 2.4 Cutting

*See grid-studies-2-4.py for this section.*

We will now use the bottom row to dynamically cut the playback position. First let's add a position display to the last row, which will be inside `draw()`:

```python
# draw play position
buffer.led_level_set(self.play_position, 7, 15)
```

Now we look for key presses in the last row, in the `grid_key` function:

```python
# cut
elif y == 7:
    # cut
    if s == 1:
        self.cutting = True
        self.next_position = x
```

We've added two variables, `cutting` and `next_position`. Check out the changed code where we check the timer:

```python
def play(self):
    while True:
        if self.cutting:
            self.play_position = self.next_position
        elif self.play_position == self.width - 1:
            self.play_position = 0
        else:
            self.play_position += 1
```

Now, when pressing keys on the bottom row it will cue the next position to be played.

### 2.5 Loop

*See grid-studies-2-5.py for this section.*

Lastly, we'll implement setting the loop start and end points with a two-press gesture: pressing and holding the start point, and pressing an end point while still holding the first key. We'll need to add a variable to count keys held, one to track the last key pressed, and variables to store the loop positions.

```python
def ready(self):
    ...
    self.loop_start = 0
    self.loop_end = self.width - 1
    self.keys_held = 0
    self.key_last = 0
```

We count keys held on the bottom row thusly:

```python
self.keys_held = self.keys_held + (s * 2) - 1
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
def play(self):
    while True:
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

### Suggested Excercises

- "Record" keypresses in the "trigger" row to the toggle matrix.
- Display the loop range on the bottom row of the grid.
- Use the rightmost key in the "trigger" row as an "alt" key.
    - If "alt" is held while pressing a toggle, clear the entire row.
    - If "alt" is held while pressing the play row, reverse the direction of play.

    
## Credits

Python was designed by Guido van Rossum and is maintained by the [Python Software Foundation](python.org).

*pymonome* was written and is maintained by [Artem Popov](https://github.com/artfwo/pymonome).

This tutorial was created by [Brian Crabtree](http://nnnnnnnn.org) for [monome.org](monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/grid-studies-python](https://github.com/monome/grid-studies-python) or e-mail [info@monome.org](mailto:info@monome.org).
