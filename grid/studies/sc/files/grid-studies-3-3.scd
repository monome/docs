(
Server.default = Server.local;

SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

~m = MonomeGrid.new();

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

	~m.connect(0);
	~step = Array.fill(cols * (rows-2), {0});
	~play_position = -1;

	~lastCol = cols-1;
	~lastRow = rows-1;

	~m.key({ arg x,y,z;
		if((z == 1) && (y <= (~lastRow-2)), {
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

			// set trigger row background
			~m.led(x,~lastRow-1,4);
		});

		// show triggers
		for(0,~lastRow-2, {arg t;
			if(~step[(t*16) + ~play_position] == 1,
				{~m.led(t,~lastRow-1,15);}
			);
		});
	};

	timer = Routine({
		var interval = 0.125;
		loop {

			~play_position = (~play_position + 1).wrap(0,~lastCol);

			// TRIGGER SOMETHING
			for(0,~lastRow-2, {arg t;
				if(~step[(t*16) + ~play_position] == 1,
					{
						Synth(\singrain, [
							freq: (5-t) * 100 + 300,
							amp: rrand(0.1, 0.5),
							sustain: interval * 0.8
						]);

					}
				)
			});

			draw.value;

			interval.yield;
		}

	});

	timer.play();

});

)