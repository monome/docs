---
layout: default
nav_exclude: true
---

# timeline
{: .no_toc }

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/903098912?color=ff7700&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

The `timeline` library is all about sequencing events in time. If you find yourself writing out the same clock routines to get a basic rhythm going, there is a better way! `timeline` is built on top of `clock`, so all the usual details for controlling tempo and clock source apply here as well.

The library has 3 flavors, each with its own purpose, though they can be combined in interesting ways too.

* `loop` is for (short) *clock-synchronized* loops in terms of *beat durations*.
* `score` creates longer form sequences of events for *song structure*.
* `real` is free from the clock, calling events over time, and is best for effects and *real-world time*.

All the events can be launched quantized to the clock, and can all be programmatically repeated a number of times.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## `loop`

We'll start with a simple clock pulse, sent every beat on output 1:

```lua
-- timeline version
timeline.loop{1, function() output[1](pulse()) end }
```

When we call any of the three core `timeline` functions, we *always* use curly braces. We're passing a table of elements to the `loop` function: first a time duration, then a function to be called. Think of the time element as a *duration* of beats that the event runs over.

For a more useful example, we'll extend the `loop` table to 2 pairs like so:

```lua
tl = timeline -- alias timeline for shorter code

-- trigger outputs 1 & 2 alternately, every beat
tl.loop{ 1, function() output[1](pulse()) end
       , 1, function() output[2](pulse()) end
       }
```

For clarity, it's idiomatic to predefine your events where possible:

```lua
kick = function() output[1](pulse()) end
snare = function() output[2](pulse()) end

-- now the timeline is a clear description of rhythm & events
tl.loop{ 1, kick
       , 1, snare
       }
```

### A Note on Timing

If you're familiar with [`clock.sync`](/docs/crow/reference/#clock) you might expect the time element above to be a beat-to-synchronize-to, but `timeline` works differently. The timing of a `loop` is in terms of the *beat-durations*. This has quite a different feel, but allows you to write out rhythms more directly.

If this doesn't mean anything to you, then don't worry! `loop` times will act the way you'd expect!

## `score`

Moving beyond a simple loop, we can start to think about longer form structures. For that we'll use `score`, which calls events at a given *timestamp* relative to when the score was started:

```lua
function intro()
  print('the intro!')
end

function verse()
  print('the verse!')
end

function chorus()
  print('the chorus!')
end

function outro()
  print('the outro!')
end

timeline.score{
    0, intro
  , 32, verse
  , 64, chorus
  , 96, outro
}
```

`score` still holds a table of pairs, like `loop`, but the *timing* values have a subtly different meaning. Each pair will be called when its timestamp (in beats) is reached. As a result, you'll typically start with an event at `0`, though this is not strictly necessary.

Above, we call `intro()` immediately, then `verse()` 32 beats after intro, the `chorus()` another 32 beats after that, and finally our `outro()` another 32 beats later.

Note that we *must* write the sequence in time-order -- this makes it far more readable too.

## `real`

...as in "realtime". This is very similar to `score` -- we are still writing *timestamps* relative to when the `real` was started. However, timing is described in *seconds* instead of beats. Tempo changes have no effect here.  

This can be useful for things like strumming notes in a chord:

```lua
-- define what each note_x function should do!
timeline.real{ 0, note_1, 0.1, note_2, 0.25, note_3 }
```

...or triggering events at longer intervals in a live performance as a guide for yourself to indicate the passing of time:

```lua
timeline.real{600, function() print "you've been playing for 10 minutes!" end
			 ,1200, function() print "20mins! time to wrap it up!" end}
```

## Function Tables

Timeline is all about events in time, right? Up to here, those events have just been function calls: either using inline style, or as named functions to keep things tidy. We can also use *function tables* to remove the need for so many tiny functions.

We'll start by modifying the above `timeline.real` example to avoid the inline (aka anonymous) functions:

