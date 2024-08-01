---
layout: default
nav_exclude: true
permalink: /norns/reference/audio
---

## audio

{: .no_toc }

Directly set system audio levels. Note that these functions are not coupled to the corresponding entries in PARAMETERS, so changes will not be reflected in the norns menu UI. To simultaneously change these levels *and* the PARAMETERS values, use the `params:set` approach listed in each function's description.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### control: main levels

| Syntax                     | Description                                                  |
| -------------------------- | ------------------------------------------------------------ |
| audio.headphone_gain(gain) | Set the headphone gain (expects `0` to `64`) : function<br/>Params version: `params:set("headphone_gain")`, expects `-math.huge` to `6` (in dB) |
| audio.level_adc(level)     | Set the level for ADC input (expects `0` to `1`) : function<br/>Params version: `params:set("input_level")`, expects `-math.huge` to `6` (in dB) |
| audio.level_dac(level)     | Set the level for both output channels (expects `0` to `1`) : function<br/>Params version: `params:set("output_level")`, expects `-math.huge` to `6` (in dB) |
| audio.monitor_mono()       | Set monitor mode to mono : function<br/>Params version: `params:set("monitor_mode")`, expects `2` for mono |
| audio.monitor_stereo()     | Set monitor mode to mono : function<br/>Params version: `params:set("monitor_mode")`, expects `1` for stereo |
| audio.level_tape(level)    | Set tape output level (expects `0` to `1`) : function<br/>Params version: `params:set("tape_level")`, expects `-math.huge` to `6` (in dB) |
| audio.level_cut(level)     | Set softcut output level (expects `0` to `1`) : function<br/>Params version: `params:set("softcut_level")`, expects `-math.huge` to `6` (in dB) |
| audio.pitch_on()           | Enable input pitch analysis : function                       |
| audio.pitch_off()          | Disable input pitch analysis (saves CPU) : function          |
| audio.restart()            | Restart the audio engine (recompiles sclang) : function      |

### control: effects levels

#### Reverb Functions

| Syntax                       | Description                                                                                                                                                                   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| audio.rev_on()               | Turn reverb on <br>Params version: `params:set("reverb")`, expects `1` (off) or `2` (on)                                                                                      |
| audio.rev_off()              | Turn reverb off <br>Params version: `params:set("reverb")`, expects `1` (off) or `2` (on)                                                                                     |
| audio.level_monitor_rev(val) | Set the send level for monitor into reverb (expects `0` to `1`) : function<br>Params version: `params:set("rev_monitor_input")`, expects `-math.huge` to `18` (in dB)         |
| audio.level_eng_rev(val)     | Set the send level for the script's engine into reverb (expects `0` to `1`) : function<br>Params version: `params:set("rev_eng_input")`, expects `-math.huge` to `18` (in dB) |
| audio.level_tape_rev(val)    | Set the send level for TAPE into reverb (expects `0` to `1`) : function<br>Params version: `params:set("rev_tape_input")`, expects `-math.huge` to `18` (in dB)               |
| audio.level_cut_rev(val)     | Set the send level for softcut into reverb (expects `0` to `1`) : function<br>Params version: `params:set("rev_cut_input")`, expects `-math.huge` to `18` (in dB)             |
| audio.level_rev_dac(level)   | Set the return level of the reverb (expects `0` to `1`) : function<br>Params version: `params:set("rev_return_level")`, expects `-math.huge` to `18` (in dB)                  |
| audio.rev_param(name, val)   | Set a reverb parameter (see full list below) : function                                                                                                                       |

#### Reverb Parameters (use with `rev_param`)

