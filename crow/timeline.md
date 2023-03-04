# timeline

`timeline` is all about sequencing events in time. i often noticed that i was writing out the same clock routines to get a basic rhythm going and i knew there was a better way! `timeline` is built on top of `clock`, so all the usual details for controlling tempo and clock-source apply here as well.

the library has 3 flavours each with it's own purpose, though they can be combined in interesting ways too.

* `loop` is for (short) clock synchronized loops in terms of beat-durations.
* `score` creates longer form sequences of events for song structure.
* `real` is free from the clock, calling events over time. best for effects and real world time.

all the events can be launched quantized to the clock, and can all be repeated a programmatic number of times.

## loop

we'll start with a simple clock pulse, sent every beat on output 1:
```lua
-- timeline version
timeline.loop{1, function() output[1](pulse())}
```
when we call the three core `timeline` functions, we always use curly braces. we're passing a table of elements to the `loop` function: first a time duration (as for `clock.sync`), then a function to be called. think of the time element as a *duration* of beats that the event runs over.

for a more useful example we'll extend the loop table to 2 pairs like so:

```lua
tl = timeline -- alias timeline for shorter code

-- trigger outputs 1 & 2 alternately, every beat
tl.loop{ 1, function() output[1](pulse()) end
       , 1, function() output[2](pulse()) end
       }

-- for clarity it's idiomatic to predefine your events where possible
kick = function() output[1](pulse()) end
snare = function() output[2](pulse()) end

-- now the timeline is a clear description of rhythm & events
tl.loop{ 1, kick
       , 1, snare
       }
```

### a note on loop timing

if you're familiar with `clock.sync` you might expect the time element above to be a beat-to-synchronize-to, but `timeline` works differently. the timing of a `loop` is in terms of the beat-durations. this has quite a different feel, but allows writing out rhythms more directly.

if this doesn't mean anything to you, then don't worry! `loop` times will act the way you'd expect.

## score

moving beyond a simple loop we can start to think about longer form structures. for that we'll use `score` which calls events at a given *timestamp* relative to when the score was started:

```lua
timeline.score{
    0, intro
  , 32, verse
  , 64, chorus
  , 128, outro
  }
```
score is still a table of pairs, but the timing values have a subtly different meaning. each pair will be called when its timestamp is reached. as a result, you'll typically start with an event at `0` though this is not strictly necessary.

above, we call `intro()` immediately, then `verse()` 32 beats after intro, and `chorus()` another 32 beats after that.

note that we *must* write the sequence in time-order -- this makes it far more readable too.

## real

as in "realtime". this is very similar to score, however timing is described in seconds instead of beats. tempo changes have no effect here. specifically we are still writing *timestamps* relative to when the `real` was started.

this can be useful for things like strumming notes in a chord:

```lua
timeline.real{ 0, note_1, 0.1, note_2, 0.25, note_3 }
```

or triggering events at longer intervals in a live performance as a guide to yourself of time passing:

```lua
timeline.real{600, function() print "you've been playing for 10 minutes!" end
			 ,1200, function() print "20mins! time to wrap it up!" end}
```

## function tables

timeline is all about events in time right? up to here those events have just been function calls. either inline style, or as named functions to keep things tidy. we can also use *function tables* to remove the need for so many tiny functions.

we'll start by modifying the above `timeline.real` example to avoid the inline (aka anonymous) function:
```lua
timeline.real{600, {print, "you've been playing for 10 minutes!"}
			 ,1200, {print, "20mins! time to wrap it up!"}}
```
a function table goes in the *event* position, where we'd normally put a function. the first element of this table is the function to call, and any following elements are passed to that function as arguments.

*technical aside*:
if you're familiar with a lisp language, this is just standard function application. we `apply` the 2nd and higher arguments to the 1st argument. code is data, huh!

for a more useful example we'll borrow from the next section on `sequins` and use a new sequins-v2 feature. here we trigger notes on Just Friends via `ii`:

```lua
timeline.loop{ 1, {ii.jf.play_note, sequins{0,2,4,6,8,10}/12, 2}}
```
there's a lot of information in this line, but the key is that we will call the `ii.jf.play_note()` function with the following 2 arguments: first a value from the sequins (converted to volts with `/12`, then the amplitude of 2V. read on for more on sequins...


## sequins enabled

to enable more elegant articulation of patterns, `timeline` is fully *sequins-enabled*. the timing values in your time-event table can be provided as `sequins` of values. when using *function tables* the arguments can also be `sequins` of values, realizing a different value each time that line is executed.

here's an example of using `sequins` in a `loop` to play some swung hi-hats on eighth-notes. just implement the `hats()` function to call whatever triggers a hihat sound in your system:

```lua
timeline.loop{ sequins{0.55, 0.45}, hats }
```

and this example plays a scale of notes on just-friends (via `ii`), once per beat:

```lua
function note(n, v) ii.jf.play_note(n/12, v) end -- a helper function to keep things clear

timeline.loop{ 1, {note, sequins{0,2,4,6,8,10}, 2}}
```

these examples all use a single time-event pair, but you're free to use `sequins` in a longer sequence, perhaps adding a simple rhythm alteration for your new math rock band!

## pre & post methods for all

similar to `sequins`, timelines can have methods applied to modify their behaviour. you chain these modifications together with the `:` character, passing the object down through each stage.

timelines are different from sequins because they have *methods* applied before and after. there's only 2 pre-methods right now, but it's important to remember that the order matters. you'll only use `queue` or `launch` at the beginning, and everything else will follow the main timeline function (loop, score, or real).

