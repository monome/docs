Engine_FXBusDemo : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		kernel = FXBusDemo.new(Crone.server);

		this.addCommand(\set_level, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var val = msg[2].asFloat;
			kernel.setLevel(voiceKey,val);
		});

		this.addCommand(\set_pan, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var val = msg[2].asFloat;
			kernel.setPan(voiceKey,val);
		});

		// NEW: add control over synth
		this.addCommand(\set_synth, "sf", { arg msg;
			var attribute = msg[1].asSymbol;
			var val = msg[2].asFloat;
			kernel.setSynth(attribute,val);
		});

		// NEW: add control over delay time
		this.addCommand(\set_delay_time, "f", { arg msg;
			var val = msg[1].asFloat;
			kernel.setDelayTime(val);
		});

		this.addCommand(\set_main, "sf", { arg msg;
			var key = msg[1].asSymbol;
			var val = msg[2].asFloat;
			kernel.setMain(key,val);
		});

		// NEW: add brightness poll
		this.addPoll(\brightness_poll, {
			var spectral = kernel.busses[\brightness].getSynchronous;
			spectral
		});

		// NEW: add amp poll
		this.addPoll(\amp_poll, {
			var amp = kernel.busses[\amp].getSynchronous;
			amp
		});

	} // alloc

	// IMPORTANT
	free {
		kernel.free;
	} // free


} // CroneEngine