// exercise 3: third adaptation
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
					// NEW: set '\freq' parameter for each voice to incoming 'hz' value
					params[vK][\freq] = hz;
					// NEW: make sure to index each of our tables with our 'voiceKey'
					Synth.new("Moonshine", [\freq, hz] ++ params[vK].getPairs, single_voice[vK]);
				});
			});
		}, // NEW: else, if the voice is not '\all':
		{
			// NEW: if this voice is already playing, gracefully release it
			single_voice[voiceKey].set(\stopGate, -1.05); // -1.05 is 'forced release' with 50ms cutoff time
			// NEW: set '\freq' parameter for this voice to incoming 'hz' value
			params[voiceKey][\freq] = hz;
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
	// we can simply pass a '\stopGate' to the 'all_voices' Group.
	// IMPORTANT SO OUR SYNTHS DON'T RUN PAST THE SCRIPT'S LIFE
	freeAllNotes {
		all_voices.set(\stopGate, -1.05);
	}

}