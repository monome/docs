---
layout: default
nav_exclude: true
permalink: /norns/softcut/
---

# softcut studies

softcut is a multi-voice sample playback and recording system built into the norns environment. It features level-smoothing, interpolated overdubbing, and matrix mixing. It was written by [`@catfact`](https://github.com/catfact).

For an introduction to norns scripting, see the [norns studies](https://monome.org/docs/norns/studies/)

## 1. basic playback

* see/run `softcut-studies/1-basic` [(source)](https://github.com/monome/softcut-studies/blob/master/1-basics.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/1-basics.png)

First, some nomenclature:

- _voice_:
  - a play/record head
  - each playhead is mono
  - each has its own parameters (ie rate, level, etc)
  - there are 6 voices

- _buffer_:
  - digital tape
  - there are 2 buffers
  - each buffer is one channel / mono
  - each buffer is 5 minutes 49.52 seconds in length

softcut parameters are reset when a script is loaded. To get a looping sound, we need to set up the following, at a minimum. The arguments are `(voice, value)`:

```lua
softcut.enable(1,1)
softcut.buffer(1,1)
softcut.level(1,1.0)
softcut.loop(1,1)
softcut.loop_start(1,1)
softcut.loop_end(1,2)
softcut.position(1,1)
softcut.play(1,1)
```

**note:** if we wanted to play and record one-off instead of looping we would still have to set the `loop_start` and `loop_end` to tell softcut which section of the buffer to use.

The buffers are blank (they are erased with each script load). To load a file (wav/aif/etc):

```lua
softcut.buffer_read_mono(file, start_src, start_dst, dur, ch_src, ch_dst)
```

- `file` -- the filename, full path required ie `"/home/we/dust/audio/spells.wav"`
- `start_src` -- start of file to read (seconds)
- `start_dst` -- start of buffer to write into (seconds)
- `dur` -- how much to read/write (seconds, use `-1` for entire file)
- `ch_src` -- which channel in file to read
- `ch_dst` -- which buffer to write


## 2. multi-voice and more parameters

* see/run `softcut-studies/2-multi` [(source)](https://github.com/monome/softcut-studies/blob/master/2-multi.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/2-multi.png)

Enable more voices, then set their parameters using the first argument in the various param functions. Here are a few more playback parameters:

```lua
softcut.pan(voice,position)
softcut.level_slew_time(voice,time)
softcut.rate_slew_time(voice,time)
```

## 3. cut and poll
* see/run `softcut-studies/3-cut` [(source)](https://github.com/monome/softcut-studies/blob/master/3-cut.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/3-cut.png)

softcut cross-fades nicely when cutting to a new position and looping. To specify the fade time:

```lua
softcut.fade_time(voice,time)
```

We can read the playback position of a voice by setting up a poll.

```lua
function update_positions(voice,position)
  print(voice,position)
end
```

And then inside `init()`:

```lua
softcut.phase_quant(voice,time)
softcut.event_phase(update_positions)
softcut.poll_start_phase()
```

`phase_quant` specifies the time quantum of reporting. For example, if voice 1 is set to 0.5, softcut will call the `update_positions` function when the playback crosses a multiple of 0.5.


## 4. record and overdub

* see/run `softcut-studies/4-recdub` [(source)](https://github.com/monome/softcut-studies/blob/master/4-recdub.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/4-recdub.png)

First, activate record mode for voice 1:

```lua
softcut.rec(1,1)
```

We can then set up the input source. First we route audio input to softcut, and then set unity levels for each input channel on voice 1:

```lua
audio.level_adc_cut(1)
softcut.level_input_cut(1,1,0.5)
softcut.level_input_cut(2,1,0.5)
```

Finally, set the `rec` and `pre` levels.

- `rec`: how much of the input gets recorded to the buffer
- `pre`: how much of the pre-existing material stays in the buffer

So, full overdub would have both levels set to `1.0`. *Just* playback would have `rec` set at `0.0`and `pre` at `1.0`. An echo effect can be easily created by setting middle ranges to each.


## 5. filters

* see/run `softcut-studies/5-filters` [(source)](https://github.com/monome/softcut-studies/blob/master/5-filters.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/5-filters.png)

softcut can apply filtering pre-record and post-playback.

```lua
softcut.pre_filter_dry(voice,value)
softcut.pre_filter_lp(voice,value)
softcut.pre_filter_hp(voice,value)
softcut.pre_filter_bp(voice,value)
softcut.pre_filter_br(voice,value)
```

Both are state variable filters with all taps available, so you can freely mix the outputs of dry, low pass, high pass, band pass, and band reject. The taps of each filter share a filter cutoff value.

To set the filter cutoff and q values:

```lua
softcut.post_filter_fc(voice,value)
softcut.post_filter_rq(voice,value)
```

`pre` filters are the same -- just replace `post` with `pre` in the commands above.

## 6. routing

* see/run `softcut-studies/6-routing` [(source)](https://github.com/monome/softcut-studies/blob/master/6-routing.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/6-routing.png)

The audio routing within softcut is highly configurable.

First, we can specify a mix of softcut's input source:

```lua
audio.level_adc_cut( level )
audio.level_eng_cut( level )
audio.level_tape_cut( level )
```

Then assign input levels per voice:

```lua
softcut.level_input_cut( ch, voice, level )
```

We can also cross-patch the output of voices to the input of other voices:

```lua
softcut.level_cut_cut( src, dst, value )
```

Each voice can have a separate level for final output:

```lua
softcut.level( voice, value )
```

The example script uses two voices. The first just plays a loop. The second jumps positions, overdub-recording into the same loop using the first playhead as the input for recording. It's a sort of feedback buffer process that radically restructures sound.


## 7. files

* see/run `softcut-studies/7-files` [(source)](https://github.com/monome/softcut-studies/blob/master/7-files.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/7-files.png)

softcut reads files to buffers and writes buffers to files, in mono and stereo.

```lua
softcut.buffer_read_mono(file, start_src, start_dst, dur, ch_src, ch_dst)
softcut.buffer_read_stereo(file, start_src, start_dst, dur)
softcut.buffer_write_mono(file, start, dur, ch)
softcut.buffer_write_stereo(file, start, dur)
```

The example script reads a "backing track" clip when K1 is long-pressed. This sets a loop length, and the playback volume can be changed with E1. A second clip is recorded from the audio input, with configurable rec/pre levels with E2/E3 respectively. The recorded clip can be saved at any time with K3, to `dust/audio/` with a `ss7-` prefix along with a random number. This functions as a live "clip grabber" with overdub options.

## 8. copy + waveform data

* see/run `softcut-studies/8-copy` [(source)](https://github.com/monome/softcut-studies/blob/master/8-copy.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/8-copy.png)

Sections of a softcut buffer can be copied and pasted, for creative collage or straightforward duplication.

```lua
softcut.buffer_copy_mono(src_ch, dst_ch, start_src, start_dst, dur, fade_time, reverse)
softcut.buffer_copy_stereo(start_src, start_dst, dur, fade_time, reverse)
```

Buffer content can also be rendered as a series of floats, -1 to +1, for waveform visualization.

To request a numerical snapshot of a section:

```lua
softcut.render_buffer(ch, start, dur, samples)
```

To perform a task after the snapshot, use the `event_render` callback:

```lua
softcut.event_render(func)
```

See the `8-copy.lua` script for an example of how to turn the -1 to +1 floats to a waveform.

## 9. query and sync position

* see/run `softcut-studies/9-query` [(source)](https://github.com/monome/softcut-studies/blob/master/9-query.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/9-query.png)

In [**cut and poll**](#3-cut-and-poll), we used a poll to continuously report the position of a voice's playhead. softcut can also return any voice's playhead position on-demand:

```lua
softcut.query_position(voice)
```

This command will send the `voice` identifier (`1` through `6`) and its current playhead position through a callback function:

```lua
softcut.event_position(func)
```

In `9-query.lua`, we use K3 to query the playhead's position at the moment of press and set it as the endpoint of a micro-loop.

If you simply wish to sync the playhead of one voice to another's position, use:

```lua
softcut.voice_sync(dst, src, offset)
```

This command will set the playhead of a specified voice (`dst`) to the position of another's (`src`), with an option for timed `offset` (in seconds) between the two.

---

## reference

- [softcut API docs](https://monome.org/docs/norns/api/modules/softcut.html)

contributions welcome: [github/monome/softcut-studies](https://github.com/monome/softcut-studies)
