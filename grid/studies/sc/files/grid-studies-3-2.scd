(
Server.default = Server.local;

~m = MonomeGrid.new(); // if we don't want to change rotation, we can leave the argument out

s.waitForBoot({

	var draw, timer, cols = 16, rows = 8;

	MonomeGrid.setAddCallback({
		arg serial, port, prefix;
		("grid was added: " ++ serial ++ " " ++ port ++ " " ++ prefix).postln;
		if( serial == MonomeGrid.getConnectedDevices[0], {
			cols = ~m.cols;
			rows = ~m.rows;
		});
	});

	~m.connect(0); // if we don't want to connect to a second device, we can leave the argument out
	~step = Array.fill(cols * (rows-2), {0});
	~play_position = -1;

	// 'cols' + 'rows' return as 1-indexed,
	// but we need 0-indexed for most of our functions!
	~lastCol = cols-1;
	~lastRow = rows-1;

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