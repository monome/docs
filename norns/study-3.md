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

- **evaluate**: When we run our script, matron (which manages the norns Lua environment) will evaluate all of our script's code and if there are no errors, it will run the script. Evaluating code just means submitting it to the system for parsing -- if the code has no errors, then the code is stored in the short-term memory for execution as part of our script.

- **global and local scope**: Functions and variables throughout our script can either be known to the entire script (and maiden's command line), or they can be unique to a specific section. By default, everything in Lua is global unless it's declared as `local`. For example, clear any previous code in the editor and start anew with:

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
	
	Because `where_is_this` is *local* to the `init()` function, that's the only place where it has any value. The command line doesn't have access to `init()`'s local space, so we cannot access `where_is_this` from the command line.
	
	norns has a lot of protections in place so that separate scripts can share global namespace (eg. one script's `hello()` might do something quite different from another script's `hello()`, but it's totally okay for them to share a name), but you should be aware of these [system globals](../reference/#system-globals) which are sacred names that you must avoid redefining in your scripts (eg. it'd be bad to redefine the entire concept of `midi`). If you ever make a mistake with this, restarting norns will set things right.

- **return**: In previous studies, functions performed operations in a fixed fashion -- eg. a `key` function is called, a number is generated, that number is passed to our engine, that's the end. Functions can also perform calculations or modify arguments and give (or *return*) the results back to us. For example, clear any previous code in the editor and start anew with:

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

So far we've seen three primary ways to run commands:

- on the command line, for single lines
- inside the `init` function which is run at startup of a script
- inside of `enc` and `key` functions which are executed when you touch an encoder or key

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

This evaluation gesture checked our code chunk and has made it executable in our current session! Place the cursor on the last line of our code chunk and evaluate it using CMD + RETURN / CTRL + ENTER. **You'll see this print to the maiden REPL**:

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

As we mentioned at the start of [study 1](../study-1/#terminology), a function is a block of code that is _called_, sometimes with additional *arguments*, and can conditionally *return* values. Functions are useful when you have some code you need to run frequently or perhaps from different places. They are very good for organizing and making your scripts readable and reusable.

For example, if we want to translate a MIDI note to a frequency in Hz (A=440), we need to use a [bunch of math](https://newt.phys.unsw.edu.au/jw/notes.html) which we likely don't want to remember: `(440 / 32) * (2 ^ ((midi_note - 9) / 12))`.

But we can just wrap that in a function:

```lua
function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end
```

What will happen:

- we pass a MIDI note as an _argument_ to the function, which our function will treat as a variable named `note`
- the function creates a local variable called `hz` and performs math with `note` for the conversion from MIDI to Hertz
- the function returns `hz`, which is the result of our conversion

### zoom out

Throughout these studies, we've tried to provide clear examples of how your code should look as we suggest changes and add new functions. As you start to dream up your own scripts, you might be wondering if there's a flow or order for how a script's individual functions should be defined.

When you execute a script, the entire file is processed and then loaded. For example:

```lua
-- study 3
-- code exercise
-- zoom out pt.1

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

Let's use this nesting in another exercise (with a new engine, `PolySub`). Clear any previous code in the editor and start anew with:

```lua
-- study 3
-- code exercise
-- zoom out pt.2

engine.name = 'PolySub'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function drone(note)
  engine.start(1,midi_to_hz(note)) -- nb. PolySub has different commands than PolyPerc!
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

- our entire script is aware of the `midi_to_hz` function (remember: unless a variable is declared as *local*, Lua makes it *global*)
- the `drone` function is designed to accept a MIDI note value, which it passes to a `midi_to_hz` function call inside of `PolySub`'s `engine.start` command
- when we execute the `drone(x)` commands, we are passing a specific MIDI note value, which results in an audible note at the correct Hertz

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

*This* is why programming in a musical context is so incredibly powerful and interesting. We hope you feel similarly :)

## parameters

Managing numbers is of primary concern. We usually want them to stay in a certain range and behave a certain way, and this means typically making a lot of repetitive code. To help keep clusters of related numbers together and scripts looking clean, norns employs *parameters*.

It might help to approach these from a user perspective first -- take a minute to revisit the [parameters section of the play docs](/docs/norns/play/#parameters). Parameters are particularly special because they help streamline a number of things:

- parameters surface variables from our code to the norns UI as readable names
- parameters facilitate MIDI mapping of these variables + recall the mapping when the script is reloaded
- parameter ID's facilitate OSC control over these variables
- parameter values can be saved through the PSET mechanism, to capture and recall unique script states

### defining a parameter

Let's establish a system menu parameter using `params`, which is a UI-visible instance of a norns library called *paramset* (which we'll cover [later](#off-menu)). Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- parameters pt.1: defining

params:add_number("velocity","velocity",0,127,63)
```

Here's what we did:

- id = "velocity" (this is the parameter's scripting ID and OSC address, which we'll cover more of in [study 5](/docs/norns/study-5/#numbers-through-air))
- name = "velocity" (the name we see in the norns `PARAMETERS > EDIT` menu UI)
- minimum = 0 (the smallest value we can reach)
- maximum = 127 (the largest value we can reach)
- default = 63 (the starting value)

If you head to the `PARAMETERS > EDIT` menu on norns, you'll see `velocity` at a default value of 63, which we can decrease/increase between 0 and 127 using E3.

Definitions for `name`, `min`, `max`, and `default` are all optional. We could add an unbounded number parameter without a visible name in the menu UI that defaults to 0 by simply writing `params:add_number("anything")`. The `id` field is all that's required, though a blank and boundless number parameter is perhaps not a terribly useful menu entry for an artist using the script.

### controlling a parameter with code

Besides editing in the menu, let's do some things with code (evaluate through either line-execution or on the command line):

```lua
params:set("velocity", 110)
print("velocity is " .. params:get("velocity"))
params:delta("velocity", 20)
print("velocity is now " .. params:get("velocity"))
```

Note the colon (`:`) for the parameter functions. For the curious, these are *class functions*, a feature of Object Oriented Programming [that we can use in Lua](https://www.tutorialspoint.com/lua/lua_object_oriented.htm) (heads up: *not* super beginner-friendly, so don't worry about the 'why').

The lines above did some pretty handy things:

- `set` the value
- `get` the value
- `delta` the value

You'll notice that our `delta` of 20 from 110 didn't get us to 130 -- instead, we ended up at 127. This is because the range is clamped to our defined `min` and `max`. Since 130 is above 127, the final result was clamped to 127.

### assigning an action to a parameter

Usually when a parameter changes we want something to happen. What if we could automatically call a function whenever a parameter changed via `set` or `delta`?

```lua
-- study 3
-- code exercise
-- parameters pt.2: assigning

function print_bpm_to_sec(bpm)
  print(bpm .. " bpm is a " .. 60/bpm .. " second interval")
end

params:add_number("tempo","tempo",20,240,88)
params:set_action("tempo", function(x) print_bpm_to_sec(x) end)
```

Here's what we did:

- created a global function called `print_bpm_to_sec`, which accepts `bpm` as an argument and prints the conversion of bpm to seconds
- added a number parameter for `tempo`, with a range of 20 to 240 and a default value of 88
- set an action for the `tempo` parameter, where the current value of the parameter (`x`) is passed as an argument to the `print_bpm_to_sec` function

Now whenever the value of `tempo` is modified you'll be informed of the interval time.

If we want to make parameter creation more readable, we can also format like this:

```lua
-- study 3
-- code exercise
-- parameters pt.2: assigning

function print_bpm_to_sec(bpm)
  print(bpm .. " bpm is a " .. 60/bpm .. " second interval")
end

params:add{
  type="number",
  id="tempo",
  min=20,
  max=240,
  default=88,
  action=function(x) print_bpm_to_sec(x) end
}
```

Note that we're using a new syntax style with curly brackets. This passes a table to the `params:add` function, which creates the new parameter. We're able to specify the attribute names (ie, `min`, `max` which makes it more readable, in addition to specifying the `action` in the same line.

Either declaration method works -- it's just about what feels most comfortable for you.

### more control + sound please

We can add more number parameters, but not all parameters are just basic numbers which change by steps of 1. To allow more responsive mapping to a specified min/max with linear and exponential scaling, norns gives us a _control_ parameter and a _control specification_ (referred to as *controlspec*) to define how our values should scale. We use these frequently with engine parameters.

Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- parameters pt.3: more control + sound

engine.name = "PolyPerc"

params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
```

The third argument of the `params:add_control` function is a _controlspec_. We used `controlspec.new()` to create a new control specification with arguments:

- min = 50
- max = 5000
- curve = `exp` (can also be `lin`)
- step = 0 (output will be rounded to a multiple of step)
- default = 555
- unit = `hz` (for printing)

It's easy to then directly attach the parameter to the engine's `cutoff` parameter:

```lua
-- study 3
-- code exercise
-- parameters pt.3: more control + sound

engine.name = "PolyPerc"

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
end
```

Now we can use the system menu to directly change an engine parameter.

Let's add some more interactions to the code!

First, let's get the `cutoff` parameter to display in the script's UI using `params:string`, which will return both the cutoff value and the 'hz' formatter:

```lua
-- study 3
-- code exercise
-- parameters pt.3: more control + sound

engine.name = "PolyPerc"

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.font_size(18)
  screen.text_center(params:string("cutoff"))
  screen.update()
end
```

Then, let's use E3 to delta the `cutoff` parameter:

```lua
-- study 3
-- code exercise
-- parameters pt.3: more control + sound

engine.name = "PolyPerc"

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.font_size(18)
  screen.text_center(params:string("cutoff"))
  screen.update()
end

function enc(n,d)
  if n == 3 then
    params:delta("cutoff",d)
    redraw()
  end
end
```

Finally, let's use K3 to trigger a note (let's use a sequins to make things interesting!):

```lua
-- study 3
-- code exercise
-- parameters pt.3: more control + sound

local s = require 'sequins'

engine.name = "PolyPerc"

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
end

notes = s{330,495,660,247.5}

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.font_size(18)
  screen.text_center(params:string("cutoff"))
  screen.update()
end

function enc(n,d)
  if n == 3 then
    params:delta("cutoff",d)
    redraw()
  end
end

function key(n,z)
  if n == 3 then
    if z == 1 then
      engine.hz(notes())
    end
  end
end
```

#### starting with action

You may have noticed that when the script loads, the synth actually doesn't reflect the default `555` cutoff value. This is because the parameters load in a 'cold' state -- they wait until they receive interaction before performing their `action`.

In order to trigger the action right when the script starts, you'll need to include a `params:bang()` at the end of your parameter declarations, eg: 

```lua
-- study 3
-- code exercise
-- parameters pt.4: starting with action

function init()
  params:add_number("print_me","print this",20,600,49)
  params:set_action("print_me", function(x) print(x) end)
  params:bang()
end
```

This code snippet will print `49` to the REPL, whereas commenting out the `params:bang()` will result in no print at script start.

### PSETs

As mentioned at the start of this section, parameters are especially powerful because their states can be saved and restored. While it's easy enough to save, load, and manage parameter sets through the norns UI, perhaps you'll want to play around with PSET functions through code.

Run the `parameters pt.3` code and adjust the cutoff value to taste. Let's save this state by executing the following on the command line:

```lua
>> params:write(1,"later")
```

Here's what we did:

- told the `params` system to `write` a new PSET
- specified slot `1` as the destination
- specified `later` as the name for the PSET

We can validate that the PSET saved by heading to `PARAMETERS > PSET` in the norns menus.

You'll also notice that after we executed the `write` command, matron returned a filepath (eg. `/home/we/dust/data/my_studies/study_3-01.pset`) where you can find this `.pset` file.

You can similarly load any PSET slot with:

```lua
>> params:read(1)
```

After a read, the norns system will cycle through every parameter to set its value to the PSET's values, but it won't perform the `action` function. In order to pass the PSET's values through the parameter's actions, you'll need to include a `params:bang()`, which triggers every parameter.

```lua
>> params:read(1)
>> params:bang()
```

### controlspec templates

In our `parameters pt.3` code, we assumed a lot about what range would be useful for controlling a filter cutoff -- to help guide us, norns comes with a number of *controlspec* templates which we can call on for easier parameter definition. These templates are listed in the [API docs](https://monome.org/docs/norns/api/modules/controlspec.html#Presets).

We could rewrite the `init` of our `parameters pt.3` to utilize the `constrolspec.FREQ` template:

```lua
function init()
  params:add_control("cutoff","cutoff",controlspec.FREQ)
  params:set_action("cutoff", function(x) engine.cutoff(x) redraw() end)
end
```

This means out `cutoff` parameter will inherit some useful defaults, rather than us having to type them all out. To see the particulars:

```lua
>> tab.print(controlspec.FREQ)
warp	table: 0x455ee0
wrap	false
step	0
quantum	0.01
units	Hz
maxval	20000
default	440
minval	20
```

### off-menu parameters {#off-menu}

We've been using the default parameter set throughout, which automatically adds what we declare to the norns PARAMETERS system menu -- but if we just want to use these templates for managing values, we can create as many of our *own* parameter sets as we want. Note that these are just convenience wrappers for using parameter-style formatting without creating norns menu items -- and since these won't be hooked up to the system menu, they don't tie into PSETs, MIDI mapping, or OSC control. But they're still helpful for establishing and manipulating variables in creative ways.

Here's how to create one:

```lua
-- study 3
-- code exercise
-- parameters pt.6: off-menu

custom = paramset.new()

custom:add{
  type = 'option',
  id = 'grocery_list',
  options = {'apples','bananas','carrots','daikon','eggplant','fennel'},
  action = function() redraw() end
}

function redraw()
  screen.clear()
  screen.move(10,10*custom:get('grocery_list'))
  screen.text(custom:string('grocery_list'))
  screen.update()
end

function enc(n,d)
  if n == 3 then
    custom:delta('grocery_list',d)
  end
end
```

This creates a new parameter set called `custom` and adds a `grocery_list` as an `option`-type paramset. For a complete rundown of all the parameter types, see the [extended reference](/docs/norns/reference/params).


## it's about time

Until now we haven't considered time. How do we become aware of time? Try executing this on the command line:

```lua
>> util.time()
```

This will return something like: `1529498027.7441`. This is the system time (in seconds), which is useful as a marker. Let's measure the length of a key press!

Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- it's about time

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

Hold K3 and you'll see a time measurement printed to the REPL upon release. We could use something like this to create a tap-tempo, by sampling the time interval between key-downs, storing those values in a table, and averaging the values.

## time again

In addition to using keys and encoders to trigger functions, we can also make time-based metronomes which trigger functions.

Clear the previous code and start anew with:

```lua
-- study 3
-- code exercise
-- time again

function init()
  position = 0
  counter = metro.init()
  counter.time = 1
  counter.count = -1
  counter.event = count
  counter:start()
end

function count(stage)
  position = position + 1
  print(stage .. "> " .. position)
end
```

Here's what happened when we created a `metro` named `counter` in our `init()`:

- set interval `time` to 1 (second)
- set count to -1, which means it'll never stop (we could set this to a target number to auto-stop)
- set the event function (like the param action functions we covered before)
- start the metronome counting (note this is a class function, so use a colon!)

On each tick of the `counter`, the `count` function is executed. The value `stage` is the stage of the metro, which is automatically provided with each metro step. We create a `position` variable which is counted up.

Just like our previous practice with `params`, a `metro` can also be established in long or short-hand. This performs the same as the above:

```lua
-- study 3
-- code exercise
-- time again: short version

function init()
  position = 0
  counter = metro.init(count,1,-1) -- arguments are (event, time, count)
  counter:start()
end

function count(stage)
  position = position + 1
  print(stage .. "> " .. position)
end
```

### manipulate time

While the `time again` exercise runs, try executing the following one by one via line-execution or by executing on the command line to manipulate how `counter` operates:

```lua
counter.time = 0.5
position = 0
counter:stop()
counter.count = 5
counter:start()
```

### strum

Here's a quick script that creates a simple ascending strum pattern:

```lua
-- study 3
-- code exercise
-- time again: strum

engine.name = "PolyPerc"

function init()
  strum = metro.init(note, 0.05, 8) -- strum will trigger 'note' every 50ms for 8 stages
end

function key(n,z)
  if z == 1 then
    strum:stop() -- stop the strum
    root = 40 + math.random(12) * 2 -- select a random root MIDI note, starting at 40
    engine.hz(midi_to_hz(root)) -- play the root
    strum:start() -- start the strum
  end
end

function note(stage)
  local pitch = midi_to_hz(root + stage * 5) -- stage multiplies by 5 and adds to root
  engine.hz(pitch) -- play the pitch
end

function midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end
```

Here's what we did:

- used a shortcut for initializing the metro by putting the event function, interval time, and number of stages in the `metro.init()` function arguments
- when we push any key down, a random root note is selected and played and then the metro is started
- because of our `strum` definition, `note` will trigger 8 times, and on each function call we will sound a new note that is 5 semi-tones above the previous note

Try:
- changing the metro interval (eg. change 0.05 to 0.5 for slower jams)
- changing the number of stages (eg. change 8 to 1 for a single note)
- changing the stage multiplier (eg. change 5 to 12 for an octave shift)


## example: spacetime

Putting together concepts above. This script is demonstrated in the video up top.

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

- part 0: [first light](../study-0/) // learning to read and edit code
- part 1: [many tomorrows](../study-1/) // variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: spacetime
- part 4: [physical](../study-4/) // grids, MIDI, clock syncing
  - part 4b: [physical tangent: arc](../study-4b) // arc
- part 5: [streams](../study-5/) // system polls, OSC, file storage
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).