# sequins v2

the sequins library is designed for building sequencers, arpeggiators and all sorts of other pattern systems. this new version adds to the original with `transformers` for simple pattern synthesis, and also streamlines some syntax for character-patterns.

## a quick refresher

## sequins strings

this feature is inspired by [foxdot](https://foxdot.org)'s sample patterns as i first saw in a [Flash Crash performance by mgs](https://youtu.be/A0ryZjW90Bo?t=258). here we take just the core idea of a string encoding different events with different characters.

for sequins this just leads to a simple syntax shortcut where you replace the normal table-of-values with a string. each character of the string becomes an element of the sequins:

```lua
char_sequence = sequins "+ - + . "
char_sequence() --> '+'
char_sequence() --> ' '
char_sequence() --> '-'
                -- etc.
```

when using these sequins strings, you'll need to build a function that takes a character & does something special with it. using spaces is a great way to clearly leave space in a pattern:

```lua
function make_sound(char)
  if     char == '+' then output[1](pulse())
  elseif char == '-' then output[2](ar())
  elseif char == '~' then output[1](lfo())
  elseif char == '.' then output[1].volts = 0
  end -- note that spaces are ignored!
end

char_sequence = sequins "+ -~ ."
make_sound(char_sequence()) -- + -> pulses output 1
make_sound(char_sequence()) -- space -> does nothing
make_sound(char_sequence()) -- - -> creates envelope on output 2
make_sound(char_sequence()) -- ~ -> starts an lfo on output 1
make_sound(char_sequence()) -- . -> sets output 1 to 0V, thus stopping the lfo
```

of course the typical flow modifiers are still available so you can manipulate your pattern in interesting ways:

```lua
-- the following 2 lines are the same! this is special lua function-call syntax.
chs = sequins"A  a!"
chs = sequins("A  a!")

-- calling chs() repeatedly produces the sequence:
--  'A', ' ', ' ', 'a', '!', 'A', etc

-- use the :step method to step forward two elements at a time:
chs = sequins"A  a!":step(2)
chs() --> 'A', ' ', '!', ' ', 'a', 'A', etc
```

sequins offers other methods for flow-modification but only when multiple patterns are nested. while this is absolutely possible with the sequins-strings, you'll lose the primary benefit of having one character space equal to one event. instead this feature is great for multiple parallel sequins that interleave elements, or phase against each other in polyrhythms like in this example:

```lua
-- two sequins with length 7 and 8.
seq_a = sequins"+  +  +0"
seq_b = sequins"R +   ."

-- add your own make_sound to handle the above characters!

-- execute both sequences at once, every beat
-- the 2 sequences will phase against one another
clock.run(function()
  while true do
  	clock.sync(1)
  	make_sound(seq_a())
  	make_sound(seq_b())
  end
end)
```


# sequins transformers

onto the new new!
while sequins has always been about taking a pattern and manipulating how you move through it, transformers are all about changing the data inside of it. this can help with clarity by allowing you to write your data in one form, but then manipulate it into a different form for some other use (eg. notes -> volts). or it can be used for more drastic manipulation of the data itself.

transformers are applied with the new `:map` method chained onto your sequins. whenever your sequins is called, the value produced is transformed by the `map` function before being returned.

## utilitarian usage

we'll start with some simple arithmetic operations. one very common usage is to convert 12TET note values (ala {0,4,7} for a major triad) into their voltage equivalents. here we convert note-numbers into voltages for use with `ii`:

```lua
my_seq = sequins{0,3,0,2,7}:map(function(n) return n/12 end)

-- now we can just use the sequins directly
ii.jf.play_note(my_seq(), 2)
```

in this case it might seem just as easy to apply the division when creating the note on just friends, but the benefit here is that we can now think about `my_seq` as being a sequins of *voltages*, rather than notes.

in a similar way, we might want to express our sequins as just-intonation ratios. here we can change `my_seq` without having to touch the code that plays the notes:

```lua
my_seq = sequins{1/1, 3/2, 8/5, 4/3}:map(justvolts)

-- note how this next line is identical to above
-- thus we can freely change the note data without modifying our playback code
ii.jf.play_note(my_seq(), 2)
```

## arithmetic operators

when you want to apply a single arithmetic operation to your sequence (like our notes->volts conversion) you can use the operator shortcut syntax. It might look a little weird, but just remember the math operation is applying via the `:map` method:

```lua
my_seq = sequins{0,3,0,2,7}/12 -- divide-by-12 will be applied as the transformer

ii.jf.play_note(my_seq(), 2)
```

this syntax is also useful if you want to apply a simple transposition:
```lua
my_seq = sequins{0,3,0,2,7}+2 -- shift up by 2 semi-tones

ii.jf.play_note(my_seq()/12, 2) -- note we had to put the /12 down here though...
```

using the new `hotswap` library will let you change this more rapidly (see hotswap).

available operations are `+`, `-`, `*`, `/` and `%`.

## pattern manipulation

now we can get into more involved transformations. the `:map` function is just a regular lua function with one argument (the value to be transformed), so the whole lua language is available to you. here we inject some randomness to probabilistically add an octave to the notes:

```lua
my_seq = sequins{0,3,0,2,7}:map(function(n) return n + (math.random() > 0.5) and 12 or 0 end)

-- you might want to break your transformers out into their own function
function maybe_octave(n)
	if math.random() > 0.5 then
		return n + 12
	else return n end
end
my_seq = sequins{0,3,0,2,7}:map(maybe_octave) -- this can clarify your intent
```

you could also use conditionals to change values based on some external signal:

```lua
function major_minor(n)
	if input[1].volts > 2 then -- switch to minor tonality if input 1 above 2V
		if     n == 4  then return 3
		elseif n == 11 then return 10
		end
	else return n end -- otherwise leave untouched
end
my_seq = sequins{0,4,7,11,14}:map(major_minor)
```

we can also use external storage to do some statistical analysis of a sequins. this example returns the median of the last 3 values which might be... useful?

```lua
local previous = {0,0,0} -- store the last 3 values
function median(n)
	table.remove(previous, 3) -- remove the last element
	table.insert(previous, n) -- add the new element

	-- copy the table so we can sort it
	local t = {}
	for i=1,3 do t[i] = previous[i] end
	table.sort(t) -- sort the table

	-- return the middle element which will be the median
	return t[2]
end
my_seq = sequins{0,10,4,3,7,11,3,4,14}:map(median)
```

## sequins as operators

extending the arithmetic-operators from above we can create some very interesting combinations by using a second sequins on the right-hand-side of the operation:

```lua
my_seq = sequins{0,7,2,9,4} + sequins{0,0,-12,12}
my_seq() --> this would be a nice long pattern jumping up and down octaves

-- the 2nd sequins above is *inside* the first's :map
-- the equivalent non-operator version is:
my_seq = sequins{0,7,2,9,4}
			:map(function(n, sq) -- we can pass additional args!
			        return n + sq()
			    end, sequins{0,0,-12,12})
```

you may be tempted to chain multiple sequins together with `+`, but remember the arithmetic operators only work in isolation. if you want to delve more deeply into this, you'll need to write the full `:map` method as shown immediately above.

## cancelling a transformer

at some point you may want to remove the current transformer. to do so, you can simply call `:map` with no argument to unset the transformer:
```lua
my_seq = sequins{0,3,0,2,7}:map(function(n) return n + (math.random() > 0.5) and 12 or 0 end)
my_seq() --> provides some fun octave switching

my_seq:map() -- remove the map transformer
my_seq() --> provides the original sequence again
```

## piecemeal transformation

sequins transformers are designed to be used to gradually build up ideas over time. by incrementally modifying the sequins data, flow-modifiers, and map-transformer, you'll hopefully get to some new place that you'd like to capture in its own right. this is where the `:bake` method comes in.

there are 3 ways to copy a sequins, each with different meaning:

the first option is to simply copy around the *name* of the sequins (eg. `seq` in `seq = sequins{1,2,3}`). this doesn't actually *copy* anything, but just passes around a reference to the sequins object. wherever you call the name, the sequins will advance a step forward and return a new value. this lets you define a sequins in one place, and use it in another.

next we can `:copy` our entire sequins:
```lua
my_seq = sequins{1,4,9,16,25}
my_copy = my_seq:copy()

my_seq() --> 1
my_seq() --> 4
my_copy() --> 1
my_copy() --> 4
```
here we can see that the original and copy have their own indices that are independent of each other. this could be useful if you want to use the same melody played by two instruments with different rhythm or tempo.

when using `:copy`, *everything* is copied into the new variable. this includes flow-modifiers (eg `:every`), and transformers. this is useful if you have found a nice configuration that you want to keep around. make a `copy` and set it to the side, then keep working on your original. similar to "Save a Copy" feature in many PC applications.

### baking

at some point you'll likely find a sequins that you love, but perhaps it's already using a transformer and you want to add another (it can get very convoluted if the transformer becomes big!). or maybe the sequins sounds great for a little while, but becomes weird or loses a sense of rhythm after some time. this is where you can `bake` your sequins.

baking a sequins captures the output data for a defined number of steps, and places it into a new sequins.

```lua
patt = s{0,7,2,9,4} + s{0,12}
patt() --> creates a nice sequence of notes, looping every 10 elements

cake = patt:bake(32) -- capture the first 32 elements of patt
cake() --> same as patt() but loops after 32 elements
```

now `cake` above can be used just like `patt` but because it's been baked, it will loop after 32 steps. this will truncate the 4th repetition of the note sequence which might be just the amount of poly-rhythm you're looking for.

you can now add a new transformer to `cake` to further take it in a new direction!

# other new goodies

along with the sequins-strings and map-transformers, v2 also has some nice quality-of-life improvements to make working with sequins a little easier:

## visualizing

previously calling `print(my_sequins)` would return something like `table 0x38746373`. we've updated this behaviour so that `print`ing a sequins will give you information about both the values, and the index state(s) of the sequins:

```lua
s1 = sequins{1,2,sequins{3,4}}
for i=1,5 do s1() end -- step forward 5 steps

print(s1) --> s[2]{1,2,s[2]{3,4}}
```

we can breakdown this printout into the following elements:
* `s`: this is a sequins
* `[2]`: we're at index 2
* `{1,2,...}` these are the values in the sequins
* `s[2]{3,4}` the state of the nested sequins

when you get deeply nested this can be a little hard to read, but it should bear a close resemblance to your original sequins for reference.

if you have flow modifers or transformers applied, they will be shown as `:e` where `e` is the first letter of the transformer (here `:every`), or `:map()` for a transformer.

## length

if you call the `#` (length) operator on a sequins, it will now return the number of elements at the top-layer of the sequins. if you have nested sequins, each nest will count as 1 element:
```lua
s1 = sequins{1,2,3}
print(#s1) --> 3

s2 = sequins{1,2,sequins{3,4}} -- nested sequins only counts for length 1
print(#s2) --> 3
```

## peek

if you're using a sequins in multiple places but only want it to be advanced in one location, you can use the `:peek` method (thanks to @tyleretters). this is especially useful if you want to find the current value to print on screen (eg. on norns):

```lua
s1 = sequins{1,2,3,4}
s1() --> 1
s1() --> 2

s1:peek() --> 2
```
