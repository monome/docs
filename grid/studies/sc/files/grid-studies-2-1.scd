(
Server.default = Server.local;

~m = MonomeGrid.new("/128", 0);

s.waitForBoot({

	~m.connect(0);

	~m.key({
		arg x,y,z;
		[x,y,z].postln;
	});

});

)