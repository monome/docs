(
Server.default = Server.local;

~a = MonomeArc.new();

s.waitForBoot({

	var step = -1, timer, draw, direction = 1;

	~a.connect();

	~a.dark();
	~a.led(0, step*16, 10);
	for(1, 3, {
		arg i;
		var quad = step * i * 16;
		~a.segment(i, quad, quad + 15, 15);
	});

	~a.key({
		arg n, z;
		if( n == 0 && z == 1, {
			direction = direction * -1;
		});
	});

	draw = {
		~a.dark();
		~a.led(0, step * 16, 10);
		for(1, 3, {
			arg i;
			var quad = step * i * 16;
			~a.segment(i, quad, quad + 15, 15);
		});
		~a.refresh;
	};

	timer = Routine({
		var interval = 0.75;
		loop {
			step = (step + direction).asInteger.wrap(0,3);
			draw.value;
			interval.yield;
		}
	});

	timer.play();

});

)