```lua
timeline.real{600, {print, "you've been playing for 10 minutes!"}
			 ,1200, {print, "20mins! time to wrap it up!"}}
```

A function table goes in the *event* position, where we'd normally put a function. The first element of this table is the function to call, and any following elements are passed to that function as arguments, separated by commas.

Here's a modified strumming example:

```lua
function note(x)
  output[1].volts = x/12
end

timeline.real{ 0, {note,5}, 0.1, {note,3}, 0.25, {note,7} }
```

*technical aside*:
If you're familiar with a lisp language, this is just standard function application. We `apply` the 2nd and higher arguments to the 1st argument. Code is data, huh!

For a more useful example, we'll borrow from the next section on `sequins` and use a new [sequins v2](/docs/crow/sequins2) feature. Here, we trigger notes on Just Friends via `ii`:

```lua
ii.jf.mode(1) -- synthesis mode

timeline.loop{ 1, {ii.jf.play_note, sequins{0,2,4,6,8,10}/12, 2}}
```

There's a lot of information in this line, but the key is that we will call the `ii.jf.play_note()` function with the following 2 arguments: first, a sequins of pitch values (converted to volts with `/12`), then an amplitude value of 2V. read on for more on `sequins`...


## `sequins`-enabled

To enable a more elegant articulation of patterns, `timeline` is fully *sequins-enabled*. The timing values in your time-event table can be provided as `sequins` of values, realizing a different value each time that line is executed.

Here's an example of using `sequins` in a `loop` to play some swung hi-hats on eighth-notes. Just implement the `hats()` function to call whatever triggers a hi-hat sound in your system:

```lua
timeline.loop{ sequins{0.55, 0.45}, hats }
```

...and this example plays a scale of notes on just-friends (via `ii`), once per beat:

```lua
ii.jf.mode(1) -- synthesis mode

function note(n, v) ii.jf.play_note(n/12, v) end -- a helper function to keep things clear

timeline.loop{ 1, {note, sequins{0,2,4,6,8,10}, 2}}
```

These examples all use a single time-event pair, but you're free to use `sequins` in a longer sequence -- perhaps adding a simple rhythm alteration for your new math rock band!

## Pre-Methods

Similar to `sequins`, a `timeline` can have *methods* applied to modify the behavior of the main function (`loop`, `score`, or `real`).

However, `timeline` differs from `sequins` in that it can have methods applied *before* and *after* the main function. In this section, we'll talk about the *pre*-methods, which are about changing when a timeline will begin.

You can chain these modifications together with the `:` character, passing the `timeline` object down through each stage of modification.

As of now, there are only two pre-methods: `queue` and `launch`.

With pre-methods, it's important to remember that the order matters. You'll only use `queue` or `launch` at the *beginning*, and everything else will follow the main function.

### Playback Control Using Pre-Methods {#playback-control}

In our previous examples, you'll notice that a `timeline` runs as soon as it's created. But perhaps you want to prepare a number of `timeline`s ahead of time, and only play them at the right moment?

For that we have the `queue` pre-method. This is a *pre*-method because it affects when the `timeline` will begin:

```lua
snare = function() output[1](pulse()) end

-- create a queued loop and save it into 'mysnare'
mysnare = timeline.queue():loop{2, snare}
-- ^ note that :loop is method-chained with colon
```

The above creates our `loop`-ing `timeline`, but since we use the `queue` pre-method, crow knows not to auto-run it.

To run the `queue`-d `timeline`, we'll use the `play` post-method. This is a *post* method because it affects how the `timeline` runs. We can also save the `timeline` into a named variable so we can interact with it in the future -- this is important if you want to stop the sequence:

```lua
> mysnare:play() -- calls the play() method on your timeline object
```

After some time you may decide a loop has run its course, at which point you can use the `stop` post-method:

```lua
> mysnare:stop()
```

#### Alternate Approach
{: .no_toc }

