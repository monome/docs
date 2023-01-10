(
Server.default = Server.local;

~m = MonomeGrid.new("/monome", 0);

s.waitForBoot({

	var draw, timer;

	~m.connect(0);
	~step = Array.fill(~m.cols * ~m.rows-2, {0});
	~play_position = -1;

	// 'cols' + 'rows' return as 1-indexed,
	// but we need 0-indexed for most of our functions!
	~lastCol = ~m.cols-1;
	~lastRow = ~m.rows-1;

	~m.key({ arg x,y,z;
		if((z == 1) && (y <= (~lastRow - 2)), {
			var pos = x + (y * 16);
			if(~step[pos] == 1,
				{~step[pos] = 0},
				{~step[pos] = 1}
			);
		});
	});


	draw = {
		var highlight;
		for(0,~lastCol, {arg x;
			if(x == ~play_position,
				{highlight = 4},
				{highlight = 0});

			// show playhead
			for(0,~lastRow-2, {arg y;
				~m.led(x,y,(~step[y*16+x] * 11) + (highlight));
			});
		})
	};

	timer = Routine({
		var interval = 0.125;
		loop {
			~play_position = (~play_position + 1).wrap(0,~lastCol);
			draw.value;
			interval.yield;
		}
	});

	timer.play();

});

)