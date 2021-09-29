---
layout: default
nav_exclude: true
permalink: /norns/firstlight-further/delay-feedback
---

## planning

Prompt: *make K2 set delay feedback (`softcut.pre_level(1,x)`) to a random value between `0.2` and `0.99`*

Questions to consider:

- where in the code does the K2 interaction happen?
- how do we generate random values between two floats and return it to softcut voice 1 via `softcut.pre_level(1,x)`?

## finding K2

In [clock by hand](https://monome.org/docs/norns/study-0/#clock-by-hand), we modified the functionality of K2:

```lua
-- key
function key(n,z)
  if n==3 and z==1 then
    -- K3, on key down toggle chimes true/false
    chimes = not chimes
  elseif n==2 and z==1 then -- key 2's interaction!
    --[[ 0_0 ]]--
	sequence = not sequence
  end
end
```

Let's comment-out `sequence = not sequence` and add our modification below!


## making random values (less than 1)


In [even strum](https:monome.org/docs/norns/study-0/#even-strum), we discussed how `math.random` generates different ranges of random values depending on how many arguments are supplied to it.

```lua
>> math.random() -- generates random floats between 0 and 1
>> math.random(10) -- generates random integers between 1 and 10
>> math.random(33,56) -- generates random integers between 33 and 56
```

However, our prompt calls for a random float between `0.2` and `0.99`. But if we try to execute `math.random(0.2,0.99)`, we get the following error:

```bash
lua: 
stdin:1: bad argument #1 to 'random' (number has no integer representation)
stack traceback:
	[C]: in function 'math.random'
	stdin:1: in main chunk
```

So, we can't pass floats to `math.random` -- we *need* to work with integers. What do you think we should do?

Hint: `0.2` and `0.99` are equivalent to `20/100` and `99/100`...

## putting it together

```lua
-- key
function key(n,z)
  if n==3 and z==1 then
    -- K3, on key down toggle chimes true/false
    chimes = not chimes
  elseif n==2 and z==1 then -- key 2's interaction!
    --[[ 0_0 ]]--
    -- sequence = not sequence
    softcut.pre_level(1, math.random(20,99)/100)
  end
end
```