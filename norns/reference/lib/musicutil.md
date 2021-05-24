---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/musicutil
---

## musicutil

`musicutil` provides various utilities for working with notes, scales and chords. Its utilities offer three broad categories of functions: (a) [generating](#generating-scales-and-chords) scales and chords; (b) [snapping](#snapping-notes) notes to scales or chords; and (c) [converting](#converting-ways-of-referring-to-notes-and-intervals) between different ways of referring to notes and intervals. `musicutil` also includes a number of [tables](#data) which contain very useful information and are often helpful in `params`.

{: .no_toc }

<details closed markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

Library contributed by @markeats

### generating scales and chords

These functions allow you to quickly generate scales and chords from a root note.

#### functions

| Syntax                                                            | Description                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| musicutil.generate_scale (root_num, scale_type[, octaves])        | Generate scale from a root note <br>`root_num`: the MIDI note number (0-127) where the scale will begin: integer <br>`scale_type`: the scale type (eg, "major", "aeolian" or "neapolitan major"). See [below](#full-list-of-scale-types) for the full list: string <br> `octaves`: (optional) the number of octaves to return, defaults to 1: integer<br>**Returns** an array of MIDI note numbers: `{integer...}`             |
| musicutil.generate_scale_of_length (root_num, scale_type, length) | Generate given number of notes of a scale from a root note. <br>`root_num`: the MIDI note number (0-127) where the scale will begin: integer <br>`scale_type`: the scale type (eg, "major", "aeolian" or "neapolitan major"). See [below](#full-list-of-scale-types) for the full list: string <br>`length`: number of notes to return, defaults to `8`: integer <br>**Returns** an array of MIDI note numbers: `{integer...}` |
| musicutil.generate_chord (root_num, chord_type[, inversion])      | Generate chord from a root note <br> `root_num`: the MIDI note number (0-127) for the root note of the chord: integer <br>`chord_type`: the chord type (eg, "major", "minor 7" or "sus4"). See [below](#full-list-of-chord-types) for the full list: string <br>`inversion`: (optional) number of chord inversion: integer<br>**Returns** an array of MIDI note numbers: `{integer...}`                                        |
| musicutil.chord_types_for_note (note_num, key_root, key_type)     | List chord types for a given root note and key. <br>`note_num`: the MIDI note number (0-127) for root of chord <br>`key_root`: MIDI note number (0-127) for root of key <br> `key_type`: key type (eg, "major", "aeolian" or "neapolitan major". See [below](#full-list-of-scale-types) for full list <br> **Returns** array of chord types that fit the criteria in strings: `{string...}`                                    |

#### example 1

In this example, we utilize the functions generating scales and the [conversion](#converting-ways-of-referring-to-notes-and-intervals) of note numbers to frequencies and note names. We also demonstrate the use of the [tables](#data) in `musicutil` to facilitate the selection of parameters. 

```lua
MusicUtil = require("musicutil")
engine.name = "PolyPerc"

-- we can extract a list of scale names from musicutil using the following
scale_names = {}
for i = 1, #MusicUtil.SCALES do
  table.insert(scale_names, MusicUtil.SCALES[i].name)
end

playing = false -- whether notes are playing

function init()
  engine.release(2)

  -- setting root notes using params
  params:add{type = "number", id = "root_note", name = "root note",
    min = 0, max = 127, default = 60, formatter = function(param) return MusicUtil.note_num_to_name(param:get(), true) end,
    action = function() build_scale() end} -- by employing build_scale() here, we update the scale

  -- setting scale type using params
  params:add{type = "option", id = "scale", name = "scale",
    options = scale_names, default = 5,
    action = function() build_scale() end} -- by employing build_scale() here, we update the scale
  
  -- setting how many notes from the scale can be played
  params:add{type = "number", id = "pool_size", name = "note pool size",
    min = 1, max = 32, default = 16,
    action = function() build_scale() end}

  build_scale() -- builds initial scale
end

function build_scale()
  notes_nums = MusicUtil.generate_scale_of_length(params:get("root_note"), params:get("scale"), params:get("pool_size")) -- builds scale
  notes_freq = MusicUtil.note_nums_to_freqs(notes_nums) -- converts note numbers to an array of frequencies
end

function play_notes()
  while true do
    clock.sync(1/2)
    local rnd = math.random(1,#notes_nums) -- a random integer
    current_note_num = notes_nums[rnd] -- select a random note from the scale
    engine.hz(notes_freq[rnd]) -- play note using the corresponding frequency
    current_note_name = MusicUtil.note_num_to_name(current_note_num,true) -- convert note number to name
    redraw()
  end
end

function stop_play() -- stops the coroutine playing the notes
  clock.cancel(play)
  playing = false
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    if not playing then
      play = clock.run(play_notes) -- starts the clock coroutine which plays a random note from the scale
      playing = true
    elseif playing then
      stop_play()
    end
  end
end

function redraw()
  screen.clear()
  screen.level(14)
  screen.move(64,32)
  if playing == true then
    screen.font_size(24)
    screen.text_center(current_note_name) -- display the name of the note that is playing
  else
    screen.font_size(8)
    screen.text_center("press k2 to play")
  end
  screen.update()
end
```

### snapping notes

These functions enable you to snap (aka quantize) incoming MIDI note numbers to an array of desired notes. This works especially well with the functions above. 

#### functions

| Syntax                                                      | Description                                                                                                                                                                                                                                                                                                  |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| musicutil.snap_note_to_array (note_num,snap_array)          | Snap a MIDI note number to the nearest note number in an array<br>`note_num`: the MIDI note number input to be snapped (0-127): integer <br>`snap_array`: array of MIDI note numbers to snap to, must be in order of lowest to highest: table <br>**Returns** adjusted MIDI note number: integer             |
| musicutil.snap_notes_to_array (note_nums_array, snap_array) | Snap an array of MIDI note numbers to an array of note numbers. <br>`note_nums`: array of MIDI note number inputs to be snapped: table <br>`snap_array`: array of MIDI note numbers to snap to, must be in order of lowest to highest: table <br>**Returns** array of adjusted note numbers: `{integer...}`] |

#### example 2

The following example randomly generates numbers in a range, which are then snapped to an array of notes generated using `musicutil.generate_scale_of_length`.

```lua
MusicUtil = require("musicutil")
engine.name = "PolyPerc"

playing = false -- whether notes are playing

function init()
  engine.release(2)
  build_scale() -- builds initial scale
end

function build_scale()
  notes_array = MusicUtil.generate_scale_of_length(60, "dorian", 16) -- builds quantization scale
end

function play_notes()
  while true do
    clock.sync(1/2)
    rnd = math.random(40,80)
    print("random: "..rnd)
    current_note_num = MusicUtil.snap_note_to_array(rnd,notes_array) -- snap the random number to the scale array
    print("snapped: "..current_note_num)
    engine.hz(MusicUtil.note_num_to_freq(current_note_num)) -- convert note number to freq and play
    current_note_name = MusicUtil.note_num_to_name(current_note_num,true) -- convert note number to name
    redraw()
  end
end

function stop_play() -- stops the coroutine playing the notes
  clock.cancel(play)
  playing = false
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    if not playing then
      play = clock.run(play_notes) -- starts the clock coroutine which plays a random note from the scale
      playing = true
    elseif playing then
      stop_play()
    end
  end
end

function redraw()
  screen.clear()
  screen.level(14)
  screen.move(64,32)
  if playing == true then
    screen.font_size(24)
    screen.text_center(current_note_name) -- display the name of the note that is playing
    screen.font_size(8)
    screen.move(128,50)
    screen.text_right("raw: "..rnd)
    screen.move(128,60)
    screen.text_right("snapped: "..current_note_num)
  else
    screen.font_size(8)
    screen.text_center("press k2 to play")
  end
  screen.update()
end
```

If we run this example, we will see something two values in the bottom right of the screen -- a `raw` value (supplied by our random number generator) and a `snapped` value (the `raw` value quantized to our note array):

```
raw: 70
snapped: 70

raw: 55
snapped: 60

raw: 52
snapped: 60

raw: 47
snapped: 60

raw: 66
snapped: 65

raw: 69
snapped: 69

raw: 68
snapped: 67

raw: 71
snapped: 70
```

### converting references

There are three ways of referring to notes in the `MusicUtil` library: (a) MIDI note numbers; (b) frequencies; (c) note names. The functions in this section offer ways to simply convert between the three. MIDI note numbers are used especially for MIDI output or for certain engines (especially sample-based engines), while frequencies are often used for synthesizer engines. Note names can be very helpful for on-screen UI.

#### functions

| Syntax                                                           | Description                                                                                                                                                                                                                                                                                                            |
| ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| musicutil.note_num_to_name (note_num[, include_octave])          | Convert a MIDI note number to a note name.<br>`note_num`: MIDI note number to be converted (0-127): integer<br>`include_octave`: (optional)include octave number in return string if set to true, defaults to `false`: boolean<br>**Returns** corresponding note name, eg "C#" or "C#3" (with octave): string          |
| musicutil.note_nums_to_names (note_nums_array[, include_octave]) | Convert an array of MIDI note numbers to an array of note names.<br>`note_nums_array`: array of MIDI note numbers to be converted: table<br>`include_octave`: (optional)include octave number in return string if set to true, defaults to `false`: boolean<br>**Returns** an array of corresponding note names: table |
| musicutil.note_num_to_freq (note_num)                            | Convert a MIDI note number to a frequency.<br>`note_num`: MIDI note number to be converted (0-127): integer<br>**Returns** the corresponding frequency in Hz: float                                                                                                                                                    |
| musicutil.note_nums_to_freqs (note_nums_array)                   | Convert an array of MIDI note numbers to an array of frequencies.<br>`note_nums_array`: array of MIDI note numbers to be converted: table<br>**Returns** an array of corresponding frequencies in Hz: table                                                                                                            |
| musicutil.freq_to_note_num(freq)                                 | Convert a frequency to the nearest MIDI note number.<br>`freq`: frequency number in Hz: float<br>**Returns** nearest MIDI note number (0-127): integer                                                                                                                                                                 |
| musicutil.freqs_to_note_nums (freqs_array)                       | Convert an array of frequencies to their nearest MIDI note numbers.<br>`freqs_array`: array of frequency numbers in Hz: table<br>**Returns** an array of corresponding MIDI note numbers: table                                                                                                                        |
| musicutil.interval_to_ratio (interval)                           | Return the ratio of an interval.<br>`interval`: interval in semitones: float<br>**Returns** ratio number: float                                                                                                                                                                                                        |
| musicutil.intervals_to_ratios (intervals_array)                  | Return the ratios of an array of intervals.<br>`intervals_array`: array of intervals in semitones: table<br>**Returns** an array of ratio numbers: table                                                                                                                                                               |
| musicutil.ratio_to_interval (ratio)                              | Return the interval of a ratio.<br>`ratio`: ratio number: float<br>**Returns** interval in semitones: float                                                                                                                                                                                                            |
| musicutil.ratios_to_intervals (ratios_array)                     | Return the intervals of an array of ratios.<br>`ratios_array`: array of ratios: table<br>**Returns** an array of intervals in semitones: table                                                                                                                                                                         |

#### example

See the two examples above, which each use conversion functions to manage notes.

### data

`musicutil` contains a number of helpful tables which can be referred to as follows:

| Syntax               | Description                                                                                    |
| -------------------- | ---------------------------------------------------------------------------------------------- |
| musicutil.NOTE_NAMES | An array of note names, eg "C", "C#": table                                                    |
| musicutil.SCALES     | An array of scale names, alternative names, intervals and chords relating to each scale: table |
| musicutil.CHORDS     | An array of chord names, alternative names, and intervals for each chord: table                |

See the example [above](#example-1) for how a script may use these tables.

### quick reference

Quick reference for scale and chord types which are used for the various functions above.

#### full list of scale types

```
Major
Natural Minor
Harmonic Minor
Melodic Minor
Dorian
Phrygian
Lydian
Mixolydian
Locrian
Whole Tone
Major Pentatonic
Minor Pentatonic
Major Bebop
Altered Scale
Dorian Bebop
Mixolydian Bebop
Blues Scale
Diminished Whole Half
Diminished Half Whole
Neapolitan Major
Hungarian Major
Harmonic Major
Hungarian Minor
Lydian Minor
Neapolitan Minor
Major Locrian
Leading Whole Tone
Six Tone Symmetrical
Balinese
Persian
East Indian Purvi
Oriental
Double Harmonic
Enigmatic
Overtone
Eight Tone Spanish
Prometheus
Gagaku Rittsu Sen Pou
In Sen Pou
Okinawa
Chromatic
```

#### full list of chord types

```
Major
Major 6
Major 7
Major 69
Major 9
Major 11
Major 13
Dominant 7
Ninth
Eleventh
Thirteenth
Augmented
Augmented 7
Sus4
Seventh sus4
Minor Major 7
Minor
Minor 6
Minor 7
Minor 69
Minor 9
Minor 11
Minor 13
Diminished
Diminished 7
Half Diminished 7
```
