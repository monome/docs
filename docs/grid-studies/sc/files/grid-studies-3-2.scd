(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

~step = Array.fill(96, {0});
~play_position = 0;

~m.useDevice(0);

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

			if((message[3] == 1) && (message[2] < 6), {
				var pos = message[1] + (message[2] * 16);
				if(~step[pos] == 1,
					{~step[pos] = 0},
					{~step[pos] = 1}
				);
			})
		}, "/monome/grid/key");


d = {
		var highlight;
		for(0,15, {arg x;
			if(x==~play_position,
					{highlight = 1},
					{highlight = 0});

			for(0,5, {arg y;
				~m.levset(x,y,(~step[y*16+x] * 11) + (highlight * 4));
			});
		})
	};

t = Routine({
	var interval = 0.125;
	loop {
		if(~play_position == 15,
				{~play_position = 0;},
				{~play_position = ~play_position + 1;}
			);

		d.value;

		interval.yield;
	}

});

t.play();

});

)