---
layout: default
nav_exclude: true
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

If you're new to SuperCollider, it will be *very* beneficial to work through the 'Getting Started' tutorial which is within SuperCollider's help file documentation ([also on their docs site](https://doc.sccode.org/Tutorials/Getting-Started/00-Getting-Started-With-SC.html)).

### clearing conflicts

As you go through each study, you'll find it useful to stop the running code so your grid presses don't have conflicting actions:

- macOS: <kbd>Command</kbd> + <kbd>.</kbd>
- Windows / Linux: <kbd>Ctrl</kbd> + <kbd>.</kbd>

[See the SuperCollider docs for more info.](https://doc.sccode.org/Guides/SCIde.html#Evaluating%20code)

## library setup

To set up the SuperCollider library for monome devices:

- [download the `monom` library](https://github.com/catfact/monom/archive/master.zip) + unzip the file
- in SuperCollider, select `File > Open user support directory`
- move or copy the `monom-master` folder into the `Extensions` folder (it might not exist, in which case you will need to create it)
- in SuperCollider, recompile the class library (`Language > Recompile Class Library`)
  - macOS: <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>
  - Windows / Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>

## 1. connect {#connect}

The `MonoM` class facilitates easy connection and communication with grids.

Let's create a variable, `~m`, to initialize the `MonoM` class:

```js
~m = MonoM.new("/monome", 0);
```

The arguments to the initializer are *prefix* and *grid rotation*. Any string can be used for the *prefix*, as long as its formatted with no spaces and leads with `/` (eg. `"/m"`).

Now that the class is initialized to a variable, let's connect to a grid:

```js
~m.useDevice(0);
```

Here the first monome device found is attached. Please note that there needs to be a slight delay in between initializing the new device and connecting to it. Waiting until the server starts provides the necessary time buffer:

```js
(
~m = MonoM.new("/monome", 0);

s.waitForBoot({
	~m.useDevice(0);
});
)
```

The library communicates with *serialosc* to discover attached devices using OSC. For a detailed description of how the mechanism and protocol work, see [monome.org/docs/tech:osc](http://monome.org/docs/tech:osc).

## 2. basics {#basics}

*See [grid-studies-2-1.scd](files/grid-studies-2-1.scd) for this section.*

![](images/grid-studies-sc-2.png)

### 2.1 key input {#key-input}

We read grid key input by creating an OSC responder. Three parameters are received, in order:

```js
x : horizontal position (0-15)
y : vertical position (0-7)
z : state (1 = key down, 0 = key up)
```

In [grid-studies-2-1.scd](files/grid-studies-2-1.scd) we define the function to simply print out incoming data:

```js
(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~m.useDevice(0);

	OSCFunc.newMatching(
		{ arg message;
			message.postln;
		},
		"/monome/grid/key"
	);

});

)
```

Please note:

- `/monome/grid/key` is the OSC pattern this function responds to
  - since we assigned `~m` to the string `"/monome"`, the OSC matching string must be prepended with the same
  - if we used `~m = MonoM.new("/m", 0);`, then our OSC matching string would be `"/m/grid/key"`
- the `message` data is formatted as `[ /monome/grid/key, 4, 5, 1 ]`. in the next section, we'll pull apart `message` to use the `x`, `y`, and `z` with `message[1]`, `message[2]` and `message[3]`
  - SuperCollider is 0-indexed! so `message[1]` corresponds to the *x* value, `message[2]` to the *y*, and `message[3]` to the *state*
  - grid coordinates are also counted from 0! eg. releasing the third key in the second row would result in `[ /monome/grid/key, 2, 1, 0 ]`

### 2.2 LED output {#led-output}

Updating a single LED takes the form:

```js
~m.levset(x, y, val)
```

Where `val` ranges from 0 (off) to 15 (full brightness), with variable levels in between.

To toggle a single LED to on or full bright:

```js
~m.ledset(x, y, state);
```

Where `state` ranges from 0 (off) to 1 (full brightness).

### 2.3 coupled interaction

*See [grid-studies-2-3.scd](files/grid-studies-2-3.scd) for this step.*

Instead of printing the key output, we can show the key state on the grid quite simply. Stop your running code and execute:

```js
(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({
	
	~m.useDevice(0);
	
	OSCFunc.newMatching(
		{ arg message;
			~m.ledset(message[1], message[2], message[3]);
		},
		"/monome/grid/key";
	);
	
});

)
```

### 2.4 decoupled interaction

*See [grid-studies-2-4.scd](files/grid-studies-2-4.scd) for this step.*

The most basic decoupled interaction is a toggle.

We turn the grid into a huge bank of toggles by creating an [Array](https://doc.sccode.org/Classes/Array.html) to store data. It needs to be the same size as our grid, so we'll use the `cls` and `rws` methods to gather our grid size. We'll call this array `step` and initialize it full of zeros.

```js
~step = Array.fill(~m.cls * ~m.rws, {0});
```

We'll also use `var`s `x`, `y`, and `z` (key state) to parse our incoming grid messages and use these to switch the states by embedding this into our `OSCFunc`:

```js
OSCFunc.newMatching(
	{ arg message, time, addr, recvPort;
		// we don't need all of these args for everything,
		// but be aware of their existence!
		var x = message[1], y = message[2], z = message[3];
		
		if(z == 1, {
			var pos = x + (y*16);
			if(~step[pos] == 1,
				{~step[pos] = 0},
				{~step[pos] = 1}
			);
			d.value(x,y);
		})
	},
	"/monome/grid/key"
	
);
```

`message[3]` is the key state (down or up). Here we do something only on key down (where the value == 1). We calculate the position, and then change the value of the `step` based on its previous state.

We refresh the grid with function `d`, which is executed with `d.value(x,y);`:

```js
d = { arg x, y;
	~m.levset(x,y,~step[y*16+x] * 15);
};
```

In `d`, we set LED level for the toggled position -- we multiply the `~step` value per position by 15 which gives us 0 (off) or 15 (full brightness).


## 3. further

Now we'll show how basic grid applications are developed by creating a step sequencer. We will add features incrementally:

- Use the top six rows as toggles.
- Generate a clock pulse to advance the playhead from left to right, one column at a time. Wrap back to 0 at the end.
- Display the play head on "position" (last) row.
- Indicate the "activity" row (second to last) with a low brightness.
- Trigger an event when the playhead reads an "on" toggle. Our "event" will be to turn on the corresponding LED in the "activity" row.
- Jump to playback position when key pressed in the position row.
- Adjust playback loop with two-key gesture in position row.


### 3.1 toggles

*See [grid-studies-3-1.scd](files/grid-studies-3-1.scd) for this step.*

We already have a full bank of toggles set up. Let's shrink down the bank to exclude the bottom two rows. We'll first reduce `step`, then we'll adjust the key detection so toggling only happens if `y` is outside of the bottom two rows:

```js
if((z == 1) && (y < (~m.rws-2)), {
	var pos = x + (y * 16);
	if(~step[pos] == 1,
		{~step[pos] = 0},
		{~step[pos] = 1}
	);
	d.value(x,y);
});
```

That will get us started.

### 3.2 play

*See [grid-studies-3-2.scd](files/grid-studies-3-2.scd) for this step.*

To make our interface adaptive to any size grid, we query the number of rows and columns with `~m.rws` and `~m.cls`. You might've noticed that these return 1-indexed numbers, however.

Since most of our SuperCollider functions will be 0-indexed, let's make it easy on ourselves and introduce 0-indexed versions of our row and column totals at the top:

```js
// 'cls' + 'rws' return as 1-indexed,
// but we need 0-indexed for most of our functions!
~cols = ~m.cls-1;
~rows = ~m.rws-1;
```

Now, let's get into fun stuff!  
Let's make a timer routine that moves a virtual playhead:

```js
t = Routine({
	var interval = 0.125;
	loop {
		if(~play_position == ~cols,
			{~play_position = 0},
			{~play_position = ~play_position + 1}
		);
		
		d.value;
		
		interval.yield;
	}
	
});
```

This routine runs at a timing interval specified by the variable `interval`. The `play_position` is advanced, rolling back to 0 after it hits the last column. We redraw the grid each time the play head moves.

For the redraw we add highlighting for the play position. Note how `levset`'s multiplication by 15 has been decreased to 11, to provide another mid-level brightness. We now have a series of brightness levels helping to indicate playback, lit keys, and currently active keys:

```js
d = {
	var highlight;
	for(0,~cols, {arg x;
		if(x == ~play_position,
			{highlight = 4},
			{highlight = 0});
		
		for(0,~rows-2, {arg y;
			~m.levset(x,y,(~step[y*16+x] * 11) + (highlight));
		});
	})
};
```

As we copy steps to the grid, we check if we're updating a column that is the play position (`if(x == ~play_position,`...). If so, we set the highlight value to 4. By adding this value during `levset`, we'll get a nice effect of an overlaid translucent bar.

### 3.3 triggers

*See [grid-studies-3-3.scd](files/grid-studies-3-3.scd) for this step.*

When the playhead advances to a new column we want something to happen which corresponds to the toggled-on steps. We'll do two things: we'll show separate visual feedback on the grid in the second-to-last row (we'll call it a 'trigger row'), and we'll make some sound.

Drawing the trigger row happens in `d` (at `// show triggers`):

```js
d = {
	var highlight;
	for(0,~cols, {arg x;
		if(x == ~play_position,
			{highlight = 4},
			{highlight = 0});
		
		for(0,~rows-2, {arg y;
			~m.levset(x,y,(~step[y*16+x] * 11) + (highlight));
		});
		
		// set trigger row background
		~m.levset(x,~rows-1,4);
	});
	
	// show triggers
	for(0,~rows-2, {arg t;
		if(~step[(t*16) + ~play_position] == 1,
			{~m.levset(t,~rows-1,15);}
		);
	});
};
```

- we create a dim row (level 4 is fairly dim)
- we search through the `step` array at the current play position, showing a bright indicator for each on state
- this displays a sort of horizontal correlation of rows (or "channels"), with the topmost at far left

We then trigger a sound, if the channel is toggled on, inside `t`:

```js
// TRIGGER SOMETHING
for(0,~rows-2, {arg t;
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

If `step` is toggled on (`== 1`) at the `play_position` we trigger a sound. The frequency corresponds to the row position.

### 3.4 cutting

*See [grid-studies-3-4.scd](files/grid-studies-3-4.scd) for this step.*

We will now use the bottom row to dynamically cut the playback position.  
First, we add a position display to the 8th row, inside `d`:

```js
// play position
~m.levset(~play_position,~rows-1,15);
```

We clear this row first, a few lines prior:

```js
// clear play position row
~m.levset(x,~rows,0);
```

Now we look for key presses in the last row, in the key function:

```js
OSCFunc.newMatching(
	{ arg message, time, addr, recvPort;
		var x = message[1], y = message[2], z = message[3];
		
		if((z == 1) && (y <= (~rows-2)), {
			var pos = x + (y * 16);
			if(~step[pos] == 1,
				{~step[pos] = 0},
				{~step[pos] = 1}
			);
		});
		
		// cut to a new position
		if((z== 1) && (y == ~rows), {
			~next_position = x;
			~cutting = 1;
		});
	},
	"/monome/grid/key"
);
```

We've added two global variables, `cutting` and `next_position`. Check out the changed code where we check the cut position inside our timer:

```js
if(~play_position == ~cols,
	{~play_position = 0;},
	{
		if(~cutting == 1,
			{~play_position = ~next_position; ~cutting = 0;},
			{~play_position = ~play_position + 1;})
	};
);
```

Now, pressing keys on the bottom row will cue the next position to be played. Note that we set `cutting = 0` after each cut so that each press only affects the timer once.

### 3.5 loop

*See [grid-studies-3-5.scd](files/grid-studies-3-5.scd) for this step.*

Lastly, we'll implement setting the loop start and end points with a two-press gesture: pressing and holding the start point, and pressing an end point while still holding the first key. We'll need to add a variable to count keys held, another to track the last key pressed, and variables to store the loop positions.

```js
~keys_held = 0;
~key_last = 0;
~loop_start = 0;
~loop_end = 15;
```

We then count keys held on the bottom row:

```js
if(y == 7,
	if(z == 1,
		{~keys_held = ~keys_held + 1;},
		{~keys_held = ~keys_held - 1;});
);
```

...and use the `keys_held` counter to do different actions:

```js
// loop and cut
if((z == 1) && (y == 7), {
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

We then modify the position change code:

```js
// update position
if(~cutting == 1,
	{~play_position = ~next_position; ~cutting = 0;},
	{
		if(~play_position == ~loop_end,
			{~play_position = ~loop_start;},
			{~play_position = (~play_position + 1).wrap(0,15)}
		);
	};
);
```

Done!


## closing

### suggested exercises

- "record" keypresses in the "trigger" row to the toggle matrix.
- display the loop range on the bottom row of the grid.
- use the rightmost key in the "trigger" row as an "alt" key.
	- if "alt" is held while pressing a toggle, clear the entire row.
	- if "alt" is held while pressing the play row, reverse the direction of play.


## Credits

*SuperCollider* was written by James McCartney and is now maintained [as a GPL project by various people](http://supercollider.sourceforge.net).

*monom* was written by and is maintained by [Ezra Buchla](http://catfact.net).

This tutorial was created by [Brian Crabtree](http://nnnnnnnn.org) for [monome.org](https://monome.org). Huge thanks to Raja Das for his very extensive Monoming with SuperCollider Tutorial.

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail [info@monome.org](mailto:info@monome.org).
