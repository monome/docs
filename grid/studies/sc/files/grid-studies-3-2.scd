(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~m.useDevice(0);
	~step = Array.fill(~m.rws-2 * ~m.cls, {0});
	~play_position = -1;

	// 'cls' + 'rws' return as 1-indexed,
	// but we need 0-indexed for most of our functions!
	~cols = ~m.cls-1;
	~rows = ~m.rws-1;

	OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
			var x = message[1], y = message[2], z = message[3];

			if((z == 1) && (y <= (~rows - 2)), {
				var pos = x + (y * 16);
				if(~step[pos] == 1,
					{~step[pos] = 0},
					{~step[pos] = 1}
				);
			})
		},
		"/monome/grid/key"
	);


	d = {
		var highlight;
		for(0,~cols, {arg x;
			if(x == ~play_position,
				{highlight = 4},
				{highlight = 0});

			for(0,~rows-2, {arg y;
				~m.levset(x,y,(~step[y*16+x] * 11) + (highlight));
			});
		})
	};

	t = Routine({
		var interval = 0.125;
		loop {
			if(~play_position == ~cols,
				{~play_position = 0},
				{~play_position = ~play_position + 1}
			);

			d.value;

			interval.yield;
		}

	});

	t.play();

});

)