For an alternative approach to the `queue` pre-method, we can just use standard Lua tables and invoke the `timeline` function at the right time in a performance. This could be useful if you prefer to have all your descriptions in one place. The point is to remember that the time-event pairs table is just a regular old Lua table -- it only becomes fancy when you load it into the timeline function:

```lua
kick = function() output[1](pulse()) end
snare = function() output[2](pulse()) end

my_events = {1, kick, 2, snare} -- just a regular Lua table
```

Invoke this when you want to play the timeline:

```
> timeline.loop(my_events) -- pass the table to the looper
```

### Launch Quantization

Every `timeline` we've used so far has been using the standard *launch quantization* of 1 beat. This means that a `timeline` will always wait until the *next* beat before executing its first element, or before setting the `0` timestamp for a score/real.

If you want to change the default quantization for all timelines you can set the `launch_default` variable in timeline:

```lua
timeline.launch_default = 4 -- switch to every 4th beat, eg. 1 bar in 4/4 time
```

But sometimes you may want a specific timeline to use a custom quantization setting. Perhaps you want your `score` to be quantized to 16, or you want your `real` to start immediately with no delay. For these cases, you can use the `launch` pre-method:

```lua
timeline.launch(16):score{...} -- forces the score to wait until the next multiple of 16 beats

timeline.launch(0):real{...} -- no quantization! begins the first element of real immediately
```

Both `launch` & `queue` can be used together and the order doesn't matter:

```lua
timeline.launch(16):queue():loop{...} -- note the chain of 2 colons
```

If the syntax feels weird to you, it can be helpful to see it more sequentially. The trick is that we are passing a timeline object through the chain sequentially. Here it is written as a sequence of mutations:

```lua
queued_loop = timeline.launch(16)   -- create an empty timeline with custom launch quantization
queued_loop = queued_loop:queue()   -- applies the queue() modifier to our loop
queued_loop = queued_loop:loop{...} -- and finally load in the loop data
```

### Stop & Go