| Name       | Description                                                                 | Params Version                 | Range                      |
| ---------- | --------------------------------------------------------------------------- | ------------------------------ | -------------------------- |
| `pre_del`  | reverb pre-delay                                                            | `params:set("rev_pre_delay")`  | `20` to `100` (in ms)      |
| `lf_fc`    | low-pass filter cutoff                                                      | `params:set("lf_fc")`          | `50` to `1000` (in Hz)     |
| `low_rt60` | low frequency decay time (at DC, depends on `mid_rt60`)                     | `params:set("rev_low_time")`   | `0.1` to `16` (in seconds) |
| `mid_rt60` | mid frequency decay time (high frequencies will decay at 1/2 of this value) | `params:set("rev_mid_time")`   | `0.1` to `16` (in seconds) |
| `hf_damp`  | high frequency damping                                                      | `params:set("rev_hf_damping")` | `1500` to `20000` (in Hz)  |

#### Compressor Functions

| Syntax                      | Description                                                                                                                |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| audio.comp_on()             | Turn compressor on <br>Params version: `params:set("compressor")`, expects `1` (off) or `2` (on)                           |
| audio.comp_off()            | Turn compressor off <br>Params version: `params:set("compressor")`, expects `1` (off) or `2` (on)                          |
| audio.comp_mix(val)         | Set the balance of wet/dry (expects `0` to `1`) : function<br>Params version: `params:set("comp_mix")`, expects `0` to `1` |
| audio.comp_param(name, val) | Set a compressor parameter (see full list below) : function                                                                |

#### Compressor Parameters (use with `comp_param`)

| Name        | Description             | Params Version                 | Range                  |
| ----------- | ----------------------- | ------------------------------ | ---------------------- |
| `ratio`     | compressor ratio        | `params:set("comp_ratio")`     | `1` to `20`            |
| `threshold` | compressor threshold    | `params:set("comp_threshold")` | `-100` to `10` (in dB) |
| `attack`    | compressor attack time  | `params:set("comp_attack")`    | `1` to `1000` (in ms)  |
| `release`   | compressor release time | `params:set("comp_release")`   | `1` to `1000` (in ms)  |
| `gain_pre`  | compressor pre-gain     | `params:set("comp_pre_gain")`  | `-20` to `60` (in dB)  |
| `gain_post` | compressor post-gain    | `params:set("comp_post_gain")` | `-20` to `60` (in dB)  |

### Tape Functions

| Syntax                       | Description                    |
| ---------------------------- | ------------------------------ |
| audio.tape_play_open(file)   | Open a tape file for playing   |
| audio.tape_play_start()      | Start playing tape             |
| audio.tape_play_stop()       | Stop playing tape              |
| audio.tape_record_open(file) | Open a tape file for recording |
| audio.tape_record_start()    | Start recording tape           |
| audio.tape_record_stop()     | Stop recording tape            |

### softcut Input Levels

| Syntax                       | Description                                                                                                                                                         |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| audio.level_adc_cut (value)  | Set the send level for the hardware input into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_adc")`, expects `-math.huge` to `18` (in dB) |
| audio.level_eng_cut (value)  | Set the send level for the engine into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_eng")`, expects `-math.huge` to `18` (in dB)         |
| audio.level_tape_cut (value) | Set the send level for the tape into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_tape")`, expects `-math.huge` to `18` (in dB)          |

### callbacks and helpers

| Syntax                          | Description                                                  |
| ------------------------------- | ------------------------------------------------------------ |
| audio.vu (in1, in2, out1, out2) | Script re-definable callback for VU meters (returns `0` to `63`) |
| audio.set_audio_level(value)    | Set the final output level, which is saved as part of system settings (expects `0` to `64`) |
| audio.adjust_audio_level(delta) | Adjusts the final output level incrementally, which is saved as part of system settings (final level is clamped to `0` to `64`) |
| audio.file_info(path)           | Returns information (channels, number of samples, sample rate) about a provided audio file from the `dust` directory |

### description

The `audio` module allows scriptable control over many aspects of the norns audio graph, including levels, built-in effects, tape, and softcut. It also provides a helper function for audio file inspection which, for example, is very useful for loading samples into softcut.

### example: `file_info`

