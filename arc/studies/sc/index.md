---
layout: default
nav_exclude: true
---

# arc studies: SuperCollider
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
- [download this study's code examples](files/arc-studies-sc.zip)
- [download the `monomeSC` library](https://github.com/monome/monomeSC/releases/latest)

If you're new to SuperCollider, it will be *very* beneficial to work through the 'Getting Started' tutorial which is within SuperCollider's help file documentation ([also on their docs site](https://doc.sccode.org/Tutorials/Getting-Started/00-Getting-Started-With-SC.html)).

### clearing conflicts {#clear}

As you go through each study, you'll find it useful to stop the running code so your grid presses don't have conflicting actions:

- macOS: <kbd>Command</kbd> + <kbd>.</kbd>
- Windows / Linux: <kbd>Ctrl</kbd> + <kbd>.</kbd>

[See the SuperCollider docs for more info.](https://doc.sccode.org/Guides/SCIde.html#Evaluating%20code)

## library setup {#setup}

To install the `monomeSC` SuperCollider library for monome grid + arc devices:

- download + unzip the [latest release](https://github.com/monome/monomeSC/releases/latest) of `monomeSC`
- in SuperCollider, select `File > Open user support directory`
- move or copy the `monomeSC` folder into the `Extensions` folder
  - if `Extensions` does not exist, please create it
- in SuperCollider, recompile the Class Library (`Language > Recompile Class Library`)
  - macOS: <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>
  - Windows / Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>

## 1. connect

### arc connection

After setting up the library, connect your arc to your computer and boot SuperCollider.

As SuperCollider boots up, it initializes the `Monome` class, which is how we get grids and arcs to communicate with SuperCollider. The `MonomeGrid` and `MonomeArc` subclasses have handlers for grid and arc alike. These subclasses index device connections as they occur, so if you try to script for a device which hasn't yet been connected, SuperCollider will let you know in the Post Window:

```js
WARNING: no monome arc detected at device slot <i>
```

If you run into this message, simply connect an arc and you'll see it acknowledged in the Post Window:

```js
monome device connected!
	model: monome arc
	port: 12260
	serial: m92613201
```
You should now be able to re-run your script without issue!

If you have any other troubles communicating with your grid from SuperCollider, quickly recompiling the Class Library should solve the issue:

- macOS: <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>
- Windows / Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd>

### initial contact

The `MonomeArc` class facilitates easy communication with arcs, modeled after the [norns scripting API](/docs/norns/reference/arc).

Let's create a variable, `~a`, to initialize the `MonomeArc` class:

```js
~a = MonomeArc.new();
```

There are two optional arguments which can be passed to the initialization:

- The `rotation` argument specifies north's orientation. If none is provided, `MonomeArc` will assume 0 rotation. Check out the `MonomeArc` help file for additional rotation options!
- The `prefix` argument is a nickname we can use to alias this script's arc, instead of relying on serial numbers. If none is provided, the instance will be assigned `"/monome"`.

Now that the class is initialized to a variable, let's connect to an arc (make sure to plug one in):

```js
~a.connect();
```

We can optionally specify a device number to connect to -- SuperCollider Lists and Arrays are 0-indexed, so device `0` is the first-connected monome device. If no device number is provided, `MonomeArc` will connect to the first arc device it finds.

Please note that there needs to be a slight delay in between initializing the new device and connecting to it. Waiting until the server starts provides the necessary time buffer:

```js
(
~a = MonomeArc.new();

s.waitForBoot({
	~a.connect();
});
)
```

The library communicates with *serialosc* to discover attached devices using OSC. For a detailed description of how the mechanism and protocol work, see [the serialosc technical docs](/docs/serialosc/osc/) and [serial reference](/docs/serialosc/serial.txt) -- please note that neither of these documents are required for this study, but they _are_ good background for creating your own arc communication libraries.

### query

Once connected, our script's instance of `MonomeArc` has some individual attributes we can query. In these examples, we'll use `~m` to illustrate:

- `~a.serial`: this arc's serial number
- `~a.dvcnum`: this arc's assigned device number (0-indexed)
- `~a.prefix`: this arc's assigned prefix
- `~a.port`: this arc's assigned OSC port
- `~a.rotation`: this arc's assigned rotation

We can also query `Monome` directly:

- `Monome.getRegisteredDevices`: returns the serial numbers of each device that's been registered since the Server started
- `Monome.getPortList`: returns the OSC ports of each device that's been connected since the Server started
- `Monome.getPrefixes`: returns the assigned prefixes of each device that's been connected since the Server started

We can also refresh the list of devices that have been connected since the Server started with `Monome.refreshConnections`.


## 2. basics {#basics}

*See [arc-studies-2-1.scd](files/arc-studies-2-1.scd) for this section.*

### 2.1 hardware input {#hardware-input}

We read arc encoder turns by utilizing the `delta` method. Two parameters are received, in order:

```js
n: encoder number (0-indexed)
d: delta (negative: left turn, positive: right turn)
```

If your arc has keys, either embedded in each encoder or in the bottom-left of its top panel, we can read keypresses by utilizing the `key` method. Two parameters are received, in order:

```js
n: button number (0-indexed)
z: state (1 = key down, 0 = key up)
```

In [arc-studies-2-1.scd](files/arc-studies-2-1.scd) we define each function to simply print out incoming data:

```js
(
Server.default = Server.local;

// MonomeArc accepts two arguments:
// * rotation (0 is default)
// * prefix (a string nickname for this arc, "/monomeArc" is default)

~a = MonomeArc.new();

s.waitForBoot({

	~a.connect(); // 0 (or not supplying any argument) means the first-connected arc

	~a.delta({
		arg n,d;
		[n,d, "serial: " ++~a.serial,"port: "++~a.port].postln;
	});

	~a.key({
		arg n,z;
		[n,z, "serial: " ++~a.serial,"port: "++~a.port].postln;
	});

});

)
```

### 2.2 LED output {#led-output}

*Note: to reduce flickering with fast redraw rates, all of the LED methods listed below require `.refresh` to draw the queued messages.*

Updating a single LED takes the form:

```js
~a.led(ring, led, val);
~a.refresh;
```

Where `val` ranges from 0 (off) to 15 (full brightness), with variable levels in between.

To set every LED on a specific ring to the same value:

```js
~a.all(ring, val);
~a.refresh;
```

To set a range of LEDs on a specific ring to the same value:

```js
~a.segment(ring, from, to, val);
~a.refresh;
```

### 2.3 coupled interaction {#coupled-interaction}

*See [arc-studies-2-3.scd](files/arc-studies-2-3.scd) for this step.*

Instead of printing the hardware interaction output, we can visualize state on arc quite simply. [Stop your running code](#clear) and execute:

```js
(
Server.default = Server.local;

~a = MonomeArc.new();

s.waitForBoot({

	var pos = [0,0,0,0];

	~a.connect();

	// draw notch:
	for(0, 3, {
		arg i;
		~a.led(i, 0, 15);
	});
	~a.refresh;

	~a.delta({
		arg n, d;
		~a.all(n, 0);
		pos[n] = (pos[n] + d).wrap(0,63);
		~a.led(n, pos[n], 15);
		~a.refresh;
	});
});

)
```

### 2.4 decoupled interaction {#decoupled-interaction}

*See [arc-studies-2-4.scd](files/arc-studies-2-4.scd) for this step.*

Decoupled interaction means drawing LED state independent of physical contact with the hardware. We'll demonstrate this through two methods: one using a timer and another by changing direction with a keypress.

We refresh arc with the `draw` function, where we draw a tick mark on the first ring and then build quad shapes on the other three:

```js
draw = {
	~a.allOff();
	~a.led(0, step * 16, 10);
	for(1, 3, {
		arg i;
		var quad = step * i * 16;
		~a.segment(i, quad, quad + 15, 15);
	});
	~a.refresh;
};
```

Our looping timer advances our `step` counter by 1 every 0.75 seconds, wrapping as we go:

```js
timer = Routine({
	var interval = 0.75;
	loop {
		step = (step + direction).asInteger.wrap(0,3);
		draw.value;
		interval.yield;
	}
});
```

If your arc has any keys (see [editions](/docs/arc/editions) to confirm), we'll use the first key to change the direction of our step-ward movement with every press:

```js
~a.key({
	arg n, z;
	if(n == 0 && z == 1, {
		direction = direction * -1;
	});
});
```

Remember, `z` is the key state (down or up), so we'll do something only on key down (where `z == 1`).

## 3. further {#further}

Now we'll show how basic arc applications are developed by creating cyclical movement. We will add features incrementally:


- Add more LED activity by creating a fading trail.
- Use the encoders to set the speed at which the tick rotate.
- Introduce friction to the motion.
- Use a key to selectively activate that friction.
- Connect drones to the motion of the encoders.

### 3.1 fading in {#fading-in}

*See [arc-studies-3-1.scd](files/arc-studies-3-1.scd) for this step.*

Let's build off of our simple notch example by adding a little more LED activity. To start, we'll take advantage of arc's high resolution (1024 steps per revolution):

```js
~a.delta({
	arg n, d;
	pos[n] = (pos[n] + d).wrap(0,1024);
	draw.value;
});
```

Since each ring has 64 LEDs with 16 stages of variable brightness each, we can use a little bit-shifting and modulo maths to draw our notch with a cascading fade:

```js
point = {
	arg n, y;
	var x = (y.floor).asInteger;
	var c = x >> 4;
	~a.led(n, (c % 64) + 1, 15);
	~a.led(n, ((c + 1) % 64) + 1, x % 16);
	~a.led(n, ((c + 63) % 64) + 1, 15 - (x % 16));
};
```

That will get us started.

### 3.2 motion {#motion}

*See [arc-studies-3-2.scd](files/arc-studies-3-2.scd) for this step.*

Instead of setting a static value, let's use our encoders to set the speed at which our value should increment and decrement:

```js
~a.delta({
	arg n, d;
	speed[n] = (speed[n] + d).clip(-48,48);
});
```

Since movement requires time to progress, we'll spin up a `Routine` to advance changes to our position values:

```js
tick = Routine({
	var interval = 0.033;
	loop {
		for(0,3,{
			arg n;
			pos[n] = (pos[n] + speed[n]).wrap(0,1024);
		});
		draw.value;
		interval.yield;
	}
});

tick.play();
```

### 3.3 friction {#friction}

*See [arc-studies-3-3.scd](files/arc-studies-3-3.scd) for this step.*

As you play with the previous sketch, you might have found joy in turning the encoders against the motion, effectively adding *friction*. Let's make a small modification to our sketch and add friction to our `tick`:

```js
tick = Routine({
	var interval = 0.033;
	loop {
		for(0,3,{
			arg n;
			pos[n] = (pos[n] + speed[n]).wrap(0, 1024);
			speed[n] = speed[n] * friction; // NEW!
		});
		draw.value;
		interval.yield;
	}
});
```

Now, encoder turns will launch our values with full force, but their journeys eventually come to an end.

### 3.4 optional: pumping the brakes {#brake}

*See [arc-studies-3-4.scd](files/arc-studies-3-4.scd) for this step.*

If your arc has a key, or many, let's use it to selectively add friction. We'll initiate a boolean `brake` variable as `false`, and we'll endow our first arc key with the power to change that state:

```js
~a.key({
	arg n, z;
	if (z == 1,
		{brake = true},
		{brake = false}
	);
});
```

And we'll add a conditional check for `brake` in our `tick`:

```js
tick = Routine({
	var interval = 0.033;
	loop {
		for(0,3,{
			arg n;
			pos[n] = (pos[n] + speed[n]).wrap(0, 1024);
			// NEW:
			if (brake == true,
				{speed[n] = speed[n] * friction}
			);
		});
		draw.value;
		interval.yield;
	}
});
```

### 3.5 drones {#drones}

*See [arc-studies-3-5.scd](files/arc-studies-3-5.scd) for this step.*

Lastly, we'll implement a few simple `SinOscFB` drones:

```js
SynthDef(\sineFB, { |freq = 440, amp = 0.2, fb = 0|
	var sig;
	sig = SinOscFB.ar(freq, fb, amp);
	Out.ar(0, sig ! 2);
}).add;
```

Let's assign their amplitudes and feedback arguments to each encoder's position. Noon will send 0, whereas 6pm will send peak amplitude. To control each drone, we need to register it to a Group; see [Skilled Labor](/docs/norns/engine-study-2/) for more about Groups).

We'll associate each encoder with a degree in the Dorian scale:

```js
var notes = [
	Scale.dorian.degreeToFreq(0,32.midicps,1),
	Scale.dorian.degreeToFreq(7,32.midicps,1),
	Scale.dorian.degreeToFreq(9,32.midicps,1),
	Scale.dorian.degreeToFreq(15,32.midicps,1),
];
```

And we'll add scaling for each drone's amplitude and feedback parameters to our `tick`:

```js
if (pos[n] < 512,
	{
		drones[n].set(\amp, pos[n].linlin(0, 512, 0, 0.5/(n+1)));
		drones[n].set(\fb, pos[n].linlin(0, 512, 0, 1/(n+1)));
	},
	{
		drones[n].set(\amp, pos[n].linlin(512, 1023, 0.5/(n+1), 0));
		drones[n].set(\fb, pos[n].linlin(512, 1023, 1/(n+1), 0));
	}
);
```

Done!


## closing

### suggested exercises

- allow each encoder to have its own friction.
- sync all of the encoders to the movement of the first, at selectable divisions or multiples.
- implement a 'paging' system, where each encoder controls multiple values depending on the page: min, max, friction setting, shape, etc.
  - try ^this regardless of the presence of keys on your arc!

### credits

*SuperCollider* was written by James McCartney and is now maintained [as a GPL project by various people](https://supercollider.github.io).

The original `monom` SuperCollider library was written by [Raja Das and Joseph Rangel](https://github.com/Karaokaze/Monom_SCs), was maintained by [Ezra Buchla](https://github.com/catfact/monom/), and was re-built into `monomeSC` in 2023 by [Dani Derks](https://dndrks.com).

This tutorial was written by [Dani Derks](https://dndrks.com) for [monome.org](https://monome.org). Huge thanks to Raja Das for his very extensive 'Monoming with SuperCollider Tutorial'.

Contributions welcome. Submit a pull request to [github.com/monome/docs](https://github.com/monome/docs) or e-mail [help@monome.org](mailto:help@monome.org).
