(
Server.default = Server.local;

~m = MonomeGrid.new();

s.waitForBoot({

	var draw, cols = 16, rows = 8;

	MonomeGrid.setAddCallback({
		arg serial, port, prefix;
		("grid was added: " ++ serial ++ " " ++ port ++ " " ++ prefix).postln;
		if( serial == MonomeGrid.getConnectedDevices[0], {
			cols = ~m.cols;
			rows = ~m.rows;
		});
	});

	~m.connect(0);
	~step = Array.fill(cols * (rows-2), {0});

	~m.key({ arg x,y,z;
		if((z == 1) && (y < (rows-2)), {
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