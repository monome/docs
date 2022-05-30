Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke Moonshine with
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		// NEW: since Moonshine is now a class definition on norns,
		// we can just invoke it:
		kernel = Moonshine.new(Crone.server);

		// NEW: build an 'engine.trig(x,y)' command,
		// x: voice, y: hz
		this.addCommand(\trig, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var hz = msg[2].asFloat;
			kernel.trigger(voiceKey,hz);
		});

		// NEW: since each voice shares the same parameters,
		// we can build a general function for each parameter
		// and pass it the voice and value
		kernel.global_voiceKeys.do({ arg voiceKey;
			kernel.params[voiceKey].keysValuesDo({ arg paramKey;
				this.addCommand(paramKey, "sf", {arg msg;
					kernel.setParam(msg[1].asSymbol,paramKey.asSymbol,msg[2].asFloat);
				});
			});
		});

		// NEW: alternate way of add controls for parameters.
		// mirror the 'setParam' function of our class definition
		// and pass voice key, parameter name, and value
		/*this.addCommand(\set_param, "ssf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var paramKey = msg[2].asSymbol;
			var paramValue = msg[3].asFloat;
			kernel.setParam(voiceKey, paramKey, paramValue);
		});*/

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
	} // free

} // CroneEngine