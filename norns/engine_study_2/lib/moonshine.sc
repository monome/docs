// exercise 3: third adaptation
// 8-voice polyphony + smoothing

Moonshine {

	// NEW: add local 'voice_keys' variable to register each voice name separately
	classvar <voice_keys;


	var <params;
	// [eb] why snake case for these? (just wondering)
	var <all_voices;
	// NEW: add 'single_voice' variable to control + track single voices
	var <single_voice;

	// audio bus that all our synths write to
	var <main_bus;
	var <fx_group;
	var <main_out_synth;
	var <delay_synth;

	*initClass {
		// NEW: create voiceKey indices for as many voices as we want control over,
		// including an '\all' index to easily send one value to the same parameter on every voice
		voice_keys = [ \1, \2, \3, \4, \5, \6, \7, \8, \all];
		StartUp.add {
			var s = Server.default;

			s.waitForBoot {

				SynthDef("Moonshine", {
					arg out=0, stop_gate = 1,
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
						// NEW: add a 'stop_gate' to silence previous synth on this voice
						gate: stop_gate,
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

		all_voices = Group.new(s);

		// NEW: create a 'single_voice' Dictionary to control each voice individually
		single_voice = Dictionary.new;
		// NEW: 'params' will hold parameters for our individual voices
		params = Dictionary.new;
		// NEW: for each of the 'voice_keys'...
		voice_keys.do({ arg voiceKey;
			// NEW: and add unique copies of the parameters to each voice
			params[voiceKey] = Dictionary.newFrom([
				\freq,400,
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
		});

		"makin main bus/synthy".postln;
		main_bus = Bus.audio(s, 2);
		main_out_synth = {
			Out.ar(0, In.ar(main_bus.index, 2));
		}.play(target:all_voices, addAction:\addAfter);

		s.sync;

		"makin fx".postln;
		fx_group = Group.new(target:main_out_synth, addAction:\addBefore);

		"makin delay".postln;
		delay_synth =  SynthDef.new(\localBufDelay, {
			arg time=1, level=0.5;
			var input, delay;
			input = In.ar(main_bus, 2);
			delay = BufDelayC.ar(LocalBuf(s.sampleRate*4.0, 2), input, time, level);
			Out.ar(main_bus, delay);
		}).play(target:fx_group);


		// ReplaceOut // overwrites instead of summing
		// InFeedback // reads audio from previous block + current block

	}


	trigger { arg voiceKey, freq;
		// NEW: if the voice is '/all'...
		if( voiceKey == \all,{
		// NEW: then do the following for all the voice_keys:
			voice_keys.do({ arg vK;
				// NEW: don't trigger an actual synth for '\all', but do it for the other voice_keys
				if( vK != \all,{
					// NEW: if the voice is already playing, gracefully release it
					single_voice[vK].set(\stop_gate, -1.05); // -1.05 is 'forced release' with 50ms cutoff time
					// NEW: set '\freq' parameter for each voice to incoming 'freq' value
					params[vK][\freq] = freq;
					// NEW: make sure to index each of our tables with our 'voiceKey'
					single_voice[vK] = Synth.new("Moonshine", [\out, main_bus, \freq, freq] ++ params[vK].getPairs, all_voices);
				});
			});
		}, // NEW: else, if the voice is not '\all':
		{
			// NEW: if this voice is already playing, gracefully release it
			single_voice[voiceKey].set(\stop_gate, -1.05); // -1.05 is 'forced release' with 50ms cutoff time
			// NEW: set '\freq' parameter for this voice to incoming 'freq' value
			params[voiceKey][\freq] = freq;
			// NEW: make sure to index each of our tables with our 'voiceKey'
			Synth.new("Moonshine", [\out, main_bus, \freq, freq] ++ params[voiceKey].getPairs, all_voices);
		});
	}

	setParam { arg voiceKey, paramKey, paramValue;
		// NEW: if the voice is '/all'...
		if( voiceKey == \all,{
			// NEW: then do the following for all the voice_keys:
			voice_keys.do({ arg vK;
				// NEW: don't set values for '\all', but do it for the other voice_keys
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

	setDelayParam { arg k, v;
		delay_synth.set(k, v);
	}

	// NEW: since each 'single_voice' is a sub-Group of 'all_voices',
	// we can simply pass a '\stop_gate' to the 'all_voices' Group.
	// IMPORTANT SO OUR SYNTHS DON'T RUN PAST THE SCRIPT'S LIFE
	freeAllNotes {
		all_voices.set(\stop_gate, -1.05);
	}

	free {
		main_out_synth.free;
		fx_group.free;
		main_bus.free;
	}

}