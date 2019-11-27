---
layout: default
title: apps
parent: norns
nav_order: 5
---

# applications

norns is uniquely oriented toward sharing. In the early days of monome, creating apps for grid and arc was relatively straightforward but there were also a lot of dependencies -- the biggest being operating systems. norns successfully navigates around this by decoupling its dependence on Windows or Mac OS. Additionally, the scripting syntax at its heart is pliable and it's incredibly easy to adapt chunks of code from others to create your dream instruments.

While this is not a comprehensive list of what's available, or even all of our favorites, these projects are a wonderful starting point for those looking to play, adapt, and develop.

All are available for download in maiden's [project manager](maiden/#project-manager). Each app name links back to its discussion thread on lines.

## sampling + looping

*nb. norns has a built-in realtime sampling layer called `softcut`. It is always running and is able to capture external audio or sounds from the engines on norns. Apps in this section control softcut. Want to build your own or have an idea to extend one of these apps? Check out the [softcut studies](https://llllllll.co/t/norns-softcut-studies/23585).*

- **[compass](https://llllllll.co/t/compass/25192)**: Asynchronous looper built around the concept of a command sequencer. Commands modulate sequence, recording, playback and looping behaviors.
- **[otis](https://llllllll.co/t/22149)**: Dual "tape" delay/looper/sampler, inspired by Peter Blasser's Cocoquantus. Includes `hnds`, a bank of LFOs that can be used to modulate panning, volume, feedback, speed, record state, direction, and position of the buffer playback.
- **[cranes](https://llllllll.co/t/cranes/21207)**: Stereo varispeed looper / delay / timeline-smoosher. On-the-fly sampling with loop sync, 60-second buffer, and snapshot function to capture + recall sets of start/end points + playback speed/direction.

## synth engines + sequencers

*nb. Since many sequencers rely on synth engines which must be installed beforehand, this list is structured by the synth engine required and then the sequencers which utilize it. Unless otherwise noted, all engines can be downloaded through maiden's [project manager](../norns/maiden/#project-manager), under `community`. Remember that after installing a new synth, you need to restart norns in order for SuperCollider to register the engine.*

### **[Molly the Poly](https://llllllll.co/t/molly-the-poly/21090)**
Classic polysynth with solar system patch creator. Juno-6 voice structure with chorus, the extra modulation of a Jupiter-8, and CS-80 inspired ring modulation. Engine has a default script to play the synth with grid or MIDI.

The following apps also use Molly the Poly:

- **[fugu](https://llllllll.co/t/fugu/21033)**: Multi-playhead sequencer inspired by "Fugue Machine" for iOS. Also speaks MIDI to sequence external instruments.
- **[the arp index](https://llllllll.co/t/the-arp-index/25182)**: Check stocks on norns (and make music). Listen to the sound of stocks falling, invest to push up the last note of your arpeggiator, do money things on norns. Also speaks MIDI to sequence external instruments.

### **ack**

- 

### **PolySub**
*Downloadable through `maiden > project manager > available > base > we`.*

- **[boingg](https://llllllll.co/t/boingg/26536)**: Bouncing balls make notes, with probability. Speaks to an internal synth engine, speaks to Just Friends through crow. grid interface available, though not required.

### **[Timber](https://llllllll.co/t/timber/21407)**
Sample player engine with two built-in scripts.

- **Timber Keys**: Map samples across a MIDI keyboard. Multi-timbral across 16 channels.
- **Timber Player**: Trigger samples with a grid or MIDI keyboard. 64 Fingers inspired, can be used as a quantized clip launcher.

The following apps also use Timber:

- **[Drum Room](https://llllllll.co/t/drum-room/23467)**: MIDI-controlled drum kits. Use the built-in kits or create your own based on the templates. Each sound has tune, decay, pan and amp/overdrive parameters. Global filter, compressor and (very) low-fi mode.

### **[Passersby](https://llllllll.co/t/passersby/21089)**
West Coast style mono synth. Wave folding, FM, LPG, spring-ish reverb, LFO and two dice to roll. Includes a default script which accepts MIDI.

The following apps also use Passersby:

- **[Dunes](https://llllllll.co/t/dunes/24790)**: A sequencer for the creation of emergent patterns, timbres and textures. Commands are assigned per step in the bottom row of the EDIT page. Each command can modulate sequence, engine and softcut parameters.

### **[glut](https://llllllll.co/t/glut/21175)**
Granular synth inspired by mlr/rove, grainfields and loomer cumulus. Includes a default script which uses grid to trigger sample playback, mute tracks and record patterns.

The following apps also use glut:

- easygrain?
- 


## sequencing

*nb. Many of these projects rely on additional sound engines which must be installed beforehand. We've made an effort to list requirements, but if you're missing anything [maiden will tell you](help/#load-fail).

- **[ekombi](https://llllllll.co/t/ekombi/26812)**: Four tracks of polyrhythmic and euclidean beats (WIP)
- **[fugu](https://llllllll.co/t/fugu/21033)**: Multi-playhead sequencer inspired by "Fugue Machine" for iOS. Requires `molly_the_polly` engine. Speaks MIDI to sequence external instruments.

## omg