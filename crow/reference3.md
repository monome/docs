---
layout: default
title: script reference
nav_exclude: true
permalink: /crow/reference3/
---

# TODO

- asl other notes? functions as args revision?
- sequins
- clock
- ii
- public
- DONE calibrate
- globals/crowlib
- full review!


# Reference

[input](#input) --- [output](#output) --- [asl](#asl) --- [sequins](#sequins) --- [metro](#metro) --- [clock](#clock) --- [ii](#ii) --- [public](#public) --- [cal](#cal) --- [crowlib](#crowlib)

## input

`input` is a table representing the 2 inputs

### input queries

```lua
input[n].volts  -- gets the current value on input n
input[n].query  -- send input n's value to the host -> ^^stream(<channel>,<volts>)
```

### input modes

available modes are: `'none'`, `'stream'`, `'change'`, `'window'`, `'scale'`, `'volume'`, `'peak'`

```lua
input[n].mode = 'stream' -- set input n to stream with default time

input[n].mode( 'none' )         -- set input n to 'none' mode

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

input[n].mode( 'volume', time ) -- set input n to stream the volume at the input
    -- 'volume': tracks the RMS amplitude of an audio signal (not a direct voltage)
    -- time:     sets the rate in seconds at which to report the volume

input[n].mode( 'peak', threshold, hysteresis ) -- set input n to:
    -- 'stream':   creates an event when an audio transient is detected at the input
    -- threshold:  sets the RMS level required to trigger an event
    -- hysteresis: sets how far the RMS level needs to decrease before retriggering
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
'stream' -> ^^stream(<channel>,<volts>)
'change' -> ^^change(<channel>,<state>)
```

you can customize the event handlers:

```lua
input[1].stream = function(volts) <your_function> end
input[1].change = function(state) <your_function> end
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

### setting cv

```lua
output[n].volts = 3.0 -- set output n to 3 volts instantly
```

### slewing cv

```lua
output[n].slew  = 0.1 -- sets output n's slew time to 0.1 seconds.
output[n].volts = 2.0 -- tell output n to move toward 2.0 volts, over the slew time

v = output[n].volts   -- set v to the instantaneous voltage of output n
```

### shaping cv

```lua
output[n].shape = 'expo' -- travel to the .volts destination with a non-linear path
output[n].slew  = 0.1
output[n].volts = 2.0
```

Available options:
- 'linear'
- 'sine'
- 'logarithmic'
- 'exponential'
- 'now': go instantly to the destination then wait
- 'wait': wait at the current level, then go to the destination
- 'over': move toward the destination and overshoot, before landing
- 'under': move away from the destination, then smoothly ramp up
- 'rebound': emulate a bouncing ball toward the destination

### quantize to scales

outputs can be quantized with a flexible scale system. these scales are applied *after* slew or actions, so they can be used to eg. convert lfo's into arpeggios.

```lua
output[n].scale( {scale}, temperament, scaling )
  -- scale: a table of note values, eg: {0,2,3,5,7,9,10}
  --        use the empty table {} for chromatic scale
  -- temperament: how many notes in a scale, default 12 (ie 12TET)
  -- scaling: volts per octave, default to 1.0, but use eg. 1.2 for buchla systems

-- deactivate any active scaling with the 'none' argument
output[n].scale( 'none' )
```

### clock

outputs can be set to output divisions of the clock. see [clock](#clock) for details.

```
output[n]:clock(division)     -- set output to clock mode with division
```

to disable the clock, set division to `'none'`.

### actions

outputs can have `actions`, not just voltages and slew times.

```lua
output[n].action = lfo() -- set output n's action to be a default LFO
output[n]()              -- start the LFO

output[n]( lfo() )       -- shortcut to set the action and start immediately
```

available actions are (from `asllib.lua`):

```lua
lfo( time, level, shape )           -- low frequency oscillator
pulse( time, level, polarity )      -- trigger / gate generator
ramp( time, skew, level )           -- triangle LFO with skew between sawtooth or ramp shapes
ar( attack, release, level, shape ) -- attack-release envelope, retriggerable
adsr( attack, decay, sustain, release, shape ) -- ADSR envelope
note( midinumber, duration)         -- set note for duration
oscillate( freq, level, shape)      -- audio rate oscillator
```

actions can take 'directives' to control them. the `adsr` action needs a `false` directive in order to enter the release phase:

```lua
output[1].action = adsr()
output[1]( true )  -- start attack phase and pause at sustain
output[1]( true )  -- re-start attack phase from the current location
output[1]( false ) -- enter release phase
```

you can query whether there is an action currently taking place:
```lua
output[1].running
```

or set an event to be called whenever the action ends:
```lua
output[1].done = function() print 'done!' end
```

### done action

assign a function to be executed when an ASL action is completed

```lua
output[1].done = _()
```

## ASL

actions above are implemented using the `ASL` mini-language.

```lua
-- a basic triangle lfo

function lfo( time, level )
    return loop{ to(  level, time/2 )
               , to( -level, time/2 )
               }
end
```

everything is built on the primitive `to( destination, time )` which takes a destination and time pair, sending the output along a gradient. ASL is just some syntax to tie these short trips into a journey.


```lua
-- an ASL is composed of a sequence of 'to' calls in a table
myjourney = { to(1,1), to(2,2), to(3,3) }

-- often clearer as a vertical sequence
myjourney = { to(1,1)
            , to(2,2)
            , to(3,3)
            }

-- assign to an output and put it in motion
output[1]( myjourney )
```

ASL provides some constructs for doing musical things:

```lua
loop{ <asl> } -- when the sequence is complete, start again
lock{ <asl> } -- ignore all directives until the sequence is complete
held{ <asl> } -- freeze at end of sequence until a false or 'release' directive
times( count, { <asl> } ) -- repeat the sequence `count` times
```

### functions as arguments

ASL can take functions as arguments to get fresh values at runtime. this feature is essential if you want your parameters to update at runtime. this is how we get a new random value each time the output action is called:

`output[n]( to( function() return math.random(5) end, 1 ) )`

in this way you can capture all kinds of runtime behaviour, like a function that fetches the state of input 1:

`function() return input[1].volts end`

to aid this, a few common functions are automatically closured if using curly braces:

```lua
output[n]( to( math.random(5), 1 ) ) -- gives one random, but unchanging value
output[n]( to( math.random{5}, 1 ) )
                          ^^^ a new random value is calculated each time
```

this functionality is provided for:

```lua
math.random
math.min
math.max
```

### asl.runtime

you can use the `asl.runtime()` function to capture a function to be executed at runtime, each time it's called within an ASL action. this means you can do simple calculations like grabbing a random value, or complex operations on a runtime variable.

check out lua/asllib.lua in the crow repo for some examples of how to use it. the `n2v` function is a simple example that divides the value by 12 at runtime.

```lua
--- convert a note number to a voltage at runtime
-- the 'n' argument can be a function that returns a note number when called
-- we wrap the division by twelve in a function to be applied to n at runtime

function n2v(n)
    return asl.runtime( function(a) return a/12 end
                      , n
                      )
end
```

## sequins

```
myseq = sequins{1,2,3,4}
myseq:reset()
myseq:step(n)
myseq:select(n)
myseq:cond(pred)
myseq:condr(pred)
myseq:every(n)
myseq:times(n)
myseq:count(n)
myseq:all()
myseq:once()
myseq:settable(new_table)
myseq()
myseq[n] = _
myseq.n = _
```


## metro

crow has 8 metros that can be used directly:

```lua
-- start a timer that prints a number every second, counting up each time

metro[1].event = function(c) print(c) end
metro[1].time  = 1.0
metro[1]:start()
```

```lua
-- create a metro with the name 'mycounter' which calls 'count_event'

mycounter = metro.init{ event = count_event
                      , time  = 2.0
                      , count = -1 -- nb: -1 is 'forever'
                      }

function count_event(count)
    -- do something fun!
end

mycounter:start() -- begin mycounter
mycounter:stop()  -- stop mycounter
```

```lua
-- update params while the timer is running like so:

mycounter.time = 0.1
metro[1].event = a_different_function
```

## clock

The clock system facilitates various time-based functionality: repeating functions, synchronizing multiple functions, delaying functions.

Basic control:
```lua
clock.start( [beat] )     -- start clock (optional: at [beat])
clock.stop()              -- stop clock
clock.tempo = x           -- assign clock tempo to x
y = clock.tempo           -- get tempo value
z = clock.get_beats       -- get current beat
z = clock.get_beat_sec    -- get current length of beat (in seconds)
```

Transport callbacks:
```
clock.transport.start = start_handler       -- assign a function to be called at clock start
clock.transport.stop = stop_handler         -- assign a function to be called at clock stop
```

Clock coroutines:
```
coro_id = clock.run(func [, args])    -- run function "func", and optional [args] get passed
                                      --   to the function "func"
                                      -- (optionally) save coroutine id as "coro_id"
clock.cancel(coro_id)                 -- cancel (requires coroutine id)
clock.sleep(seconds)                  -- sleep specified time (in seconds)
clock.sync(beats)                     -- sleep until next sync at intervals "beats" (ie, 1/4)
```

Example:
```
function init()
  x = 0
  clock.run(forever)
end

function forever()
  while true do:
    x = x + 1
    clock.sleep(0.1)
  end
end
```


## ii

```lua
ii.help()          -- prints a list of supported ii devices
ii.<device>.help() -- prints available functions for <device>
ii.pullup( state ) -- turns on (true) or off (false) the hardware i2c pullups
ii.raw(addr, bytes, rx_len)
ii.event_raw = raw_handler
```

multiple addresses per device are supported (eg: txi, er301, faders)
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

nb: don't mix and match multiple-address style with regular style!

generally ii arguments corresponding to voltage parameters, including
pitch, are specified in volts, times are specified in seconds, and others
work the same as the teletype op.


## public

```lua
public(name, init_value [, type_limits] [, action])

-- potential method style
pubvar = public{name = init_value}
pubvar:range(min, max)
pubvar:options{...}
pubvar:type(str)
pubvar:action(fn)

-- potential table-style
public{ name    = _
      , default = _
      , range   = _
      , options = _
      , type    = _
      , action  = _
      }

-- actions upon public params
public.name = _
_ = public.name

-- cv i/o viewers
public.view.all( [state] )
public.view.input[n]( [state] )
public.view.output[n]( [state] )

-- remote fns (called by remote host, from library, not userspace)
public.discover()
public.update(name, value [, subkey])
```

## cal

```lua
cal.test()    -- re-runs the CV calibration routine
cal.default() -- returns to default calibration values
cal.print()   -- prints the current calibration scalers for debugging

cal.save()                -- save current calibartion
cal.source(chan)          --
_ = cal.input[n].offset   -- get input offset
_ = cal.input[n].scale    -- get input scale
cal.input[n].offset = _   -- set input offset
cal.input[n].scale = _    -- set input scale
_ = cal.output[n].offset  -- get output offset
_ = cal.output[n].scale   -- get output scale
cal.output[n].offset = _  -- set output offset
cal.output[n].scale = _   -- set output scale
```

## crow

Accessed with `crow` or `_c`:

```lua
-- send a formatted message to host
crow.tell( name, <args> ) -> ^^name(arg1,arg2)

-- deactivate input modes, zero outputs and slews, and free all metros
crow.reset()
```

## globals

TODO: sentence below, revise?

These will likely be deprecated / pulled into `_c` or their respective libs

```lua
get_out( channel ) -- send the current output voltage to host
get_cv( channel )  -- send the current input voltage to host

time() -- returns a count of milliseconds since crow was turned on
cputime() -- prints a count of main loops per dsp block. higher == lower cpu
delay( action, time, repeats ) -- delays execution of action (a function)
                               -- by time (in seconds), repeats times

quotes(str)

justvolts(fraction [, offset])
just12(fraction [, offset])
hztovolts(freq [, reference])
```
