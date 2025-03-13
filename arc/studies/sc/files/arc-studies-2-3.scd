(
Server.default = Server.local;

~a = MonomeArc.new();

s.waitForBoot({

	var pos = [0,0,0,0];

	~a.connect();

	// draw notch:
	for(0, 3, {
		arg i;
		~a.led(i, 0, 15);
	});
	~a.refresh;

	~a.delta({
		arg n, d;
		~a.all(n, 0);
		pos[n] = (pos[n] + d).wrap(0,63);
		~a.led(n, pos[n], 15);
		~a.refresh;
	});
});

)