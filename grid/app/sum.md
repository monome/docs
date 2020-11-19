---
layout: default
nav_exclude: true
redirect_from: /app/sum/
---

<div class="vid"><html><iframe src="//player.vimeo.com/video/91524122" width="570" height="321" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></html></div>

# monome sum

*monome sum* is a collection of essential monome applications, synchronized together, creating a flexible environment for creating music. The apps are simplified for easy exploration with enhanced visual feedback for vari-bright grids. Expanded versions are available in the monome application repository.

*gome* is based on the original polygome by [stretta](http://www.stretta.com).

## Download

Get the latest version of [monome sum](https://github.com/monome/monome_sum/releases/latest).

## Getting Started

Open the *monome sum* application.

![Main interface](images/main_interface.png)

*note: for OSX 10.8+ you'll need to bypass gatekeeper the first time you open sum. control-click the app in finder, click 'open', then click 'open' again.*


### Smallbatch

Attach your grid via USB and select it from the dropdown. You should see something like the following image:

![smallbatch](images/smallbatch.png)

*smallbatch* is an intermediary layer allowing the grid to switch effortlessly between available applications.

Change the active application by clicking the grey boxes. A pale blue colour highlights the current selection.

### Master & Presets

![Master](images/master.png)

Master Controls allow all the application components to work together, by setting tempo, musical scale and global volume. There is a simple audio recorder provided to capture performances into a wave file.

Select from the Presets for quick sound transformation, exploring some of the many sonic possibilities of *sum*. All changes made can be stored and recalled easily.

[The Scream](https://en.wikipedia.org/wiki/The_Scream) is a 'panic button' allowing you to clear all current playback & patterns, starting with a fresh slate.

## Applications

*monome sum* is comprised of six interlinked applications:

### flin

A cyclic poly-rhythm music box, where each column represents a voice. Notes are arranged left (lowest), to right (highest). The vertical dimension represents time, where top is fastest and bottom slowest.

![flin](images/flin.png)

- Press a key to start cycling a note.
- Push the bottom row to mute that note.
- Cycle rate is set by the vertical location of the key press. Faster notes toward the top.
- Duration can be changed by holding a press and pressing elsewhere in the column. The second press sets duration, longer toward the bottom.

*Width* & *Pitch* can also be modified to alter the notes that *flin* can play. Increasing *Width* stretches the high and low notes apart for lower bass, and higher highs. Shifting *Pitch* transposes the entire bank of notes together, while keeping everything locked in key.



### corners

A gravity-influenced modulator for affecting the timbre of *sum's* synthesizer. The puck slides around the surface as it is attracted toward keypresses.

![corners](images/corners.png)

- Hold a key to make an attractor, the puck will slide toward this location.
- Press many points at different times to juggle the puck around the surface.
- Top-left key is a brake function, slowing the puck gradually to a stop.
- 'Reflections' can be disabled in app to allow the puck to wrap edge-to-edge.
- Friction & Gravity can be set to change the acceleration and attractor strength.

Moving the puck upward on the grid makes the synthesizer sounds more aggressive, and resonant, while more subtle sounds are available downward. Panning around the horizontal space will shift the filter parameters to create changes in the spectrum of the synthesizer elements, where left sounds are bassier, while right sounds are brighter.


### step

A simple step sequencer for triggering drum sounds. Standard percussion sounds are used by default, though these can be altered via the 'step sound editor'.

![step](images/step.png)

- Enter note events with key presses. Notes will light when active.
- Top row shows the current playhead.
- Press keys in the top row to jump to a new playback position.
- Set a playback loop by holding the new playback position, and pressing another top-row key to set the end position.


### gome

A dynamic pattern instrument, creating automatic melodies & arpeggiations. The grid maps pitches increasing from top-left to bottom-right.

![gome](images/gome.png)

- Hold keys to play the current pattern starting from the given root note.
- Pitches are arranged with diatonic scales horizontally and fourths vertically.
- Multiple notes can be played simultaneously by holding multiple keys.
- The current playback pattern is selected in the top-row.
- 'Loop' mode is toggled with the top-left key for sustained arpeggios.


### mlr

A sample-playback engine for live-cutting samples and recording pattern gestures. *monome sum* comes preloaded with samples, or you can drag and drop your own into the mlr window.

![mlr](images/mlr.png)

- Press keys in a row to playback the sample from the given location.
- Samples are mapped across each row, with playback indicated by the moving light.
- Top-row buttons are meta functions, dimly lit for orientation:
  - Left pair (0/1) stop playback for group 1 (Rows 1-3) and group 2 (Rows 4-7).
  - Right pair (4/5) are pattern recorders.
- Press a pattern recorder, cut up a sample, and the pattern will loop back.
- Stop and clear a pattern by pressing the recorder's key again.
- Create a sub-loop within a row by holding a start position, then pressing the loop end.


### beams

A bank of virtual faders for controlling application wide parameters. Each fader has inertia for smooth fades and modulation.

![beams](images/beams.png)

  - Press a key to set the new value for the given fader.
  - Hold a key briefly to add inertia causing the fader to slide around the destination value before settling.
  - Hold a key for 1second and the fader will oscillate slowly around the destination value.


## Synthesizer

![Synthesizer](images/synth.png)

*monome sum* includes a simple, yet flexible synthesis engine used to create all the sounds throughout the environment (excluding mlr). To create such a broad palette of sounds the synth uses both FM & subtractive synthesis approaches, plus an Attack-Decay envelope to control volume, with additional modulation routing options.

*Pitch* allows the tuning of the synth to be finetuned to match with samples loaded in mlr. The small *env* slider modulates the pitch with the *envelope* in either positive or negative direction, accordingly to the slider.

*Timbre* fades smoothly between different oscillator waveforms allowing for smooth control over harmonic content. *Noise* can be mixed in with the oscillator, which is particularly useful for percussion sounds.

The oscillator is processed by the *Filter* for sculpting the sonic response. *Cutoff* shifts the point at which the filter begins to take action. *Q* adds resonance, or emphasis, around the cutoff frequency. *Env* allows the Cutoff control to be modulated by the *envelope*.

The last *Filter* slider allows the response of the filter to be faded between many different responses. At either end is the classic Lowpass response, with the less common Bandpass, Highpass, and Band Reject (Notch) responses in between. Mixing smoothly between these responses allows subtle shifts between the standard responses.

*Modulation* controls a second, slave oscillator, for frequency modulating the main oscillator. *FM multiplier* sets the harmonic relationship between the oscillators, where higher multiples add upper harmonics to the sound, where lower settings add low frequencies and sub-octave tones. *FM Index* controls how much modulation should be applied to the main oscillator. *Env* allows the FM Index to be modulated according to the *envelope*.

*Envelope* is a slow changing modulation triggered each time a note is received. The output volume of the synth is always controlled by envelope. *Length* controls the duration of the modulation. The envelope contains attack and decay sections where *Shape* alters the linearity of these slopes - lower settings for softer attacks, higher settings for smoother tails. *Slope* shifts the amount of time spent in attack versus decay - lower settings for quick percussive attacks, higher settings for swelling synth tones.

## Smallbatch & Routing

In addition to changing applications by clicking the onscreen UI, the current app can also be changed directly from the grid.

![router](images/router.png)

  - Hold the top-right button at any time to reveal the *Router*
  - The bottom row will display an LED for each available application.
  - The currently active app is displayed with a bright column.
  - Select a new app by pressing anywhere in the appropriate column.
  - Release the *Route* key (top right) to resume with the new selection.

Applications are available in the same order as listed in Smallbatch.

If you would like to change the location of the *Route* key, or remove it altogether:

  - Select *Advanced* in the Smallbatch window, new options will appear.
  - To the right of the *Advanced* button, find the *Route Key:* Box.
  - Click *Map* to show the current location of the route key on the grid.
  - Press another key to set a new route key location.
  - Press the current location again to disable the route key.


## Master Controls
### Scales & Tempo

Sum forces all generated notes to fall into the selected scales. *Key* and *Scale* set the bank of notes to select from. All *modes* of the scales are available through your choice of notes in flin & gome.

*Tempo* can be quickly set with the slider, or entered directly by clicking on the numerical display, typing your desired BPM, then hitting Enter (When click for numerical entry, a small triangle will appear to the left of the tempo display).

### Audio Recorder

*monome sum* includes an audio recorder to capture live performances to disk.

  - Click *Filename* and set a location & filename for your recording.
  - Press *Record* to begin capturing audio.
  - Press *Stop* to finalize your recording.

### MIDI Clock Out

In order to synchronize other devices or applications to *sum*, a MIDI clock output is available.

  - In the menu bar select: `Preferences -> MIDI Clock`.
  - Select your MIDI output destination.
  - Press the big toggle button to turn on the clock.

### MIDI Clock In aka Clocksource

Since v1.3 *sum* now supports slaving to an external MIDI clock. This can be a DAW (over Rewire or internal MIDI) or external hardware.

  - In the menu bar select: `Preferences -> MIDI Clock`.
  - Under `clocksource` you will see a dropdown with a list of options.
  - `INTERNAL` is selected by default, and will use Sum's internal clock.
  - Select an option from the dropdown to sync and deactivate the internal clock.

### Audio Settings

Upon loading, *sum* will select your default audio interface and be ready to make sound instantly. In the case that you want to select a different output destination or change other audio settings:

  - In the menu bar select: `Preferences -> Audio Settings`.
  - *Driver* & *Device* select your driver options and physical audio interface.
  - *Buffer Size* can be decreased for faster response, with higher CPU usage.
  - *Left* & *Right* allow you to select alternate outputs on more complex soundcards.

#### Multi Channel

*sum* sends the full mix of instruments out of the channels selected by *Left* and *Right* (as above). Additionally, by arming the *multi channel* button, *sum* will send each of the individual parts out on different channels. Try using this with Rewire into a DAW or out of a multi-channel soundcard into an analog mixer.

The channel assignments are:

  - 1: Main output (left)
  - 2: Main output (right)
  - 3: Flin
  - 4: Gomé
  - 5: Step
  - 6: Delay & Reverb (mixed together)
  - 7: mlr (left channel)
  - 8: mlr (right channel)


## Presets

*monome sum* includes 8 presets preloaded with useful musical departure points highlighting the breadth of sonic capabilities of the program. You can however, create your own collections of settings and return to them later.

Whenever you edit the settings of the current preset, via the app or the grid, those changes will be saved into the temporary save file. Changing between presets is instant and will not lose changes to the previous preset.

  - Select: `File -> Save As` and give your preset collection a filename.
  - Select `File -> Open` to reload a previously saved preset collection.

These save files are complete collections of sounds that can be shared between users, though audio samples are not saved within the file and will need to be included alongside the save file.



## Credits

*monome sum* was created by [monome.org](https://monome.org) using Max 6.

This manual was created by [Trent Gill](http://www.whimsicalraps.com) for [monome.org](https://monome.org).

Contributions welcome. Submit a pull request to [github.com/monome/monome_sum](https://github.com/monome/monome_sum) or e-mail `help@monome.org`.
