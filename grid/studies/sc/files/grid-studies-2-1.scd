(
Server.default = Server.local;

~m = MonomeGrid.new(0); // 0 means no rotation

s.waitForBoot({

	~m.connect(0); // 0 means the first-connected device

	~m.key({
		arg x,y,z;
		[x,y,z].postln;
	});

});

)