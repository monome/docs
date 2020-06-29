---
layout: default
nav_exclude: true
permalink: /norns/study-3/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/276054881?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# spacetime

norns studies part 3: functions, parameters, time

## we function together

so far we've seen a few ways to run commands:

- the command line, for single lines
- the `init` function which is run at startup of a script
- `enc` and `key` functions which are executed when you touch an encoder or key

i just said _function_ a few times, and you may have seen in study 1 we didn't explain the first word of `function init()`. a function is a block of code that can be _called_ and conditionally accept and return parameters. simplest example:

```lua
function greeting()
  print("hello there!")
end
```

in the command line you can type `greeting()` and this function will run, printing `hello there!`. but this is a silly example. functions are useful when you have some code you need to run frequently or perhaps from different places. they are very good for organizing and making your scripts readable and reusable. a better example:

```lua
function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end
```

it's just a bunch of math that you likely don't want to remember. but we introduce a couple of things:

- we pass an _argument_ to the function, which is the variable `note`
- we make a local variable called `hz`, do some math with `note` for the conversion
- we return `hz`

let's use it:

```lua
drone = midi_to_hz(30)
```

here's what happens:

- `midi_to_hz` is called with a value of 30, which is assigned to `note`
- the function runs and returns a value which is assigned to `drone`

## zoom out

but where do you put the function definition? check this out:

```lua
-- spacetime
-- norns study 3

engine.name = "PolyPerc"

function init()
  engine.amp(0.5)
end

function key(n,z)
  local whatever = 30 + math.random(24)*2
  engine.hz(midi_to_hz(whatever))
end

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end
```

we simply put our function at the bottom. when you execute the script, the entire file is processed. so even though the `key` function comes earlier and references `midi_to_hz()`, everything is fine because now the whole global scope knows about `midi_to_hz`.

you'll also see that we did a little shortcut with function calling. you can nest them:

```lua
drone = midi_to_hz(60)
engine.hz(drone)
```

is the same as:

```lua
engine.hz(midi_to_hz(60))
```

## many to many

functions can have many arguments:

```lua
function stack_notes(root, interval, number)
  local note = root
  for i=1,number do
    engine.hz(midi_to_hz(note))
    note = note + interval
  end
end
```

this function takes three arguments: a `root` note, a note `interval`, and a `number` of notes. using a loop it plays a stack of notes. try this:

```lua
stack_notes(40,7,6)
```

it'll play these 6 midi notes, which start at 40 and increment by 7 each time: `40 47 54 61 68 75`. but what if we leave off an argument, ie `stack_notes(40,7)`? you'll get an error when the function tries to use `nil` as `number` in the loop. in functions we can define a default value like this:

```lua
function stack_notes(root, interval, number)
  number = number or 4
  interval = interval or 7
  note = root or 50
  ...
```

now you can even call `stack_notes()` and you'll get something much more pleasant than an error. the `number = number or 4` trick is the same as `if number == nil then number = 4 end`.

functions can also return many values:

```lua
function whereami()
  local a = math.random(128)
  local b = math.random(64)
  return a,b
end
```

and the get the values:

```lua
x,y = whereami()
x,y,z = whereami()
x = whereami()
```

in the second line `z` will be nil. in the third line the second returned value is thrown away.

try this:

```lua
function redraw()
  screen.clear()
  screen.level(15)
  screen.move(whereami())
  screen.text("here!")
  screen.update()
end
```

then enter/exit menu mode.

## tangle and detangle

lua lets us easily make functions that point at other functions. observe:

```lua
function happy()
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(64))
  engine.hz(midi_to_hz(67))
end

function sad()
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(63))
  engine.hz(midi_to_hz(67))
end

function key(n,z)
  if z == 1 then
    go = happy
  else
    go = sad
  end
  go()
end
```

the trick happens in the `key` function. see how `go` is getting reassigned to one of the other functions? for the puzzle lovers let's make it even more complicated:

```lua
feelings = {sad,happy}

function key(n,z)
  feelings[z+1]()
end
```

what? it's a table of functions! why would you want to do this??

the default way of thinking about decisions is perhaps to make a big if-else statement:

```lua
function key(n,z)
  if z == 1 then
    happy()
  elseif z == 0 then
    sad()
  end
end
```

makes sense, totally readable. but what if your program could change itself while it ran?

```lua
feelings[2] = sad
```

(oh no!! always sad now!)

but really. imagine adding some complexity to these functions, having more of them, and design a process where they dynamically inform one another.

pause. really consider the possibilities, and i hope your mind explodes a tiny bit. this is why programming in a musical context is so incredibly powerful and interesting.

