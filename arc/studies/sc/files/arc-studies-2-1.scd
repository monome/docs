(
Server.default = Server.local;

// MonomeArc accepts two arguments:
// * rotation (0 is default)
// * prefix (a string nickname for this arc, "/monome" is default)

~a = MonomeArc.new(rotation: 0, prefix: "/monome");

s.waitForBoot({

	~a.connect(); // 0 (or not supplying any argument) means the first-connected arc

	~a.delta({
		arg n,d;
		["encoder turn", n, d, "serial: " ++~a.serial,"port: "++~a.port].postln;
	});

	~a.key({
		arg n,z;
		["keypress", n,z, "serial: " ++~a.serial,"port: "++~a.port].postln;
	});

});

)