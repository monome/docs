---
layout: default
title: apps
parent: norns
nav_order: 5
---

# applications

norns is uniquely oriented toward sharing. In the early days of monome, creating apps for grid and arc was relatively straightforward but there were also a lot of dependencies -- the biggest being operating systems. norns successfully navigates around this by decoupling its dependence on Windows or Mac OS. Additionally, the scripting syntax at its heart is pliable and it's incredibly easy to adapt chunks of code from others to create your dream instruments.

While this is not a comprehensive list of what's available (or even all of our favorites!), these projects are a wonderful starting point for those looking to play, adapt, and develop.

All are available for download in maiden's [project manager](maiden/#project-manager). Each app name links back to its discussion thread on lines.

## sampling + looping

*norns has a built-in realtime sampling layer called `softcut`. It is always running and is able to capture external audio or sounds from the engines on norns. Apps in this section control softcut. Want to build your own or have an idea to extend one of these apps? Check out the [softcut studies](https://llllllll.co/t/norns-softcut-studies/23585).*

- **[compass](https://llllllll.co/t/compass/25192)**: Asynchronous looper built around the concept of a command-based sequencer. Commands modulate recording, playback, looping, even sequencing behaviors.
- **[otis](https://llllllll.co/t/22149)**: Dual "tape" delay/looper/sampler with digital noise, inspired by Peter Blasser's Cocoquantus. Includes `hnds`, a bank of LFOs that can be used to modulate panning, volume, feedback, speed, record state, direction, and position of the buffer playback.
- **[mlr](https://llllllll.co/t/mlr-norns/21145)**: The original live sample-cutting platform. Load samples or record live audio, then re-pitch + chop + record gestures.
- **[cranes](https://llllllll.co/t/cranes/21207)**: Stereo varispeed looper / delay / timeline-smoosher. On-the-fly sampling into a 60-second buffer, snapshot function to capture/recall sets of start/end points and playback speed/direction.
- **[tunnels](https://llllllll.co/t/tunnels/21973)**: A collection of randomized, experimental stereo delays. Flip through a plethora of preset modes (with delightfully esoteric names) for immediate fun.
- **[reels](https://llllllll.co/t/reels/21030)**: 4-track asynchronous looper, inspired by OP-1's tape recorder and the Whimsical Raps w/ Eurorack module. Includes library version (`libreels`) to easily add reels to any other scripts which do not yet utilize softcut.
- **[TimeParty](https://llllllll.co/t/timeparty/22837)**: Delay with seven step sequencers to modulate time, rate, feedback, autopanning, reverb, filter cutoff, and position.

## synth engines + sequencers

*Many sequencers rely on synth engines which must be installed beforehand. To help keep this front-of-mind, we will list the synth engine and then the sequencers which utilize it. Unless otherwise noted, all engines can be downloaded through maiden's [project manager](../norns/maiden/#project-manager), under `community`. Remember that after installing a new synth engine, you need to restart norns (SYSTEM > RESET) in order for SuperCollider to register it.*

*When applicable, engines are hyperlinked to their lines discussion thread.*

### **ack**
Sample player engine with fine-grain controls over pitch, filtering (w/envelopes), start/end point, and volume (w/ envelopes).

- **[foulplay](https://llllllll.co/t/foulplay/21081)**: Euclidean rhythm sequencer with logic and probability. Sequences up to eight voices.
- **[step](https://llllllll.co/t/step/21093)**: Grid controlled step sequencer for eight samples, with variable tempo and swing.
- **[takt](https://llllllll.co/t/takt/21032)**: Elektron-inspired parameter locking step sequencer. Independent lengths / time dividers per track, step retriggers, song sequencing.
- **[vials](https://llllllll.co/t/vials/23109)**: 4-track sample-player that turns the grid into a highly flexible performance surface. Sequences are built from decimal-to-binary conversions with probability, rotation, loops, and fx send/randomization.

### **[glut](https://llllllll.co/t/glut/21175)**
Granular synth inspired by mlr/rove, grainfields and loomer cumulus. Includes a default script which uses grid to trigger sample playback, mute tracks and record patterns.

The following apps also use glut:

- **[langl](https://llllllll.co/t/langl/26931)**: Granular looper for arc. Tactile control over grain clouds: pitch, density, size, jitter, spread, volume, speed, loop location.
- **[mangl](https://llllllll.co/t/mangl/21066)**: Sample player + manipulator for grid + arc. Quickly manipulate up to seven samples (and the sounds in between) to create new landscapes from familiar material.

### **[Molly the Poly](https://llllllll.co/t/molly-the-poly/21090)**
Classic polysynth with solar system patch creator. Juno-6 voice structure with chorus, the extra modulation of a Jupiter-8, and CS-80 inspired ring modulation. Engine has a default script to play the synth with grid or MIDI.

The following apps also use Molly the Poly:

- **[fugu](https://llllllll.co/t/fugu/21033)**: Multi-playhead sequencer inspired by "Fugue Machine" for iOS. Also speaks MIDI to sequence external instruments.
- **[loom](https://llllllll.co/t/loom/21091) + [traffic]((https://llllllll.co/t/traffic/21262))**: Surprisingly controllable generative sequencer. Think flin-meets-snake; notes are played when threads moving across the X and Y axis collide. **traffic** is the arc-enabled version, which also decouples motifs from their harmonic framework.
- **[the arp index](https://llllllll.co/t/the-arp-index/25182)**: Check stocks on norns (and make music). Listen to the sound of stocks falling, invest to push up the last note of your arpeggiator, do money things on norns. Also speaks MIDI to sequence external instruments.

### **[Passersby](https://llllllll.co/t/passersby/21089)**
West Coast-style mono synth. Wave folding, FM, LPG, spring-ish reverb, LFO and two dice to roll. Includes a default script which accepts MIDI.

The following apps also use Passersby:

- **[Dunes](https://llllllll.co/t/dunes/24790)**: A sequencer for the creation of emergent patterns, timbres and textures. Commands are assigned per step in the bottom row of the EDIT page. Each command can modulate sequence, engine and softcut parameters.
- **[less concepts](https://llllllll.co/t/less-concepts/21109)**: 1-d cellular automata generative playground, with built-in sequence-able varispeed softcut delay. Save up to a hundred "sets" of different rule/seed combinations, offset probabilities, and scales.

### **PolyPerc**
Simple polyphonic filtered decaying square wave.

*nb. Pre-installed engine, does not require additional installation.*

- **[rebound](https://llllllll.co/t/rebound/23243)**: Kinetic sequencer. Spawn orbs that bounce endlessly from left to right, top to bottom, and back again. Each orb has its own adjustable velocity, direction, and note value.
- **[Zellen](https://llllllll.co/t/zellen/21107)**: Generative sequencer based on Conway’s Game of Life with a bunch of sequencing and play modes, Euclidean rhythms, simple controls, scales, CV and clocking via Crow, MIDI, standalone sound, and time travel.

### **PolySub**
*Downloadable through `maiden > project manager > available > base > we`.*

- **[boingg](https://llllllll.co/t/boingg/26536)**: Bouncing balls make notes, with probability. Speaks to an internal synth engine, speaks to Just Friends through [crow](../crow/index). grid interface available, though not required.

### **[Timber](https://llllllll.co/t/timber/21407)**
Sample player engine with two built-in scripts.

- **Timber Keys**: Map samples across a MIDI keyboard. Multi-timbral across 16 channels.
- **Timber Player**: Trigger samples with a grid or MIDI keyboard. 64 Fingers inspired, can be used as a quantized clip launcher.

The following apps also use Timber:

- **[Drum Room](https://llllllll.co/t/drum-room/23467)**: MIDI-controlled drum kits. Use the built-in kits or create your own based on the templates. Each sound has tune, decay, pan and amp/overdrive parameters. Global filter, compressor and (very) low-fi mode.
- **[orca](https://llllllll.co/t/orca/22492)**: norns port of [ORCΛ](https://100r.co/pages/orca.html) from Hundred Rabbits. A visual programming language, designed to create procedural sequencers on the fly.

## unique standalones

*These projects extend the world of norns and showcase a unique need which leads to a unique solution.*

- **[Monitor](https://llllllll.co/t/monitor/23273)**: Small kit of MIDI utilities to transpose and route MIDI messages through norns to external instruments.
- **[onehanded](https://llllllll.co/t/onehanded/25869/1)**: Minimal manual MIDI controller script. Dial in note, velocity, CC, channel; then, send the message to your connected MIDI instrument with a single button press.
- **[Punchcard](https://llllllll.co/t/punchcard/23557)**: Experimental sequencer that uses grid as a classic punchcard computer interface.
- **[seaflex](https://llllllll.co/t/seaflex/23209)**: earthsea companion app to practice playing chords on grid.
- **[Sway](https://llllllll.co/t/sway/21117)**: Analysis-driven live audio processing. Interactive music system based on incoming audio amplitude, density, and pitch clarity. Sway is both a script and engine, so please make sure you restart norns after installing it.