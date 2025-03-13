(
Server.default = Server.local;

SynthDef(\sineFB, { |freq = 440, amp = 0.2, fb = 0|
	var sig;
	sig = SinOscFB.ar(freq, fb, amp);
	Out.ar(0, sig ! 2);
}).add;

~a = MonomeArc.new();

s.waitForBoot({
	var friction = 0.9; // set 0-0.99
	var pos = [0,0,0,0];
	var speed = [0,0,0,0];
	var brake = false;
	var draw, point, tick;
	var voiceGroup = Group.new(Server.default);
	var drones = Dictionary.new;
	var notes = [
		Scale.dorian.degreeToFreq(0,32.midicps,1),
		Scale.dorian.degreeToFreq(7,32.midicps,1),
		Scale.dorian.degreeToFreq(9,32.midicps,1),
		Scale.dorian.degreeToFreq(15,32.midicps,1),
	];

	for(0, 3, {
		arg i;
		drones[i] = Group.new(voiceGroup);
		Synth.new(\sineFB, [\freq, notes[i], \amp, 0], drones[i]);
	});

	~a.connect();

	~a.delta({
		arg n, d;
		speed[n] = (speed[n] + d).clip(-48, 48);
	});

	~a.key({
		arg n, z;
		if (z == 1,
			{brake = true},
			{brake = false}
		);
	});

	draw = {
		~a.dark;
		for(0, 3, {
			arg i;
			point.value(i, pos[i]);
		});
		~a.refresh;
	};

	point = {
		arg n, y;
		var x = (y.floor).asInteger;
		var c = x >> 4;
		~a.led(n, (c % 64) + 1, 15);
		~a.led(n, ((c + 1) % 64) + 1, x % 16);
		~a.led(n, ((c + 63) % 64) + 1, 15 - (x % 16));
	};

	tick = Routine({
		var interval = 0.033;
		loop {
			for(0,3,{
				arg n;
				pos[n] = (pos[n] + speed[n]).wrap(0, 1023);
				if (brake == true,
					{speed[n] = speed[n] * friction}
				);
				// NEW:
				if (pos[n] < 512,
					{
						drones[n].set(\amp, pos[n].linlin(0, 512, 0, 0.5/(n+1)));
						drones[n].set(\fb, pos[n].linlin(0, 512, 0, 1/(n+1)));
					},
					{
						drones[n].set(\amp, pos[n].linlin(512, 1023, 0.5/(n+1), 0));
						drones[n].set(\fb, pos[n].linlin(512, 1023, 1/(n+1), 0));
					}
				);
			});
			draw.value;
			interval.yield;
		}
	});

	tick.play();

});
)