```lua
-- audio module: file_info example

fileselect = require("fileselect")

selected_file = "none"
selected_file_path = "none"

clip_info = {}
screen_dirty = true

is_playing = false
play_position = 0

function init()
	-- softcut initialization:
	-- enable voice 1
	softcut.enable(1, 1)
	-- set voice 1 to buffer 1
	softcut.buffer(1, 1)
	-- set voice 1 level to 1.0
	softcut.level(1, 1.0)
	-- voice 1 enable loop
	softcut.loop(1, 1)
	-- set voice 1 playback rate to 0 (stopped)
	softcut.rate(1, 0)
	-- voice 1 play state
	softcut.play(1, 1)
	softcut.fade_time(1, 0)

	softcut.phase_quant(1, 1 / 30)
	softcut.event_phase(update_positions)

	screen_redraw_metro = metro.init(function()
		if screen_dirty then
			redraw()
			screen_dirty = false
		end
	end, 1 / 60, -1)
	screen_redraw_metro:start()
end

function update_positions(i, pos)
	play_position = (pos - 1) / (clip_info.sample_length + 1)
	screen_dirty = true
end

function callback(file_path)
	if file_path ~= "cancel" then
		softcut.poll_stop_phase()
		clip_info = {}
		local channels, length, rate = audio.file_info(file_path)
		clip_info.sample_rate = rate
		if clip_info.sample_rate ~= 48000 then
			print("sample rate should be 48khz!")
		end
		clip_info.sample_length = (length / clip_info.sample_rate) * calculate_sr_offset()
		softcut.buffer_clear()
		if ch == 2 then
			for i = 1, 2 do
				-- sum stereo to mono:
				softcut.buffer_read_mono(
					file_path, -- input file
					0, -- source start point
					1, -- destination start point
					clip_info.sample_length, -- duration
					i, -- soundfile channel
					1, -- buffer channel
					i - 1, -- level of existing audio
					0.5 -- level of imported audio
				)
			end
		else
			softcut.buffer_read_mono(file_path, 0, 1, clip_info.sample_length, i, 1)
		end
		softcut.rate(1, 0)
		-- set voice 1 loop start to 1
		softcut.loop_start(1, 1.0)
		-- set voice 1 loop end to the sample's length
		softcut.loop_end(1, clip_info.sample_length + calculate_sr_offset())
		-- set voice 1 position to 1
		softcut.position(1, 1)
		is_playing = false
		play_position = 0
		screen_dirty = true
	end
end

function calculate_sr_offset()
	local sample_rate_compensation
	local base_sr
	base_sr = clip_info.sample_rate
	if (48000 / base_sr) > 1 then
		sample_rate_compensation = ((1200 * math.log(48000 / base_sr, 2)) / -100)
	else
		sample_rate_compensation = ((1200 * math.log(base_sr / 48000, 2)) / 100)
	end
	return math.pow(0.5, -sample_rate_compensation / 12)
end

function redraw()
	if fileselect.done then
		screen.clear()
		screen.level(15)
		screen.move(10, 20)
		screen.line_rel(play_position * 108, 0)
		screen.stroke()
		screen.move(0, 50)
		screen.text("press K2 to select file")
		if clip_info.sample_rate ~= nil then
			screen.move(0, 60)
			if not is_playing then
				screen.text("press K3 to play file")
			else
				screen.text("press K3 to stop file")
			end
		end
		screen.update()
	end
end

function key(n, z)
	if n == 2 and z == 1 then
		fileselect.enter(_path.audio, callback, "audio")
	elseif n == 3 and z == 1 and clip_info.sample_rate ~= nil then
		-- toggle voice 1 play state
		if is_playing then
			softcut.rate(1, 0)
			softcut.poll_stop_phase()
		else
			softcut.rate(1, calculate_sr_offset())
			softcut.poll_start_phase()
		end
		is_playing = not is_playing
		screen_dirty = true
	end
end
```

