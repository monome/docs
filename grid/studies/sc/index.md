---
layout: default
nav_exclude: true
redirect_from: /grid-studies/sc/
---

# grid studies: SuperCollider
{: .no_toc }

SuperCollider is an environment and programming language for real time audio synthesis and algorithmic composition. It provides an interpreted object-oriented language which functions as a network client to a state of the art, realtime sound synthesis server.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## prerequisites

- install [`serialosc`](/docs/serialosc/setup)
- [download SuperCollider](https://supercollider.github.io/)
- [download this study's code examples](files/grid-studies-sc.zip)
- [download the `monomeSC` library](https://github.com/monome/monomeSC/releases/latest)

If you're new to SuperCollider, it will be *very* beneficial to work through the 'Getting Started' tutorial which is within SuperCollider's help file documentation ([also on their docs site](https://doc.sccode.org/Tutorials/Getting-Started/00-Getting-Started-With-SC.html)).

### clearing conflicts {#clear}

As you go through each study, you'll find it useful to stop the running code so your grid presses don't have conflicting actions:

- macOS: <kbd>Command</kbd> + <kbd>.</kbd>
- Windows / Linux: <kbd>Ctrl</kbd> + <kbd>.</kbd>

[See the SuperCollider docs for more info.](https://doc.sccode.org/Guides/SCIde.html#Evaluating%20code)

## library setup {#setup}

To install the `monomeSC` SuperCollider library for monome grid devices:

- download + unzip the [latest release](https://github.com/monome/monomeSC/releases/latest) of `monomeSC`
- in SuperCollider, select `File > Open user support directory`
- move or copy the `monomeSC` folder into the `Extensions` folder
  - if `Extensions` does not exist, please create it
- in SuperCollider, recompile the Class Library (`Language > Recompile Class Library`)
  - macOS: <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>
  - Windows / Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>

## 1. connect

### grid connection

After setting up the library, connect your grid to your computer and boot SuperCollider.

As SuperCollider boots up, it initializes the `MonomeGrid` class, which is how we get grids and SuperCollider to communicate. `MonomeGrid` indexes device connections as they occur, so if you try to script for a grid which hasn't yet been connected, SuperCollider will let you know in the Post Window:

```js
WARNING: no monome grid detected at device slot <i>
```

If you run into this message, simply connect a grid and you'll see it acknowledged in the Post Window:

```js
MonomeGrid device added to port: 17675
MonomeGrid serial: m46674021
MonomeGrid model: monome 128
```
You should now be able to re-run your script without issue!

If you have any other troubles communicating with your grid from SuperCollider, quickly recompiling the Class Library should solve the issue:

- macOS: <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>
- Windows / Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>

### initial contact

The `MonomeGrid` class facilitates easy communication with grids, modeled after the [norns scripting API](/docs/norns/reference/grid).

Let's create a variable, `~m`, to initialize the `MonomeGrid` class:

```js
~m = MonomeGrid.new(rotation: 0, prefix: "/monome", fps: 60);
```

- The `rotation: 0` argument to the initializer is *grid rotation*. If none is provided, `MonomeGrid` will assume 0 rotation. Check out the `MonomeGrid` help file for additional rotation options!
- The `prefix: "/monome"` argument is a nickname we can use to alias this script's grid, instead of relying on serial numbers. If none is provided, it will be assigned `"/monome"`.
- The `fps: 60` argument specifies the *frames per second* which the grid will redraw. If none is provided, it will be assigned `60`.

Now that the class is initialized to a variable, let's connect to a grid:

```js
~m.connect(0);
```

Here, our script connects to the first monome grid device that was physically attached to our device (SuperCollider Lists and Arrays are 0-indexed, so device `0` is the first one). If no device number is provided, `MonomeGrid` will connect to the first grid device it finds.

Please note that there needs to be a slight delay in between initializing the new device and connecting to it. Waiting until the server starts provides the necessary time buffer:

```js
(
~m = MonomeGrid.new(rotation: 0, prefix: "/monome", fps: 60);

s.waitForBoot({
	~m.connect(0);
});
)
```

The library communicates with *serialosc* to discover attached devices using OSC. For a detailed description of how the mechanism and protocol work, see [the serialosc technical docs](/docs/serialosc/osc/) and [grid serial reference](/docs/serialosc/serial.txt) -- please note that neither of these documents are required for this study, but they _are_ good background for creating your own grid communication libraries.

### query

Once connected, our script's instance of `MonomeGrid` has some individual attributes we can query. In these examples, we'll use `~m` to illustrate:

- `~m.serial`: this grid's serial number
- `~m.rows`: this grid's row count (1-indexed)
- `~m.cols`: this grid's column count (1-indexed)
- `~m.dvcnum`: this grid's assigned device number (0-indexed)
- `~m.prefix`: this grid's assigned prefix
- `~m.port`: this grid's assigned OSC port
- `~m.rotation`: this grid's assigned rotation
- `~m.fps`: this grid's assigned refresh rate


We can also query `MonomeGrid` directly:

- `MonomeGrid.getConnectedDevices`: returns the serial numbers of each device that's been connected since the Server started
- `MonomeGrid.getPortList`: returns the OSC ports of each device that's been connected since the Server started
- `MonomeGrid.getPrefixes`: returns the assigned prefixes of each device that's been connected since the Server started

We can also refresh the list of devices that have been connected since the Server started with `MonomeGrid.refreshConnections`.


## 2. basics {#basics}

*See [grid-studies-2-1.scd](files/grid-studies-2-1.scd) for this section.*

![](images/grid-studies-sc-2.png)

### 2.1 key input {#key-input}

We read grid key input by utilizing the `key` method. Three parameters are received, in order:

```js
x : horizontal position (cartesian coordinates, 0-indexed)
y : vertical position (cartesian coordinates, 0-indexed)
z : state (1 = key down, 0 = key up)
```

In [grid-studies-2-1.scd](files/grid-studies-2-1.scd) we define the function to simply print out incoming data:

```js
(
Server.default = Server.local;

// MonomeGrid accepts three arguments:
// * rotation (0 is default)
// * prefix (a string nickname for this grid)
// * fps (frames per second)

~m = MonomeGrid.new(rotation: 0, prefix: "/monome", fps: 60);

s.waitForBoot({

	~m.connect(0); // 0 (or not supplying any argument) means the first-connected device

	~m.key({
		arg x,y,z;
		[x,y,z, "serial: " ++~m.serial,"port: "++~m.port].postln;
	});

});

)
```

### 2.2 LED output {#led-output}

Updating a single LED takes the form:

```js
~m.led(x, y, val)
```

Where `val` ranges from 0 (off) to 15 (full brightness), with variable levels in between.

To toggle a single LED to on or full bright, with no in-between values:

```js
~m.ledset(x, y, state);
```

Where `state` ranges from 0 (off) to 1 (full brightness).

### 2.3 coupled interaction {#coupled-interaction}

*See [grid-studies-2-3.scd](files/grid-studies-2-3.scd) for this step.*

Instead of printing the key output, we can show the key state on the grid quite simply. [Stop your running code](#clear) and execute:

```js
(
Server.default = Server.local;

~m = MonomeGrid.new();

s.waitForBoot({

	~m.connect();

	~m.key({
		arg x,y,z;
		~m.led(x,y,z*15);
	});

});

)
```

### 2.4 decoupled interaction {#decoupled-interaction}

*See [grid-studies-2-4.scd](files/grid-studies-2-4.scd) for this step.*

Decoupled interaction means drawing LED state independent of physical contact with any of the keys. The most basic decoupled interaction is a toggle.

We turn the grid into a huge bank of toggles by creating an [Array](https://doc.sccode.org/Classes/Array.html) to store data. It needs to be the same size as our grid, so we'll use the `cols` and `rows` accessors to gather our grid size. We'll call this array `step` and initialize it full of zeros.

```js
~step = Array.fill(~m.cols * ~m.rows, {0});
```

We refresh the grid with function `draw` (a variable we establish toward the start of the `grid-studies-2-4.scd`):

```js
draw = { arg x, y;
	~m.led(x,y,~step[y*16+x] * 15);
};
```

In `draw`, we set LED level for the toggled position -- we multiply the `~step` value per position by 15 which gives us 0 (off) or 15 (full brightness).

We'll also use our incoming grid messages to set the corresponding `step` LED states, which are sent to our `draw` function with `draw.value(x,y)`:

```js
~m.key({ arg x,y,z;
	if(z == 1, {
		var pos = x + (y*16);
		if(~step[pos] == 1,
			{~step[pos] = 0},
			{~step[pos] = 1}
		);
		draw.value(x,y);
	});
});
```

Remember, `z` is the key state (down or up), so we do something only on key down (where `z == 1`). We calculate the position, and then change the value of the `step` based on its previous state.

## 3. further {#further}

Now we'll show how basic grid applications are developed by creating a step sequencer. We will add features incrementally:

- Use the top six rows as toggles.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end.
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.


### 3.1 toggles {#toggles}

*See [grid-studies-3-1.scd](files/grid-studies-3-1.scd) for this step.*

We already have a full bank of toggles set up. Let's shrink down the bank to exclude the bottom two rows. We'll first reduce `step`, then we'll adjust the key detection so toggling only happens if `y` is outside of the bottom two rows:

```js
~m.key({ arg x,y,z;
	if((z == 1) && (y < (rows-2)), {
		var pos = x + (y * 16);
		if(~step[pos] == 1,
			{~step[pos] = 0},
			{~step[pos] = 1}
		);
		draw.value(x,y);
	});
});
```

That will get us started.

### 3.2 play {#play}

*See [grid-studies-3-2.scd](files/grid-studies-3-2.scd) for this step.*

To make our interface adaptive to any size grid (eg. we don't want to count to 16 steps on 64 grid with 8 columns), we can query the number of rows and columns with the `rows` and `cols` accessors. We'll set that up as a callback for added devices with:

```js
MonomeGrid.setAddCallback({
		arg serial, port, prefix;
		("grid was added: " ++ serial ++ " " ++ port ++ " " ++ prefix).postln;
		if( serial == MonomeGrid.getConnectedDevices[0], {
			cols = ~m.cols;
			rows = ~m.rows;
		});
	});
```

However, you might've noticed that these methods return 1-indexed numbers. Since most of our SuperCollider functions will be 0-indexed, let's make it easy on ourselves and introduce 0-indexed versions of our row and column totals at the top:

```js
// 'cols' + 'rows' return as 1-indexed,
// but we need 0-indexed for most of our functions!
~lastCol = cols-1;
~lastRow = rows-1;
```

Now, let's get into fun stuff!  
Let's make a timer routine that moves a virtual playhead across the grid (we declare a `timer` variable toward the start of the sketch):

```js
timer = Routine({
	var interval = 0.125;
	loop {
		~play_position = (~play_position + 1).wrap(0,~lastCol);
		draw.value;
		interval.yield;
	}
});
```

This routine runs at a timing interval specified by the variable `interval`. The `play_position` is advanced, rolling back to 0 after it hits the last column (using SuperCollider's helpful `.wrap(lo, hi)` method). We redraw the grid each time the play head moves.

For the redraw we add highlighting for the play position. Note how `led`'s previous multiplication by 15 has been decreased to 11, to provide another mid-level brightness. We now have a series of brightness levels helping to indicate playback, lit keys, and currently active keys:

```js
draw = {
	var highlight;
	for(0,~lastCol, {arg x;
		if(x == ~play_position,
			{highlight = 4},
			{highlight = 0});
		
		// show playhead
		for(0,~lastRow-2, {arg y;
			~m.led(x,y,(~step[y*16+x] * 11) + (highlight));
		});
	})
};
```

As we copy steps to the grid, we check if we're updating a column that is the play position (`if(x == ~play_position,`...). If so, we set the highlight value to 4. By adding this value inside of `led`, we'll get a nice effect of an overlaid translucent bar.

### 3.3 triggers {#triggers}

*See [grid-studies-3-3.scd](files/grid-studies-3-3.scd) for this step.*

When the playhead advances to a new column, we want something to happen which corresponds to the toggled-on steps. Let's do two things: show separate visual feedback on the grid in the second-to-last row (we'll call it a 'trigger row'), and make some sound.

Drawing the trigger row happens in `draw`, at `// show triggers`:

```js
draw = {
	var highlight;
	for(0,~lastCol, {arg x;
		if(x == ~play_position,
			{highlight = 4},
			{highlight = 0});
		
		// show playhead
		for(0,~lastRow-2, {arg y;
			~m.led(x,y,(~step[y*16+x] * 11) + (highlight));
		});
		
		// set trigger row background
		~m.led(x,~lastRow-1,4);
	});
	
	// show triggers
	for(0,~lastRow-2, {arg t;
		if(~step[(t*16) + ~play_position] == 1,
			{~m.led(t,~lastRow-1,15);}
		);
	});
};
```

In the snippet above:

- we create a dim row (level 4 is fairly dim)
- we search through the `step` array at the current play position, showing a bright indicator for each on state
- this displays a sort of horizontal correlation of rows (or "channels"), with the topmost at far left

If the channel is toggled on, we then trigger the Synth (which we defined at the start of our file), inside of `timer`:

```js
// TRIGGER SOMETHING
for(0,~lastRow-2, {arg t;
	if(~step[(t*16) + ~play_position] == 1,
		{
			Synth(\singrain, [
				freq: (5-t) * 100 + 300,
				amp: rrand(0.1, 0.5),
				sustain: interval * 0.8
			]);
			
		}
	)
});
```

If any vertical toggle in `step` is toggled on (`== 1`) at the `play_position` we trigger a sound. The frequency corresponds to the row position.

### 3.4 dynamic cuts {#dynamic-cuts}

*See [grid-studies-3-4.scd](files/grid-studies-3-4.scd) for this step.*

We will now use the bottom row to dynamically cut the playback position.  

First, we clear the last row:

```js
// clear play position row
~m.led(x,~lastRow,0);
```

And a few lines later, we add a position display to the last row:

```js
// show play position
~m.led(~play_position,~lastRow,15);
```

We look for key presses in the last row, in the key function:

```js
~m.key({ arg x,y,z;
	if((z == 1) && (y <= (~lastRow-2)), {
		var pos = x + (y * 16);
		if(~step[pos] == 1,
			{~step[pos] = 0},
			{~step[pos] = 1}
		);
	});
	
	// cut to a new position
	if((z== 1) && (y == ~lastRow), {
		~next_position = x;
		~cutting = 1;
	});
});
```

We've added two global variables, `cutting` and `next_position`. Check out the changed code where we check the cut position inside our step timer:

```js
if(~cutting == 1,
	{~play_position = ~next_position; ~cutting = 0;},
	{~play_position = (~play_position + 1).wrap(0,~lastCol);}
);
```

Now, pressing keys on the bottom row will cue the next position to be played. Note that we set `cutting = 0` after each cut so that each press only affects the timer **once**.

### 3.5 loop {#loop}

*See [grid-studies-3-5.scd](files/grid-studies-3-5.scd) for this step.*

Lastly, we'll implement setting the loop start and end points with a two-press gesture: pressing and holding the start point, and pressing an end point while still holding the first key. We'll need to add a variable to count keys held, another to track the last key pressed, and variables to store the loop positions.

```js
~keys_held = 0;
~key_last = 0;
~loop_start = 0;
~loop_end = ~lastCol;
```

We then count keys held on the bottom row:

```js
// count bottom row keys
if(y == ~lastRow,
	if(z == 1,
		{~keys_held = ~keys_held + 1;},
		{~keys_held = ~keys_held - 1;});
);
```

...and use the `keys_held` counter to do different actions:

```js
// loop and cut
if((z == 1) && (y == ~lastRow), {
	if(~keys_held == 1, {
		~next_position = x;
		~cutting = 1;
		~key_last = x;
	},
	{
		if( ~key_last < x,
			{
				~loop_start = ~key_last;
				~loop_end = x;
			},
			{
			// exercise: define what should happen if the loop is negative!
			}
		);
		("start: " ++ ~loop_start ++ " // end: " ++ ~loop_end).postln;
	});
});
```

We then modify the position change code, so that cutting to a position outside of the loop will play through freely until the `loop_end` is reached, when it will cycle back to the `loop_start`:

```js
// update position
if(~cutting == 1,
	{~play_position = ~next_position; ~cutting = 0;},
	{
		if(~play_position == ~loop_end,
			{~play_position = ~loop_start;},
			{~play_position = (~play_position + 1).wrap(0,~lastCol)}
		);
	}
);
```

Done!


## closing

### suggested exercises

- display the loop range on the bottom row of the grid.
- "record" keypresses in the "trigger" row to the toggle matrix.
- use the rightmost key in the "trigger" row as an "alt" key.
	- if "alt" is held while pressing a toggle, clear the entire row.
	- if "alt" is held while pressing the play row, reverse the direction of play.

### credits

*SuperCollider* was written by James McCartney and is now maintained [as a GPL project by various people](https://supercollider.github.io).

The original `monom` SuperCollider library was written by [Raja Das and Joseph Rangel](https://github.com/Karaokaze/Monom_SCs), was maintained by [Ezra Buchla](https://github.com/catfact/monom/), and was re-built into `monomeSC` in 2023 by [Dan Derks](https://dndrks.com).

This tutorial was written by [Brian Crabtree](http://nnnnnnnn.org) and [Dan Derks](https://dndrks.com) for [monome.org](https://monome.org). Huge thanks to Raja Das for his very extensive 'Monoming with SuperCollider Tutorial'.

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail [help@monome.org](mailto:help@monome.org).