## parameters

managing numbers is of primary concern. we usually want them to stay in a certain range and behave a certain way, and this means typically making a lot of repetitive code. but we've created some structures to help you keep your numbers together and scripts looking clean:

```lua
params:add_number("tempo","tempo",20,240,88)
```

we just created an entry in the default _parameter set_ which is called `params`. this is the parameter set that you see in the system menu under `PARAMETERS`. go there now and you'll see "tempo" which you can change with the menu interface. here's what we did:

- parameter id = "tempo"
- name = "tempo"
- minimum = 20
- maximum = 240
- default = 88

`min`, `max`, and `default` are all optional. we could add an unbounded number parameter that defaults to 0 by simply writing `params:add_number("anything")`. the `name` field is required.

besides editing in the menu, let's do some things with code:

```lua
params:set("tempo", 110)
print("tempo is " .. params:get("tempo"))
params:delta("tempo", -100)
print("tempo is now " .. params:get("tempo"))
```

note the colon (`:`) for the parameter functions (these are class functions). the lines above did some pretty handy things:

- `set` the value
- `get` the value
- `delta` the value

that last delta we did was clamped into the range, so you'll that the final `tempo` value is 20 (which is the minimum we specified above).

usually when a parameter changes we want something to happen. what if we could automatically call a function whenever a parameter changed, via `set` or `delta`?

```lua
function print_bpm_to_ms(bpm)
  print(bpm .. " bpm is a " .. 60/bpm .. "second interval.")
end

params:set_action("tempo", function(x) print_bpm_to_ms(x) end)
```

indeed indeed! now whenever the value of `tempo` is touched you'll be informed of the interval time. the value `x` is the value of the parameter, and we pass it to the `print_bpm_to_ms()` function.

there's a shortcut to make parameter creation more readable:

```lua
params:add{type="number", id="tempo", min=20, max=240, default=88,
  action=function(x) print_bpm_to_ms(x) end}
```

