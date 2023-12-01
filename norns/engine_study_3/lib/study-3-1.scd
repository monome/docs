// SC Bus exercise 1: building some sends

// CMD + ENTER / CTRL + ENTER from here to run the code
(
// create a Dictionary of synths:
~synths = Dictionary.new;

// create a Dictionary of audio busses:
~busses = Dictionary.new;
~busses[\mainOut] = Bus.audio(server: Server.default, numChannels: 2);
~busses[\delaySend] = Bus.audio(server: Server.default, numChannels: 2);
~busses[\reverbSend] = Bus.audio(server: Server.default, numChannels: 2);

// alias our Server:
s = Server.default;

// make a Routine, so that we can sync changes to the Server
Routine{

	// define our source sound:
	SynthDef("source", {
		var snd = LPF.ar(Saw.ar(\hz.kr(330)), \hz.kr(330)*4);
		snd = snd * LagUD.ar(Impulse.ar(2), 0, 0.5);

		Out.ar(\outMain.kr, (snd * \levelMain.kr(1)).dup); // .dup = send stereo signal
		Out.ar(\outSend1.kr, (snd * \levelSend1.kr(0)).dup);
		Out.ar(\outSend2.kr, (snd * \levelSend2.kr(0)).dup);
	}).add;

	// define our delay:
	SynthDef("delay", {
		Out.ar(\out.kr, CombC.ar(In.ar(\in.kr, 2),1.0,0.2,3.2));
	}).add;

	// define our reverb:
	SynthDef("reverb", {
		var sig = In.ar(\in.kr, 2);
		Out.ar(\out.kr, FreeVerb2.ar(sig[0], sig[1], 1.0, 0.7, 0.2, 1.5));
	}).add;

	// define our main output:
	SynthDef("main", {
		Out.ar(\out.kr, In.ar(\in.kr, 2));
	}).add;

	// we sync the Server here so that the common SynthDefs above
	//   are present on the Server when requested below
	s.sync;

	// build our source + pass it arguments:
	~synths[\source] = Synth.new("source", [
		\outMain, ~busses[\mainOut], // connecting to the mainOut bus
		\outSend1, ~busses[\delaySend], // connecting to the delaySend bus
		\outSend2, ~busses[\reverbSend] // connecting to the reverbSend bus
	]);

	// build our delay AFTER our source
	//   and pass it arguments:
	~synths[\delay] = Synth.after(~synths[\source], "delay", [
		\in, ~busses[\delaySend], // input = the delaySend bus
		\out, ~busses[\mainOut] // output = the mainOut bus
	]);

	// build our reverb AFTER our delay
	//   and pass it arguments:
	~synths[\reverb] = Synth.after(~synths[\delay], "reverb", [
		\in, ~busses[\reverbSend], // input = the reverbSend bus
		\out, ~busses[\mainOut] // output = the mainOut bus
	]);

	// build our main output AFTER our reverb
	//   and pass it arguments:
	~synths[\main] = Synth.after(~synths[\reverb], "main", [
		\in, ~busses[\mainOut], // input = the mainOut bus
		\out, 0 // output = the default output device
	]);
}.play;
)

// send to main:
~synths[\source].set(\levelMain,1);
// send to delay:
~synths[\source].set(\levelSend1,1);
// send to reverb:
~synths[\source].set(\levelSend2,1);
// don't send to main:
~synths[\source].set(\levelMain,0);
// don't send to delay:
~synths[\source].set(\levelSend1,0);
// don't send to reverb:
~synths[\source].set(\levelSend2,0);