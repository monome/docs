---
layout: default
title: apps
parent: norns
nav_order: 4
---

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/412510077?byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

# applications

norns is uniquely oriented toward sharing. In the early days of monome, creating apps for grid and arc was relatively straightforward but there were also a lot of dependencies -- the biggest being operating systems. norns successfully navigates around this by decoupling its dependence on Windows or Mac OS. Additionally, the scripting syntax at its heart is pliable and it's incredibly easy to adapt chunks of code from others to create your dream instruments.

While this is not a comprehensive list of what's available (or even all of our favorites!), these projects are a wonderful starting point for those looking to play, adapt, and develop. [Click here to view the complete library](https://llllllll.co/search?expanded=true&q=%23library%20tags%3Anorns%20order%3Alatest_topic).

All of the projects in this section are available for download in maiden's [project manager](/docs/norns/maiden/#project-manager). Each name links back to its discussion thread on lines.

### summon scripts

in the video above, scripts made by the [lines community](https://llllllll.co) are being played by the [lines community](https://llllllll.co).

[orca](https://llllllll.co/t/orca/22492) // script: [`@its_your_bedtime`](https://www.instagram.com/its_your_bedtime/) // performance: [`@elia`](https://www.instagram.com/eliapiana/)

[TimeParty](https://llllllll.co/t/timeparty/22837) // script: [`@crim`](https://llllllll.co/u/crim/summary) // performance: [`@Olivier`](https://www.instagram.com/oliviercreurer/)

[mlr](https://llllllll.co/t/mlr-norns/21145) // script: [`@tehn`](https://softbits.bandcamp.com/album/rapid-history) // performance: [`@shellfritsch`](https://linktr.ee/coolmaritime)

[QUENCE](https://llllllll.co/t/quence/29436) // script: [`@spunoza`](https://www.youtube.com/channel/UCYTk7jkyot_w15r_7mqcTuw) // performance: [`@Justmat`](https://www.instagram.com/probably_justmat/)

[Compass](https://llllllll.co/t/compass-3-0/25192) // script: [`@Olivier`](https://www.instagram.com/oliviercreurer/) // performance: [`@glia`](https://www.instagram.com/zunaito/)

[otis](https://llllllll.co/t/otis/22149) // script: [`@Justmat`](https://www.instagram.com/probably_justmat/) // performance: [`@mattlowery`](https://www.instagram.com/mattlowery/)

[Animator](https://llllllll.co/t/animator/28242) // script: [`@crim`](https://llllllll.co/u/crim/summary) // performance: [`@bereenondo`](http://www.instagram.com/bereenondo)

[wrms](https://llllllll.co/t/wrms/28954) // script: [`@andrew`](https://www.instagram.com/_and.rew__/) // performance: [`@zanderraymond`](https://www.instagram.com/zanderraymond/)

[cheat codes](https://llllllll.co/t/cheat-codes-v1-3-april-26-2020/31655) // script: [`@dan_derks`](https://www.instagram.com/jailaibookie/) // performance: [`@andrew`](https://www.instagram.com/_and.rew__/)

## softcut-based

*norns has a built-in realtime sampling layer called `softcut`. It is always running and is able to capture external audio or sounds from the engines. Apps in this section control softcut and cover nearly every corner of sampling and looping. Want to build your own or have an idea to extend one of these apps? Check out the [softcut studies](https://llllllll.co/t/norns-softcut-studies/23585).*

- **[beets](https://llllllll.co/t/beets-1-0/30069)**: Probabilistic performance drum loop slicer. Load up a directory of drum loops, set loop points, set parameters such as stutter, reverse, jump forward and jump back probabilities. beets will always return to the start of the loop on the "1" and all changes are quantized to the beat.

- **[cheat codes](https://llllllll.co/t/cheat-codes-v1-3-april-26-2020/31655)**: A sample playground for chopping audio, both realtime and pre-recorded. A hybrid of sampling workflows inspired by SP's and Elektron boxes to inspire both tightly timed beats and wandering ambient jams.

- **[compass](https://llllllll.co/t/compass/25192)**: Asynchronous looper built around the concept of a command-based sequencer. Commands modulate recording, playback, looping, and sequencing behaviors. The audio buffers and the sequencer each have their own sense of time in order to facilitate experimentation.

- **[mlr](https://llllllll.co/t/mlr-norns/21145)**: The original live sample-cutting platform for grid. Load samples or record live audio, then re-pitch + chop + record gestures.

- **[otis](https://llllllll.co/t/22149)**: Dual "tape" delay/looper/sampler with digital noise, inspired by Peter Blasser's Cocoquantus. Includes `hnds`, a bank of LFOs that can be used to modulate panning, volume, feedback, speed, record state, direction, and position of the buffer playback.

- **[reels](https://llllllll.co/t/reels/21030)**: 4-track asynchronous looper, inspired by OP-1's tape recorder and the Whimsical Raps w/ Eurorack module. Includes library version (`libreels`) to easily add reels to any other scripts which do not yet utilize softcut.

- **[TimeParty](https://llllllll.co/t/timeparty/22837)**: Delay with seven step sequencers to modulate time, rate, feedback, autopanning, reverb, filter cutoff, and position.

- **[tunnels](https://llllllll.co/t/tunnels/21973)**: A collection of randomized, experimental stereo delays. Flip through a plethora of preset modes (with delightfully esoteric names) for immediate fun.

- **[wrms](https://llllllll.co/t/wrms/28954)**: Dual asynchronous time-wigglers / echo loopers. Each loop (wrm) has its own response to rate, time, and the other wrm. Feed them to each other for ping pong effects. Includes a library version to easily add wrms to any other scripts which do not yet utilize softcut.

## synths and audio processing

*norns has SuperCollider at its heart, which is a powerful language for synthesis and audio processing. This section is a mix of SuperCollider engines that have been wrapped up for norns and scripts which provide control over those engines.*

*All engines can be downloaded through maiden's [project manager](/docs/norns/maiden/#project-manager), under `community`. After installing a new synth engine, you need to restart norns (SYSTEM > RESET) in order for SuperCollider to register it.*

*When applicable, engines are hyperlinked to their lines discussion thread.*

- **ack**: Sample player engine with fine-grain controls over pitch, filtering (w/envelopes), start/end point, and volume (w/ envelopes).

- **[Benjolis](https://llllllll.co/t/benjolis/28061)**: A somewhat unpredictable synth that is highly enjoyable to interact with which can produce both the harshest of noise and some really tranquil sounds. Adapted from Alejandro Olarte’s Benjolis SuperCollider patch, inspired from Rob Hordijk’s Benjolin.

- **[gemini](https://llllllll.co/t/gemini/21086)**: Twin granulators that phase, harmonize, and race.

- **[glut](https://llllllll.co/t/glut/21175)**: Granular synth inspired by mlr/rove, grainfields and loomer cumulus. Includes a default script which uses grid to trigger sample playback, mute tracks and record patterns.

- **[greyhole](https://llllllll.co/t/greyhole/27687)**: "A complex echo-like effect, inspired by the classic Eventide effect of a similar name. The effect consists of a diffuser (like a mini-reverb, structurally similar to the one used in JPverb) connected in a feedback system with a long, modulated delay-line. Excels at producing spacey washes of sound."

- **[haven](https://llllllll.co/t/haven/21285)**: Two unique oscillators: one high, one low. One self-oscillating feedback loop with built-in ladder filter, smearing the pitch of the oscillators. No controls.

- **[mangl](https://llllllll.co/t/mangl/21066)**: Sample player + manipulator for grid + arc. Quickly manipulate up to seven samples (and the sounds in between) to create new landscapes from familiar material.

- **[Molly the Poly](https://llllllll.co/t/molly-the-poly/21090)**: Classic polysynth with solar system patch creator. Juno-6 voice structure with chorus, the extra modulation of a Jupiter-8, and CS-80 inspired ring modulation. Engine has a default script to play the synth with grid or MIDI.

- **[Passersby](https://llllllll.co/t/passersby/21089)**: West Coast-style mono synth. Wave folding, FM, LPG, spring-ish reverb, LFO and two dice to roll. Includes a default script which accepts MIDI.

- **[Pedalboard](https://llllllll.co/t/31119)**: A broad collection of chain-able stereo effects for norns, everything from auto-wah to overdrive.

- **[Phyllis](https://llllllll.co/t/27988)**: Digitally modeled analog filter, built around the DFM1 supercollider ugen, with some softclipping and built-in LFOs.

- **PolyPerc**: Simple polyphonic, filtered, decaying square wave.

- **PolySub**: Multi-type oscillator with polyphonic modulation busses for polytimbral expression.

- **[Pools](https://llllllll.co/t/28320)**: A shimmery reverb which combines DFM1 input filtering, JPverb reverb parameters, and a PitchShift feedback loop.

- **[R](https://llllllll.co/t/norns-r-engine/21071)**: Extensible collection of engines that link together in a modular synth-style workflow.

- **[Sway](https://llllllll.co/t/sway/21117)**: Analysis-driven live audio processing. Interactive music system based on incoming audio amplitude, density, and pitch clarity.

- **[Timber](https://llllllll.co/t/timber/21407)**: Sample player engine with two built-in scripts.

	- **Timber Keys**: Map samples across a MIDI keyboard. Multi-timbral across 16 channels.
	- **Timber Player**: Trigger samples with a grid or MIDI keyboard. 64 Fingers inspired, can be used as a quantized clip launcher.

## sequencers

*Lua's straightforward handling of tables + arrays makes norns an excellent platform for experiments with sequencers. Nearly all of the following scripts have MIDI capability, internal synth engines, and connectivity to [crow](/docs/crow).*

### generative / probabilistic

- **[the arp index](https://llllllll.co/t/the-arp-index/25182)**: Check stocks on norns (and make music). Listen to the sound of stocks falling, invest to push up the last note of your arpeggiator, do money things on norns. Also speaks MIDI to sequence external instruments.

- **[boingg](https://llllllll.co/t/boingg/26536)**: Bouncing balls make notes, with probability. Speaks to an internal synth engine, speaks to Just Friends through [crow](/docs/crow). grid interface available, though not required.

- **[circles](https://llllllll.co/t/22951)**: Move cursor. Place circles. Make music. Circles burst when they hit another circle or grow too big. When they burst, they make sound. The sound they make depends on position and size.

- **[less concepts](https://llllllll.co/t/less-concepts/21109)**: 1-d cellular automata generative playground, with built-in sequence-able varispeed softcut delay. Save up to a hundred "sets" of different rule/seed combinations, offset probabilities, and scales.

- **[loom](https://llllllll.co/t/loom/21091) + [traffic]((https://llllllll.co/t/traffic/21262))**: Surprisingly controllable generative sequencer. Think flin-meets-snake; notes are played when threads moving across the X and Y axis collide. **traffic** is the arc-enabled version, which also decouples motifs from their harmonic framework.

- **[Quence](https://llllllll.co/t/quence/29436)**: A probabilistic 4-track sequencer for MIDI, Molly the Poly, and Crow. Inspired by both Turing Machine and Fugue Machine.

- **[rebound](https://llllllll.co/t/rebound/23243)**: Kinetic sequencer. Spawn orbs that bounce endlessly from left to right, top to bottom, and back again. Each orb has its own adjustable velocity, direction, and note value.

- **[Zellen](https://llllllll.co/t/zellen/21107)**: Generative sequencer based on Conway’s Game of Life with a bunch of sequencing and play modes, Euclidean rhythms, simple controls, scales, CV and clocking via Crow, MIDI, standalone sound, and time travel.

### rule-based / programmable

- **[Animator](https://llllllll.co/t/animator/28242)**: A 2D polyphonic grid-based sequencer. Draw sequences vertically, horizontally, or diagonally and define "intersect" rules to determine what happens when two lanes collide.

- **[Dunes](https://llllllll.co/t/dunes/24790)**: A sequencer for the creation of emergent patterns, timbres and textures. Commands are assigned per step in the bottom row of the EDIT page. Each command can modulate sequence, engine and softcut parameters.

- **[meadowphysics](https://llllllll.co/t/21185)**: A norns port of monome's [meadowphysics](/docs/ansible/meadowphysics) to use with MIDI instruments or the PolyPerc engine.

- **[NISP](https://llllllll.co/t/nisp/27596)**: Scheme dialect livecoding tracker.

- **[orca](https://llllllll.co/t/orca/22492)**: norns port of [ORCΛ](https://100r.co/pages/orca.html) from Hundred Rabbits. A visual programming language, designed to create procedural sequencers on the fly.

- **[Patchwork](https://llllllll.co/t/patchwork/28800)**: A dual function sequencer for crow and grid. Note patterns and command patterns (octave, position, direction, respawn, etc) work together to create complex sequences.

- **[Punchcard](https://llllllll.co/t/punchcard/23557)**: Experimental sequencer that uses grid as a classic punchcard computer interface.

- **[vials](https://llllllll.co/t/vials/23109)**: 4-track sample-player that turns the grid into a highly flexible performance surface. Sequences are built from decimal-to-binary conversions with probability, rotation, loops, and fx send/randomization.


### step-style / multi-playhead / polyrhythmic

- **[ekombi](https://llllllll.co/t/ekombi/26812)**: 4-tracks of polyrhythmic and euclidean beats controllable with grid or norns alone. Plays samples through the ack engine as well as crow trigger outputs.

- **[foulplay](https://llllllll.co/t/foulplay/21081)**: Euclidean rhythm sequencer with logic and probability. Sequences up to eight voices.

- **[fugu](https://llllllll.co/t/fugu/21033)**: Multi-playhead sequencer inspired by "Fugue Machine" for iOS. Also speaks MIDI to sequence external instruments.

- **[kria MIDI](https://llllllll.co/t/21255)**: A norns port of monome's [kria](/docs/ansible/kria) to use with MIDI instruments.

- **[step](https://llllllll.co/t/step/21093)**: Grid controlled step sequencer for eight samples, with variable tempo and swing.

- **[takt](https://llllllll.co/t/takt/21032)**: Elektron-inspired parameter locking step sequencer. Independent lengths / time dividers per track, step retriggers, song sequencing.

## unique standalones

*These projects extend the world of norns and showcase a unique need which leads to a unique solution.*

- **[caliper](https://llllllll.co/t/caliper/31353)**: A tuner / frequency counter / volt/octave calibration assistant for norns + crow.

- **[Drum Room](https://llllllll.co/t/drum-room/23467)**: MIDI-controlled drum kits. Use the built-in kits or create your own based on the templates. Each sound has tune, decay, pan and amp/overdrive parameters. Global filter, compressor and (very) low-fi mode.

- **[Monitor](https://llllllll.co/t/monitor/23273)**: Small kit of MIDI utilities to transpose and route MIDI messages through norns to external instruments.

- **[n16o](https://llllllll.co/t/n16o/28198)**: i2c-based ER-301 control via korg nanoKONTROL2

- **[onehanded](https://llllllll.co/t/onehanded/25869/1)**: Minimal manual MIDI controller script. Dial in note, velocity, CC, channel; then, send the message to your connected MIDI instrument with a single button press.

- **[seaflex](https://llllllll.co/t/seaflex/23209)**: earthsea companion app to practice playing chords on grid.

- **[Showers](https://llllllll.co/t/31622)**: A thunderstorm.