note that we're using a new syntax style with curly brackets. this passes a table to the function which creates the new parameter. we're able to specify the attribute names (ie, `min`, `max` which makes it more readable, in addition to specifying the `action` in the same line. you can use either method, but this way is generally recommended.

## more sound please

add more parameters with multiple lines of `params:add_number()`, but all parameters are not just basic numbers. there is a _control_ parameter that maps a "control" range (think 0-100) to a specified min/max, with linear and exponential scaling. we use these frequently with engine parameters:

```lua
params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
```

the third argument of the `params:add_control` function is a _control spec_. we use `controlspec.new()` to create a new spec with arguments:

- min = 50
- max = 5000
- curve = `exp` (can also be `lin`)
- step = 0
- default = 555
- unit = `hz` (for printing)

if we wanted to define this control spec once and then assign it to many controls, we could do it like this:

```lua
filter_cs = controlspec.new(50,5000,'exp',0,555,'hz')
params:add_control("f1","f1",filter_cs)
params:add_control("f2","f2",filter_cs)
params:add_control("f3","f3",filter_cs)
```

it is easy to then directly attach the parameter to an engine parameter:

```lua
params:set_action("cutoff", function(x) engine.cutoff(x) end)
```

now we can use the system menu to directly change an engine parameter. or much more fun, include it in our own script function:

```lua
function enc(n,d)
  if n == 3 then
    params:delta("cutoff",d)
  end
end
```

with this short few lines we have an exponential, range-limited parameter control! and what's more:

```lua
params:write("later.pset")
```

this saves the current values of the parameter set to disk, in the file `later.pset` under `/dust/data/`. you can similarly load with:

```lua
params:read("later.pset")
params:bang()
```

after a read you'll want to call `params:bang()` which will activate every parameter's `action` function.

lastly, we've been using the default parameter set throughout, but we can create as many of our own parameter sets as desired. they won't be hooked up to the system menu, but we can manipulate them in all of the same ways. here's how to create one:

```lua
others = paramset.new()
others:add_number("first","My First Parameter")
```

this creates a new parameter set called `others` and adds a number.

## it's about time

until now we haven't considered time. how do we become aware of time?

```lua
util.time()
```

this returns something like: `1529498027.7441`. it's the system time, which is useful as a marker. now we will measure the length of a key press:

```lua
down_time = 0

function key(n,z)
  if n == 3 then
    if z == 1 then
      down_time = util.time()
    else
      hold_time = util.time() - down_time
      print("held for " .. hold_time .. " seconds")
    end
  end
end
```

try it out. press key 3, you'll get a time measurement. we can use something like this to create a tap-tempo, by sampling the time interval between key-downs, storing those values in a table, and averaging the values.

## time again

in addition to using keys and encoders to trigger functions, we can also make time-based metronomes which trigger functions.

```lua
function init()
  position = 0
  counter = metro.init()
  counter.time = 1
  counter.count = -1
  counter.event = count
  counter:start()
end

function count(c)
  position = position + 1
  print(c .. "> " .. position)
end

```

this `init` function creates a `metro` called `counter`:

- set interval `time` to 1 (second)
- set count to -1, which means never stop. (we could set this to a target number to auto-stop).
- set the event function (like a param action function).
- start the metronome counting. (note this is a class function, use a colon).

on each tick of the `counter`, the `count` function is executed. the value `c` is the stage of the metro. we create a `position` variable which is counted up. try the following one by one on the command line:

```lua
counter.time = 0.5
position = 0
counter:stop()
counter.count = 5
counter:start()
```

this demonstrates how we're able to manipulate `counter` on the fly. here's a quick script that creates a simple ascending strum pattern:

```lua
-- strum

engine.name = "PolyPerc"

function init()
  strum = metro.init(note, 0.05, 8)
end

function key(n,z)
  if z == 1 then
    strum:stop()
    root = 40 + math.random(12) * 2
    engine.hz(midi_to_hz(root))
    strum:start()
  end
end

function note(stage)
  engine.hz(midi_to_hz(root + stage * 5))
end

function midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end
```

we use a shortcut for initializing the metro by putting the event function, interval time, and number of stages in the `metro.init()` function arguments. when we push any key down, a random root note is selected and played and then the metro is started. it will trigger 8 times, and on each function call we will sound a new note that is 5 semi-tones above the previous note. try modulating the metro interval, number of stages, and stage multiplier! for example, change 8 to 1 (for a single note) and 5 to 12 (for an octave shift).


## example: spacetime

putting together concepts above. this script is demonstrated in the video up top.

```lua
-- spacetime
-- norns study 3
--
-- ENC 1 - sweep filter
-- ENC 2 - select edit position
-- ENC 3 - choose command
-- KEY 3 - randomize command set
--
-- spacetime is a weird function sequencer.
-- it plays a note on each step.
-- each step is a symbol for the action.
-- + = increase note
-- - = decrease note
-- < = go to bottom note
-- > = go to top note
-- * = random note
-- M = fast metro
-- m = slow metro
-- # = jump random position
--
-- augment/change this script with new functions!

engine.name = "PolyPerc"

note = 40
position = 1
step = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
STEPS = 16
edit = 1

function inc() note = util.clamp(note + 5, 40, 120) end
function dec() note = util.clamp(note - 5, 40, 120) end
function bottom() note = 40 end
function top() note = 120 end
function rand() note = math.random(80) + 40 end
function metrofast() counter.time = 0.125 end
function metroslow() counter.time = 0.25 end
function positionrand() position = math.random(STEPS) end

act = {inc, dec, bottom, top, rand, metrofast, metroslow, positionrand}
COMMANDS = 8
label = {"+", "-", "<", ">", "*", "M", "m", "#"}

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
  counter = metro.init(count, 0.125, -1)
  counter:start()
end

function count()
  position = (position % STEPS) + 1
  act[step[position]]()
  engine.hz(midi_to_hz(note))
  redraw()
end

function redraw()
  screen.clear()
  for i=1,16 do
    screen.level((i == edit) and 15 or 2)
    screen.move(i*8-8,40)
    screen.text(label[step[i]])
    if i == position then
      screen.move(i*8-8, 45)
      screen.line_rel(6,0)
      screen.stroke()
    end
  end
  screen.update()
end

function enc(n,d)
  if n == 1 then
    params:delta("cutoff",d)
  elseif n == 2 then
    edit = util.clamp(edit + d, 1, STEPS)
  elseif n == 3 then
    step[edit] = util.clamp(step[edit]+d, 1, COMMANDS)
  end
  redraw()
end

function key(n,z)
  if n==3 and z==1 then
    randomize_steps()
  end
end

function midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end

function randomize_steps()
  for i=1,16 do
    step[i] = math.random(COMMANDS)
  end
end
```

## reference

- `metro` class is in [http://norns.local/doc](http://norns.local/doc) (must be connected to norns)
- `util` (also in the docs) includes many other helper functions, such as `util.clamp`

## continued

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: spacetime
- part 4: [physical](../study-4/) // grids + midi
- part 5: [streams](../study-5/) // system polls, osc, file storage

## community

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to this study welcome, see [monome/docs](http://github.com/monome/docs)
