// SC Bus exercise 4: polls
// sending brightness + amplitude analysis to Lua

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
			busses[\source] = Bus.audio(s, 1);
			busses[\main_out] = Bus.audio(s, 2);
			busses[\reverb_send] = Bus.audio(s, 2);
			busses[\delay_send] = Bus.audio(s, 2);

			// NEW: add an analysis audio bus:
			busses[\analysis] = Bus.audio(s, 2);
			// NEW: define control Busses for our Lua polls
			busses[\brightness] = Bus.control(s);
			busses[\amp] = Bus.control(s);

			SynthDef.new(\patch_pan, {
				Out.ar(\out.kr, Pan2.ar(In.ar(\in.kr), \pan.kr(0), \level.kr(1)));
			}).send(s);

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
				var snd = LPF.ar(Saw.ar(\hz.kr(330)), \fchz.kr(800).clip(20,20000));
				snd = snd * LagUD.ar(Impulse.ar(0.3), 0, 10);
				Out.ar(\out.kr, snd * \level.kr(0.5));
			}).play(target:g, addAction:\addToTail, args:[
				\out, busses[\source]
			]);

			// we're syncing here so that the SynthDef above
			//   is present on the Server when requested
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
				arg in, out, dtime=0.2, level=1;
				Out.ar(out, DelayC.ar(In.ar(in, 2), 1.0, dtime, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\delay_send], \out, busses[\main_out]
			]);

			synths[\reverb] = SynthDef.new(\reverb, {
				arg in, out, level=1;
				Out.ar(out, FreeVerb.ar(In.ar(in, 2), 1.0, 0.9, 0.1, level));
			}).play(target:g, addAction:\addToTail, args:[
				\in, busses[\reverb_send], \out, busses[\main_out]
			]);

			// we're syncing here so that the SynthDefs above
			//   are present on the Server when requested
			s.sync;

			synths[\main_out] = Synth.new(\patch_main,
				target:g, addAction:\addToTail, args: [
					// NEW: send main out to analysis bus
					\in, busses[\main_out], \out, busses[\analysis]
			]);

			// NEW: build a brightness tracker
			synths[\brightness] = SynthDef.new(\brightnessTracker, {
				arg in, out, brightOut, ampOut;
				var src = In.ar(in, 2);
				var mixed = Mix.new([src[0],src[1]]);
				var amp = Amplitude.kr(mixed);
				var chain = FFT(LocalBuf(2048), mixed);
				var brightness = SpecCentroid.kr(chain);
				// send the output out:
				Out.ar(out, src);
				// send the brightness to a control bus:
				Out.kr(brightOut, brightness);
				// send the amp to a control bus:
				Out.kr(ampOut, amp);
			}).play(target:g, addAction:\addToTail, args: [
				\in, busses[\analysis],
				\out, 0,
				\brightOut, busses[\brightness].index,
				\ampOut, busses[\amp].index
			]);

		}.play;
	}

	setLevel { arg key, val;
		synths[key].set(\level, val);
	}

	setPan { arg key, val;
		synths[key].set(\pan, val);
	}

	// NEW: add controls for our source synth voice
	setSynth { arg key, val;
		synths[\source].set(key, val);
	}
	// NEW: add control for our delay time
	setDelayTime{ arg val;
		synths[\delay].set(\dtime, val.min(1));
	}

	setMain { arg key, val;
		synths[\main_out].set(key, val);
	}

	// IMPORTANT: free Server resources and nodes when done!
	free {
		g.free;
		busses.do({arg bus; bus.free;});
	}

}