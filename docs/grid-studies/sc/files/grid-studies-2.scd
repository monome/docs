(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

~m.useDevice(0);

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
			~m.ledset(message[1], message[2], message[3]);

		}, "/monome/grid/key");

});

)