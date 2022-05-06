---
layout: default
nav_exclude: true
permalink: /norns/engine-study-2/
---

# skilled labor
{: .no_toc }

*norns engine study 2: expanding an engine, building classes, realtime changes, managing polyphony*

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. Many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined).

This study is meant to extend the topics covered in [rude mechanicals](/docs/norns/engine-study-1/), which outlines starting points for engine development on norns, using SuperCollider. Like that study, we'll assume here that you've already got a bit of familiarity with SuperCollider -- if not, be sure to check out [learning SuperCollider](/docs/norns/studies/#learning-supercollider) for helpful learning resources and come back here after some experimentation.

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

<!--Now, let's do a little norns housekeeping before digging into SuperCollider:

- create a folder inside of `code` named `engine_study_2`
- create a folder inside of `engine_study_2` named `lib`-->

## where we were, where we'll go

The *Moonshine* engine we built in [rude mechanicals](/docs/norns/engine-study-1/) showcased a few key elements of norns engine development:

- using a SuperCollider `Dictionary` to hold our parameters
- leveraging SuperCollider's built-in functions like `.keysDo` to establish norns-specific commands
- building a Lua file to bundle with your engine, to easily integrate it into another script

To reduce complexity, *Moonshine* polled the values of our synth at the time of creation -- this meant that changes to the filter cutoff wouldn't be articulated on an already-playing voice, but would serve as the starting point for the next note event. And while the engine is technically polyphonic, this is more a virtue of not establishing any specific way of handling voices.

This study will aim to build upon our understanding of SuperCollider's relationship to norns scripting by:

- breaking our SuperCollider files into separate *class* and CroneEngine files
- using Groups in SuperCollider to manage realtime parameter changes to a playing voice
- modeling two approaches to polyphony -- one in SuperCollider, the other in Lua

## part 1: building our class and CroneEngine files {#part-1}

Though the header for this section might be hard to parse, it'll set us up nicely for the rest of study.

In [rude mechanicals](/docs/norns/engine-study-1/), we combined our SynthDef declarations and all the required norns plumbing into a single file. This meant that our synth would work on norns but couldn't be loaded on a non-norns computer like your laptop without modification. As we develop engines, this becomes an annoyance -- it'd be easier to simply do our SuperCollider coding on our non-norns computer, where we can quickly test out changes to its shape, without engaging in a cycle of copying/pasting our SynthDef between the CroneEngine file and a throwaway SuperCollider file.

So, in order to extend our *Moonshine* engine, we'll rely on SuperCollider's handling of [objects](https://doc.sccode.org/Guides/Intro-to-Objects.html) -- this allows us to define a *class* to hold the sound-making bits separate from the code which only norns requires. In short, this means our SuperCollider code will be portable between norns and any other computer.

To start, open SuperCollider on your non-norns computer and create a new SuperCollider file.

### class file

Let's adapt our [previous Moonshine code](/docs/norns/engine-study-1/#moonshine-engine) to a standard class structure.

#### first adaptation {#class_example-1}

Rather than walk through each step here, we've added annotations to the code which will hopefully clarify any ambiguity:

```
// exercise 1: first adaptation
// a class does all the heavy lifting
// it defines our SynthDefs and handles variables, etc.

Moonshine {

	// we want 'params' to be accessible any time we instantiate this class,
	// so we'll prepend it with '<', which turns 'params' into a 'getter' method
	// see 'Getters and Setters' at https://doc.sccode.org/Guides/WritingClasses.html for more info
	var <params;

	*initClass {
		StartUp.add {
			var s = Server.default;
			// we need to make sure the server is running before asking it to do anything
			s.waitForBoot {
				// this is just our SynthDef from 'rude mechanicals':
				SynthDef("Moonshine", {
					arg freq, sub_div, noise_level,
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

					Out.ar(0,signal);
				}).add;
			} // s.waitForBoot
		} // StartUp
	} // *initClass

	*new { // when this class is initialized...
		^super.new.init; // ...run the init below.
	}

	init {
		// build a list of our sound-shaping parameters, with default values:
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
	// 'trigger' to play a note with the current 'params' settings:
	trigger { arg hz;
		Synth.new("Moonshine", [\freq, hz] ++ params.getPairs);
	}
	// 'setParam' to set one of our 'params' to a new value:
	setParam { arg paramKey, paramValue;
		params[paramKey] = paramValue;
	}

}
```

To keep working on this class definition on our non-norns computer, we'll want to save it in a place where SuperCollider can find it. According to the [SuperCollider docs for Writing Classes](https://doc.sccode.org/Guides/WritingClasses.html):

> NOTE: Class definitions are statically compiled when you launch SuperCollider or "recompile the library." This means that class definitions must be saved into a file with the extension .sc, in a disk location where SuperCollider looks for classes. Saving into the main class library (SCClassLibrary) is generally not recommended. It's preferable to use either the user or system extension directories.
> 
> ```
> Platform.userExtensionDir;   // Extensions available only to your user account
> Platform.systemExtensionDir; // Extensions available to all users on the machine
> ```

So, choose whether you want the class definition available to your *user account* or *all users* of your machine and execute one of the two stated invocations to learn where on your computer that specific `Extensions` folder lives.

Then, save the class definition as `moonshine.sc` to that location. Remember where, as we'll need to import it to norns later on.

Now, to have your class definition useable in SuperCollider, recompile the class library via `Language > Recompile Class Library`.

#### invoke the class

When the library recompiles, we should be able to invoke `Moonshine` and its associated methods like any other class in SuperCollider.

To try it out, open a blank SuperCollider file and type + live-execute (`Ctrl-Enter` or `CMD-RETURN` on macOS) the following:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute one line at a time:
x.trigger(400);

x.setParam(\release,3);

x.trigger(400/3);
```

If everything was successful, you should hear the Moonshine synth when you execute the `x.trigger(hz)` commands and you should be able to adjust parameter values for the next `.trigger` with `x.setParam(paramKey, paramValue)`.

#### second adaptation: make real-time changes with Groups {#class_example-2}

You might notice that `x.setParam(\pan,-1)` doesn't hard-pan any currently-playing voices to the left -- rather, it queues up a change for the *next* `.trigger`'d voices. To allow instantaneous control over our synth, we'll turn to SuperCollider's Groups, which are useful for controlling a number of synths while propagating changes instantly.

Here's our second adaptation, with changes demarcated by `NEW:` comments:

```
// second adaptation
// using a Group for instantaneous control

Moonshine {

	var <params;
	// NEW: add 'all_voices' variable to register each voice to a control group
	var <all_voices;

	*initClass {
		StartUp.add {
			var s = Server.default;

			s.waitForBoot {

				SynthDef("Moonshine", {
					arg freq, sub_div, noise_level,
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

					Out.ar(0,signal);
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

		// NEW: register 'all_voices' as a Group on the Server
		all_voices = Group.new(s);
	}


	trigger { arg hz;
		// NEW: set the target of every Synth voice to the 'all_voices' Group
		Synth.new("Moonshine", [\freq, hz] ++ params.getPairs, all_voices);
	}

	setParam { arg paramKey, paramValue;
		// NEW: send changes to the paramKey, paramValue pair immediately to all voices
		all_voices.set(paramKey, paramValue);
		params[paramKey] = paramValue;
	}

	// NEW: free our Group when the class is freed
	free {
		all_voices.free;
	}

}
```

Now, if we recompile our class library via `Language > Recompile Class Library`, we should be able to execute the following in SuperCollider and hear our active voices pan as they decay:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute this bundle:
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

x.setParam(\pan,rrand(-1.0,1.0).postln);

x.setParam(\cutoff,rrand(30,12000).postln);
```

If everything was successful, these changes should take immediate effect on the currently-playing Moonshine voices. What we now have is a sort of paraphonic synth architecture, where all voices share a single set of parameter control.

#### third adaptation: 8-voice polyphony + parameter slewing {#class_example-3}

The results of the second adaptation is more controllable than our initial shape, but we've traded polyphony (where each voice has its own signal path) for an architecture where all voices share a single set of controls. In our final adaptation, let's specify a few goals:

- 8-voice polyphony
- if a voice is re-triggered, it cuts itself off
- each voice has its own controllable parameters, but with a way to unify control over a single parameter
- changes to filter cutoff, noise level, synth amplitude, and panning should be slewed

Here's our third adaptation, with changes demarcated by `NEW:` comments:

```
// third adaptation
// 8-voice polyphony + smoothing

Moonshine {

	// NEW: add local 'voiceKeys' variable to register each voice name separately
	classvar <voiceKeys;
	// NEW: add 'global_voiceKeys' variable with a getter to send the local 'voiceKeys' externally
	var <global_voiceKeys;

	var <params;
	var <all_voices;
	// NEW: add 'single_voice' variable to control + track single voices
	var <single_voice;


	*initClass {
		// NEW: create voiceKey indices for as many voices as we want control over,
		// including an '\all' index to easily send one value to the same parameter on every voice
		voiceKeys = [ \1, \2, \3, \4, \5, \6, \7, \8, \all];
		StartUp.add {
			var s = Server.default;

			s.waitForBoot {

				SynthDef("Moonshine", {
					arg stopGate = 1,
					freq, sub_div, noise_level,
					cutoff, resonance,
					attack, release,
					amp, pan,
					// NEW: add slews to different parameters
					amp_slew, noise_slew, cutoff_slew, pan_slew;

					var pulse = Pulse.ar(freq: freq);
					var saw = Saw.ar(freq: freq);
					var sub = Pulse.ar(freq: freq/sub_div);
					// NEW: integrate slew using '.lag3'
					var noise = WhiteNoise.ar(mul: noise_level.lag3(noise_slew));
					var mix = Mix.ar([pulse,saw,sub,noise]);

					var envelope = EnvGen.kr(
						// NEW: separate 'amp' from the envelope, as it can't be changed after execution
						envelope: Env.perc(attackTime: attack, releaseTime: release, level: 1),
						// NEW: add a 'stopGate' to silence previous synth on this voice
						gate: stopGate,
						doneAction: 2
					);
					// NEW: integrate slew using '.lag3'
					var filter = MoogFF.ar(in: mix, freq: cutoff.lag3(cutoff_slew) * envelope, gain: resonance);
					// NEW: integrate slew using '.lag3'
					var signal = Pan2.ar(filter*envelope,pan.lag3(pan_slew));
					// NEW: bring 'amp' to final output calculation + integrate slew using '.lag3'
					Out.ar(0,signal * amp.lag3(amp_slew));
				}).add;
			}
		}
	}

	*new {
		^super.new.init;
	}

	init {

		var s = Server.default;

		all_voices = Group.new(s);

		// NEW: create a 'single_voice' Dictionary to control each voice individually
		single_voice = Dictionary.new;
		// NEW: 'params' will hold parameters for our individual voices
		params = Dictionary.new;
		// NEW: copy 'voiceKeys' (which is local to the class definition) in a public getter
		global_voiceKeys = voiceKeys;
		// NEW: for each of the 'voiceKeys'...
		voiceKeys.do({ arg voiceKey;
			// NEW: create a single_voice entry in the 'all_voices' group...
			single_voice[voiceKey] = Group.new(all_voices);
			// NEW: and add unique copies of the parameters to each voice
			params[voiceKey] = Dictionary.newFrom([
				\sub_div, 2,
				\noise_level, 0.1,
				\cutoff, 8000,
				\resonance, 3,
				\attack, 0,
				\release, 0.4,
				\amp, 0.5,
				\pan, 0,
				\amp_slew, 0.05,
				\noise_slew, 0.05,
				\cutoff_slew, 0.05,
				\pan_slew, 0.5;
			]);
		});
	}


	trigger { arg voiceKey, hz;
		// NEW: if the voice is '/all'...
		if( voiceKey == \all,{
		// NEW: then do the following for all the voiceKeys:
			voiceKeys.do({ arg vK;
				// NEW: don't trigger an actual synth for '\all', but do it for the other voiceKeys
				if( vK != \all,{
					// NEW: if the voice is already playing, gracefully release it
					single_voice[vK].set(\stopGate, -1.05); // -1.05 is 'forced release' with 50ms cutoff time
					// NEW: make sure to index each of our tables with our 'voiceKey'
					Synth.new("Moonshine", [\freq, hz] ++ params[vK].getPairs, single_voice[vK]);
				});
			});
		}, // NEW: else, if the voice is not '\all':
		{
			// NEW: if this voice is already playing, gracefully release it
			single_voice[voiceKey].set(\stopGate, -1.05); // -1.05 is 'forced release' with 50ms cutoff time
			// NEW: make sure to index each of our tables with our 'voiceKey'
			Synth.new("Moonshine", [\freq, hz] ++ params[voiceKey].getPairs, single_voice[voiceKey]);
		});
	}

	setParam { arg voiceKey, paramKey, paramValue;
		// NEW: if the voice is '/all'...
		if( voiceKey == \all,{
			// NEW: then do the following for all the voiceKeys:
			voiceKeys.do({ arg vK;
				// NEW: don't set values for '\all', but do it for the other voiceKeys
				if( vK != \all,{
					single_voice[vK].set(paramKey, paramValue);
					params[vK][paramKey] = paramValue
				});
			});
		}, // NEW: else, if the voice is not '\all':
		{
			// NEW: send changes to the correct 'single_voice' index,
			// which will immediately affect the 'voiceKey' synth
			single_voice[voiceKey].set(paramKey, paramValue);
			// NEW: proliferate the new values to the 'voiceKey'-indexed Dictionary
			params[voiceKey][paramKey] = paramValue;
		});
	}

	// NEW: since each 'single_voice' is a sub-Group of 'all_voices',
	// we can simply free the 'all_voices' Group when the class is freed.
	// IMPORTANT SO OUR SYNTHS DON'T RUN PAST THE SCRIPT'S LIFE
	free {
		all_voices.free;
	}

}
```

Now, if we recompile our class library via `Language > Recompile Class Library`, we should be able to execute the following in SuperCollider and hear our active voices take individual life:

```
// execute this line to start up Moonshine:
x = Moonshine.new();

// execute this bundle:
(
x.setParam(\all,\pan_slew,6);
x.setParam(\1,\release,0.2);
x.setParam(\2,\release,10);
x.setParam(\3,\release,3.3);
x.setParam(\4,\release,2.7);
x.trigger(\1,200/3);
x.trigger(\2,200/2);
x.trigger(\3,200);
x.trigger(\4,200*2);
)

// execute this bundle:
(// for each global_voiceKey...
x.global_voiceKeys.do({ arg voiceKey;
	// if the voiceKey is not '\all' then...
	if( voiceKey != \all,{
		// set '\pan' and '\cutoff' to random values
		x.setParam(voiceKey,\pan,rrand(-1.0,1.0));
		x.setParam(voiceKey, \cutoff,rrand(30,7000));
	});
});

x.setParam(\all,\release,rrand(1,12));
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

If everything was successful, it should feel like there's a *lot* of control over each voice. Every parameter can be unified using `\all`, or each voice can have its own settings using `\x` notation. This class definition feels pretty complete, so let's move onto our CroneEngine file!

### CroneEngine file

The CroneEngine file is what norns needs in order to shuttle meaningful engine commands and their values between Supercollider and Lua. We just spent a lot of time in our class definition file, so thankfully we don't need to spend much longer on the CroneEngine file!

```
Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke Moonshine to
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		kernel = Moonshine.new(Crone.server);

		this.addCommand(\trig, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var hz = msg[2].asFloat;
			kernel.trigger(voiceKey,hz);
		});

		this.addCommand(\set_param, "ssf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var paramKey = msg[2].asSymbol;
			var paramValue = msg[3].asFloat;
			kernel.setParam(voiceKey, paramKey, paramValue);
		});
	} // alloc

} // CroneEngine
```

That's it! Since we did so much planning inside of our class definition, our CroneEngine file pretty much just needs to invoke the class file and then create commands to surface to the Lua layer. Save it as `Engine_Moonshine.sc` somewhere you can find it easily, as we'll port everything we've done over to norns in the next section.

### bring it all onto norns

The next part of our study will involve only norns scripting, so let's get our SuperCollider files onto norns and test things out.

Connect to norns via [one of the transfer methods](/docs/norns/wifi-files/#transfer). If you completed the [rude mechanicals](/docs/norns/engine-study-1/) study, then simply navigate to your `code/engine_study/lib` folder on norns.

If you didn't complete the previous study:

- create a folder inside of `code` named `engine_study`
- create a folder inside of `engine_study` named `lib`

Under `lib`, we'll want to drop in copies of our `moonshine.sc` and `Moonshine_Engine.sc` files. Once they're imported, use `SYSTEM > RESTART` on norns to recompile the SuperCollider library and get the Lua layer synced with the new engine files.

Alright, take a break! You've done a lot of typing and experimenting for one sitting. We'll see you back here soon.

## part 2: scripting in Lua {#part-2}