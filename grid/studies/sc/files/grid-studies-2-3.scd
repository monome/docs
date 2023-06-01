(
Server.default = Server.local;

~m = MonomeGrid.new();

s.waitForBoot({

	~m.connect();

	~m.key({
		arg x,y,z;
		~m.led(x,y,z*15);
	});

});

)