(
Server.default = Server.local;

~a = MonomeArc.new();

s.waitForBoot({
	var friction = 0.9; // set 0-0.99
	var pos = [0,0,0,0];
	var speed = [0,0,0,0];
	var brake = false;
	var draw, point, tick;

	~a.connect();

	~a.delta({
		arg n, d;
		speed[n] = (speed[n] + d).clip(-48, 48);
	});

	~a.key({
		arg n, z;
		if (z == 1,
			{brake = true},
			{brake = false}
		);
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

	tick = Routine({
		var interval = 0.033;
		loop {
			for(0,3,{
				arg n;
				pos[n] = (pos[n] + speed[n]).wrap(0, 1024);
				// NEW:
				if (brake == true,
					{speed[n] = speed[n] * friction}
				);
			});
			draw.value;
			interval.yield;
		}
	});

	tick.play();

});
)