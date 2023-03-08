---
layout: default
nav_exclude: true
---

# Seeded vs true random

crow's microcontroller has a true-random-number-generator on board. This is the random source that is hooked up to the `math.random` function and should reliably produce numbers with high entropy.

This is different to most CPUs that generate pseudo-randomness from a seed number (often the current up-time of the system) and then apply a series of transformations for the appearance of randomness. while this approach doesn't generate a truly random sequence, it can be very useful because of the "seed" approach.

crow 4.0 introduces two new functions allowing for this pseudo-randomness generation:

```lua
math.srandomseed(time())
math.srandom() --> random number between 0.0 and 1.0
math.srandom(5) --> random integer between 0 and 5 inclusive
math.srandom(3,10) --> random integer between 3 and 10 inclusive
```

Where this seeded-random option becomes more interesting is by setting the seed (with `math.srandomseed`) with a known number. Re-seeding the pseudo-random generator with the same number will cause `math.srandom` to produce the same sequence of values.

One way this could be used is in a function that randomizes the parameters of your script. Start with a function that writes new values to your variables, and pass it a "seed" value to be applied before randomizing. A very simple script would be something like:

```lua
function init()
	randomize(unique_id()) -- each hardware unit will generate a different sequence!
end

local shapes = {'sine', 'linear', 'exp', 'log'}
function randomize(seed)
	math.srandomseed(seed) -- re-seed the values
	output[1](lfo(math.srandom()+0.1))
	output[2](lfo(1, math.srandom(1,5)))
	output[3](lfo(1/3, 3, shapes[math.srandom(1,4)]))
end
```

This little script will start 3 different LFOs on the first 3 outputs of crow:
* output 1 will have random speed between 0.1 and 1.1Hz
* output 2 will have random amplitude between 1 and 5V (in 1V steps)
* output 3 will have a randomly selected shape

The `init` function will use your crow's unique identifier number to start the LFOs in a way specific to your particular module. this could be a nice thing when sharing a patch with others (though can be hard to test!).

In `druid` you can now create new 'presets' of LFOs by passing different numbers to the `randomize` function. If you just want truly random values, call `randomize(math.random*2^31)` which will re-seed with a random number. but if you're going to this trouble, you might as well save the value you pass in, so you can recall those same settings if they're nice!

```lua
>>> druid
> seed = math.random() * 2^31; randomize(seed)
46384874 --< this is your random number that was generated! 
> seed = math.random() * 2^31; randomize(seed)
7309311 --< another random number which you're now hearing
```
