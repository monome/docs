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