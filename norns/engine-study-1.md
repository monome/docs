---
layout: default
nav_exclude: true
permalink: /norns/engine-study-1/
---

# norns engine study
{: .no_toc }

Welome! We're so glad you're here! This study is meant to provide orientation for engine development on norns, using SuperCollider. We assume that you've already got a bit of familiarity with SuperCollider -- if not, be sure to check out [learning SuperCollider](/docs/norns/studies/#learning-supercollider) for helpful learning resources and come back here after some experimentation.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## preparation

**Please note** that if you're new to SuperCollider, you'll likely make some unexpectedly loud / sharp sounds. To protect your ears and equipment, we recommend that you install the [SafetyNet Quark](https://github.com/adcxyz/SafetyNet), both within SuperCollider on your computer and on your norns. This Quark ensures that the output volume of SuperCollider won't reach levels which would damage your hearing. To add this to your norns, simply execute the following line from the maiden REPL, under the `SuperCollider` tab:

```lua
Quarks.install("SafetyNet")
```

Now, let's do a little housekeeping:

- make sure you have SuperCollider installed on a non-norns computer
- connect to [maiden](/docs/norns/maiden) from your non-norns computer
  - create a folder inside of `code` named `engine_study`
  - create a folder inside of `engine_study` named `lib`
 

## part 1: starting from scratch in SuperCollider {#part-1}

We'll start by building a basic synth definition, which we'll then port into norns later on. Open SuperCollider, create a new file, and read on!

### make a sound {#sound}

Type this text into a blank SuperCollder file:

```
(
SynthDef("BloopSynth", {
	// let's build a raw sound:
	var sound = Pulse.ar(440,0.3);

	// put that raw sound through a resonant filter:
	var filter = MoogFF.ar(in: sound, freq: 3000, gain: 3);

	// and add an envelope:
	var envelope = Env.perc(level: 1.0, releaseTime: 0.4).kr(2);

	// our final signal is our filter multiplied by our envelope, panned to center:
	var signal = Pan2.ar(filter*envelope,0);

	// let's send our signal to the output:
	Out.ar(0,signal);
	
	}).add;
)
```

Navigate to the closing parenthesis and press `CMD-RETURN` (Mac) / `CTRL-ENTER` (Win) to evaluate the text. This adds the synth definition to our current SuperCollider session.

To trigger the synth, simply assign it to a variable (and evaluate):

```
x = Synth("BloopSynth");
```

We should hear a plucky little tone as our SynthDef plays a 440hz note through our Pulse UGen, shaped by a resonant filter and percussive envelope.

### build and modify arguments {#arguments}

If we were to port this to norns, it'd be fun to mash a key and make this sound for a bit, but it'd eventually become stale because the pitch, the release time, the pulse width are static. So, let's introduce a few arguments so we can use them to control these dynamic elements:

```
(
SynthDef("BloopSynth", {
	arg freq = 440, pw = 0.3, cutoff = 3000, resonance = 3,
	amp = 1, release = 0.4, pan = 0, out = 0;
	
	var sound = Pulse.ar(freq,pw);
	var filter = MoogFF.ar(in: sound, freq: cutoff, gain: resonance);
	var envelope = Env.perc(level: amp, releaseTime: release).kr(2);
	var signal = Pan2.ar(filter*envelope,pan);
	
	Out.ar(out,signal);
	}).add;
)
```

Now, we can simply execute the default values with:

```
x = Synth("BloopSynth");
```

Or we can modify the values through our arguments: 

```
x = Synth("BloopSynth",[\freq,300, \cutoff,1400, \resonance,4, \release,3]);
```

We're pretty much there, right? We have a neat little synth + a way to send it commands -- now, let's get it into shape as a norns engine!

## part 2: building an engine for norns {#part-2}

Rather than attempt to poetically guide you through discovery, it seems helpful to present the norns engine boilerplate first.

### boilerplate

```
Engine_MySynthName : CroneEngine {

	// ** add your variables here **

	// establish input + output busses/groups,
	//   do not modify this:
	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	// allocate memory:
	alloc {
		
		// ** add your SynthDefs here **
				
		context.server.sync;
		
		// ** add your commands here **
		
	}

}
```

### BloopSynth engine

Following the structure above, let's build a norns engine from the synth definition we were previously working on in SuperCollider.

The end goal is to generate a SuperCollider Class File named `Engine_BloopSynth.sc`, which will contain our engine definition.

We can do this either in SuperCollider (be sure to save as a Class File!) and import it into our `code > engine_study > lib` folder, or we can create the file directly in maiden (just use maiden's file renaming feature to rename the file `Engine_BloopSynth.sc`).

```
Engine_BloopSynth : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// Here, we define variables for our synth's starting values,
	//  which our script commands can modify:
	var amp = 1;
	var release=4;
	var pw=0.5;
	var cutoff=3000;
	var resonance=3;
	var pan = 0;
	var out = 0;

// This is your constructor. The 'context' arg is a CroneAudioContext.
// It provides input and output busses and groups.
// NO NEED TO MODIFY THIS
	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

// This is called when the engine is actually loaded by a script.
// You can assume it will be called in a Routine,
//  and you can use .sync and .wait methods.
	alloc { // allocate memory to the following:

		// add SynthDefs
		SynthDef("BloopSynth", {
			arg freq = 440, pw = pw, cutoff = cutoff, resonance = resonance,
			amp = amp, release = release, pan = pan, out = out;
			var sound = Pulse.ar(freq,pw);
			var filter = MoogFF.ar(in: sound, freq: cutoff, gain: resonance);
			var envelope = Env.perc(level: amp, releaseTime: release).kr(2);
			var signal = Pan2.ar(filter*envelope,pan);
			Out.ar(out,signal); // let's send our signal to the output
		}).add;
		
		context.server.sync; // syncs our synth definition to the server

// This is how you add "commands",
//  which are how the Lua interpreter controls the engine.
// The format string is analogous to an OSC message format string,
//  and the 'msg' argument contains data.

		this.addCommand("amp", "f", { arg msg;
			amp = msg[1];
		});

		this.addCommand("pw", "f", { arg msg;
			pw = msg[1];
		});
		
		this.addCommand("release", "f", { arg msg;
			release = msg[1];
		});
		
		this.addCommand("cutoff", "f", { arg msg;
			cutoff = msg[1];
		});
		
		this.addCommand("resonance", "f", { arg msg;
			resonance = msg[1];
		});
		
		this.addCommand("pan", "f", { arg msg;
			pan = msg[1];
		});
		
		this.addCommand("hz", "f", { arg msg;
			Synth("BloopSynth", [
				\freq,msg[1],
				\pw,pw,
				\amp,amp,
				\cutoff,cutoff,
				\resonance,resonance,
				\release,release,
				\pan,pan,
				\out,out
			]);
		});	
			
	}

}
```

Once the `Engine_BloopSynth.sc` file is under `code > engine_study > lib`, we'll want to restart matron + SuperCollider together, via `SYSTEM > RESTART`.

#### commands

Building commands are where things really get fun, because commands surface dynamic controls to the Lua layer. Once you identify what you'd like to control from your script, command construction is pretty straightforward.

Let's break one down:

```
this.addCommand("release", "f", { arg msg;
	release = msg[1];
});
```

- `"release"` is the name we'd like Lua to use to reference this command
- `"f"` defines the type of argument we expect (`"f"` means float, but we could also use `"i"` for integers or `"s"` for strings)
	- commands can also accept many arguments at once, eg. `"ifffff"`
	- we're using single float commands for this example because it's easier for an introduction
- `arg msg` lets SuperCollider know that the incoming argument is a message to unpack
- `release = msg[1]` assigns the SynthDef's `release` to the value of the first message
	- in our case, we only have one message -- a `"f"` (float)

#### command focus: hz {#hz}

Though most of this engine's components are recognizable from our previous SynthDef exercise, you'll notice that `hz` is a new gesture:

```
this.addCommand("hz", "f", { arg msg;
	Synth("BloopSynth", [
		\freq,msg[1],
		\pw,pw,
		\amp,amp,
		\cutoff,cutoff,
		\resonance,resonance,
		\release,release,
		\pan,pan,
		\out,out
	]);
});
```

This is a command which accepts a single float (our `hz` value), but then bundles the current state of all the other variables to instantiate a `BloopSynth` voice at the specified frequency.

### using commands {#using-commands}

Now that our `BloopSynth` engine is installed on norns (and we've done a proper `SYSTEM > RESTART`), let's use Lua to execute the commands we established in the previous exercise.

In maiden, navigate to the `code > engine_study` folder and create a new Lua file (make sure this file is created outside of the `code > engine_study > lib` folder!). Name it `bloopsynth.lua` and enter the following text:

```lua
engine.name = 'BloopSynth'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'

function init()
  mults = s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} }
  playing = false
  sequence = clock.run(
    function()
      while true do
        clock.sync(1)
        if playing then
          engine.hz(200 * mults())
        end
      end
    end
  )
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
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
>> engine.pw(0.3)
>> engine.cutoff(500)
>> engine.release(0.2)
```

As our sequence plays and we execute these commands, you'll notice the timbre of our synth changes.

## part 3: build a Lua library file for our engine {#part-3}

One of the conveniences of scripting in norns is the [parameters](/docs/norns/study-3/#parameters) system, which provides scripts with MIDI control + presets for free. While controlling our engine via the REPL's command line is fun, it's perhaps not the most effective means for all types of performances. But we don't want to leave parameter initialization and engine maintenance up to the main script -- if somebody builds a fantastic control scheme and simply wants to drop in our engine, we don't want them to have to dig through SuperCollider code to figure out how to best address all of our different commands from Lua.

So, to cleanly + portably integrate our engine into the norns ecosystem, let's build a companion Lua file for our engine which will bundle its commands as part of its use in a script!

We'll name this file `bloopsynth_engine.lua` and we'll want it to live in our `code > engine_study > lib` folder -- so either create it there via maiden or import your externally-created `bloopsynth_engine.lua` file to that location:

```lua
local BloopSynth = {} -- we build a container for our engine-specific Lua functions
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["amp"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["pw"] = controlspec.new(0.01, 0.99, "lin", 0, 0.5, ""),
  ["release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["cutoff"] = controlspec.WIDEFREQ,
  ["resonance"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["pan"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"amp","pw","release","cutoff","resonance","pan"}

-- initialize parameters:
function BloopSynth.add_params()
  params:add_group("BloopSynth",#param_names)

  for i = 1,#param_names do
    local p_name = param_names[i]
    params:add{
      type = "control",
      id = "bloopsynth_"..p_name,
      name = p_name,
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil
    }
  end

end

-- a single-purpose triggering command to gather our parameter values
--  and send them as commands before we fire a note
function BloopSynth.trig(hz)

  for i = 1,#param_names do
    local p_name = param_names[i]
    local current_val = params:get("bloopsynth_"..p_name)
    engine[p_name](current_val)
  end
  
  if hz ~= nil then
    engine.hz(hz)
  end
  
end

return BloopSynth -- we return these engine-specific Lua functions back to the host script
```

### import + initialize {#import}

Now that our engine's timbral commands are all self-contained as norns parameters, a host script can import + initialize `BloopSynth` very easily:

```lua
-- SC engine study: import + initialize

engine.name = 'BloopSynth' -- assign the engine to this script's run

-- our engine's Lua file is assigned a script-scope variable:
bloop = include('engine_study/lib/bloopsynth_engine')

function init()
  bloop.add_params() -- the script adds params via the `.add params()` function
end

function key(n,z)
  if n == 3 and z == 1 then
    bloop.trig(187 * math.random(3)) -- the script triggers the engine and passes a Hz value
  end
end
```

#### script-scope variable + path {#script-scope}

Whenever we include a library's functions in a norns script, we need to assign it to a script-scope variable in order to use it. From the code snippet above:

```lua
bloop = include('engine_study/lib/bloopsynth_engine')
```

Remember: in our `bloopsynth_engine.lua` file, we wrapped all of the engine-specific functions into a `BloopSynth` table, which we then **return** at the end. So when we use `include`, we assign those functions to the script-scope variable `bloop`, which then has access to those same functions. To confirm, run the `SC engine study: import + initialize` code snippet and execute the following on the command line:

```
>> tab.print(bloop)
```

Which returns:

```
add_params	function: 0x3f3860
trig	function: 0x4fa410
```

The *path* we provide the `include` function is also very important -- it specifies where the compiler should look to round out a script's functionality. In order for any script to find and initialize our `BloopSynth`'s Lua file, we provide the exact path (eg. `'engine_study/lib/bloopsynth_engine'`).

### readying distribution {#distro}

To distribute our `BloopSynth` engine to others, we could use the following architecture:

```
bloopsynth/
  lib/
    Engine_BloopSynth.sc
    bloopsynth_engine.lua
  bloopsynth.lua
```

#### the example script {#example-script}

While we've made it easier for another script to use our `BloopSynth` engine by providing a companion Lua library file, we can ensure success + legibility by including a simple example script (in the filetree above, this is the `bloopsynth.lua` file) which clarifies usage.

The `SC engine study: import + initialize` [snippet above](#import) is a fine starting point:

- it models the proper engine naming
- it confirms the library file's path
- it shows how to add the engine's timbral parameters as part of the script initialization
- it shows how to trigger the engine

### further

To continue exploring + creating new synthesis engines for norns, we highly recommend:

-  Zack Scholl's video series (produced in partnership between monome and Music Hackspace):
	-  [Tone to Drone](https://musichackspace.org/events/tone-to-drone-introduction-to-supercollider-for-monome-norns-live-session/)
	-  [Ample Samples](https://musichackspace.org/events/ample-samples-introduction-to-supercollider-for-monome-norns-live-session/)
- [Zack Scholl's #supercollider blog entries](https://schollz.com/tags/supercollider/)
- [Eli Fieldsteel's *fantastic* YouTube series](https://youtu.be/yRzsOOiJ_p4)
- [norns SuperCollider engines index](https://norns.community/libs-and-engines#supercollider-engines)