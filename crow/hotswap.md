# hotswap

this new library is designed for live-coding style interactions. it builds some simple syntax helpers for the `sequins` and `timeline` libraries so you can modify your composition on the fly. before diving in here, it's highly recommended to have a solid grip on how both of those libraries work!

fundamentally, `hotswap` is just a global table that you can save your sequins & timelines into. using some lua magic (metatables), we're able to *update* a sequins (or timeline) as it's playing, preserving the current state of that object. let's start with a sequins object in a `clock` routine that plays a melody to the outputs:

```lua
function init()
	notes = sequins{0,4,7,11} -- major7th arpeggio
	output[2].action = ar() -- assign a simple AR envelope to output 2

	clock.run(function()
		while true do
			clock.sync(1)
			output[1].volts = notes()/12 -- convert the next sequins value to volts
			output[2]() -- create an AR envelope
		end
	end)
end
```

this script will happily arpeggiate away, on a major 7th chord. but what if we want to change the chord?
```lua
>>> druid
> notes = sequins{0,3,7,10} -- change to minor 7th
```

this will work just fine, however whenever you call the line above the arpeggio will be reset to the root note of the arpeggio. that's ok for exploration, but if you're performing live you'll very likely want to be able to switch on the fly! that's where hotswap comes in.

just place the `notes` variable inside the `hotswap` table:
```lua
hotswap.notes = sequins{0,4,7,11}
```

and now we can update it via druid without missing a beat!
```lua
>>> druid
> hotswap.notes = sequins{0,3,7,10} -- minor 7th!
```
the arpeggio will switch to a minor 7th seemlessly, no matter when you call it!

## timeline

to get to the true power of `hotswap` though, we'll use it for a `timeline` object rather than just a sequins. we'll create the arpeggio as before, but add another `sequins` for creating a more complex rhythm:

```lua
function init()
	output[2].action = ar() -- assign a simple AR envelope to output 2

	hotswap.pattern = timeline.loop{ sequins{3,3,2}, {make_note, sequins{0,4,7,11}}}
end

function make_note(v)
	output[1].volts = v/12 -- assign the next note as a voltage
	output[2]() -- create an AR envelope
end
```

first note the `make_note` function has been pulled out to separate the timing / sequence logic from the note-generation logic. more importantly though, see how the whole timeline has been assigned into the `hotswap` table. we can now apply a sequence of transformations in `druid` to take a tiny composition in new directions:

```lua
>>> druid
-- first we change the rhythm
> hotswap.pattern = timeline.loop{ sequins{3,2,3}, {make_note, sequins{0,4,7,11}}}
-- now switch to half-diminished chord
> hotswap.pattern = timeline.loop{ sequins{3,2,3}, {make_note, sequins{0,3,6,10}}}
-- too much tension! make it minor 7th
> hotswap.pattern = timeline.loop{ sequins{3,2,3}, {make_note, sequins{0,3,7,10}}}
```
as you make these modifications you'll hear the sequence carry on, and your changes gradually introduced.

the above example code gets pretty long in `druid` which we combat in 2 ways. firstly, it's idiomatic to alias the libraries to 1 and 2 letter abbreviations at the top of your script. simply add the following before `init`:
```lua
s = sequins
tl = timeline
hs = hotswap
```

that brings us down to:
```lua
>>> druid
> hs.pattern = tl.loop{ s{3,2,3}, {make_note, s{0,4,7,11}}}
```

but we can also pull out the inner-sequins into their own `hotswap` variables if you just want to manage them individually. here's an updated version of the script which creates `rhythm` and `melody` hotswap variables for seamless modification:

```lua
s = sequins
tl = timeline
hs = hotswap

function init()
	output[2].action = ar() -- assign a simple AR envelope to output 2

	hs.rhythm = s{3,3,2}
	hs.melody = s{0,4,7,11}
	hs.pattern = tl.loop{ hs.rhythm, {make_note, hs.melody}}
end

function make_note(v)
	output[1].volts = v/12 -- assign the next note as a voltage
	output[2]() -- create an AR envelope
end
```

this gives us a tight little API for manipulating our composition on the fly:
```lua
>>> druid
> ^^r -- run our script
> hs.rhythm = s{3, 3.1, 1.9} -- get it swinging~~
> hs.melody = s{0,3,7,10}
> hs.melody = s{0,3,7,10,14} -- add the 9th
> hs.melody = hs.melody:step(2) -- now step through the arp hitting every 2nd note
```

### tech note:

`hotswap` is just calling the `sequins:settable` and `timeline:hotswap` methods. the key is that it stops you from needing to change the syntax of each call when live-coding. you just freely re-assign the objects as if you were creating them for the first time.

when you change the structure of either object, `hotswap` will do it's best to navigate the change -- it will preserve the state of all the previously existing elements. swapping a `sequins` element for a nested `sequins` will work just fine, and applying the flow-modifiers (`:count`, `:every` etc) should too.

this implementation leaves open the possibility of adding this feature to other stateful classes in the future. one thing that may be added is the function-tables of `timeline`, and perhaps `asl` structures (but that's a big maybe).

## closing

`hotswap` doesn't add any dramatic new sonic capability, but it has made my live-coding experience on crow much more satisfying & immediate!
