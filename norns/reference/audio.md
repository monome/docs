---
layout: default
nav_exclude: true
permalink: /norns/reference/audio
---

## audio

Directly set system audio levels. Note that these functions are not coupled to the corresponding entries in PARAMETERS, so changes will not be reflected in the norns menu UI. To simultaneously change these levels *and* the PARAMETERS values, use the `params:set` approach listed in each function's description.

### control: main levels

| Syntax                     | Description                                                                                                                                                  |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| audio.headphone_gain(gain) | Set the headphone gain (expects `0` to `64`) : function<br/>Params version: `params:set("headphone_gain")`, expects `-math.huge` to `6` (in dB)              |
| audio.level_adc(level)     | Set the level for ADC input (expects `0` to `1`) : function<br/>Params version: `params:set("input_level")`, expects `-math.huge` to `6` (in dB)             |
| audio.level_dac(level)     | Set the level for both output channels (expects `0` to `1`) : function<br/>Params version: `params:set("output_level")`, expects `-math.huge` to `6` (in dB) |
| audio.monitor_mono()       | Set monitor mode to mono : function<br/>Params version: `params:set("monitor_mode")`, expects `2` for mono                                                   |
| audio.monitor_stereo()     | Set monitor mode to mono : function<br/>Params version: `params:set("monitor_mode")`, expects `1` for stereo                                                 |
| audio.level_tape(level)    | Set tape output level (expects `0` to `1`) : function<br/>Params version: `params:set("tape_level")`, expects `-math.huge` to `6` (in dB)                    |
| audio.level_cut(level)     | Set softcut output level (expects `0` to `1`) : function<br/>Params version: `params:set("softcut_level")`, expects `-math.huge` to `6` (in dB)              |
| audio.pitch_on()           | Enable input pitch analysis : function                                                                                                                       |
| audio.pitch_off()          | Disable input pitch analysis (saves CPU) : function                                                                                                          |
| audio.restart()            | Restart the audio engine (recompiles sclang) : function                                                                                                      |

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

### Softcut Input Levels

| Syntax                       | Description                                                                                                                                                         |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| audio.level_adc_cut (value)  | Set the send level for the hardware input into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_adc")`, expects `-math.huge` to `18` (in dB) |
| audio.level_eng_cut (value)  | Set the send level for the engine into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_eng")`, expects `-math.huge` to `18` (in dB)         |
| audio.level_tape_cut (value) | Set the send level for the tape into softcut (expects `0` to `1`)<br/>Params version: `params:set("cut_input_tape")`, expects `-math.huge` to `18` (in dB)          |

### callbacks and helpers

| Syntax                          | Description                                                                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| audio.vu (in1, in2, out1, out2) | Script re-definable callback for VU meters (returns `0` to `63`)                                                                |
| audio.set_audio_level(value)    | Set the final output level, which is saved as part of system settings (expects `0` to `64`)                                     |
| audio.adjust_audio_level(delta) | Adjusts the final output level incrementally, which is saved as part of system settings (final level is clamped to `0` to `64`) |
| audio.file_info(path)           | Returns info about a provided audio file from the `dust` directory                                                              |

# 
