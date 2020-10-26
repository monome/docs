---
layout: default
nav_exclude: true
permalink: /norns/softcut/
---

# softcut studies

softcut is a multi-voice sample playback and recording system built into the norns environment. it features level-smoothing, interpolated overdubbing, and matrix mixing. it was written by @zebra.

for an introduction to scripting:

- [studies](https://monome.org/docs/norns/study-1/)
- [tutorial](https://llllllll.co/t/norns-tutorial/23241)
- [video: softcut + clocks](https://vimeo.com/416730766)

## 1. basic playback

* see/run softcut-studies/1-basic [(source)](https://github.com/monome/softcut-studies/blob/master/1-basics.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/1-basics.png)

first, some nomenclature:

- _voice_ --- a play/record head. mono. each has its own parameters (ie rate, level, etc). there are 6 voices.
- _buffer_ --- digital tape, there are 2 buffers. mono. just about 5 minutes each.

softcut parameters are reset when a script is loaded. to get a looping sound we need at a minimum the following, where the arguments are `(voice, value)`:

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

the buffers are blank. load a file (wav/aif/etc):

```lua
softcut.buffer_read_mono(file, start_src, start_dst, dur, ch_src, ch_dst)
```

- `file` --- the filename, full path required ie `"/home/we/dust/audio/spells.wav"`
- `start_src` --- start of file to read (seconds)
- `start_dst` --- start of buffer to write into (seconds)
- `dur` --- how much to read/write (seconds, use `-1` for entire file)
- `ch_src` --- which channel in file to read
- `ch_dst` --- which buffer to write


## 2. multivoice and more parameters

* see/run softcut-studies/2-multi [(source)](https://github.com/monome/softcut-studies/blob/master/2-multi.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/2-multi.png)

enable more voices, then set their parameters using the first argument in the various param functions. here are a few more playback parameters:

```lua
softcut.pan(voice,position)
softcut.level_slew_time(voice,time)
softcut.rate_slew_time(voice,time)
```

## 3. cut and poll
* see/run softcut-studies/3-cut [(source)](https://github.com/monome/softcut-studies/blob/master/3-cut.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/3-cut.png)

softcut cross-fades nicely when cutting to a new position and looping. specify the fade time:

```lua
softcut.fade_time(voice,time)
```

we can read the playback position of a voice by setting up a poll.

```lua
function update_positions(voice,position)
  print(voice,position)
end
```

and then inside `init()`:

```lua
softcut.phase_quant(voice,time)
softcut.event_phase(update_positions)
softcut.poll_start_phase()
```

`phase_quant` specifies the time quantum of reporting. for example, if voice 1 is set to 0.5, softcut will call the `update_positions` function when the playback crosses a multiple of 0.5.


## 4. record and overdub

* see/run softcut-studies/4-recdub [(source)](https://github.com/monome/softcut-studies/blob/master/4-recdub.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/4-recdub.png)

first activate record mode for voice 1:

```lua
softcut.rec(1,1)
```

then set up the input source. first we route audio input to softcut, and then set unity levels for each input channel on voice 1:

```lua
audio.level_adc_cut(1)
softcut.level_input_cut(1,1,1.0)
softcut.level_input_cut(2,1,1.0)
```

finally, set the `rec` and `pre` levels.

- `rec`: how much of the input gets recorded to the buffer
- `pre`: how much of the pre-existing material stays in the buffer

so, full overdub would have both levels set to `1.0`. just playback would have `rec` set at `0.0`and `pre` at `1.0`. an echo effect can be easily created by setting middle ranges to each.


## 5. filters

* see/run softcut-studies/5-filters [(source)](https://github.com/monome/softcut-studies/blob/master/5-filters.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/5-filters.png)

softcut can apply filtering pre-record and post-playback.

```lua
softcut.pre_filter_dry(voice,value)
softcut.pre_filter_lp(voice,value)
softcut.pre_filter_hp(voice,value)
softcut.pre_filter_bp(voice,value)
softcut.pre_filter_br(voice,value)
```

both are state variable filters with all taps available, so you can freely mix the outputs of dry, low pass, high pass, band pass, and band reject.

to set the filter cutoff and q values:

```lua
softcut.pre_filter_fc(voice,value)
softcut.pre_filter_rq(voice,value)
```

`post` filters are the same. just replace `pre` with `post` in the command set.

## 6. routing

* see/run softcut-studies/6-routing [(source)](https://github.com/monome/softcut-studies/blob/master/6-routing.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/6-routing.png)

the audio routing within softcut is highly configurable.

first we can specify a mix of softcut's input source:

```lua
audio.level_adc_cut( level )
audio.level_eng_cut( level )
audio.level_tape_cut( level )
```

then assign input levels per voice:

```lua
softcut.level_input_cut( ch, voice, level )
```

we can also cross-patch the output of voices to the input of other voices:

```lua
softcut.level_cut_cut( src, dst, value )
```

each voice can have a separate level for final output:

```lua
softcut.level( voice, value )
```

the example script uses two voices. the first just plays a loop. the second jumps positions, overdub-recording into the same loop using the first playhead as the input for recording. it's a sort of feedback buffer process that radically restructures sound.


## 7. files

* see/run softcut-studies/7-files [(source)](https://github.com/monome/softcut-studies/blob/master/7-files.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/7-files.png)

softcut reads files to buffers and writes buffers to files, in mono and stereo.

```lua
softcut.buffer_read_mono(file, start_src, start_dst, dur, ch_src, ch_dst)
softcut.buffer_read_stereo(file, start_src, start_dst, dur)
softcut.buffer_write_mono(file, start, dur, ch)
softcut.buffer_write_stereo(file, start, dur)
```

the example script reads a "backing track" clip when K1 is long-pressed. this sets a loop length, and the playback volume can be changed with E1. a second clip is recorded from the audio input, with configurable rec/pre levels with E2/E3 respectively. the recorded clip can be saved at any time with K3, to `dust/audio/` with a `ss7-` prefix along with a random number. this functions as a live "clip grabber" with overdub options.

## 8. copy + waveform data

* see/run softcut-studies/8-copy [(source)](https://github.com/monome/softcut-studies/blob/master/8-copy.lua)

![](https://raw.githubusercontent.com/monome/softcut-studies/master/lib/8-copy.png)

sections of a softcut buffer can be copied and pasted, for creative collage or straightforward duplication.

```lua
softcut.buffer_copy_mono(src_ch, dst_ch, start_src, start_dst, dur, fade_time, reverse)
softcut.buffer_copy_stereo(start_src, start_dst, dur, fade_time, reverse)
```

buffer content can also be rendered as a series of floats, -1 to +1, for waveform visualization.

to request a numerical snapshot of a section:

```lua
softcut.render_buffer(ch, start, dur, samples)
```

to perform a task after the snapshot, use the `event_render` callback:

```lua
softcut.event_render(func)
```

see the `8-copy.lua` script for an example of how to turn the -1 to +1 floats to a waveform.

---

## reference

- [softcut API docs](https://monome.org/docs/norns/api/modules/softcut.html)

contributions welcome: [github/monome/softcut-studies](https://github.com/monome/softcut-studies)
