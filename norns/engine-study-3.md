---
layout: default
nav_exclude: true
permalink: /norns/engine-study-3/
---

# transit authority
{: .no_toc }

*norns engine study 3: using audio busses to build FX chains and aux sends*

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
- being explicit about the ordering of synths and busses on the Server
- syncing changes to our Server architecture at key moments

## part 1: {#part-1}

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
	var snd = LPF.ar(Saw.ar(\hz.kr(330)), \hz.kr(330)*4);
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
		var snd = LPF.ar(Saw.ar(\hz.kr(330)), \hz.kr(330)*4);
		snd = snd * LagUD.ar(Impulse.ar(2), 0, 0.5);

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
			// in this demo, source bus is mono / fx are stereo:
			busses[\source] = Bus.audio(s, 1);
			busses[\main_out] = Bus.audio(s, 2);
			busses[\reverb_send] = Bus.audio(s, 2);
			busses[\delay_send] = Bus.audio(s, 2);

			// define our patch synths, to control stereo field:
			SynthDef.new(\patch_pan, {
				Out.ar(\out.kr, Pan2.ar(In.ar(\in.kr), \pan.kr(0), \level.kr(1)));
			}).send(s);

			SynthDef.new(\patch_stereo, {
				Out.ar(\out.kr, In.ar(\in.kr, 2) * \level.kr(1));
			}).send(s);

			// add a group to order our synths / nodes:
			g = Group.new(s);

			// define our source synth:
			synths[\source] = SynthDef.new(\sourceBlip, {
				var snd = LPF.ar(Saw.ar(\hz.kr(330)), \hz.kr(330)*4);
				snd = snd * LagUD.ar(Impulse.ar(2), 0, 0.5);
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

			synths[\main_out] = Synth.new(\patch_stereo,
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

When the library recompiles, we should be able to instantiate the `FXBusDemo` Class and its associated methods like any other class in SuperCollider. To try it out, open a blank SuperCollider file and type + live-execute (<kbd>Ctrl-Enter</kbd> on Windows/Linux or <kbd>CMD-RETURN</kbd> on macOS) the following:

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