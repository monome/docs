---
layout: default
nav_exclude: true
permalink: /norns/engine-study-2/
---

# skilled labor
{: .no_toc }

*norns engine study 2: expanding an engine, building classes, realtime changes, envelopes, polyphony*

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. Many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined).

This study extends the topics covered in [rude mechanicals](/docs/norns/engine-study-1/), which outlines starting points for engine development on norns, using SuperCollider. As with that study, we'll assume that you've already got a bit of familiarity with SuperCollider -- if not, be sure to check out [learning SuperCollider](/docs/norns/studies/#learning-supercollider) for helpful resources and come back here after some experimentation.

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

**Please note** that if you're new to SuperCollider, you'll likely make some unexpectedly loud / sharp sounds. To protect your ears and equipment, we recommend that you install the [SafetyNet Quark](https://github.com/adcxyz/SafetyNet) within SuperCollider both on your computer and your norns. This Quark ensures that the output volume of SuperCollider won't reach levels which would damage your hearing. To add SafetyNet to your norns, simply execute the following line from the maiden REPL, under the `SuperCollider` tab:

```lua
Quarks.install("SafetyNet")
```

## hidden text

To keep things relatively navigable, we've compressed big chunks of code into the following interaction:

<details closed markdown="block">

<summary>
<~~ click to expand
</summary>
Hello! This is how big chunks of code will be presented throughout the study.  
Please be sure to expand them as you come across them, otherwise the study will feel like it's missing a lot of crucial information.
</details>

## where we were, where we'll go

The *Moonshine* engine we built in [rude mechanicals](/docs/norns/engine-study-1/#moonshine-engine) showcased a few key elements of norns engine development:

- using a SuperCollider `Dictionary` to hold our parameters
- leveraging SuperCollider's built-in functions like `.keysDo` to establish norns-specific commands
- building a Lua file to bundle with your engine, to easily integrate it into another script

To reduce complexity at the start of the learning journey, *Moonshine* polled our parameter values as a voice was triggered -- this meant that changes to the level parameter, for example, wouldn't be articulated on an already-playing voice, but would serve as the starting point for the next note event. And while the engine was technically polyphonic, this was more a virtue of not establishing any specific way to handle individual voices.

This study will build on our understanding of SuperCollider's relationship to norns scripting by:

- breaking our SuperCollider files into separate *class* and *CroneEngine* files
- using Groups in SuperCollider to manage realtime parameter changes to a playing voice
- modeling an approach to polyphony and voice distribution in SuperCollider
- structuring a template for Lua parameters
- gluing it all together into an example norns script

## part 1: building our class and CroneEngine files {#part-1}

In [rude mechanicals](/docs/norns/engine-study-1/), we combined our SynthDef declarations and all the required norns plumbing into a single file (`Engine_Moonshine.sc`). This meant that our synth would work on norns but couldn't be loaded on a non-norns computer (like your laptop) without modification. As we develop engines, this becomes an annoyance -- it'd be easier to simply write our SuperCollider code on our non-norns computer, where we can quickly test out changes to its shape, without engaging in a monotonous cycle of copying/pasting our SynthDef between the CroneEngine file and a throwaway SuperCollider file.

### class file

In order to extend our *Moonshine* engine, we'll rely on SuperCollider's handling of [objects](https://doc.sccode.org/Guides/Intro-to-Objects.html). We'll start by defining a *class* to hold the sound-making bits separate from the code which only norns requires, making our synthesis code portable between norns and any other computer.

To start, open SuperCollider on your non-norns computer and create a new SuperCollider file.

Let's adapt our [previous Moonshine code](/docs/norns/engine-study-1/#moonshine-engine) to a standard class structure.

#### first adaptation {#class_example-1}

Rather than walk through each step, we've added comments to the code which will hopefully clarify any ambiguity. Here are a few new language features which are introduced:

- When a variable is prepended with `<`, that means it's accessible outside of the class file by virtue of being a 'getter'. See [**Getters and Setters**](https://doc.sccode.org/Guides/WritingClasses.html#Getters%20and%20Setters) in the official SuperCollider docs for more info.
- When an asterisk `*` is used, it denotes a function which is specific to the class -- eg. `*initClass` is called whenever SuperCollider starts and the class is initialized. See [**the `*initClass` section**](https://doc.sccode.org/Classes/Class.html#*initClass) of the official SuperCollider docs for more info.
- When `++` is used, it represents concatenation in an array. See [**Array and Collection operators**](https://depts.washington.edu/dxscdoc/Help/Overviews/SymbolicNotations.html#Array%20and%20Collection%20operators) in the University of Washington SuperCollider docs for more info.
  - Arrays in SuperCollider have a lot in common with Lua's tables. In the code below, we'll create a Dictionary of key/value pairs called `params` to hold our synth's parameter states -- toward the end, we'll create a `setParam` method which uses a `paramKey` argument to index the `params` table. See [**Array**](https://doc.sccode.org/Classes/Array.html) in the official SuperCollider docs for more info.
 
<details closed markdown="block">

<summary>
SC class exercise 1: first adaptation
</summary>

```
// SC class exercise 1: first adaptation
// a class does all the heavy lifting
// it defines our SynthDefs, handles variables, etc.

Moonshine {

	// we want 'params' to be accessible any time we instantiate this class,
	// so we'll prepend it with '<', which turns 'params' into a 'getter' method
	// see 'Getters and Setters' at https://doc.sccode.org/Guides/WritingClasses.html for more info
	var <params;

	// in SuperCollider, asterisks denote functions which are specific to the class.
	// '*initClass' is called when the class is initialized: https://doc.sccode.org/Classes/Class.html#*initClass
	*initClass {
		StartUp.add {
			var s = Server.default;
			// we need to make sure the server is running before asking it to do anything
			s.waitForBoot {
				// this is just our SynthDef from 'rude mechanicals':
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
			} // s.waitForBoot
		} // StartUp
	} // *initClass

	*new { // when this class is initialized...
		^super.new.init; // ...run the 'init' below.
	}

	init {
		// build a list of our sound-shaping parameters, with default values
		// (see https://doc.sccode.org/Classes/Dictionary.html for more about Dictionaries):
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
	}

	// these methods will populate in SuperCollider when we instantiate the class
	//   'trigger' to play a note with the current 'params' settings:
	trigger { arg freq;
		Synth.new("Moonshine", [\freq, freq] ++ params.getPairs);
		// '++ params.getPairs' iterates through all the 'params' above,
		//   and sends them as [key, value] pairs
	}
	//   'setParam' to set one of our 'params' to a new value:
	setParam { arg paramKey, paramValue;
		params[paramKey] = paramValue;
	}

}
```
</details>

To move forward, we'll need to save this class definition in a place on our non-norns computer where SuperCollider can find it. According to the [SuperCollider docs for Writing Classes](https://doc.sccode.org/Guides/WritingClasses.html):

> NOTE: Class definitions are statically compiled when you launch SuperCollider or "recompile the library." This means that class definitions must be saved into a file with the extension .sc, in a disk location where SuperCollider looks for classes. Saving into the main class library (SCClassLibrary) is generally not recommended. It's preferable to use either the user or system extension directories.
> 
> ```
> Platform.userExtensionDir;   // Extensions available only to your user account
> Platform.systemExtensionDir; // Extensions available to all users on the machine
> ```

So, choose whether you want the class definition available to *your user account* or *all users* of your machine and execute one of the two stated invocations to learn where that specific `Extensions` folder lives.

If you want to make the class available only to your user account, it might be easiest to save the file as `moonshine.sc` to a quickly-accessible location from SuperCollider, then drag + drop it into the `Extension` folder via File Explorer / Finder.  
*nb. MacOS users can simply copy/paste the location SuperCollider prints to the Post window into Finder > Go > Go to Folder to drop into that location*

If you want to make the class available to all users on the machine, use `File > Save As Extension` and SuperCollider will navigate to the location for you, where you can save the file as `moonshine.sc`.

Now, to have your class definition useable in SuperCollider, recompile the class library via `Language > Recompile Class Library`.

#### instantiate the class

When the library recompiles, we should be able to instantiate the `Moonshine` Class and its associated methods like any other class in SuperCollider. To try it out, open a blank SuperCollider file and type + live-execute (`Ctrl-Enter` or `CMD-RETURN` on macOS) the following:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute one line at a time:
x.trigger(400);
x.setParam(\release,7);
x.trigger(400/3);
x.setParam(\pan,-1);
x.trigger(400/2.5);
x.setParam(\pan,1);
x.trigger(400/1.25);
```

If everything was successful, you should hear the Moonshine synth when you execute the `x.trigger(hz)` commands and you should be able to adjust parameter values for the next `.trigger` with `x.setParam(paramKey, paramValue)`.

#### second adaptation: make real-time changes with Groups {#class_example-2}

You might notice that `x.setParam(\pan,-1)` doesn't hard-pan any currently-playing voices to the left -- rather, it queues up a change for the *next* voice we `.trigger`. To allow instantaneous control over our synth, we'll turn to SuperCollider's [Groups](https://doc.sccode.org/Classes/Group.html), which are useful for controlling many synths at once and propagating changes to them instantly.

Here's our second adaptation, with changes demarcated by `NEW:` comments:

<details closed markdown="block">

<summary>
SC class exercise 2: second adaptation
</summary>

```
// SC class exercise 2: second adaptation
// using a Group for instantaneous control

Moonshine {

	var <params;
	// NEW: add 'voiceGroup' variable to register each voice to a control group
	var <voiceGroup;

	*initClass {
		StartUp.add {
			var s = Server.default;

			s.waitForBoot {

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
			}
		}
	}

	*new {
		^super.new.init;
	}

	init {
		// NEW: assign 's' to the booted Server
		var s = Server.default;

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

		// NEW: register 'voiceGroup' as a Group on the Server
		voiceGroup = Group.new(s);
	}


	trigger { arg freq;
		// NEW: set the target of every Synth voice to the 'voiceGroup' Group
		Synth.new("Moonshine", [\freq, freq] ++ params.getPairs, voiceGroup);
	}

	setParam { arg paramKey, paramValue;
		// NEW: send changes to the paramKey, paramValue pair immediately to all voices
		voiceGroup.set(paramKey, paramValue);
		params[paramKey] = paramValue;
	}

	// NEW: free our Group when the class is freed
	free {
		voiceGroup.free;
	}

}
```
</details>

Now, if we recompile our class library via `Language > Recompile Class Library`, we should be able to execute the following in SuperCollider and hear our active voices pan as they decay:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute this bundle to trigger four voices:
(
x.setParam(\release,30);
x.trigger(200/3);
x.trigger(200/2);
x.trigger(200);
x.trigger(200*2);
)

// execute one line at a time:
x.setParam(\pan,1);
x.setParam(\pan,-1);

// execute each many times as the notes decay:
x.setParam(\pan,rrand(-1.0,1.0).postln);
x.setParam(\cutoff,rrand(1000,12000).postln);
```

If everything was successful, the `x.setParam` changes should have immediate effect on the currently-playing Moonshine voices. What we now have is a sort of paraphonic synth architecture, where all voices share a single set of parameter control.

#### third (and final) adaptation: 8-voice polyphony + more {#class_example-3}

The second adaptation is more controllable than our first, but we've traded polyphony (where each voice has its own signal path) for an architecture where all voices share a single set of controls. For our final adaptation, let's specify a few goals:

- 8-voice polyphony (with an option to send a value to all voices at once)
- if a voice is re-triggered, it cuts itself off
- allow a voice's frequency to be changed while it's decaying, versus exclusively via re-triggering
- provide an option for turning the filter envelope off/on
- give each voice its own controllable parameters, but with a way to unify control over a single parameter
- slew changes to synth frequency, noise level, synth amplitude, and panning

In the code below, we'll introduce a few new gestures:

- To establish a 'local' scope variable, we'll utilize a `classvar`. From [the University of Washington's SuperCollider docs](depts.washington.edu/dxscdoc/Help/Reference/Classes.html): "Class variables are values that are shared by all objects in the class. Class variables [...] may only be directly accessed by methods of the class."
- Since we want to establish 8 separate voices, we'll set up dictionaries to manage each voice's parameter values. We'll use `.do` to iterate a function with each Dictionary entry, which is comparable to `for i = 1,#params do` in Lua. See [**Control Structures**](https://depts.washington.edu/dxscdoc/Help/Reference/Control-Structures.html#do) in the University of Washington's SuperCollider docs.
- To simplify the single + 'all' voice controls, we'll include two helper functions inside of the class -- we'll pass `freq` arguments to `playVoice` from `trigger` and parameter values to `adjustVoice` from `setParam`.
  - Since `playVoice` and `adjustVoice` are local to the Moonshine object, we call them from within the Class file by prepending `this.`, eg. `this.playVoice` and `this.setParam`. See [**Instance Methods**](https://doc.sccode.org/Guides/WritingClasses.html#Instance%20Methods) for more info.
  - While we can do things differently / more efficiently, we don't want to introduce too many variables in this tutorial. This implementation aims for simplicity over optimal performance.
- We'll introduce slews using SuperCollider's [**`Lag3` UGen**](https://doc.sccode.org/Classes/Lag3.html), which creates smooth transitions while saving CPU.
- We'll also use boolean expressions to build if/else statements. See [**Boolean Expressions**](http://sc3howto.blogspot.com/2010/05/boolean-expressions.html) at *How to Program in SuperCollider* for more info.


Here's our third adaptation, with changes demarcated by `NEW:` comments:

<details closed markdown="block">

<summary>
SC class exercise 3: third (and final) adaptation
</summary>

```
// SC class exercise 3: third (and final) adaptation
// 8-voice polyphony + smoothing

Moonshine {

	// NEW: add local 'voiceKeys' variable to register each voice name separately
	classvar <voiceKeys;


	// NEW: establish 'globalParams' list for all voices
	var <globalParams;
	// NEW: establish 'voiceParams' to track the state of each 'globalParams' entry for each voice
	var <voiceParams;
	var <voiceGroup;
	// NEW: add 'singleVoices' variable to control + track single voices
	var <singleVoices;

	*initClass {
		// NEW: create voiceKey indices for as many voices as we want control over
		voiceKeys = [ \1, \2, \3, \4, \5, \6, \7, \8 ];
		StartUp.add {
			var s = Server.default;

			s.waitForBoot {

				SynthDef("Moonshine", {
					arg out = 0, stopGate = 1,
					freq, sub_div,
					cutoff, resonance, cutoff_env, // NEW: add 'cutoff_env'
					attack, release,
					amp, noise_amp, pan,
					// NEW: add slews to different parameters
					freq_slew, amp_slew, noise_slew, pan_slew;

					var slewed_freq = freq.lag3(freq_slew);
					var pulse = Pulse.ar(freq: slewed_freq);
					var saw = Saw.ar(freq: slewed_freq);
					var sub = Pulse.ar(freq: slewed_freq/sub_div);
					// NEW: integrate slew using '.lag3'
					var noise = WhiteNoise.ar(mul: noise_amp.lag3(noise_slew));
					var mix = Mix.ar([pulse,saw,sub,noise]);

					var envelope = EnvGen.kr(
						// NEW: separate 'amp' from the envelope, as it can't be changed after execution
						envelope: Env.perc(attackTime: attack, releaseTime: release, level: 1),
						// NEW: add a 'stopGate' to silence previous synth on this voice
						gate: stopGate,
						doneAction: 2
					);
					// NEW: integrate slew using '.lag3'
					var filter = MoogFF.ar(
						in: mix,
						// NEW: add a comparison to know whether to use the cutoff value, or to envelope:
						freq: Select.kr(cutoff_env > 0, [cutoff, cutoff * envelope]),
						gain: resonance
					);
					// NEW: integrate slew using '.lag3'
					var signal = Pan2.ar(filter*envelope,pan.lag3(pan_slew));
					// NEW: bring 'amp' to final output calculation + integrate slew using '.lag3'
					Out.ar(out, signal * amp.lag3(amp_slew));
				}).add;
			}
		}
	}

	*new {
		^super.new.init;
	}

	init {

		var s = Server.default;

		voiceGroup = Group.new(s);

		// NEW: create a 'globalParams' Dictionary to hold the parameters common to each voice
		globalParams = Dictionary.newFrom([
			\freq, 400,
			\sub_div, 2,
			\noise_amp, 0.1,
			\cutoff, 8000,
			\cutoff_env, 1,
			\resonance, 3,
			\attack, 0,
			\release, 0.4,
			\amp, 0.5,
			\pan, 0,
			\freq_slew, 0.0,
			\amp_slew, 0.05,
			\noise_slew, 0.05,
			\pan_slew, 0.5;
		]);

		// NEW: create a 'singleVoices' Dictionary to control each voice individually
		singleVoices = Dictionary.new;
		// NEW: 'voiceParams' will hold parameters for our individual voices
		voiceParams = Dictionary.new;
		// NEW: for each of the 'voiceKeys'...
		voiceKeys.do({ arg voiceKey;
			// NEW: create a 'singleVoices' entry in the 'voiceGroup'...
			singleVoices[voiceKey] = Group.new(voiceGroup);
			// NEW: and add unique copies of the globalParams to each voice
			voiceParams[voiceKey] = Dictionary.newFrom(globalParams);
		});
	}

	// NEW: helper function to manage voices
	playVoice { arg voiceKey, freq;
		// NEW: if this voice is already playing, gracefully release it
		singleVoices[voiceKey].set(\stopGate, -1.05); // -1.05 is 'forced release' with 50ms (0.05s) cutoff time
		// NEW: set '\freq' parameter for this voice to incoming 'freq' value
		voiceParams[voiceKey][\freq] = freq;
		// NEW: make sure to index each of our tables with our 'voiceKey'
		Synth.new("Moonshine", [\freq, freq] ++ voiceParams[voiceKey].getPairs, singleVoices[voiceKey]);
	}

	trigger { arg voiceKey, freq;
		// NEW: if the voice is 'all'...
		if( voiceKey == 'all',{
		// NEW: then do the following for all of the voiceKeys:
			voiceKeys.do({ arg vK;
				// NEW: use 'this.' to call functions specific to this instance
				this.playVoice(vK, freq);
			});
		}, // NEW: else, if the voice is not 'all':
		{
			// NEW: play the specified voice
			this.playVoice(voiceKey, freq);
		});
	}

	adjustVoice { arg voiceKey, paramKey, paramValue;
		singleVoices[voiceKey].set(paramKey, paramValue);
		voiceParams[voiceKey][paramKey] = paramValue
	}

	setParam { arg voiceKey, paramKey, paramValue;
		// NEW: if the voiceKey is 'all'...
		if( voiceKey == 'all',{
			// NEW: then do the following for all of the voiceKeys:
			voiceKeys.do({ arg vK;
				this.adjustVoice(vK, paramKey, paramValue);
			});
		}, // NEW: else, if the voiceKey is not 'all':
		{
			// NEW: send changes to the correct 'singleVoices' index,
			// which will immediately affect the 'voiceKey' synth
			this.adjustVoice(voiceKey, paramKey, paramValue);
		});
	}

	// NEW: since each 'singleVoices' is a sub-Group of 'voiceGroup',
	//   we can simply pass a '\stopGate' to the 'voiceGroup' Group.
	// IMPORTANT SO OUR SYNTHS DON'T RUN PAST THE SCRIPT'S LIFE
	freeAllNotes {
		voiceGroup.set(\stopGate, -1.05);
	}

	free {
		// IMPORTANT
		voiceGroup.free;
	}

}
```

</details>

Now, if we recompile our class library via `Language > Recompile Class Library`, we should be able to execute the following in SuperCollider and hear our active voices take individual life:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute this bundle to trigger four voices,
//  each with their own release lengths:
(
x.setParam('all',\pan_slew,6);
x.setParam(\1,\release,0.2);
x.setParam(\2,\release,10);
x.setParam(\3,\release,3.3);
x.setParam(\4,\release,2.7);
x.trigger(\1,200/3);
x.trigger(\2,200/2);
x.trigger(\3,200);
x.trigger(\4,200*2);
)

// execute this bundle many times while the notes decay
//  to perform slewed changes to the frequency value on all voices:
(
x.setParam('all',\freq_slew,0.3);
x.setParam('all',\freq,200 * rrand(1,8));
)

// execute this bundle:
(
// for each of Moonshine's voiceKeys, do...
Moonshine.voiceKeys.do({ arg voiceKey;
	// set '\pan' and '\cutoff' to random values
	x.setParam(voiceKey,\pan,rrand(-1.0,1.0));
	x.setParam(voiceKey,\cutoff,rrand(30,7000));
});

x.setParam('all',\release,rrand(1,12));
x.setParam(\1,\attack,rrand(0,12));
x.setParam(\2,\attack,rrand(0,12));
x.setParam(\3,\attack,rrand(0,12));
x.setParam(\4,\attack,rrand(0,12));
x.trigger(\1,600/rrand(1,6));
x.trigger(\2,200/2);
x.trigger(\3,200);
x.trigger(\4,200*2);
)
```

If everything was successful, there should be a *lot* of control over each voice. Every parameter change can be proliferated to all voices using `'all'`, or each voice can have its own settings using `\x` notation. This class definition feels pretty complete, so let's move onto our CroneEngine file!

### CroneEngine file

The CroneEngine file is what norns needs in order to shuttle meaningful engine commands and their values between Supercollider and Lua. We just spent a lot of time in our class definition file, so thankfully we don't need to spend much longer on the CroneEngine file!

<details closed markdown="block">

<summary>
CroneEngine file
</summary>

```
Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke Moonshine with
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		// NEW: since Moonshine is now a supercollider Class,
		//   we can just construct an instance of it
		kernel = Moonshine.new(Crone.server);

		// NEW: build an 'engine.trig(x,y)' command,
		//   x: voice, y: freq
		this.addCommand(\trig, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var freq = msg[2].asFloat;
			kernel.trigger(voiceKey,freq);
		});

		// NEW: since each voice shares the same parameters ('globalParams'),
		//   we can define a command for each parameter that accepts a voice index
		kernel.globalParams.keysValuesDo({ arg paramKey;
			this.addCommand(paramKey, "sf", {arg msg;
				kernel.setParam(msg[1].asSymbol,paramKey.asSymbol,msg[2].asFloat);
			});
		});

		// NEW: add a command to free all the voices
		this.addCommand(\free_all_notes, "", {
			kernel.freeAllNotes();
		});

	} // alloc


	// NEW: when the script releases the engine,
	//   free all the currently-playing notes and groups.
	// IMPORTANT
	free {
		kernel.freeAllNotes;
		// groups are lightweight but they are still persistent on the server and nodeIDs are finite,
		//   so they do need to be freed:
		kernel.allVoices.free;
	} // free


} // CroneEngine
```

</details>

That's it! Since we did so much planning inside of our class definition, our CroneEngine file pretty much just needs to invoke the class file and then create commands to surface to the Lua layer. Save it as `Engine_Moonshine.sc` somewhere you can find it easily, as we'll port everything we've done over to norns in the next section.

### bring it all onto norns

The next part of our study will involve only norns scripting, so let's get our SuperCollider files onto norns and test things out.

Connect to norns via [one of the transfer methods](/docs/norns/wifi-files/#transfer).  
If you completed the [rude mechanicals](/docs/norns/engine-study-1/) study, then simply navigate to your `code/engine_study/lib` folder on norns.  
If you didn't complete the previous study:

- create a folder inside of `code` named `engine_study`
- create a folder inside of `engine_study` named `lib`

Under `lib`, we'll want to drop in copies of our `moonshine.sc` and `Engine_Moonshine.sc` files. Once they're imported, use `SYSTEM > RESTART` on norns to recompile its SuperCollider library and get the Lua layer synced with the new engine files.

Alright, take a break! You've done a lot of typing and experimenting for one sitting. We'll see you back here soon.

## part 2: scripting in Lua {#part-2}

Now that our `Moonshine` engine is installed on norns (and we've done a proper `SYSTEM > RESTART`), let's use Lua to play the voices we established in the previous exercise.

### a three-voice sequins example {#sequins-example}

Navigate to your `code/engine_study/` folder on norns and create a new Lua file named `moonshine_sequins.lua` and enter the following text into it:

<details closed markdown="block">

<summary>
SC engine study 2: three-voice Moonshine sequins
</summary>

```lua
-- SC engine study 2:
-- 3-voice Moonshine sequins

engine.name = 'Moonshine'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'
-- see https://monome.org/docs/norns/reference/lib/sequins for more info

function init()
  mults = {
    s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} }, -- create a sequins of hz multiples for voice 1
    s{0.25, 1.25, s{2/3, 3.5, 1/3} }, -- create a sequins of hz multiples for voice 2
    s{2, 1.25, s{3.5, 1.5, 2.25, 0.5} } -- create a sequins of hz multiples for voice 3
  }
  playing = false
  base_hz = 200
  sequence = {}
  sequence[1] = clock.run(
    function()
      while true do
        clock.sync(1/4)
        if playing then
          for i = 1,2 do
            engine.trig(i, base_hz * mults[i]() * math.random(2))
          end
        end
      end
    end
  )
  
  sequence[2] = clock.run(
    function()
      while true do
        clock.sync(3)
        if playing then
          engine.trig(3, base_hz * mults[3]())
        end
      end
    end
  )
  
  -- some default parameters:
  for i = 1,2 do
    engine.amp(i,0.5)
    engine.attack(i,0)
    engine.release(i,0.3)
    engine.pan(i,i == 1 and -1 or 1)
    engine.cutoff(i,2300)
  end
  engine.release(3,clock.get_beat_sec()*2.5)
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    for i = 1,3 do
      mults[i]:reset() -- resets sequins index to 1
    end
    if not playing then
        engine.free_all_notes()
      end
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

</details>

Now, if we run this script and press K3, our sequence will toggle on and off.

You'll notice that when we run our script, maiden prints all of the commands registered via our `Engine_Moonshine.sc` file's `this.addCommand` functions to the matron window:

```bash
___ engine commands ___
amp	 	sf
amp_slew	 	sf
attack	 	sf
cutoff	 	sf
cutoff_env	 	sf
free_all_notes	 	
freq	 	sf
freq_slew	 	sf
noise_amp	 	sf
noise_slew	 	sf
pan	 	sf
pan_slew	 	sf
release	 	sf
resonance	 	sf
sub_div	 	sf
trig	 	sf
```

This type of heads-up display of what parameters can be controlled via Lua, and what arguments it expects, is super helpful! From here, we can simply execute live-code commands via maiden's command line, while the sequins iterate, eg:

```lua
>> engine.cutoff(1,1200)
>> engine.release(1,0.9)
>> engine.noise_amp(3,0.4)
```

Of course, control via code isn't for everybody -- let's build up a supplementary parameters file, so we can change these values via norns encoders and MIDI messages.

### build a Lua library file for our engine parameters {#engine-lib}

One of the conveniences of scripting in norns is the [parameters](/docs/norns/study-3/#parameters) system, which provides scripts with MIDI control + presets for free. While controlling our engine via the REPL's command line is fun, it's perhaps not the most effective means for all types of performances. But we don't want to leave parameter initialization and engine maintenance up to the main script -- if somebody builds a fantastic control scheme and simply wants to drop in our engine, we don't want them to have to dig through SuperCollider code to figure out how to best address all of our different commands from Lua.

So, to cleanly + portably integrate our engine into the norns ecosystem, let's build a companion Lua file for our engine which will bundle its commands as part of its use in a script!

We'll name this file `moonshine.lua` and we'll want it to live in our `code > engine_study > lib` folder -- so either create it there via maiden or import your externally-created `moonshine.lua` file to that location:

<details closed markdown="block">

<summary>
Moonshine Lua file
</summary>

```lua
-- this file easily adds Moonshine parameters to a host script
-- save it as 'moonshine.lua' under 'code > engine_study > lib'

local Moonshine = {}
local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

-- helper function to round and format parameter value text:
function round_form(param,quant,form)
  return(util.round(param,quant)..form)
end

-- first, we'll collect all of our commands into a table of norns-friendly ranges.
-- since all the voices share the same parameter names,
--   we can just iterate on this table and cleanly build 16 parameters across 9 voices.
local specs = {
  {type = "separator", name = "synthesis"},
  {id = 'amp', name = 'level', type = 'control', min = 0, max = 2, warp = 'lin', default = 1, formatter = function(param) return (round_form(param:get()*100,1,"%")) end},
  {id = 'sub_div', name = 'sub division', type = 'number', min = 1, max = 10, default = 1},
  {id = 'noise_amp', name = 'noise level', type = 'control', min = 0, max = 2, warp = 'lin', default = 0, formatter = function(param) return (round_form(param:get()*100,1,"%")) end},
  {id = 'cutoff', name = 'filter cutoff', type = 'control', min = 20, max = 24000, warp = 'exp', default = 1200, formatter = function(param) return (round_form(param:get(),0.01," hz")) end},
  {id = 'cutoff_env', name = 'filter envelope', type = 'number', min = 0, max = 1, default = 1, formatter = function(param) return (param:get() == 1 and "on" or "off") end},
  {id = 'resonance', name = 'filter q', type = 'control', min = 0, max = 4, warp = 'lin', default = 2, formatter = function(param) return (round_form(util.linlin(0,4,0,100,param:get()),1,"%")) end},
  {id = 'attack', name = 'attack', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'release', name = 'release', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.3, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'pan', name = 'pan', type = 'control', min = -1, max = 1, warp = 'lin', default = 0, formatter = Formatters.bipolar_as_pan_widget},
  {type = "separator", name = "slews"},
  {id = 'freq_slew', name = 'frequency slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'amp_slew', name = 'level slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'noise_slew', name = 'noise level slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.05, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'pan_slew', name = 'pan slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.5, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
}

-- initialize parameters:
function Moonshine.add_params()
  params:add_separator("Moonshine")
  local voices = {"all",1,2,3,4,5,6,7,8} -- match the engine's expected arguments for commands
  for i = 1,#voices do -- for each voice...
    params:add_group("voice ["..voices[i].."]",#specs) -- add a PARAMS group, eg. 'voice [all]'
    for j = 1,#specs do -- for each of the lines in the 'specs' table above, do this:
      local p = specs[j] -- (creates an alias for the line's contents)
      if p.type == 'control' then -- if the 'type' in the current 'specs' line is 'control', do this:
        params:add_control( -- add a control using:
          voices[i].."_"..p.id, -- the 'id' in the line
          p.name, -- the name in the line
          ControlSpec.new(p.min, p.max, p.warp, 0, p.default), -- the controlspec values in the line ('min', 'max', 'warp', and 'default')
          p.formatter -- the formatter in the line
        )
      elseif p.type == 'number' then -- otherwise, if the 'type' is 'number', do this:
        params:add_number(
          voices[i].."_"..p.id,
          p.name,
          p.min,
          p.max,
          p.default,
          p.formatter
        )
      elseif p.type == "option" then -- otherwise, if the 'type' is 'option', do this:
        params:add_option(
          voices[i].."_"..p.id,
          p.name,
          p.options,
          p.default
        )
      elseif p.type == 'separator' then -- otherwise, if the 'type' is 'separator', do this:
        params:add_separator(p.name)
      end
      
      -- if the parameter type isn't a separator, then we want to assign it an action to control the engine:
      if p.type ~= 'separator' then
        params:set_action(voices[i].."_"..p.id, function(x)
          -- use the line's 'id' as the engine command, eg. engine.amp or engine.cutoff_env,
          --  and send the voice and the value:
          engine[p.id](voices[i],x) -- 
          if voices[i] == "all" then -- it's nice to echo 'all' changes back to the parameters themselves
            -- since 'all' voice corresponds to the first entry in 'voices' table,
            --   we iterate the other parameter groups as 2 through 9:
            for other_voices = 2,9 do
              -- send value changes silently, since 'all' changes all values on SuperCollider's side:
              params:set(voices[other_voices].."_"..p.id, x, true)
            end
          end
        end)
      end
      
    end
  end
  -- activate the parameters' current values:
  params:bang()
end

 -- we return these engine-specific Lua functions back to the host script:
return Moonshine
```

</details>

Something to note about the above code is that it uses a table to hold all of the parameter commands we want to control -- this type of central data repository helps us quickly establish 144 parameters in less than 100 lines of code. Tables are a uniquely helpful feature of Lua -- we can iterate through them without trouble, and even nest their iteration to create many layers of control and data throughout our script. See [norns study 3](/docs/norns/study-3/#more-tangled) and the [Tables Tutorial from lua-users](http://lua-users.org/wiki/TablesTutorial) for more insight.

### import, initialize, play {#import}

Now that our engine's timbral commands are all self-contained as norns parameters, a host script can import + initialize `Moonshine` very easily. Let's build off of our previous `moonshine_sequins.lua` [example](#sequins-example) to play with these changes:

<details closed markdown="block">

<summary>
SC engine study 2: import, initialize, play
</summary>

```lua
engine.name = 'Moonshine'

moonshine_setup = include 'lib/moonshine'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'
-- see https://monome.org/docs/norns/reference/lib/sequins for more info

function init()
  moonshine_setup.add_params()
  mults = {
    s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} }, -- create a sequins of hz multiples for voice 1
    s{0.25, 1.25, s{2/3, 3.5, 1/3} }, -- create a sequins of hz multiples for voice 2
    s{2, 1.25, s{3.5, 1.5, 2.25, 0.5} } -- create a sequins of hz multiples for voice 3
  }
  playing = false
  base_hz = 200
  sequence = {}
  sequence[1] = clock.run(
    function()
      while true do
        clock.sync(1/4)
        if playing then
          for i = 1,2 do
            engine.trig(i, base_hz * mults[i]() * math.random(2))
          end
        end
      end
    end
  )
  
  sequence[2] = clock.run(
    function()
      while true do
        clock.sync(3)
        if playing then
          engine.trig(3, base_hz * mults[3]())
          clock.sync(1)
          engine.freq(3, base_hz * mults[3]())
        end
      end
    end
  )
  
  -- some default parameters:
  for i = 1,2 do
    params:set(i.."_amp",0.65)
    params:set(i.."_attack",0)
    params:set(i.."_release",0.3)
    params:set(i.."_pan",i == 1 and -1 or 1)
    params:set(i.."_cutoff",2300)
  end
  params:set("3_amp",0.55)
  params:set("3_cutoff",16000)
  params:set("3_attack",clock.get_beat_sec()*2.5)
  params:set("3_release",clock.get_beat_sec()*0.75)
  params:set("3_freq_slew",clock.get_beat_sec()/2)
  params:set("3_pan_slew", clock.get_beat_sec()*2)
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    for i = 1,3 do
      mults[i]:reset() -- resets sequins index to 1
    end
    if not playing then
        engine.free_all_notes()
      end
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

</details>

As the sequences run, head to the `PARAMETERS > EDIT` screen to change our newly-minted parameters! Any changes to `voice [1]`, `voice [2]`, and `voice [3]` will be immediately heard -- you can also use `voice [all]` to proliferate changes to all three voices at once!

## part 3: explore + extend

That was a *lot* to cover -- if you've made it to this point, **thank you** for digging in so openly and we really hope this text helped model a few key tools to continue sharpening as you work with norns + SuperCollider.

For SuperCollider:

- keep your SynthDefs and your CroneEngine boilerplate files separated, so you can easily work with your synths on any non-norns computer
- try Groups to build class files which allow realtime changes to active sounds
- try `.lag` variants to slew value changes on active voices
- try `Select.kr` to replicate if-then statements in a SynthDef
- try Dictionaries in your class files to proliferate parameters across many voices

For norns:

- be mindful of how script authors will control your engine + build clear commands
- bundle a `lib` file with your engine, which handles all the parameter initialization and control for it -- this will make it easy for other artists to adopt your synth into their scripts
- take advantage of the flexibility of norns parameter formatting to build parameters with clear names, ranges, and descriptors

You can also download the final versions of our class, Crone Engine, Lua parameter container, and example script here: [`engine_study_2.zip`](/docs/norns/engine_study_2.zip)

### next assignment: MIDI

We got to a pretty complete [sequins](/docs/norns/reference/lib/sequins)-powered example in the previous section, but perhaps you'd rather trigger the synth with a keyboard -- that'd be a fantastic extension! To get started, check out these scripting resources:

- [norns study 4](/docs/norns/study-4/#long-live-parts-of-the-80s), which has a full breakdown of incoming + outgoing MIDI
- [musicutil's extended reference page](/docs/norns/reference/lib/musicutil), which will help you convert incoming MIDI to the Hz values `engine.trigger(x,hz)` and `engine.freq(x,hz)` are expecting

You'll also might want to modify the Moonshine class and CroneEngine files to add `note_on` and `note_off` commands, instead of relying on the fixed-envelope approach of `trig`. If you're feeling nervous, start by checking out how other norns engines manage these types of commands and compare that to Moonshine's structure. You'll also want to change the SynthDef's envelope for `Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve, bias)`. Having your Moonshine class file on your non-norns computer is going to come in handy as you modify, recompile, and test these changes.

This type of open exploration is the fun stuff! Modifying existing code is a really rewarding way to build collaboratively across time, even if you've never met the author. Plus, you'll always have a strong base to return to if things get funky.

### further

If you feel prepared to explore both SuperCollider and Lua more deeply (and hopefully you do!), here are a few jumping-off points to extend the `Moonshine` engine:

- show parameter values on the screen
- create an on-norns interaction for parameter manipulation in the main script UI
- create a separate envelope for filter cutoff modulation

To continue exploring + creating new synthesis engines for norns, we highly recommend:

-  Zack Scholl's incredible resources for SuperCollider + norns explorations:
	-  [Tone to Drone](https://musichackspace.org/events/tone-to-drone-introduction-to-supercollider-for-monome-norns-live-session/) (produced in partnership between monome and Music Hackspace)
	-  [Ample Samples](https://musichackspace.org/events/ample-samples-introduction-to-supercollider-for-monome-norns-live-session/) (produced in partnership between monome and Music Hackspace)
  - [Zack's #supercollider blog entries](https://schollz.com/tags/supercollider/)
- [Eli Fieldsteel's *fantastic* YouTube series](https://youtu.be/yRzsOOiJ_p4)
- [norns SuperCollider engines index](https://norns.community/libs-and-engines#supercollider-engines)
