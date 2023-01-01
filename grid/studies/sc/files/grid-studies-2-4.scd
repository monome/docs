(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~step = Array.fill(128, {0});

	~m.useDevice(0);

	OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
		// we don't need all of these args for everything,
		// but be aware of their existence!

			if(message[3] == 1, {
				var pos = message[1] + (message[2] * 16);
				if(~step[pos] == 1,
					{~step[pos] = 0},
					{~step[pos] = 1}
				);
				d.value(message[1], message[2]);
			})
		},
		"/monome/grid/key"

	);


	d = { arg x, y;
		~m.levset(x,y,~step[y*16+x] * 15);
	};

});

)