(
Server.default = Server.local;

SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~m.useDevice(0);

	~step = Array.fill(~m.rws-2 * ~m.cls, {0});
	~play_position = -1;
	~next_position;
	~cutting = 0;
	~cols = ~m.cls-1;
	~rows = ~m.rws-1;

	OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
			var x = message[1], y = message[2], z = message[3];

			if((z == 1) && (y <= (~rows-2)), {
				var pos = x + (y * 16);
				if(~step[pos] == 1,
					{~step[pos] = 0},
					{~step[pos] = 1}
				);
			});

			// cut to a new position
			if((z== 1) && (y == ~rows), {
				~next_position = x;
				~cutting = 1;
			});
		},
		"/monome/grid/key"
	);


	d = {
		var highlight;
		for(0,~cols, {arg x;
			if(x == ~play_position,
				{highlight = 1},
				{highlight = 0});

			for(0,~rows-2, {arg y;
				~m.levset(x,y,(~step[y*16+x] * 11) + (highlight * 4));
			});

			// set trigger row background
			~m.levset(x,~rows-1,4);

			// clear play position row
			~m.levset(x,~rows,0);
		});

		// play position
		~m.levset(~play_position,~rows-1,15);

		// show triggers
		for(0,~rows-2, {arg t;
			if(~step[(t*16) + ~play_position] == 1,
				{~m.levset(t,~rows-1,15);}
			)
		});
	};

	t = Routine({
		var interval = 0.125;
		loop {

			if(~play_position == ~cols,
				{~play_position = 0;},
				{
					if(~cutting == 1,
						{~play_position = ~next_position; ~cutting = 0;},
						{~play_position = ~play_position + 1;})
				};
			);

			// TRIGGER SOMETHING
			for(0,~rows-2, {arg t;
				if(~step[(t*16) + ~play_position] == 1,
					{
						Synth(\singrain, [
							freq: (5-t)*100+300,
							amp: rrand(0.1, 0.5),
							sustain: interval * 0.8
						]);
					}
				)
			});

			d.value;

			interval.yield;
		}

	});

	t.play();

});

)