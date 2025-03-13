(
Server.default = Server.local;

~a = MonomeArc.new();

s.waitForBoot({
	var pos = [0,0,0,0];
	var draw, point;

	~a.connect();

	~a.delta({
		arg n, d;
		pos[n] = (pos[n] + d).wrap(0, 1024);
		draw.value;
	});

	draw = {
		~a.dark;
		for(0, 3, {
			arg i;
			point.value(i, pos[i]);
		});
		~a.refresh;
	};

	point = {
		arg n, y;
		var x = (y.floor).asInteger;
		var c = x >> 4;
		~a.led(n, (c % 64) + 1, 15);
		~a.led(n, ((c + 1) % 64) + 1, x % 16);
		~a.led(n, ((c + 63) % 64) + 1, 15 - (x % 16));
	};

	draw.value;

});
)