---
layout: default
nav_exclude: true
permalink: /norns/study-3/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/276054881?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# spacetime
{: .no_toc }

norns studies part 3: functions, parameters, time

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## terminology

Before we dive in, here is some terminology which is mentioned throughout this study:

- **evaluate**: when we run our script, matron (which manages the norns Lua environment) will evaluate all of our script's code and if there are no errors, it will run the script. Evaluating code just means submitting it to the system for parsing -- if the code has no errors, then the code is stored in the short-term memory for execution as part of our script.

- **global and local scope**: functions and variables throughout our script can either be known to the entire script (and maiden's command line), or they can be unique to a specific section. By default, everything in Lua is global unless it's declared as `local`. For example, clear any previous code in the editor and start anew with:

	```lua
	-- study 3
	-- code exercise
	-- global and local
	
	function init()
	  local where_is_this = "here"
	end
	```
	
	And execute on the command line:
	
	```lua
	>> where_is_this
	nil
	```
	
	Because `where_is_this` is *local* to the `init()` function, that's the only place where it has any value.
	
	norns has a lot of protections in place so that separate scripts can share global namespace (eg. one script's `hello()` might do something quite different from another script's `hello()`, but it's totally okay for them to share a name), but you should be aware of these [system globals](../reference/#system-globals) which are sacred names that you must avoid redefining in your scripts (eg. it'd be bad to redefine the entire concept of `midi`). If you ever make a mistake with this, restarting norns will set things right.

- **return**: in previous studies, functions performed operations in a fixed fashion -- eg. a `key` function is called, a number is generated, that number is passed to our engine, that's the end. Functions can also perform calculations or modify arguments and give (or *return*) the results back to us. For example, clear any previous code in the editor and start anew with:

	```lua
	-- study 3
	-- code exercise
	-- return

	function add_ten(number)
	  return number + 10
	end
	
	function init()
	  x = add_ten(3)
	  y = add_ten(9)
	  z = add_ten(-4)
	  print(x)
	  print(y)
	  print(z)
	end
	```
	And matron will print:
	
	```
	13
	19
	6
	```
	
## we function together

So far we've seen a few ways to run commands:

- the command line, for single lines
- the `init` function which is run at startup of a script
- `enc` and `key` functions which are executed when you touch an encoder or key

Let's learn a fourth way to quickly execute multi-line chunks of code for experimentation.

### evaluating lines in maiden

First, locate yourself thus:

- connect to norns via [hotspot or network](../wifi-files/#connect)
- navigate web browser to http://norns.local (or type in IP address if this fails)
- you're looking at [_maiden_](../maiden), the editor

**If you've gone through the previous studies:**

- open your uniquely-named study folder in the maiden file browser
- create a new file in your study folder: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor

<details closed markdown="block">
  <summary>
    <i>If you haven't gone through the previous studies</i>
  </summary>
  {: .text-delta }
- create a new folder in the `code` directory: click on the `code` directory and then click the folder icon with the plus symbol to create a new folder
  - name your new folder something meaningful, like `my_studies` (only use alphanumeric, underscore and hyphen characters when naming)
- create a new file in the folder you created: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor
</details>

The file is blank. Full of possibilities. Type the text below into the editor:

```lua
-- study 3
-- code exercise
-- evaluate

function greeting()
  print("hello there!")
end

greeting()
```

Now, instead of saving and running the entire script, highlight the function definition in the editor and then press CMD + RETURN (Mac) / CTRL + ENTER (PC). This evaluates the highlighted text and **you'll see the code print as a single line with semicolons in the maiden REPL**:

```lua
function greeting();  print("hello there!");end
```

This evaluation gesture checked our code chunk and has made it executable in our current session! Place the cursor on the last line of our code chunk and evaluate it using CMD + RETURN / CTRL + ENTER. **You'll this print to the maiden REPL**:

```lua
greeting()
hello there!
<ok>
```

It's the same as if you executed it on the command line:

```lua
>> greeting()
hello there!
<ok>
```

This can be a powerful learning tool, as we can modify and re-evaluate sections of our code without re-running the entire script. **However, if we want to start from a blank slate, we need to re-run the entire script using the 'run script' play button or using CMD+P / CTRL+P**

### functional programming

As we mentioned at the start of [study 1](../study-1/#terminology), a function is a block of code that can be _called_ and conditionally accept and return parameters. Functions are useful when you have some code you need to run frequently or perhaps from different places. They are very good for organizing and making your scripts readable and reusable.

For example, if we want to translate a MIDI note to a frequency in Hz (A=440), we need to use a bunch of math we likely don't want to remember: `(440 / 32) * (2 ^ ((midi_note - 9) / 12))`.

But we can just wrap that in a function:

```lua
function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end
```

What will happen:

- we pass an _argument_ to the function, which our function will treat as a variable named `note`
- we make a local variable called `hz`, do some math with `note` for the conversion
- we return `hz`

Let's use it in an exercise (with a new engine, `PolySub`):

```lua
-- study 3
-- code exercise
-- functional programming

engine.name = 'PolySub'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function drone(note)
  engine.start(1,midi_to_hz(note)) -- PolySub has different commands than PolyPerc!
end
```

Now, execute each of these lines of code, one at a time -- either by using our line-evaluation key combo or the command line:

```lua
drone(41)
drone(44)
drone(39)
drone(49)
drone(45)
```

Here's what happens:

- `midi_to_hz` is called with a value of 30, which is assigned to `note`
- the function runs and returns a value which is assigned to `drone`

### zoom out

Throughout these studies, we've tried to provide clear examples of how your code should look as we suggest changes and add new functions. As you start to dream up your own scripts, you might be wondering if there's a flow or order for how a script's individual functions should be defined.

When you execute a script, the entire file is processed and then loaded. For example:

```lua
-- study 3
-- code exercise
-- zoom out

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

Even though the `key` function comes earlier and references `midi_to_hz()`, everything works when we press any of our keys because the whole global scope is made aware of `midi_to_hz`. So, generally, we can simply add new functions at the bottom of the script, as we go.

In our `zoom out` exercise, you'll also see that we did a little shortcut when we called `midi_to_hz` inside of our `key` function. Instead of:

```lua
local whatever = 30 + math.random(24)*2
local another_variable = midi_to_hz(whatever)
engine.hz(another_variable)
```

We simply nested the `midi_to_hz` function inside of our `engine.hz` function:

```lua
local whatever = 30 + math.random(24)*2
engine.hz(midi_to_hz(whatever))
```

### many to many

So far, we've only used functions with one argument, but functions can have *many* arguments. Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- many to many

engine.name = "PolyPerc"

function init()
  engine.amp(0.5)
end

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function stack_notes(root, interval, number)
  local note = root
  for i=1,number do
    engine.hz(midi_to_hz(note))
    note = note + interval
  end
end
```

The `stack_notes` function takes three arguments: a `root` note, a note `interval`, and a `number` of notes. Using a loop it plays a stack of notes. Try evaluating this:

```lua
stack_notes(40,7,6)
```

It'll play these 6 MIDI notes, which start at 40 and increment by 7 each time: `40 47 54 61 68 75`.

#### some of many

But what if we leave off an argument when we call `stack_notes`?

```lua
stack_notes(40,7)
```

Well, matron will return an error when the function tries to use `nil` as `number` in the loop:

```lua
lua: stdin:1: 'for' limit must be a number
stack traceback:
	stdin:1: in function <stdin:1>
	(...tail calls...)
```

To protect against this, we can define a default value in our functions. Let's rewrite our `stack_notes` function to include some safeguards:

```lua
function stack_notes(root, interval, number)
  number = number or 4
  interval = interval or 7
  note = root or 50
  for i=1,number do
    engine.hz(midi_to_hz(note))
    note = note + interval
  end
end
```

The `number = number or 4` trick is the same as writing `if number == nil then number = 4 end`. It's basically saying '*number* equals whatever *number* argument is passed in or if no *number* argument has been passed in, assign *number* the value of 4'.

Now you can even call `stack_notes()` and you'll get something much more pleasant than an error!

#### many in return

Functions can also return many values. Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- many in return

function whereami()
  local a = math.random(128)
  local b = math.random(64)
  return a,b
end
```

Now we can execute `whereami()` (either through line-evaluation or on the command line) to get two random numbers. But how do we use them?

Try executing these lines in pairs:

```lua
x = whereami()
print(x)

x,y = whereami()
print(x,y)

x,y,z = whereami()
print(x,y,z)
```

<details closed markdown="block">
  <summary>
    <i>The last one returned two values, but also a <code>nil</code>...why?</i>
  </summary>
  {: .text-delta }
  <p>
	<code>whereami()</code> is written to return only two values, so when we try to get a third value, it can only return <i>nil</i>.
	</p>
</details>

Let's use `whereami()` to display text in random positions on the screen:

```lua
-- study 3
-- code exercise
-- many in return

function whereami()
  local a = math.random(128)
  local b = math.random(64)
  return a,b
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(whereami())
  screen.text("here!")
  screen.update()
end
```

To force a `redraw`, press K1 to exit the script and press it again to come back in -- norns will automatically call the `redraw` function of the currently-running script when screen focus comes back to the script.

### tangle and detangle

Lua lets us easily make functions that point at other functions. Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- tangle and detangle

engine.name = 'PolyPerc'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

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

The trick is in the `key` function -- see how `go` is getting reassigned between each of the two functions before it's executed at the end of the `key` function? *This* is where order really matters -- matron will execute all the lines sequentially, one after the other. To demonstrate this, let's modify the `key` function and re-run the script (so matron forgets what `go` is):

```lua
function key(n,z)
  go()
  if z == 1 then
    go = happy
  else
    go = sad
  end
end
```

Now, we'll see errors that `go` is nil -- that's because `key` is attempting to call `go` *before* we assign it a function.

#### more tangled

For the puzzle lovers let's make it even more complicated. Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- more tangled

engine.name = 'PolyPerc'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

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

feelings = {sad,happy}

function key(n,z)
  feelings[z+1]()
end
```

What we've done is create a table of `feelings`, which contains the `sad` and `happy` functions. When we press a key, we shift the index of `feelings` and execute the corresponding function, since `feelings[1] = sad` and `feelings[2] = happy`

Being able to create a table of functions is actually *very rad* because the default way of thinking about decisions is perhaps to make a big if-else statement, eg.:

```lua
function key(n,z)
  if z == 1 then
    happy()
  elseif z == 0 then
    sad()
  end
end
```

While this makes sense and is totally readable, it's pretty rigid -- `happy()` and `sad()` are hard-coded into our key-down and key-up. But what if our `more tangled` code could change itself while it ran?

After running the `more tangled` code example above, try live-executing:

```lua
feelings[2] = sad
```

...and press some keys. Oh no!! Always sad now!

#### all the feels

Now imagine adding some complexity to these functions, having more of them, and designing a process where they dynamically inform one another. It could look like:

```lua
-- study 3
-- code exercise
-- all the feels

engine.name = 'PolyPerc'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function happy()
  engine.release(0.3)
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(64))
  engine.hz(midi_to_hz(67))
end

function sad()
  engine.release(1)
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(63))
  engine.hz(midi_to_hz(67))
end

function melancholic()
  engine.release(3)
  engine.hz(midi_to_hz(53))
  engine.hz(midi_to_hz(56))
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(63))
  engine.hz(midi_to_hz(67))
end

feelings = {sad,happy,melancholic,happy,happy,sad,sad,melancholic}
cutoffs = {800,400,1200}

feeling_index = 0 -- let's keep track of which feeling we're feeling
cutoff_index = 0 -- same for cutoff values

function key(n,z)
  if z == 1 then
    feeling_index = util.wrap(feeling_index + 1, 1, #feelings) -- increment the index
    cutoff_index = util.wrap(cutoff_index + 1, 1, #cutoffs) -- increment the index
    engine.cutoff(cutoffs[cutoff_index]) -- set the cutoff
    feelings[feeling_index]() -- feel the feeling
  end
end
```

By using a table to store chord shapes, we created a *score* which we can iterate through our keypresses. By using a table to store cutoff values, we create timbral variety. By using libraries built into norns, we made easy work of cycling through both the chords and cutoff values and wrapping back around (here, we used `util.wrap` -- check out [its reference](https://monome.org/docs/norns/api/modules/lib.util.html#wrap)). By using live-evaluation, we can change the score by simply modifying our `feelings` table.

*This* is why programming in a musical context is so incredibly powerful and interesting.

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

### more sound please

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

### norns-specific
- `metro` -- module to create high-resolution counters, see [`metro` API docs](https://monome.org/docs/norns/api/modules/metro.html) for detailed usage
- `params` -- module to map numbers to useful controls and ranges, see [`paramset` API docs](https://monome.org/docs/norns/api/modules/paramset.html) and [`params.control` API docs](https://monome.org/docs/norns/api/modules/params.control.html) for detailed usage
- `util` -- module to perform common utility functions, see [`util` API docs](https://monome.org/docs/norns/api/modules/lib.util.html) for detailed usage

## continued
{: .no_toc }

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: spacetime
- part 4: [physical](../study-4/) // grids + midi
- part 5: [streams](../study-5/) // system polls, osc, file storage

## community
{: .no_toc }

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to this study welcome, see [monome/docs](http://github.com/monome/docs)
