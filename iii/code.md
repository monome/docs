---
layout: default
title: iii code
permalink: /iii/code
nav_exclude: true
---

# iii code

## device: grid

| function | description |
| --- | --- |
| `event_grid(x,y,z)` | callback function for grid key |
| `grid_led(x,y,z)` | set coordinates _x_,_y_ to value _z_ |
| `grid_led_rel(x,y,z,zmin,zmax)` |
add value _z_ to existing value for coordinates _x_,_y_ with optional range _zmin_ and _zmax_ |
| `grid_led_get(x,y)` | returns value at coordinates _x_,_y_ |
| `grid_led_all(z)` | set all values to _z_ |
| `grid_intensity(b)` | set global intensity to brightness _b_, triggers refresh |
| `grid_refresh()` | refresh LED values |
| `grid_size_x()` | returns x size |
| `grid_size_y()` | returns y size |

## device: arc

`event_arc(n,d)`  
callback function for arc knob ring _n_ delta _d_

`event_arc_key(n,d)`  
callback function for arc knob ring _n_ delta _d_

`arc_res(n,div)`  
set knob resolution for ring _n_ to _div_ (default 1, use higher values for less resolution)

`arc_led(n,x,z)`  
set ring _n_ segment _x_ to value _z_

`arc_led_rel(n,x,z,zmin,zmax)`  
add value _z_ to existing value for ring _n_ segment _x_ with optional range _zmin_ and _zmax_

`arc_led_ring(n,z)`  
set all values of ring _r_ to _z_

`arc_led_all(z)`  
set all values to _z_

`arc_intensity(b)`  
set global intensity to brightness _b_, triggers refresh

`arc_refresh()`  
refresh LED values

## lib

These functions are included on all iii devices. Most of these functions are defined in the file _lib.lua_ which is stored in the onboard filesystem.

_lib.lua_ can be modified, though we recommend staying close to the original for compatibility. If you need to return your lib file to its default state, use `rm(lib.lua)` and it will be rebuilt on next boot.

### midi

USB MIDI device functions

`event_midi(byte1, byte2, byte3)`  
callback function for incoming USB MIDI

`midi_to_msg(data)`  
returns decoded midi byte array _data_ as a labeled table

`midi_out(table)`  
table can be data bytes or msg, sent to USB MIDI port

`midi_note_on(note, vel, ch)`  
shortcut function for sending note on

`midi_note_off(note, vel, ch)`  
shortcut function for sending note off

`midi_cc(cc, val, ch)`  
shortcut function for sending cc

### metro

Repeating timers which executes a callback function.

Note these are hardware driven, limited to 15 total. You can of course use one fast timer to creatively manage sub-timers if you need more.

`m = metro.init(callback, time_sec, count_optional)`  
initialize a metro _m_, with callback function, time in seconds, (optional) count before stop

`m:start()`  
start metro

`m:stop()`  
stop metro

### slew

Stepped interpolation between values over specified time interval. No hard limit to how many slews can be created, though memory or cpu time will eventually cause problems with high numbers of simaltaneous slews.


`id = slew.new(callback, start_val, end_val, time_sec, q)`  
create a new slew with callback function, from _start_val_ to _end_val_ over interval _time_sec_, with callbacks on quantum _q_ (default 1). returns _id_ which is used to further manage the slew.

`slew.to(id, end_val, time_optional)`  
interrupt running slew, set new destination from current position, new time interval optional

`slew.freeze(id)`  
freezes slew, can be resumed with _slew.to_

`slew.allfreeze()`  
freezes all slews

`slew.stop(id)`  
stops and removes a slew

`slew.allstop()`  
stop and remove all slews

### pset

`pset_init(name)`  
assign _name_ to pset files to be written and read

`pset_write(index, table)`  
writes pset number _index_ with data _table_

`table = pset_read(index)`  
read pset number _index_ into _table_

### utils

`dostring(lua_command)`  
send text to lua interpretter, execute command

`get_time()`  
returns time in seconds with usec precision

`ps(formatted_string,...)`  
print a formatted string, like printf

`pt(table)`  
print table

`clamp(n,min,max)`  
returns _n_ clamped between _min_ and _max_

`round(n,quant)`  
returns _n_ rounded to nearest _quant_ (default 1)

`linlin(n,slo,shi,dlo,dhi)`  
returns _n_ transposed from range (_slo_,_shi_) to range (_dlo_,_dhi_)

`wrap(n,min,max)`  
returns _n_ wrapped within range (_min_,_max_)

### system

`device_id()`  
returns device name

`first(file)`  
set _file_ to be run at startup, omit _file_ to remove current startup

`ls()`  
list files

`cat(file)`  
display _file_

`rm(file)`  
remove _file_

`mem()`  
display current memory availability

`gc()`  
garbage collector (see lua docs)

`require(file)`  
run _file_


