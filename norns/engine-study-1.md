---
layout: default
nav_exclude: true
permalink: /norns/engine-study-1/
---

# rude mechanicals
{: .no_toc }

*norns engine study 1: building a synth, creating an engine, scripting with engines on norns*

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. Many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined).

This study is meant to provide orientation for engine development on norns, using SuperCollider. We assume that you've already got a bit of familiarity with SuperCollider -- if not, be sure to check out [learning SuperCollider](/docs/norns/studies/#learning-supercollider) for helpful learning resources and come back here after some experimentation.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## preparation

If you haven't already, please [download SuperCollider](https://supercollider.github.io) on your primary non-norns computer. Though we'll eventually end up at norns, being able to quickly execute snippets of SuperCollider code during the experimentation stages will provide the foundation necessary for engine construction.

**Please note** that if you're new to SuperCollider, you'll likely make some unexpectedly loud / sharp sounds. To protect your ears and equipment, we recommend that you install the [SafetyNet Quark](https://github.com/adcxyz/SafetyNet), both within SuperCollider on your computer and on your norns. This Quark ensures that the output volume of SuperCollider won't reach levels which would damage your hearing. To add SafetyNet to your norns, simply execute the following line from the maiden REPL, under the `SuperCollider` tab:

```lua
Quarks.install("SafetyNet")
```

Now, let's do a little norns housekeeping before digging into SuperCollider:

- create a folder inside of `code` named `engine_study`
- create a folder inside of `engine_study` named `lib`
 

## part 1: starting from scratch in SuperCollider {#part-1}

We'll start by building a basic synth definition in SuperCollider, which we'll then port into norns later on. Open SuperCollider on your non-norns computer and create a new SuperCollider file.

### make a sound {#sound}

Type this text into a blank SuperCollder file:

```
(
SynthDef("Moonshine", {
	// let's build a raw sound:
	var pulse = Pulse.ar(freq: 300);
	var saw = Saw.ar(freq: 300);
	var sub = Pulse.ar(freq: 300/2);
	var noise = WhiteNoise.ar(mul: 0.1);
	var mix = Mix.ar([pulse,saw,sub,noise]);

	// and generate an envelope:
	var envelope = Env.perc(attackTime: 0.3, releaseTime: 2).kr(doneAction: 2);
	
	// put the raw sound through a resonant filter
	//  and modulate the filter with the envelope
	var filter = MoogFF.ar(in: mix, freq: 6000 * envelope, gain: 3);

	// our filtered signal is then multiplied by our envelope, panned to center:
	var signal = Pan2.ar(filter*envelope,0);

	// let's send our signal to the output:
	Out.ar(0,signal);
	
	}).add;
)
```

Navigate to the closing parenthesis and press `CMD-RETURN` (Mac) / `CTRL-ENTER` (Win) to evaluate the text. You won't hear sound yet, since this only adds the synth definition to our current SuperCollider session.

To trigger the synth and make sound, assign it to a variable and evaluate:

```
x = Synth("Moonshine");
```

You should hear a buzzy tone swept by a filter as our SynthDef plays a 300hz note through our three wave generator UGens (alongside a white noise UGen) and generates an envelope which controls the synth's amplitude but *also* modulates the cutoff frequency of a final-stage resonant filter.

### build and modify arguments {#arguments}

If we were to port this sketch as a norns engine and assigned a key to trigger the synth, it'd eventually become stale because the *pitch*, the envelope's *attack* and *release*, the *noise level*, the starting *filter cutoff*, even the sub-oscillator's division -- these are all **static** values. So, let's introduce a few arguments to our SynthDef to modify these elements with each execution:

```
(
SynthDef("Moonshine", {
	arg freq = 330, sub_div = 5, noise_level = 0.1,
	cutoff = 8000, resonance = 3,
	attack = 0.3, release = 0.4,
	amp = 1, pan = 0, out = 0;
	
	var pulse = Pulse.ar(freq: freq);
	var saw = Saw.ar(freq: freq);
	var sub = Pulse.ar(freq: freq/sub_div);
	var noise = WhiteNoise.ar(mul: noise_level);
	var mix = Mix.ar([pulse,saw,sub,noise]);

	// and generate an envelope:
	var envelope = Env.perc(attackTime: attack, releaseTime: release, level: amp).kr(doneAction: 2);
	
	// put the raw sound through a resonant filter
	//  and modulate the filter with the envelope
	var filter = MoogFF.ar(in: mix, freq: cutoff * envelope, gain: resonance);

	// our filtered signal is then multiplied by our envelope, panned to center:
	var signal = Pan2.ar(filter*envelope,pan);

	// let's send our signal to the output:
	Out.ar(out,signal);
	
	}).add;
)
```

Now, we can simply execute the default values with:

```
x = Synth("Moonshine");
```

*Or* we can modify the values by addressing these arguments:

```
x = Synth("Moonshine",[\freq,300, \cutoff,2000, \resonance,3.7, \release,3]);
```

Now, we have a neat little synth + a way to send it commands -- let's get this SynthDef shaped into a norns engine!

## part 2: building an engine for norns {#part-2}

Rather than attempt to poetically guide you through discovery, it seems helpful to present the norns engine boilerplate first.

### boilerplate

```
Engine_MySynthName : CroneEngine {

	// ** add your variables here **

	// This is called when the engine is actually loaded by a script.
	// You can assume it will be called in a Routine,
	//  and you can use .sync and .wait methods.
	alloc { // allocate memory to the following:
		
		// ** add your SynthDefs here **
				
		// if you need your SynthDef to be available before commands are sent,
		//  sync with the server by ** uncommenting the following line **:
		// Server.default.sync;
		
		// ** add your commands here **
		
	}

}
```

### Moonshine engine

Following the structure above, let's build a norns engine from the synth definition we were previously working on in SuperCollider.

The end goal is to generate a SuperCollider Class File named `Engine_Moonshine.sc`, which will contain our engine definition.

We can do this either in SuperCollider (be sure to save as a Class File!) and import it into our `code > engine_study > lib` folder, or we can create the file directly in maiden (just use maiden's file renaming feature to rename the file `Engine_Moonshine.sc`).

```
Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	var params;

	alloc { // allocate memory to the following:

		// add SynthDefs
		SynthDef("Moonshine", {
			arg out = 0,
			freq, sub_div, noise_level,
			cutoff, resonance,
			attack, release,
			amp, pan;

			var pulse = Pulse.ar(freq: freq);
			var saw = Saw.ar(freq: freq);
			var sub = Pulse.ar(freq: freq/sub_div);
			var noise = WhiteNoise.ar(mul: noise_level);
			var mix = Mix.ar([pulse,saw,sub,noise]);

			var envelope = Env.perc(attackTime: attack, releaseTime: release, level: amp).kr(doneAction: 2);
			var filter = MoogFF.ar(in: mix, freq: cutoff * envelope, gain: resonance);

			var signal = Pan2.ar(filter*envelope,pan);

			Out.ar(out,signal);

		}).add;

  // We don't need to sync with the server in this example,
  //   because were not actually doing anything that depends on the SynthDef being available,
  //   so let's leave this commented:
  // Server.default.sync;
		
  // let's create an Dictionary (an unordered associative collection)
  //   to store parameter values, initialized to defaults.
		params = Dictionary.newFrom([
			\sub_div, 2,
			\noise_level, 0.1,
			\cutoff, 8000,
			\resonance, 3,
			\attack, 0,
			\release, 0.4,
			\amp, 0.5,
			\pan, 0;
		]);

  // "Commands" are how the Lua interpreter controls the engine.
  // The format string is analogous to an OSC message format string,
  //   and the 'msg' argument contains data.

  // We'll just loop over the keys of the dictionary, 
  //   and add a command for each one, which updates corresponding value:
		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

  // This is faster than (but similar to) individually defining each command, eg:
		// this.addCommand("amp", "f", { arg msg;
		//	  amp = msg[1];
		// });

  // The "hz" command, however, requires a new syntax!
  // ".getPairs" flattens the dictionary to alternating key,value array
  //   and "++" concatenates it:
		this.addCommand("hz", "f", { arg msg;
			Synth.new("Moonshine", [\freq, msg[1]] ++ params.getPairs)
		});

	}

}
```

Once the `Engine_Moonshine.sc` file is under `code > engine_study > lib`, we'll want to restart matron + SuperCollider together, via `SYSTEM > RESTART`.

#### commands

Building commands are where things really get fun, because commands surface dynamic controls to the Lua layer. Once you identify what you'd like to control from your script, command construction is pretty straightforward.

We could define our commands for each timbral parameter individually, eg:

```
this.addCommand("release", "f", { arg msg;
	release = msg[1];
});
```

Where:

- `"release"` is the name we'd like Lua to use to reference this command
- `"f"` defines the type of argument we expect (`"f"` means float, but we could also use `"i"` for integers or `"s"` for strings)
	- commands can also accept many arguments (and argument types) at once, eg. `"ifffff"`
	- we're using single float commands for this example because it's easier for an introduction
- `arg msg` lets SuperCollider know that the incoming argument is a message to unpack
- `release = msg[1]` assigns the SynthDef's `release` to the value of the first message
	- in our case, we only have one message -- a `"f"` (float)

But we have 8 timbral parameters, which means we'll basically iterate the same structure over and over again, just changing names.

Rather than needlessly repeating lines of similar code with small differences, our `Moonshine` engine utilizes SuperCollider's [Dictionary](http://doc.sccode.org/Classes/Dictionary.html) object to build an associative array which holds each of our parameter commands (and a starting default value):

```
params = Dictionary.newFrom([
	\sub_div, 2,
	\noise_level, 0.1,
	\cutoff, 8000,
	\resonance, 3,
	\attack, 0,
	\release, 0.4,
	\amp, 0.5,
	\pan, 0;
]);
```

Once we establish `params` as a *Dictionary*, we can iterate on it very easily using SuperCollider's built in methods for iteration. [keysDo](https://depts.washington.edu/dxscdoc/Help/Classes/Dictionary.html#-keysDo) allows us to iterate over the a Dictionary and evaluate a given function for each key. Since each of these timbral commands accept a single float and contribute a single argument to our SynthDef, we can save a lot of lines using this approach:

```
params.keysDo({ arg key;
	this.addCommand(key, "f", { arg msg;
		params[key] = msg[1];
	});
});
```

#### command focus: hz {#hz}

`Moonshine` represents a useful design pattern -- the 1-shot synth which bundles the current state of the timbral parameters as it plays a note. Our `hz` command is how it happens:

```
this.addCommand("hz", "f", { arg msg;
	Synth.new("Moonshine", [\freq, msg[1]] ++ params.getPairs)
});
```

The action of this command first passes the argument as the `freq` value for our `Moonshine` synth, but then it uses another Dictionary method ([`.getPairs`](https://doc.sccode.org/Classes/Dictionary.html#-getPairs)) to succinctly bundle up our timbral parameters. Through an array concatenation method ([++](https://doc.sccode.org/Classes/Array.html#-++)), one line of code can perform the following:

- create a new Synth: `Synth.new(`
- use the `Moonshine` SynthDef: `"Moonshine",`
- and pass the incoming argument as the synth's frequency: `[\freq, msg[1]]`
- but also bundle that argument: ` ++ `
- with every current timbral parameter value: `params.getPairs)`

What results is a command which accepts a single float for frequency and bundles the current state of all the other variables to instantiate a `Moonshine` voice.

### using commands {#using-commands}

Now that our `Moonshine` engine is installed on norns (and we've done a proper `SYSTEM > RESTART`), let's use Lua to execute the commands we established in the previous exercise.

In maiden, navigate to the `code > engine_study` folder and create a new Lua file (make sure this file is created outside of the `code > engine_study > lib` folder!). Name it `Moonshine.lua` and enter the following text:

```lua
engine.name = 'Moonshine'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'
-- see https://monome.org/docs/norns/reference/lib/sequins for more info

function init()
  mults = s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} } -- create a sequins of hz multiples
  playing = false
  base_hz = 200
  sequence = clock.run(
    function()
      while true do
        clock.sync(1/3)
        if playing then
          engine.hz(base_hz * mults() * math.random(2))
        end
      end
    end
  )
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    mults:reset() -- resets 'mults' index to 1
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text(playing and "K3: turn off" or "K3: turn on")
  screen.update()
end
```

Now, if we run this script and press K3, our sequence will toggle on and off.

As far as our engine was concerned, though, we only used a single command -- `hz`. This is what initiates sound in our SuperCollider code, but it does so by polling the state of a lot of other parameters: `\pw,pw, \amp,amp, \cutoff,cutoff, \resonance,resonance, \release,release, \pan,pan`. What if we want to modify one of these facets?

Since we set each of these up as commands in our SuperCollider code, we can simply execute changes to them in Lua (for this example, via maiden's REPL):

```lua
>> engine.attack(0.1)
>> engine.cutoff(500)
>> engine.sub_div(3)
```

As our sequence plays and we execute these commands, you'll notice the timbre of our synth mutate.

## part 3: build a Lua library file for our engine {#part-3}

One of the conveniences of scripting in norns is the [parameters](/docs/norns/study-3/#parameters) system, which provides scripts with MIDI control + presets for free. While controlling our engine via the REPL's command line is fun, it's perhaps not the most effective means for all types of performances. But we don't want to leave parameter initialization and engine maintenance up to the main script -- if somebody builds a fantastic control scheme and simply wants to drop in our engine, we don't want them to have to dig through SuperCollider code to figure out how to best address all of our different commands from Lua.

So, to cleanly + portably integrate our engine into the norns ecosystem, let's build a companion Lua file for our engine which will bundle its commands as part of its use in a script!

We'll name this file `moonshine_engine.lua` and we'll want it to live in our `code > engine_study > lib` folder -- so either create it there via maiden or import your externally-created `moonshine_engine.lua` file to that location:

```lua
local Moonshine = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["amp"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["sub_div"] = controlspec.new(1, 10, "lin", 1, 2, ""),
  ["noise_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
  ["cutoff"] = controlspec.new(0.1, 20000, 'exp', 0, 1300, "Hz"),
  ["resonance"] = controlspec.new(0, 4, "lin", 0, 2, ""),
  ["attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["pan"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"amp","sub_div","noise_level","cutoff","resonance","attack","release","pan"}

-- initialize parameters:
function Moonshine.add_params()
  params:add_group("Moonshine",#param_names)

  for i = 1,#param_names do
    local p_name = param_names[i]
    params:add{
      type = "control",
      id = "Moonshine_"..p_name,
      name = p_name,
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end
  
  params:bang()
end

-- a single-purpose triggering command fire a note
function Moonshine.trig(hz)
  if hz ~= nil then
    engine.hz(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return Moonshine
```

### import + initialize {#import}

Now that our engine's timbral commands are all self-contained as norns parameters, a host script can import + initialize `Moonshine` very easily:

```lua
-- SC engine study: import + initialize

engine.name = 'Moonshine' -- assign the engine to this script's run

-- our engine's Lua file is assigned a script-scope variable:
moonshine = include('engine_study/lib/moonshine_engine')
s = require 'sequins'

function init()
  moonshine.add_params() -- the script adds params via the `.add params()` function
  mults = s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} }
  playing = false
  sequence = clock.run(
    function()
      while true do
        clock.sync(1/3)
        if playing then
          moonshine.trig(200 * mults() * math.random(2))
        end
      end
    end
  )
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    mults:reset()
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text(playing and "K3: turn off" or "K3: turn on")
  screen.update()
end
```

#### script-scope variable + path {#script-scope}

Whenever we include a library's functions in a norns script, we need to assign it to a script-scope variable in order to use it. From the code snippet above:

```lua
moonshine = include('engine_study/lib/moonshine_engine')
```

Remember: in our `moonshine_engine.lua` file, we wrapped all of the engine-specific functions into a `Moonshine` table, which we then **return** at the end. So when we use `include`, we assign those functions to the script-scope variable `moonshine`, which then has access to those same functions. To confirm, run the `SC engine study: import + initialize` code snippet and execute the following on the command line:

```
>> tab.print(moonshine)
```

Which returns:

```
add_params	function: 0x3f3860
trig	function: 0x4fa410
```

The *path* we provide the `include` function is also very important -- it specifies where the compiler should look to round out a script's functionality. In order for any script to find and initialize our `Moonshine`'s Lua file, we provide the exact path (eg. `'engine_study/lib/moonshine_engine'`).

### readying distribution {#distro}

To distribute our `Moonshine` engine to others, we could use the following architecture:

```
moonshine/
  lib/
    Engine_Moonshine.sc
    moonshine_engine.lua
  moonshine.lua
```

#### the example script {#example-script}

While we've made it easier for another script to use our `Moonshine` engine by providing a companion Lua library file, we can ensure success + legibility by including a simple example script (in the filetree above, this is the `moonshine.lua` file) which clarifies usage.

The `SC engine study: import + initialize` [snippet above](#import) is a fine starting point:

- it models the proper engine naming
- it confirms the library file's path
- it shows how to add the engine's timbral parameters as part of the script initialization
- it shows how to trigger the engine

### further

If you feel prepared to explore both SuperCollider and Lua more deeply (and hopefully you do!), here are a few jumping-off points to extend the `Moonshine` engine:

- show parameter values on the screen
- create an on-norns interaction for parameter manipulation in the main script UI
- swap out the sequins sequencer for external MIDI control
- create a separate envelope for filter cutoff modulation
- add a mechanism to control the individual level of each of the 3 voices

To continue exploring + creating new synthesis engines for norns, we highly recommend:

-  Zack Scholl's video series (produced in partnership between monome and Music Hackspace):
	-  [Tone to Drone](https://musichackspace.org/events/tone-to-drone-introduction-to-supercollider-for-monome-norns-live-session/)
	-  [Ample Samples](https://musichackspace.org/events/ample-samples-introduction-to-supercollider-for-monome-norns-live-session/)
- [Zack Scholl's #supercollider blog entries](https://schollz.com/tags/supercollider/)
- [Eli Fieldsteel's *fantastic* YouTube series](https://youtu.be/yRzsOOiJ_p4)
- [norns SuperCollider engines index](https://norns.community/libs-and-engines#supercollider-engines)
