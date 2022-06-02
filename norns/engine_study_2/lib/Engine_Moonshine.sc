Engine_Moonshine : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	// NEW: select a variable to invoke Moonshine with
	var kernel;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc { // allocate memory to the following:

		// NEW: since Moonshine is now a supercollider Class,
		//   we can just construct an instance of it
		kernel = Moonshine.new(Crone.server);

		// NEW: build an 'engine.trig(x,y)' command,
		//   x: voice, y: freq
		this.addCommand(\trig, "sf", { arg msg;
			var voiceKey = msg[1].asSymbol;
			var freq = msg[2].asFloat;
			kernel.trigger(voiceKey,freq);
		});

		// NEW: since each voice shares the same parameters ('globalParams'),
		//   we can define a command for each parameter that accepts a voice index
		kernel.globalParams.keysValuesDo({ arg paramKey;
			this.addCommand(paramKey, "sf", {arg msg;
				kernel.setParam(msg[1].asSymbol,paramKey.asSymbol,msg[2].asFloat);
			});
		});

		// NEW: add a command to free all the voices
		this.addCommand(\free_all_notes, "", {
			kernel.freeAllNotes();
		});

	} // alloc


	// NEW: when the script releases the engine,
	//   free all the currently-playing notes and groups.
	// IMPORTANT
	free {
		kernel.freeAllNotes;
		// groups are lightweight but they are still persistent on the server and nodeIDs are finite,
		//   so they do need to be freed:
		kernel.voiceGroup.free;
	} // free


} // CroneEngine