As you can see in [playback control](#playback-control) section above, you save your timeline into a variable, you can always stop it with `:stop()`. Additionally, whenever you call `:play()` the timeline will be restarted at the beginning and will be launch-quantized again.

### Panic!

If you need to stop all the running timelines you can run `timeline.cleanup()` to stop all running timelines. Beware that this will also stop *any* running `clock` routines, even if they weren't started by `timeline`!

## `loop` Post-Methods

**Note: as of now, only `loop` functions can have post-methods applied.**

Post-methods determine how a `loop` runs, or when it will stop.

By default, `loop` will repeat the time-event table endlessly. You can stop the timeline at any moment with the `:stop()` method, but you can also make the looping programmatic with the following post-methods:

### `:unless`

`:unless(predicate)` takes a "predicate" -- a true or false value -- or a function that produces one. Whenever the predicate evaluates as `true`, the timeline will stop! 

If you want a `loop` that only runs once, you can apply `:unless(true)` to the end of the loop. On the other hand, if the predicate is a function, it will allow you to stop the loop based on the result of the function call. This could be used for probabilistic looping:

```lua
timeline.loop{1, kick, 2, snare} -- add white-space before the method chain for readability
	    :unless(function() math.random() > 0.5 end) -- 50% chance of stopping the loop
```

Or perhaps you want to loop until a high-signal is detected at the input:

```lua
timeline.loop{1, kick, 2, snare}
	    :unless(function() input[1].volts > 2.0 end) -- stop if input[1] is high
```

Of course you could call `my_timeline:stop()` from the input event, but this approach requires both events to happen at once, and means the timeline will always complete a full cycle.

### `:times`

This post-method is used instead of `unless` when you want the timeline to be run a specific number of times. Perhaps your `loop` is 4 beats long and you want it to play for 32 beats -- just append `:times(8)` and it will stop automatically.

```lua
timeline.loop{4, random_note}:times(8) -- play 8 random notes, one note every 4 beats
```

Note: adding a `times` post-method will always play the timeline at least once. Passing values to `times` that are less than 1 are effectively the same as 1.

## `score` and `real`: `"reset"` Keyword {#reset-keyword}

Though the `score` and `real` event types don't have any post-methods, they *do* have one special feature: the `"reset"` keyword.

If you have a `score` or `real` that you would like to repeat endlessly, you can set the last event in your table to be the string `"reset"`. This will immediately jump to the beginning of the timeline and start again.

```lua
timeline.score{
    0, intro
  , 32, verse
  , 64, 'reset' -- will jump to beat 0, aka intro (single or double quotes ok)
  }
```

Note that you can *return* the `"reset"` string from a function! This means your last event can be a function that returns "reset", or more interestingly *might* return "reset". This updated score has a 50% chance of repeating every time it completes:

```lua
timeline.score{
    0, intro
  , 32, verse
  , 64, function() return (math.random() > 0.5) and 'reset' end
  }
```

While these examples imply that the "reset" message has to happen at the *end* of the `timeline`, this is not strictly true! Any event can return the "reset" message and jump to the start of the `timeline`. Exploiting this could lead to some very interesting repeating sequences that play different amounts of the whole score.

## Wrapping Up

There are a lot of features here to absorb, but `timeline` is all about making rhythmic ideas more concise. You'll likely need many of `timeline`'s features only occasionally, so try and build up your ideas slowly. And remember that sprinkling a `sequins` or two into your `timeline` is a fantastic way to add variation into your patterns!

### example: automatic music

This script is featured in the banner video above.

Outputs 1 and 2 are assigned LFOs which are [quantized to scales](/docs/crow/reference/#quantize-to-scales), to create arpeggios. Clocked pulses are sent to output 3, which sync to the `pulse_pacing` variable. Using `timeline.score` we change `pulse_pacing`, set output scaling, and change LFO time / maximum / shape.

In the banner video:

- output 1 is sent to Mangrove PITCH
- output 2 is mult'd to Just Friends TIME + Three Sisters FREQ
- output 3 triggers Just Friends envelopes, which reveal Mangrove SQUARE and FORMANT through a Dual Pass Low Pass Gate

```lua
scales = {
	intro = { 10, 12, 19, 0, 3, -5, 17, 15 },
	verse = { 10, 2, 3, 5, 7 },
	chorus = { 10, 14, 3, 5, 7, 2, 12, 10, 0, -5, 17 },
	outro = { 10, 14, 15, 3, 7 },
}

function init()
	pulse_pacing = 1
	pulse_clock = clock.run(function()
		while true do
			clock.sync(pulse_pacing)
			output[3](pulse())
		end
	end)
end

function intro()
	print("the intro!")
	pulse_pacing = 1
	output[1].scale(scales.intro)
	output[2].scale(scales.intro)
	output[1](lfo(5, 2, "sine"))
	output[2](lfo(3, 3, "logarithmic"))
end

function verse()
	print("the verse!")
	pulse_pacing = 1 / 4
	output[1].scale(scales.verse)
	output[2].scale(scales.verse)
	output[1](lfo(13, 3, "sine"))
	output[2](lfo(5, 2, "rebound"))
end

function chorus()
	print("the chorus!")
	pulse_pacing = 1 / 5
	output[1].scale(scales.chorus)
	output[2].scale(scales.chorus)
	output[1](lfo(8, 3, "exponential"))
	output[2](lfo(7, 1, "logarithmic"))
end

function outro()
	print("the outro!")
	pulse_pacing = 1 / 12
	output[1].scale(scales.outro)
	output[2].scale(scales.outro)
	output[1](lfo(7, 3, "rebound"))
	output[2](lfo(10, 2, "exponential"))
end

function the_end()
	print("song done")
	output[1](ar(3, 2, 1))
	output[2].volts = 0
	clock.cancel(pulse_clock)
end

timeline.score({
	0,
	intro,
	64,
	verse,
	128,
	chorus,
	155,
	outro,
	200,
	the_end,
})

```