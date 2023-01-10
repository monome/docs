(
Server.default = Server.local;

~m = MonomeGrid.new("/grid", 0);

s.waitForBoot({

	var draw;

	~m.connect(0);
	~step = Array.fill(~m.cols * ~m.rows-2, {0});

	~m.key({ arg x,y,z;
		if((z == 1) && (y < (~m.rows-2)), {
			var pos = x + (y * 16);
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