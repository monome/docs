(
Server.default = Server.local;

~m = MonomeGrid.new();

s.waitForBoot({

	var draw;

	~m.connect();
	~step = Array.fill(~m.cols * ~m.rows, {0});

	~m.key({ arg x,y,z;
		if(z == 1, {
			var pos = x + (y*16);
			if(~step[pos] == 1,
				{~step[pos] = 0},
				{~step[pos] = 1}
			);
			draw.value(x,y);
		});
	});

	draw = { arg x, y;
		~m.led(x,y,~step[y*16+x] * 15);
	};

});

)