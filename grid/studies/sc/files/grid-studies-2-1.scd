(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~m.useDevice(0);

	OSCFunc.newMatching(
		{ arg message;
			message.postln;
		},
		"/monome/grid/key"
	);

});

)