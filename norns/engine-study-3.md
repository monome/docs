---
layout: default
nav_exclude: true
permalink: /norns/engine-study-3/
---

# transit authority
{: .no_toc }

*norns engine study 3: using audio busses to build FX chains + aux sends, and using polls to send data from SuperCollider back to Lua*

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. Many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined).

This study extends the topics covered in [rude mechanicals](/docs/norns/engine-study-1/), which outlines starting points for engine development on norns using SuperCollider, and [skilled labor](/docs/norns/engine-study-2/), which covers polyphony and realtime timbral changes. As with each of those studies, we'll assume that you've already got a bit of familiarity with SuperCollider -- if not, be sure to check out [learning SuperCollider](/docs/norns/studies/#learning-supercollider) for helpful resources and come back here after some experimentation.

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

**Please note** that if you're new to SuperCollider, you'll likely make some unexpectedly loud / sharp sounds. Nathan Ho has some fantastic tips [on his site](https://nathan.ho.name/posts/supercollider-tips/), specifically for "Levels management and volume safety":

> A quick summary:
>
> 1. If you are on macOS, upgrade to at least SC 3.12 right dang now and add Server.default.options.safetyClipThreshold = 1 to your startup file so the audio output clips.  
> 2. Work at low levels in your system’s volume control, but high levels in SC. If your audio is at a comfortable level and peaks in SC at -6 dBFS, the loudest sounds can only peak at 6 dB louder than that, so a synthesis accident can be startling, but unlikely to be dangerous.  
> 3. As a corollary: if SC produces a quiet signal, do not turn up the volume using your computer’s volume control! Instead, turn it up in SC.  
> 4. Use a Limiter on the master bus.  
> 5. Type in gain amounts as e.g. * -60.dbamp instead of * 0.001.

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

The *Moonshine* engine we extended in [skilled labor](/docs/norns/engine-study-2/) built on our understanding of SuperCollider's relationship to norns scripting by:

- breaking our SuperCollider files into separate *class* and *CroneEngine* files
- using Groups in SuperCollider to manage realtime parameter changes to a playing voice
- modeling an approach to polyphony and voice distribution in SuperCollider
- structuring a template for Lua parameters
- gluing it all together into an example norns script

This third study will turn its focus from the core synth voices toward working with FX by:

- establishing Busses to route signals from one place in the Server to another
- being explicit about the ordering of synths and busses on the Server, and being purposeful about syncing those changes
- using [polls](/docs/norns/reference/poll) to send data from SuperCollider back to norns

## part 1: shuttling signals {#part-1}

Before we get into retrofitting Moonshine with an FX bus, let's first demonstrate how Busses can be used to shuttle signals around the Server.

It'll also likely be helpful to pull up SuperCollider's [documentation on Busses](https://doc.sccode.org/Tutorials/Getting-Started/11-Busses.html).

### formatting

Note that we'll be demonstrating a slightly different formatting for arguments in this study than the previous two chapters.

Previously, we established all of our arguments at the start of the SynthDef. For example:

```js
SynthDef("source", {
	arg hz = 330, outMain = 0, panMain = 0, levelMain = 1;
	var snd = LPF.ar(Saw.ar(hz), hz*4);
	snd = snd * LagUD.ar(Impulse.ar(2), 0, 0.5);

	Out.ar(outMain, Pan2.ar(snd, panMain) * levelMain);
}).add;
```

In this study, we'll showcase a slightly different but totally synonymous argument formatting, using `.kr` (signifying a continuous control rate signal):

```js
SynthDef("source", {
	var snd = LPF.ar(Saw.ar(\hz.kr(330)), (\hz.kr(330)*8).clip(20,20000);
	snd = snd * LagUD.ar(Impulse.ar(2), 0, 0.5);

	Out.ar(\outMain.kr(0), Pan2.ar(snd, \panMain.kr(0)) * \levelMain.kr(1));
}).add;
```

We like this `.kr` formatting because it quickly draws attention to all the places where an argument gets utilized in the code.

### building some sends

In this example, we'll send a source sound to two FX sends and a main output.

<details closed markdown="block">

<summary>
`study-3-1.scd`
</summary>

```js
// SC Bus exercise 1: building some sends

// CMD + ENTER / CTRL + ENTER from here to run the code
(
// create a Dictionary of synths:
~synths = Dictionary.new;

// create a Dictionary of audio busses:
~busses = Dictionary.new;
~busses[\mainOut] = Bus.audio(server: Server.default, numChannels: 2);
~busses[\delaySend] = Bus.audio(server: Server.default, numChannels: 2);
~busses[\reverbSend] = Bus.audio(server: Server.default, numChannels: 2);

// alias our Server:
s = Server.default;

// make a Routine, so that we can sync changes to the Server
Routine{

	// define our source sound:
	SynthDef("source", {
		var snd = LPF.ar(Saw.ar(\hz.kr(330)), (\hz.kr(330)*8)).clip(20,20000);
		snd = snd * LagUD.ar(Impulse.ar(2), 0, 2);

		Out.ar(\outMain.kr, (snd * \levelMain.kr(1)).dup); // .dup = send stereo signal
		Out.ar(\outSend1.kr, (snd * \levelSend1.kr(0)).dup);
		Out.ar(\outSend2.kr, (snd * \levelSend2.kr(0)).dup);
	}).add;

	// define our delay:
	SynthDef("delay", {
		Out.ar(\out.kr, CombC.ar(In.ar(\in.kr, 2),1.0,0.2,3.2));
	}).add;

	// define our reverb:
	SynthDef("reverb", {
		var sig = In.ar(\in.kr, 2);
		Out.ar(\out.kr, FreeVerb2.ar(sig[0], sig[1], 1.0, 0.7, 0.2, 1.5));
	}).add;

	// define our main output:
	SynthDef("main", {
		Out.ar(\out.kr, In.ar(\in.kr, 2));
	}).add;

	// we sync the Server here so that the common SynthDefs above
	//   are present on the Server when requested below
	s.sync;

	// build our source + pass it arguments:
	~synths[\source] = Synth.new("source", [
		\outMain, ~busses[\mainOut], // connecting to the mainOut bus
		\outSend1, ~busses[\delaySend], // connecting to the delaySend bus
		\outSend2, ~busses[\reverbSend] // connecting to the reverbSend bus
	]);

	// build our delay AFTER our source
	//   and pass it arguments:
	~synths[\delay] = Synth.after(~synths[\source], "delay", [
		\in, ~busses[\delaySend], // input = the delaySend bus
		\out, ~busses[\mainOut] // output = the mainOut bus
	]);

	// build our reverb AFTER our delay
	//   and pass it arguments:
	~synths[\reverb] = Synth.after(~synths[\delay], "reverb", [
		\in, ~busses[\reverbSend], // input = the reverbSend bus
		\out, ~busses[\mainOut] // output = the mainOut bus
	]);

	// build our main output AFTER our reverb
	//   and pass it arguments:
	~synths[\main] = Synth.after(~synths[\reverb], "main", [
		\in, ~busses[\mainOut], // input = the mainOut bus
		\out, 0 // output = the default output device
	]);
}.play;
)
```
</details>

After executing the code, you should hear a regular plucky note at 330 Hz. We can control its send levels via these commands:

```js
// send to main:
~synths[\source].set(\levelMain,1);
// send to delay:
~synths[\source].set(\levelSend1,1);
// send to reverb:
~synths[\source].set(\levelSend2,1);
// don't send to main:
~synths[\source].set(\levelMain,0);
// don't send to delay:
~synths[\source].set(\levelSend1,0);
// don't send to reverb:
~synths[\source].set(\levelSend2,0);
```

### Class file

It'd be nice to extend our sketch by:

- building it into a full Class file
- using [Groups](https://doc.sccode.org/Classes/Group.html) to organize our synths / nodes
- adding panning to each send (dry source, delay, reverb)
- establishing a few commands for control over level, panning, and the Hertz of the played note

Of note in this example:

- rather than force our source sound into stereo with `.dup` (as in our previous example), we'll simply feed it into a two channel panning UGen
- we'll use a Group (assigned var `g`) to control the order of execution, which will include specifying `target:g` and `addAction:\addToTail` for each of our synths
- we'll use `s.sync` every time we want to execute what is queued for the Server, before adding more synths / nodes
- instead of adding a panning control to each stage's synth, we'll use panning to specify the stereo placement of the source as its *sent* into each FX stage

<details closed markdown="block">

<summary>
`FXBusDemo.sc`
</summary>
```js
// SC Bus exercise 2
// busses in a class with panning + commands

FXBusDemo {

	var <synths;
	var <busses;
	var <g;

	*new {
		^super.new.init();
	}

	init {
		var s = Server.default;
		synths = Dictionary.new;
		busses = Dictionary.new;

		Routine {
			// in this demo, source bus is mono / FX are stereo:
			busses[\source] = Bus.audio(s, 1);
			busses[\main_out] = Bus.audio(s, 2);
			busses[\reverb_send] = Bus.audio(s, 2);
			busses[\delay_send] = Bus.audio(s, 2);

			// define our patch synths, to control stereo field:
			SynthDef.new(\patch_pan, {
				Out.ar(\out.kr, Pan2.ar(In.ar(\in.kr), \pan.kr(0), \level.kr(1)));
			}).send(s);

			SynthDef.new(\patch_main, {
				Out.ar(\out.kr, In.ar(\in.kr, 2) * \level.kr(1));
			}).send(s);

			// add a group to order our synths / nodes:
			g = Group.new(s);

			// define our source synth:
			synths[\source] = SynthDef.new(\sourceBlip, {
				var snd = LPF.ar(Saw.ar(\hz.kr(330)), (\hz.kr(330)*8).clip(20,20000));
				snd = snd * LagUD.ar(Impulse.ar(2), 0, 2);
				Out.ar(\out.kr, snd * \level.kr(0.5));
			}).play(target:g, addAction:\addToTail, args:[
				\out, busses[\source]
			]);

			// why are we syncing here? two reasons:
			// 1. so the common SynthDefs above are present on the Server when requested
			// 2. because the send synths below use \addToTail,
			//   we need the Server to finish creating the source synth before they are added
			s.sync;

			synths[\dry] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\main_out],
					\level, 1.0
			]);

			synths[\delay_send] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\delay_send],
					\level, 0.0
			]);

			synths[\reverb_send] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\reverb_send],
					\level, 0.0
			]);

			synths[\delay] = SynthDef.new(\delay, {
				arg in, out, level=1;
				Out.ar(out, DelayC.ar(In.ar(in, 2), 1.0, 0.2, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\delay_send], \out, busses[\main_out]
			]);

			synths[\reverb] = SynthDef.new(\reverb, {
				arg in, out, level=1;
				Out.ar(out, FreeVerb.ar(In.ar(in, 2), 1.0, 0.9, 0.1, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\reverb_send], \out, busses[\main_out]
			]);

			// again, we want the next synth to actually be added *after* all others
			s.sync;

			synths[\main_out] = Synth.new(\patch_main,
				target:g, addAction:\addToTail, args: [
					\in, busses[\main_out], \out, 0
			]);

		}.play;
	}

	setLevel { arg key, val;
		synths[key].set(\level, val);
	}

	setPan { arg key, val;
		synths[key].set(\pan, val);
	}

	setHz { arg val;
		synths[\source].set(\hz, val);
	}

	// IMPORTANT: free Server resources and nodes when done!
	free {
		g.free;
		busses.do({arg bus; bus.free;});
	}

}
```
</details>

To move forward, we'll need to save this Class definition in a place on our non-norns computer where SuperCollider can find it. We've covered this process in [skilled labor](/docs/norns/engine-study-2/#class_example-1), so we won't repeat those steps here.

Now, to have your class definition useable in SuperCollider, recompile the class library via `Language > Recompile Class Library`.

#### instantiate the class

When the library recompiles, we should be able to instantiate the `FXBusDemo` Class and its associated methods like any other class in SuperCollider. To try it out, open a blank SuperCollider file and type + live-execute (<kbd>Ctrl-Enter</kbd> on Windows/Linux or <kbd>CMD-RETURN</kbd> on macOS) the following lines:

```
// take note of the server nodes that print:
s.queryAllNodes;

// execute this line to start up the FXBusDemo:
x = FXBusDemo.new();

// take another look at the server:
s.queryAllNodes;
// you should see a group present with 'sourceBlip', 'patch_pan', etc

// execute one cluster at a time:
x.setLevel(\delay_send,0.6);
x.setLevel(\reverb_send,0.6);

x.setPan(\dry,1);
x.setPan(\delay_send,-1);

x.setLevel(\dry, 0);
x.setPan(\reverb_send,1);

x.setHz(330/3);

x.setHz(330*0.75);
```

#### side-quest: adding a DJ-style isolator {#sidequest}

*nb. many thanks to Ezra for their assistance with this topic!*

Adventures in reproducing hardware are very rewarding in SuperCollider -- they allow us to concretize our understanding of the devices we'd like to model and expand our understanding of DSP theory. So, before we move into polls, let's round out our final audio stage with a [DJ-style isolator](https://djtechtools.com/2011/12/11/an-introduction-to-mixing-with-dj-isolator-mixers/).

An isolator is a very handy tool for creative mixing. It allows you to selectively cut or boost "low", "mid" and "high" bands within an input signal. Most importantly, it has a flat response -- when all three bands are at 0dB, the isolator should not color the input signal.

To keep things simple, we'll use [`LPF`](https://doc.sccode.org/Classes/LPF.html) and [`HPF`](https://doc.sccode.org/Classes/HPF.html), which are non-resonant 2nd-order Butterworth filters. However, if we naively mix a lowpass and highpass Butterworth at the same FC, we get a +3db bump at the filter cutoff. To avoid this, we'll cascade *two* 2nd order Butterworths -- this gets us a [Linkwitz-Riley](https://en.wikipedia.org/wiki/Linkwitz%E2%80%93Riley_filter) filter, which is a standard building block for crossovers. So, we'll take a lowpass and highpass L-R filter at same frequency, with a mid section, and their sum will have a flat magnitude response.

Here's an example of this architecture:

```js
// white noise source, watch your ears!
(
z = {
	var src = WhiteNoise.ar;
	var fc1 = \fc1.kr(600);
	var fc2 = \fc2.kr(1800);
	
	var ampLo = \ampLo.kr(1);
	var ampMid = \ampMid.kr(1);
	var ampHi = \ampHi.kr(1);
	
	var lo = LPF.ar(LPF.ar(src, fc1), fc1) * ampLo;
	var mid = HPF.ar(HPF.ar(LPF.ar(LPF.ar(src, fc2), fc2), fc1), fc1) * ampMid;
	var hi = HPF.ar(HPF.ar(src, fc2), fc2) * ampHi;
	
	Out.ar(\out.kr(0), ((lo + mid + hi) * \amp.kr(0.2)).dup);
}.play(s, \addToTail);
)

// controls:
z.set(\ampLo,0);
z.set(\ampMid,0);
z.set(\ampHi,0);

z.set(\ampLo,1);
z.set(\ampMid,1);
z.set(\ampHi,1);
```

To add this functionality, we'll adjust `\patch_main`:

```js
SynthDef.new(\patch_main, {
	var src = In.ar(\in.kr, 2);
	var fc1 = \fc1.kr(600);
	var fc2 = \fc2.kr(1800);
	
	var ampLo = \ampLo.kr(1);
	var ampMid = \ampMid.kr(1);
	var ampHi = \ampHi.kr(1);
	
	var lo = LPF.ar(LPF.ar(src, fc1), fc1) * ampLo;
	var mid = HPF.ar(HPF.ar(LPF.ar(LPF.ar(src, fc2), fc2), fc1), fc1) * ampMid;
	var hi = HPF.ar(HPF.ar(src, fc2), fc2) * ampHi;
	
	var mix = lo + mid + hi;
	
	Out.ar(\out.kr, mix * \level.kr(1));
}).send(s);
```

And to control it, we'll add a `setMain` command:

```js
setMain { arg key, val;
	synths[\main_out].set(key, val);
}
```

<details closed markdown="block">
<summary>
Our new `FXBusDemo.sc`
</summary>

```js
// SC Bus exercise 3
// adding an isolator

FXBusDemo {

	var <synths;
	var <busses;
	var <g;

	*new {
		^super.new.init();
	}

	init {
		var s = Server.default;
		synths = Dictionary.new;
		busses = Dictionary.new;

		Routine {
			// in this demo, source bus is mono / FX are stereo:
			busses[\source] = Bus.audio(s, 1);
			busses[\main_out] = Bus.audio(s, 2);
			busses[\reverb_send] = Bus.audio(s, 2);
			busses[\delay_send] = Bus.audio(s, 2);

			// define our patch synths, to control stereo field:
			SynthDef.new(\patch_pan, {
				Out.ar(\out.kr, Pan2.ar(In.ar(\in.kr), \pan.kr(0), \level.kr(1)));
			}).send(s);

			// NEW: build an isolator into our main output:
			SynthDef.new(\patch_main, {
				var src = In.ar(\in.kr, 2);
				var fc1 = \fc1.kr(600);
				var fc2 = \fc2.kr(1800);

				var ampLo = \ampLo.kr(1);
				var ampMid = \ampMid.kr(1);
				var ampHi = \ampHi.kr(1);

				var lo = LPF.ar(LPF.ar(src, fc1), fc1) * ampLo;
				var mid = HPF.ar(HPF.ar(LPF.ar(LPF.ar(src, fc2), fc2), fc1), fc1) * ampMid;
				var hi = HPF.ar(HPF.ar(src, fc2), fc2) * ampHi;

				var mix = lo + mid + hi;

				Out.ar(\out.kr, mix * \level.kr(1));
			}).send(s);

			// add a group to order our synths / nodes:
			g = Group.new(s);

			// define our source synth:
			synths[\source] = SynthDef.new(\sourceBlip, {
				var snd = LPF.ar(Saw.ar(\hz.kr(330)), (\hz.kr(330)*8).clip(20,20000));
				snd = snd * LagUD.ar(Impulse.ar(2), 0, 2);
				Out.ar(\out.kr, snd * \level.kr(0.5));
			}).play(target:g, addAction:\addToTail, args:[
				\out, busses[\source]
			]);

			// why are we syncing here? two reasons:
			// 1. so the common SynthDefs above are present on the Server when requested
			// 2. because the send synths below use \addToTail,
			//   we need the Server to finish creating the source synth before they are added
			s.sync;

			synths[\dry] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\main_out],
					\level, 1.0
			]);

			synths[\delay_send] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\delay_send],
					\level, 0.0
			]);

			synths[\reverb_send] = Synth.new(\patch_pan,
				target:g, addAction:\addToTail, args:[
					\in, busses[\source],
					\out, busses[\reverb_send],
					\level, 0.0
			]);

			synths[\delay] = SynthDef.new(\delay, {
				arg in, out, level=1;
				Out.ar(out, DelayC.ar(In.ar(in, 2), 1.0, 0.2, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\delay_send], \out, busses[\main_out]
			]);

			synths[\reverb] = SynthDef.new(\reverb, {
				arg in, out, level=1;
				Out.ar(out, FreeVerb.ar(In.ar(in, 2), 1.0, 0.9, 0.1, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\reverb_send], \out, busses[\main_out]
			]);

			// again, we want the next synth to actually be added *after* all others
			s.sync;

			synths[\main_out] = Synth.new(\patch_main,
				target:g, addAction:\addToTail, args: [
					\in, busses[\main_out], \out, 0
			]);

		}.play;
	}

	setLevel { arg key, val;
		synths[key].set(\level, val);
	}

	setPan { arg key, val;
		synths[key].set(\pan, val);
	}

	setHz { arg val;
		synths[\source].set(\hz, val);
	}

	// NEW: add controls for our main_out synth:
	setMain { arg key, val;
		synths[\main_out].set(key, val);
	}

	// IMPORTANT: free Server resources and nodes when done!
	free {
		g.free;
		busses.do({arg bus; bus.free;});
	}

}
```
</details>

Recompile the class library via `Language > Recompile Class Library` and run:

```js
// start the synth:
(
Routine{
	x = FXBusDemo.new();
	0.05.wait;
	x.setHz(330*0.75);
	x.setLevel(\delay_send,0.6);
	x.setLevel(\reverb_send,0.6);
	
	x.setPan(\delay_send,-1);
	x.setPan(\reverb_send,1);
}.play;
)

// control the isolator:
x.setMain(\ampLo,0);
x.setMain(\ampMid,0);
x.setMain(\ampHi,0);

x.setMain(\ampLo,1);
x.setMain(\ampMid,1);
x.setMain(\ampHi,1);
```

## part 2: turn on the engine {#part-2}

As in our previous studies, we'll now construct a norns engine from this SuperCollider Class file.

Just for review: a norns engine an instance of the built-in [CroneEngine Class](https://github.com/monome/norns/blob/main/sc/core/CroneEngine.sc), which gives a standardized structure to shuttle meaningful commands and their values between Supercollider and Lua.

<details>
<summary>`Engine_FXBusDemo.sc`</summary>
```js
Engine_FXBusDemo : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke FXBusDemo with
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		// NEW: since FXBusDemo is now a supercollider Class,
		//   we can just construct an instance of it
		kernel = FXBusDemo.new(Crone.server);

		// NEW: build an 'engine.set_level(synth,val)' command
		this.addCommand(\set_level, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var freq = msg[2].asFloat;
			kernel.setLevel(voiceKey,freq);
		});

		// NEW: build an 'engine.set_pan(synth,val)' command
		this.addCommand(\set_pan, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var freq = msg[2].asFloat;
			kernel.setPan(voiceKey,freq);
		});

		// NEW: build an 'engine.set_hz(val)' command
		this.addCommand(\set_hz, "f", { arg msg;
			var freq = msg[1].asFloat;
			kernel.setHz(freq);
		});

		// NEW: build an 'engine.set_main(key,val)' command
		this.addCommand(\set_main, "sf", { arg msg;
			var key = msg[1].asSymbol;
			var val = msg[2].asFloat;
			kernel.setMain(key,val);
		});

	} // alloc


	// NEW: when the script releases the engine,
	//   free Server resources and nodes!
	// IMPORTANT
	free {
		kernel.free;
	} // free


} // CroneEngine
```
</details>

### bring it all onto norns

Let's get our SuperCollider files onto norns and test things out.

Connect to norns via [one of the transfer methods](/docs/norns/wifi-files/#transfer).  

If you completed the [rude mechanicals](/docs/norns/engine-study-1/) study, then simply navigate to your `code/engine_study/lib` folder on norns.  

If you didn't complete the previous study:

- create a folder inside of `code` named `engine_study`
- create a folder inside of `engine_study` named `lib`

Under `lib`, we'll want to drop in copies of our `FXBusDemo.sc` and `Engine_FXBusDemo.sc` files. Once they're imported, use `SYSTEM > RESTART` on norns to recompile its SuperCollider library and get the Lua layer synced with the new engine files.

### building our Lua file

Let's build a script which engages our `FXBusDemo` engine and builds some norns parameters to control it.

<details>
<summary>`engine_study_3.lua`</summary>
```lua
-- norns engine study 3: Busses

engine.name = "FXBusDemo"
formatters = require("formatters")

function init()
  default_vals = {
    amp = {
      min = 0,
      max = 2,
      default = 1,
      quantum = 1 / 200,
      step = 0.001,
      formatter = function(param)
        return ((param:get() * 100) .. "%")
      end,
    },
    pan = {
      min = -1,
      max = 1,
      default = 0,
      quantum = 1 / 200,
      step = 0.001,
      formatter = formatters.bipolar_as_pan_widget,
    },
  }

  level_params = {
    { type = "separator", id = "levels_separator", name = "levels" },
    {
      id = "dry_level",
      name = "dry level",
      action_key = "dry",
    },
    {
      id = "delay_level",
      name = "delay level",
      action_key = "delay_send",
    },
    {
      id = "reverb_level",
      name = "reverb level",
      action_key = "reverb_send",
    },
  }

  pan_params = {
    { type = "separator", id = "pan_separator", name = "panning" },
    {
      id = "dry_pan",
      name = "dry pan",
      action_key = "dry",
    },
    {
      id = "delay_pan",
      name = "delay pan",
      action_key = "delay_send",
    },
    {
      id = "reverb_pan",
      name = "reverb pan",
      action_key = "reverb_send",
    },
  }

  eq_params = {
    { type = "separator", id = "main_separator", name = "main EQ" },
    {
      id = "ampLo",
      name = "lo",
    },
    {
      id = "ampMid",
      name = "mid",
    },
    {
      id = "ampHi",
      name = "hi",
    },
  }

  for i = 1, #level_params do
    local d = level_params[i]
    local dv = default_vals.amp
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_level(d.action_key, x)
      end)
    end
  end

  for i = 1, #pan_params do
    local d = pan_params[i]
    local dv = default_vals.pan
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_pan(d.action_key, x)
      end)
    end
  end

  for i = 1, #eq_params do
    local d = eq_params[i]
    local dv = default_vals.amp
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_main(d.id, x)
      end)
    end
  end

  params:set("delay_level", 0)
  params:set("reverb_level", 0)

  params:bang()
end
```


Alright, take a break! You've done a lot of typing and experimenting for one sitting. We'll see you back here soon.

## part 3: polls {#part-3}

So far, our studies have all been focused on sending data from Lua to SuperCollider, using engine *commands*. We can also go the other direction, using engine *polls*.

Polls report basic data from the audio subsystem, for use within a script. We can use them to trigger script events based on incoming amplitude, or capture the pitch and match it with a synth engine. See [study 5](/docs/norns/study-5/#numerical-superstorm) for additional examples.

For the purposes of this study, let's measure the spectral flatness of our final stage output and send that to Lua for visualization.

### FFT

We'll use SuperCollider's Fast Fourier Transform tools for analyzing our final signal

### further

If you feel prepared to explore both SuperCollider and Lua more deeply (and hopefully you do!), here are a few jumping-off points to extend the `Moonshine` engine:

- show parameter values on the screen
- create an on-norns interaction for parameter manipulation in the main script UI
- create a separate envelope for filter cutoff modulation

To continue exploring + creating new synthesis engines for norns, we highly recommend:

-  Zack Scholl's incredible resources for SuperCollider + norns explorations:
	-  [Tone to Drone](https://musichackspace.org/product/tone-to-drone-introduction-to-supercollider-for-monome-norns/)
	-  [Ample Samples](https://musichackspace.org/product/ample-samples-introduction-to-supercollider-for-monome-norns/
  - [Zack's #supercollider blog entries](https://schollz.com/tags/supercollider/)
- [Eli Fieldsteel's *fantastic* YouTube series](https://youtu.be/yRzsOOiJ_p4)
- [norns SuperCollider engines index](https://norns.community/libs-and-engines#supercollider-engines)

### acknowledgements

The `FXBusDemo` engine was written by Ezra Buchla + Dan Derks for [monome.org](https://monome.org).

This study's text was initiated by Dan Derks.