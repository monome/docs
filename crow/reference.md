---
layout: default
title: script reference
nav_order: 7
permalink: /crow/reference/
---

# Reference

[input](#input) --- [output](#output) --- [asl](#asl) --- [sequins](#sequins) --- [metro](#metro) --- [delay](#delay) --- [clock](#clock) --- [ii](#ii) --- [public](#public) --- [cal](#cal) --- [globals](#globals)

## input

`input` is a table representing the 2 CV inputs

### input queries

```lua
_ = input[n].volts  -- returns the current value on input n
input[n].query  -- send input n's value to the host -> ^^stream(channel, volts)
```

### input modes

available modes are: `'none'`, `'stream'`, `'change'`, `'window'`, `'scale'`, `'volume'`, `'peak'`, `'freq'`

```lua
input[n].mode = 'stream' -- set input n to stream with default time

input[n].mode( 'none' )         -- set input n to 'none' mode (ie. disable events)

input[n].mode( 'stream', time ) -- set input n to 'stream' every time seconds

input[n].mode( 'change', threshold, hysteresis, direction ) -- set input n to:
    -- 'change':   create an event each time the threshold is crossed
    -- threshold:  set the voltage around which to change state
    -- hysteresis: avoid noise of this size (in volts)
    -- direction:  'rising', 'falling', or 'both' transitions create events

input[n].mode( 'window', windows, hysteresis ) -- set input n to:
    -- 'window':  create an event when the input enters a new voltage window
    -- windows:   a table of voltages defining window boundaries, eg: {-3,-1,1,3}
    -- threshold: sets the hysteresis voltage at each boundary

input[n].mode( 'scale', notes, temperament, scaling ) -- set input n to:
    -- 'scale':     quantize the input, raising an event when a new note is entered
    -- notes:       a table of notes representing the scale, eg: {0,2,4,5,7,9,11}
    -- temperament: number of possible notes per octave. defaults to 12
    -- scaling:     volts-per-octave. default to 1.0, but use 1.2 for buchla systems
-- 'scale' also supports just intonation ratios in the 'notes' position
    -- notes appears as {1/1, 3/2, 9/8} etc
    -- temperament must be set to 'ji'

input[n].mode( 'volume', time ) -- set input n to stream the volume at the input
    -- 'volume': tracks the RMS amplitude of an audio signal (not a direct voltage)
    -- time:     sets the rate in seconds at which to report the volume

input[n].mode( 'peak', threshold, hysteresis ) -- set input n to:
    -- 'stream':   creates an event when an audio transient is detected at the input
    -- threshold:  sets the RMS level required to trigger an event
    -- hysteresis: sets how far the RMS level needs to decrease before retriggering

-- NOTE: 'freq' mode is only available on input 1.
input[1].mode( 'freq', time ) -- set input 1 to:
    -- 'freq':  calculate the frequency of a connected oscillator.
    -- time:    rate at which frequency is reported.
```

table calling the input will set the mode with named parameters:

```lua
-- set input n to stream every 0.2 seconds
input[n]{ mode = 'stream'
        , time = 0.2
        }
```

the default behaviour is that the modes call a specific event, sending to the host:

```lua
'stream' -> ^^stream(channel, volts)
'change' -> ^^change(channel, state)
```

you can customize the event handlers:

```lua
input[1].stream = function(volts) <your_inline_function> end
input[1].change = change_handler_function
```

using table call syntax, you can set the event handler at the same time:
```lua
-- set input n to stream every 0.2 seconds & print the value
input[n]{ mode   = 'stream'
        , time   = 0.2
        , stream = function(v) print(v) end -- assign the handler inline
        }
```

## output

`output` is a table representing the 4 CV outputs

### setting cv

```lua
output[n].volts = 3.0 -- set output n to 3 volts instantly
```

### slewing cv

```lua
output[n].slew  = 0.1 -- sets output n's slew time to 0.1 seconds.
output[n].volts = 2.0 -- tell output n to move toward 2.0 volts, over the slew time

_ = output[n].volts   -- inspect the instantaneous voltage of output n
```

### shaping cv

```lua
output[n].shape = 'expo' -- travel to the .volts destination with a non-linear path
output[n].slew  = 0.1
output[n].volts = 2.0
```

Available options:
- `'linear'`
- `'sine'`
- `'logarithmic'`
- `'exponential'`
- `'now'`: go instantly to the destination then wait
- `'wait'`: wait at the current level, then go to the destination
- `'over'`: move toward the destination and overshoot, before landing
- `'under'`: move away from the destination, then smoothly ramp up
- `'rebound'`: emulate a bouncing ball toward the destination

### quantize to scales

outputs can be quantized with a flexible scale system. these scales are applied *after* slew or actions, so they can be used to eg. convert lfo's into arpeggios.

```lua
output[n].scale( {scale}, temperament, scaling )
  -- scale: a table of note values, eg: {0,2,3,5,7,9,10}
  --        use the empty table {} for chromatic scale
  -- temperament: how many divisions in an octave, default 12 (ie 12TET)
  -- scaling: volts per octave, default to 1.0, but use eg. 1.2 for buchla systems

-- deactivate any active scaling with the 'none' argument
output[n].scale( 'none' )

-- scale table can be modified without reactivating scale
output[n].scale = {0,7,2,9} -- note: scale can be out of order to create arpeggios

-- 'ji' as the second argument causes the scale to be interpreted as just ratios
output[n].scale( {1/1, 9/8, 5/4, 4/3, 3/2 11/8}, 'ji' )
```

### clock mode

outputs can be set to output pulses at divisions of the clock. see [clock](#clock) for details.

```
output[n]:clock(division) -- set output to clock mode with division
  -- division is in the same units as for clock.sync(division)

output[n]:clock('none') -- disable the output clock

output[n].clock_div = 1/4 -- update the clock division without re-syncing the clock
```

after the clock is assigned, the output `action` can be changed from the default `pulse` to any other shape (see below).

### actions

outputs can have `actions`, not just voltages and slew times. an `action` is a sequence of voltage slopes, like an lfo or envelope.

```lua
output[n].action = lfo() -- set output n's action to be a default LFO
output[n]()              -- call the output table to start the action- starts the LFO

output[n]( lfo() )       -- shortcut to set the action and start immediately
```

a small set of actions are included (from `asllib.lua`):

```lua
lfo( time, level, shape )           -- low frequency oscillator
pulse( time, level, polarity )      -- trigger / gate generator
ramp( time, skew, level )           -- triangle LFO with skew between sawtooth and ramp shapes
ar( attack, release, level, shape ) -- attack-release envelope, retriggerable
adsr( attack, decay, sustain, release, shape ) -- ADSR envelope
oscillate( freq, level, shape)      -- audio rate oscillator
```

actions can take 'directives' to control them. the `adsr` action needs a `false` directive in order to enter the release phase:

```lua
output[1].action = adsr()
output[1]( true )  -- start attack phase and pause at sustain
output[1]( true )  -- re-start attack phase from the current location
output[1]( false ) -- enter release phase
```

### done event

assign a function to be executed when an ASL action is completed

```lua
output[1].done = function() print 'done!' end
```

## ASL

actions above are implemented using the `ASL` mini-language. you can write your own action functions to further customize your scripts.

```lua
-- a basic triangle lfo

function lfo( time, level )
    return loop{ to(  level, time/2 )
               , to( -level, time/2 )
               }
end
```

everything is built on the primitive `to( destination, time, shape )` which takes a destination and time pair (and optional shape), sending the output along a gradient. ASL is just some syntax to tie these short trips into a journey.

```lua
-- an ASL is composed of a sequence of 'to' calls in a table
myjourney = { to(1,1), to(2,2), to(3,3,'log') }

-- often clearer as a vertical sequence
myjourney = { to(1,1)
            , to(2,2)
            , to(3,3,'log')
            }

-- assign to an output and put it in motion
output[1]( myjourney )
```

shape types for the third parameter are [listed above](#shaping-cv).

ASL provides some constructs for doing musical things:

```lua
loop{ <asl> } -- when the sequence is complete, start again
held{ <asl> } -- freeze at end of sequence until a false or 'release' directive
lock{ <asl> } -- ignore all directives until the sequence is complete
times( count, { <asl> } ) -- repeat the sequence `count` times

-- 2 lower-level constructs are also available:
asl._if( pred, { <asl> } ) -- only execute the sequence if `pred` is true
asl._while( pred, { <asl> } ) -- `loop` the sequence so long as `pred` is true
```

See [asllib.lua](https://github.com/monome/crow/blob/main/lua/asllib.lua) to see these constructs in use.

### dynamic variables

ASLs are *descriptions* not programs, meaning variables are fixed when the ASL is created. an ASL can be unfixed by using `dynamic` variables. these named variables can be updated by a script or from the REPL, and will be used by the running ASL.

```lua
-- a standard lfo
output[1].action = loop{ to( 1, 1)
                       , to(-1, 1)
                       }

-- adding dynamic control of lfo height
output[1].action = loop{ to( dyn{height = 1}, 1)
                       , to(-1, 1)
                       }
-- dyn.height will now control the rising destination
output[1].dyn.height = 2 -- rise to 2V

-- arithmetic operations are permitted over dynamics
-- eg: lfo with dynamic speed control
output[1].action = loop{ to( 1, dyn{time=1}/2)
                       , to(-1, dyn{time=1}/2)
                       }
-- if multiple dyn's use the same name (eg. time) they will share state
output[1].dyn.time = 2 -- set the overall LFO time to 2seconds
```

in addition to modifying dynamics from a script, or the REPL, one can attach mutations to a `dyn`. mutations are applied every time the dynamic is used in the script.
```lua
-- ramp lfo, decelerating from 0.1 seconds to infinity
output[1].action =
  loop{ to(5, dyn{time=0.1}:step(0.1)) -- step performs addition / subtraction
      , to(0, 0)
      }
-- the lfo will slow down by 0.1 seconds each time it repeats
output[1].dyn.time = 0.1 -- reset the variable like a normal dyn

-- mutation can be made exponential with 'mul' instead of 'step'
-- ramp lfo, slowing down by 10% on each repeat
output[1].action =
  loop{ to(5, dyn{time=0.1}:mul(1.1)) -- mul performs multiplication
      , to(0, 0)
      }

-- to create looping patterns, one can 'wrap' the values into a range
-- when the ramp reaches 5seconds long, it will reset to 0.1 seconds
output[1].action =
  loop{ to(5, dyn{time=0.1}:step(0.1):wrap(0.1,5))
      , to(0, 0)
      }

-- 'wrap' can be used without 'step' or 'mul' to ensure a dynamic stays in range
output[1].action =
  loop{ to(5, dyn{time=0.1}:wrap(0.1,2))
      , to(0, 0)
      }
output[1].dyn.time = 0.5 -- sets dyn.time to 0.5
output[1].dyn.time = 2.1 -- wraps dyn.time to 0.2


-- reference usage
dyn{k=v}
  :step(inc) -- add 'inc' to the dynamic value on each access
  :mul(factor) -- multiply the dynamic value by 'factor' on each access
  :wrap(min, max) -- wrap the dynamic value into the range from min to max
```

## sequins

sequins are lua tables with associated behaviour. the sequins library is designed for building sequencers and arpeggiators with short scripts.

```lua
seq = sequins{1,2,3} -- create a sequins of 3 values, and save it as seq
_ = seq() --> returns the next value from the sequins
    -- eg. the first 4 seq() calls result in: 1, 2, 3, 1

-- it is idiomatic to alias 'sequins' with the letter 's' when in use
s = sequins

-- any datatype is allowed
fnseq  = s{lfo, ar, pulse}
strseq = s{'+', '-', '*', '/'}
tabseq = s{ {1,2,3}, {4,5,6} } -- the whole table will be returned as the value

-- the 'step' that occurs on each call can be changed from the default of +1
seq = s{1,2,3,4,5}         -- seq() --> 1,2,3,4,5,1,...
seq = s{1,2,3,4,5}:step(2) -- seq() --> 1,3,5,2,4,1,...
    -- note how 'step' is "method chained" onto the sequins

-- while it's typical to apply these method chains at initialization, they can be built up sequentially
seq = s{1,2,3,4,5} -- defaults to step(1)
seq:step(2)        -- modifies seq, changing to step(2)

-- current active index can be set and queried
seq:select(n) -- at the next seq(), index n will be selected & returned
_ = seq.ix    -- value of the index can be queried directly

-- sequins elements can be modified like normal tables
seq[n] = _ -- update the value of table index n
_ = seq[n] -- access the value of the nth element of the sequins

-- to change the whole table (including changing the length of the sequins)
seq:settable(new_table) -- preserves current index

-- sequins can be nested in sequins (good for arranging melodies)
seq = s{1, 2, s{3, 4}}
    -- by default the behaviour will take only one value from the nested sequins at a time
    -- eg: seq() --> 1, 2, 3, 1, 2, 4 ...
```

to enable more complex arrangement, the standard interleaved flow of nested sequins can be modified. modifications are applied as 'method chains' operating over a sequins object.

when calling a sequins object it will *always* return a result. when a flow-modifier *doesn't* return a value (eg every(2) only returns a value every second time), the outer-sequins will simply request the next value immediately until a value is returned.
```lua
-- flow-modifiers that might return a value, or might skip
seq:every(n)   -- produce a value every nth call
seq:times(n)   -- only produce a value the first n times it's called
seq:once()     -- just a shortuct for :times(1)
seq:cond(pred) -- conditionally produces a value if pred() returns true

-- flow-modifiers that will capture focus
-- these are 'greedy' modifiers, keeping the spotlight on them
seq:count(n) -- produce n values in a row without letting other sequins give a value
seq:all()    -- like count(#self), returns all values of seq before returning 

-- modifiers that may return a value, and capture focus
seq:condr(pred) -- conditionally produces a value if pred() returns true, and captures focus

-- with nested sequins, you can restart the arrangement
seq:reset() -- resets all flow-modifiers as well as table indices
```

## metro

crow has 8 metros, each able to run at a it's own timebase and trigger a defined event. metros are best used when you want a fixed action to occur at a regular interval.

```lua
-- start a timer that prints a number every second, counting up each time

metro[1].event = function(c) print(c) end
metro[1].time  = 1.0
metro[1]:start()
```

```lua
-- create a metro with the name 'mycounter' which calls 'count_event'

function count_event(count)
    -- do something fun!
end

mycounter = metro.init{ event = count_event
                      , time  = 2.0
                      , count = -1 -- nb: -1 is 'forever'
                      }

mycounter:start() -- begin mycounter
mycounter:stop()  -- stop mycounter
```

```lua
-- update params while the timer is running like so:

metro[1].event = a_different_function
mycounter.time = 0.1
```

## delay

delay takes a function and executes it in the future. by default it is only executed once, but can optionally be repeated. delay is the most basic of the timing systems, ideally used when simply delaying execution of an action. for more complex time management, use `metro` or `clock`.

NOTE: if using `delay` and `metro` simultaneously, metros must be initialized with `metro.init` and not directly indexed.

```lua
delay( action, time, [repeats] ) -- delays execution of action (a function)
                                 -- by time (in seconds)
                                 -- (optional) repeat the delay action repeats times
```

## clock

the clock system facilitates various time-based functionality: repeating functions, synchronizing multiple functions, delaying functions. `clock` is preferable to `metro` when synchronizing to the global timebase, or for irregular time intervals.

clocks work by running a function in a 'coroutine'. these functions are special because they can call `clock.sleep(seconds)` and `clock.sync(beats)` to pause execution, but are otherwise just normal functions. to run a special clock function, you don't call it like a normal function, but instead pass it to `clock.run` which manages the coroutine for you.
```
coro_id = clock.run(func [, args]) -- run function "func", and optional [args] get passed
                                   --   to the function "func"
                                   -- (optionally) save coroutine id as "coro_id" so it can be cancelled
clock.cancel(coro_id)              -- cancel a clock started by clock.run (requires coro_id)
clock.sleep(seconds)               -- sleep specified time (in seconds)
clock.sync(beats)                  -- sleep until next sync at intervals "beats" (ie, 1/4)
```

clock tempo & timing:
```lua
clock.tempo = t           -- assign clock tempo to t beats-per-minute
_ = clock.tempo           -- get tempo value (BPM)
_ = clock.get_beats       -- get count of beats since the clock started
_ = clock.get_beat_sec    -- get the length of a beat in seconds
```

the clock can be stopped & started, and events can occur when doing either. the clock starts running when crow awakens. note start/stopping the clock does not affect `clock.sleep` calls.
```
clock.start( [beat] )     -- start clock (optional: start counting from 'beat')
clock.stop()              -- stop clock

clock.transport.start = start_handler -- assign a function to be called when the clock starts
clock.transport.stop = stop_handler   -- assign a function to be called when the clock stops
```

example:
```lua
function init()
  x = 0
  clock.run(forever) -- start a clock which will run the forever function
end

function forever()
  while true do -- this will loop forever
    x = x + 1
    clock.sleep(0.1) -- waits for 100ms before the next loop
  end
end
```

## ii

crow has functions for *leading* most available ii devices:
```lua
ii.help()          -- prints a list of supported ii devices
ii.<device>.help() -- prints available functions for <device>
```

when leading the ii bus, you can send commands, or query values:
```lua
-- mydevice is the name of the recipient, eg: 'jf' in ii.jf.play_note()

-- commands
ii.mydevice.command( [args] ) -- 'command' will be changed to eg: play_note

-- queries
ii.mydevice.get('param' [, args]) -- asks device to send back the value of 'param'
-- the get function does not return a value, instead it will raise an event (see below).

-- response to query. triggered by .get('param')
ii.mydevice.event = function(e, value) ... end
  -- e is a table of metadata matching your .get request:
    -- 'name':   the 'param' name. same as the first argument to the .get 
    -- 'arg':    the first argument sent to the .get
    -- 'device': the number of the ii device (usually 1, see below)
  -- value is the actual response to .get
```

```lua
-- example usage
ii.jf.event = function(e, value)
  if e.name == 'ramp' then
    print('ramp is '..value)
  end
end
ii.jf.get 'ramp' -- will trigger the above .event function
ii.jf.tr(1, 1)   -- sets just friends' 1st trigger to the on state
```
generally `ii` arguments corresponding to pitch, are specified in volts (like `input` and `output`), times are specified in seconds (like `.slew` and `ASL`). other parameters use regular numbers.

multiple ii devices of the same type are supported (eg. txi, er301, jf):
```lua
ii.txi[1].get('param',1) -- get the first param of the first device
ii.txi[2].get('param',1) -- get the first param of the second device

ii.txi.event( e, value ) -- 'e' is a table of: { name, device, arg }
    if e.name == 'param' then
        print('txi[' .. e.device .. '][' .. e.arg .. ']=' .. value)
        -- prints: txi[1][1]=1.0
        --         txi[2][1]=3.2
    end
end
```

if you are working with an unsupported ii device, or you are developing a new device that will support `ii`, you can use the `ii.raw` functions:
```lua
-- both set & get commands are sent using ii.raw
ii.raw(addr, bytes [, rx_len])
  -- addr:   i2c address as an int, typically in hex (eg. 0x70)
  -- bytes:  bytestring of the message (eg. '\x09\x00\x00\x20')
  -- rx_len: (optional, default 0) number of response bytes to read

-- capture responses with event_raw
ii.event_raw = function(addr, cmd, data)
  -- NOTE: *all* ii events pass through this function, so you must match on your desired address
  if addr == 0x70 then
    -- handle your custom event here
    return true -- if you don't return true, this event will also be processed by the normal ii system (raising an error)
  end
end
```

crow has weak pullups for the `ii` line. they are on by default & should probably stay on. if you have some reason to turn them off you can do so with:
```lua
ii.pullup( state ) -- turns on (true) or off (false) the hardware i2c pullups. on by default
```

## public

public variables are the automatic method for exposing crow variables to a connected USB host device. public variables are kept synchronized across both devices, and may be modified by either device.
```lua
-- create a public variable 'name' and set it to 'init_value'
public{name = init_value}
    -- equivalent to: public.name = init_value

-- on crow, the variable can be used like a normal variable in a table
public.name = 'jin' -- set public.name to the value 'jin'
_ = public.name     -- get the value of public.name --> 'jin'

-- public variables can be most normal lua types:
public{mynum = 33}
public{mystring = 'hello'}
public{mytable = {1,2,3}} -- 'flat' tables are supported

-- *no functions, coroutines, or nested-tables (ie tables within tables)*

-- sequins are supported, but only the first layer (no nested sequins)
-- this is enough for making a traditional step-sequencer public
public{myseq = s{1,2,3,4}}
public.myseq() -- get the next value from the sequins
    -- remote hosts (eg norns) can support changing the 'playhead'
```

metadata can be attached to public variables, informing a remote device how that value should be modified. it allows support for explicit datatypes, number ranges, options, and actions that are called when a value is remotely updated.
```lua
-- declare a range so a remote host won't allow out-of-bounds values
public{volts = 0}:range(-5, 10) -- limit voltage to crow's hardware range
public.volts = 20 -- 20 will be clamped down to 10

-- types can be 'hinted' by crow, but relies on USB host to implement
-- see documentation for the USB host to see which types are supported
-- below are examples from norns
public{seconds = 1}:range{0.001, 10}:type('exp') -- use exponential scaling
public{count = 0}:type('int') -- force steps to be in integer multiples

-- special types can be used for other data
public{readonly = 'hello'}:type('@') -- @ stops the host changing the value
public{readint = 22}:type('@int') -- @ can be prepended to other types, for eg readonly-integer
public{myslide = 0}:range{-5,10}:type('slider') -- draws myslide with a visual slider

-- options are variables that can be one of a set of possibilities
-- option types are also known as 'enumerated' types
-- list of options must be a list of strings
public{myopt = '+'}:options{'+', '-', '*', '/'}
_ = public.myopt --> returns the string '+'
public.myopt = '*' --> set the value with the string (not an index)
public.myopt = '%' --> IGNORED: the value is not an option, so ignored

-- an action can be triggered when a variable is remotely updated from the host
-- this is very useful when you need to set hardware i/o or timers
public{speed = 1.0}:action( update_speed ) -- call update_speed whenever changed
function update_speed(value) -- value is passed in by the action
  metro[1].time = value
end
```

`public.view` is a special set of public parameters that keep a remote device informed of the state of the input and output jacks. transmission is heavily throttled to reduce USB overhead.
```lua
-- (optional) argument is true/false for on/off. no arg activates view.
public.view.all( [state] )       -- set state of all input & output views
public.view.input[n]( [state] )  -- set state of nth input view
public.view.output[n]( [state] ) -- set state of nth output view
```

when implementing public support on a USB host, these functions enable automated discovery & synchronization of variables.
```lua
-- remote fns to be called by remote host, not a crow userscript
public.discover() -- request a list of all declared public vars
    -- terminated with the key '_end'
public.update(name, value [, subkey])
    -- equivalent to 'public.name = value' but also triggers any 'action'
    -- (optional) 3rd argument allows table updates --> public.name[subkey] = value
```

## cal

crow has hardware to enable self-calibration of the CV inputs & outputs. the calibration procedure is run at the factory, so it's unlikely you'll need to use these features in a script. below are the building blocks for building your own calibration system. the official calibration script is located [here](https://github.com/monome/crow/blob/THREE/util/recalibrate.lua).
```lua
cal.save()       -- save current calibration to flash
cal.source(chan) -- configures output->input multiplexer

_ = cal.input[n].offset   -- get input offset
_ = cal.input[n].scale    -- get input scale
cal.input[n].offset = _   -- set input offset
cal.input[n].scale = _    -- set input scale
_ = cal.output[n].offset  -- get output offset
_ = cal.output[n].scale   -- get output scale
cal.output[n].offset = _  -- set output offset
cal.output[n].scale = _   -- set output scale
```

## globals

```lua
-- deactivate input modes, zero outputs and slews, and free all metros
-- equivalent to restarting crow, but supresses any active userscript
crow.reset()

tell( event, <args> ) -> ^^event(arg1, ...) -- send a formatted message to host
quote(...) -- returns a string-representation of it's arguments
  -- the string is a reconstructed lua chunk, that can be loaded as lua
  -- primarily useful for sending lua tables to a USB host with tell()

time() -- returns a count of milliseconds since crow was turned on

_, _, _ = unique_id() -- returns 3 numbers unique to each crow
  -- the first number is the most unique, and will likely be unique
  -- use all 3 if you need to ensure uniqueness between crows

cputime() -- prints a count of main loops per dsp block. higher == lower cpu

justvolts(fraction [, offset]) -- convert a just ratio to it's volt-per-octave representation
  -- fraction can be a single ratio, or a table of ratios
  -- in case of a table, a new table of voltages is returned
  -- (optional) offset shifts the results by a just ratio (ie transposition)
just12(fraction [, offset]) -- same as justvolts, but output is in '12TET' semitone form

hztovolts(freq [, reference]) -- convert a frequency to a voltage
  -- default reference is middle-C == 0V
  -- (optional) reference is the frequency that will be referenced as 0V
```
