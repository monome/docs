Engine_ExamplePoll : CroneEngine {
	var kernel, debugPrinter;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		kernel = ExamplePoll.new(Crone.server);

		// 'amp' has a string argument, to target a specific channel:
		this.addCommand(\amp, "sf", { arg msg;
			var side = msg[1].asString, amp = msg[2].asFloat;
			kernel.setAmp(side, amp);
		});

		// polls are monophonic, so we'll set one up for each channel:
		this.addPoll(\outputAmpL, {
			// 'getSynchronous' lets us query a SuperCollider variable from Lua!
			var ampL = kernel.amplitude[0].getSynchronous;
			ampL
		});

		this.addPoll(\outputAmpR, {
			var ampR = kernel.amplitude[1].getSynchronous;
			ampR
		});
	}

	free {
		kernel.free;
	}
}