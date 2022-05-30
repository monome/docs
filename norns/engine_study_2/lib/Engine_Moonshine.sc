Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke Moonshine with
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		// NEW: since Moonshine is now a supercollider Class,
		// we can just construct an instance of it
		kernel = Moonshine.new(Crone.server);

		// NEW: build an 'engine.trig(x,y)' command,
		// x: voice, y: hz
		this.addCommand(\trig, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var hz = msg[2].asFloat;
			kernel.trigger(voiceKey,hz);
		});

		// NEW: since each voice shares the same parameters,
		// we can define a command for each parameter that accepts a voice index
		// ([eb] this is what accessing a class variable looks like; 
		// don't need to copy it to a member variable)
		Moonshine.voiceKeys.do({ arg voiceKey;
			kernel.params[voiceKey].keysValuesDo({ arg paramKey;
				this.addCommand(paramKey, "sf", {arg msg;
					kernel.setParam(msg[1].asSymbol,paramKey.asSymbol,msg[2].asFloat);
				});
			});
		});

		// NEW: alternate way of add controls for parameters.
		// mirror the 'setParam' function of our class definition
		// and pass voice key, parameter name, and value
		// [eb] (don't see a particular reason not to enable this, it doesn't conflict?
		// or just eliminate it; but having commented dead code seems odd)
		this.addCommand(\set_param, "ssf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var paramKey = msg[2].asSymbol;
			var paramValue = msg[3].asFloat;
			kernel.setParam(voiceKey, paramKey, paramValue);
		});

		// NEW: add a command to free all the voices
		this.addCommand(\free_all_notes, "", {
			kernel.freeAllNotes();
		});

	} // alloc


	// NEW: when the script releases the engine,
	// free all the currently-playing notes.
	// IMPORTANT
	free {
		kernel.freeAllNotes;

	// [eb] FIXME: this frees the synths all right, but does not free the containing groups.
	// groups are lightweight but they are still persistent on the server and nodeIDs are finite, 
	// so they do need to be freed.
	// the easy thing here would be to simply free the top level group.
	/*
	kernel.all_voices.free;
	*/
	// however, this would instantly stop all voices without a fade-out.
	// since it is guaranteed that `free` will be called in a Routine, 
	// and we know the hardcoded fadeout time is 50ms,
	// we could add a delay (though it's not very clean design)
	/*
	0.06.wait;
	*/


	} // free


} // CroneEngine