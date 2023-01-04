(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

	~m.useDevice(0);
	~step = Array.fill(~m.rws-2 * ~m.cls, {0});

	OSCFunc.newMatching(
		{
			arg message, time, addr, recvPort;
			var x = message[1], y = message[2], z = message[3];

			if((z == 1) && (y < (~m.rws-2)), {
				var pos = x + (y * 16);
				if(~step[pos] == 1,
					{~step[pos] = 0},
					{~step[pos] = 1}
				);
				d.value(x,y);
			});
		},
		"/monome/grid/key"
	);


	d = { arg x, y;
		~m.levset(x,y,~step[y*16+x] * 15);
	};

});

)