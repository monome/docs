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
				d.value;
			});
		}, "/monome/grid/key");


d = {
		for(0,5, {arg y;
			for(0,15, {arg x;
				~m.levset(x,y,~step[y*16+x] * 15);
			})
		})


	};

});

)