pre-methods are about changing when a timeline will begin, whereas post-methods are about how they run, or when they will stop.

### playback control

when any timeline is created it runs immediately! sometimes you'll want to prepare a number of them ahead of time, and only play them at the right moment. for that we have the `queue` and `play` methods. note here that we save the timeline into a named variable so we can interact with it in the future -- this is important if you want to stop an endless sequence too:
```lua
-- create a queued loop and save it into mysnare
mysnare = timeline.queue():loop{2, snare} -- note that :loop is method-chained with colon

-- now it's time to play the loop!
mysnare:play() -- call the play() method on your timeline object

-- after some time you may decide a loop has run its course, at which point you can stop:
mysnare:stop()
```

for an alternative approach we can just use standard lua tables and invoke the timeline function at the right time. this could be useful if you prefer to have all your descriptions in one place. the point is to remember that the time-event pairs table is just a regular old lua table -- it only becomes fancy when you load it into the timeline function.

```lua
my_events = {1, kick, 2, snare} -- just a regular lua table

-- invoke this when you want to play the timeline!
timeline.loop(my_events) -- pass the table to the looper
```

### stop & go

if you save your timeline into a variable, you can always stop it with `:stop()`. additionally, whenever you call `:play()` the timeline will be restarted at the beginning (and will be launch quantized again).

### launch quantization

every timeline we've used so far has been using the standard *launch quantization* of 1 beat. this means that a timeline will always wait until the next beat before executing it's first element, or setting the `0` timestamp for a score/real.

if you want to change the default quantization for all timelines you can set the `launch_default` variable in timeline:

```lua
timeline.launch_default = 4 -- switch to every 4th beat, ie 1bar in 4/4 time
```

but sometimes you may want a specific timeline to use a custom quantization setting. perhaps you want your `score` to be quantized to 16, or you want your `real` to start immediately with no delay. for that you can use the `launch` pre-method:

```lua
timeline.launch(16):score{...} -- forces the score to wait until the next multiple of 16 beats

timeline.launch(0):real{...} -- no quantization! begins the first element of real immediately
```

both `launch` & `queue` can be used together and the order doesn't matter:
```lua
timeline.launch(16):queue():loop{...} -- note the chain of 2 colons
```

if the syntax feels weird to you, it can be helpful to see it more sequentially. the trick is that we are passing a timeline object through the chain sequentially. here it is written as a sequence of mutations:
```lua
queued_loop = timeline.launch(16)   -- create an empty timeline with custom launch quantization
queued_loop = queued_loop:queue()   -- applies the queue() modifier to our loop
queued_loop = queued_loop:loop{...} -- and finally load in the loop data
```

### panic!
if you need to stop all the running timelines you can run `timeline.cleanup()` to stop all running timelines. beware that this will also stop any running `clock` routines even if they weren't started by `timeline`!

## special features: loop

by default `loop` will repeat the time-event table endlessly. you can stop the timeline at any moment with the `:stop()` method, but you can also make the looping programmatic with the following post-methods:

### unless

`:unless(predicate)` takes a "predicate" -- a true or false value -- or a function that produces one. whenever the predicate evaluates as `true`, the timeline will stop! if you want a `loop` that only runs once, you can apply `:unless(true)` to the end of the loop.

instead, if the predicate is a function, it will allow you to stop the loop based on the result of the function call. this could be used for probabilistic looping:

```lua
timeline.loop{1, kick, 2, snare} -- add white-space before the method chain for readability
	    :unless(function() math.random() > 0.5 end) -- 50% chance of stopping the loop
```

or perhaps you want to loop until a high-signal is detected at the input:

```lua
timeline.loop{1, kick, 2, snare}
	    :unless(function() input[1].volts > 2.0 end) -- stop if input[1] is high
```

of course you could call `my_timeline:stop()` from the input event, but this approach requires both events to happen at once, and means the timeline will always complete a full cycle.

### times

this post-method is used instead of `unless` when you want the timeline to be run a specific number of times. perhaps your `loop` is 4 beats long and you want it to play for 32 beats -- just append `:times(8)` and it will stop automatically.

```lua
timeline.loop{4, random_note}:times(8) -- play 8 random notes, one note every 4 beats
```

note: `times` will always play at least once. values less than 1 are effectively the same as 1.

## special features: score & real

`score` and `real` don't have any post-methods, but they do have one special feature:

### 'reset' keyword

if you have a `score` or `real` that you would like to repeat endlessly, you can set the last event in your table to be the string `"reset"`. this will immediately jump to the beginning of the timeline and start again.

```lua
timeline.score{
    0, intro
  , 32, verse
  , 64, 'reset' -- will jump to beat 0, aka intro
  }
```

note that you can *return* the `"reset"` string from a function! this means your last event can be a function that returns "reset", or more interestingly *might* return "reset". this updated score has a 50% chance of repeating every time it completes:

```lua
timeline.score{
    0, intro
  , 32, verse
  , 64, function() return (math.random() > 0.5) and 'reset' end
  }
```

above it was stated that the "reset" message has to happen at the *end* of the timeline. this is not strictly true! any event can return the "reset" message and jump to the start of the timeline. exploiting this could lead to some very interesting repeating sequences that play different amounts of the whole score...

## wrapping up

there's a lot of features here, but timeline is all about making rhythmic ideas concise. you'll likely need the extra features only occasionally, so try and build up ideas slowly. adding a sequins or two into your timeline is a fantastic way to add variation into your patterns!
