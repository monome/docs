---
layout: default
nav_exclude: true
permalink: /norns/study-1/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/273692952?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# many tomorrows
{: .no_toc }

norns studies part 1: variables, simple maths, keys + encoders

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

- [**function**](https://www.tutorialspoint.com/lua/lua_functions.htm): a named task or event in our script. *Calling* a function simply means executing or invoking that task or event. If we are defining a function, we use `end` at the end of our definition. If we are calling a function, we use parenthesis after its name to indicate a function call -- we can pass arguments (see next) to the function inside of the parenthesis.
	- **argument**: functions can be written to have general knowledge of the other components of our script, or we can ask it to perform its task on specific supplied values. Supplying these values is referred to as 'passing *arguments*' into the function call. In `print("hello")`, `print` is the function and `"hello"` is the argument specifying what we'd like to print.
- [**string**](https://www.tutorialspoint.com/lua/lua_strings.htm): a sequence of characters, like every word in this sentence. A sequence of characters becomes a string when its enclosed in single quotes eg. `'hello'`, double quotes eg. `"hello"`, or double brackets eg. `[[hello]]`. We will only use double and single quotes throughout these studies, but please be sure not to mix + match -- `'hello"` is *not* a valid string.
- [**variable**](https://www.tutorialspoint.com/lua/lua_variables.htm): a named storage container for data that our script can manipulate. We *declare* a variable and *assign* it a value by using a convention like `my_favorite_number = 11`. While our script runs, it will remember that our favorite number is 11. Variables can store numbers, strings, functions, and tables (which we'll talk about in the next study). For those with prior coding experience, it might be interesting to learn that variables in Lua are, by default, global -- later on, we'll cover [local vs. global variables](#addendum-global).

## hello?

Hello. Ready? Remember to stay hydrated.

First, locate yourself thus:

- connect to norns via [hotspot or network](../wifi-files/#connect)
- navigate web browser to http://norns.local (or type in IP address if this fails)
- you're looking at [_maiden_](../maiden), the editor
- create a new folder in the `code` directory: click on the `code` directory and then click the folder icon with the plus symbol to create a new folder
  - name your new folder something meaningful, like `my_studies` (only use alphanumeric, underscore and hyphen characters when naming)
- create a new file in the folder you created: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor

The file is blank. Full of possibilities. Type the text below into the editor:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  print("the end and the beginning they are the same.")
end
```

Click *save script* (the disk icon in the upper right) and then *run script* (the play icon just below that).

If the code has been typed correctly and your levels are up, you'll hear a sine tone.

### what happened really

The top three lines are comments. In Lua a comment begins with two dashes. When scripting for norns, the very top comments of the main script file are special in that they are displayed as the preview text in the script selector. Try it:

- press K1 get into the norns menu
- navigate to the SELECT / SYSTEM / SLEEP screen
- press K2 on SELECT
- find your file, select it with K3

You can type as many lines at the top of a script as you want, but note that the norns screen isn't so wide, so keep your lines short. It's helpful to write a description about your script and list the controls. But so far this does basically nothing, so we wrote basically nothing.

But we did do one important thing! We selected an engine on line 4:

```lua
engine.name = "TestSine" -- don't run this code, it's just a reminder
```

This line loaded the `TestSine` engine -- note that this needs to be in quotes (single or double work, but don't mix + match). This is an imperative first step.

Then, we created the `init` function, which gets called at script startup (this is true of every script). Right now all it does is print. But where does it print?

## robot hangout

The COMMAND LINE (aka *REPL*: Read-Eval-Print Loop) is where information about the currently-running script is printed. It's the window below the editor. Messages from matron (the Lua component of norns) will appear here -- you can scroll back to see what it had to say.

At the bottom is a `>>` prompt which is where you can type in commands (aka *command line*).

Type this in and then press ENTER on your keyboard:

```lua
>> print("hello.")
```

...and you'll see `hello.` printed in response. norns has _excellent_ manners.

Being able to print to the REPL is incredibly helpful, despite this being possibly the most boring intro to such an astoundingly interesting music machine.

Let's do something even more useful now:

```lua
>> engine.list_commands()
```

Which will print this to the REPL:

```
engine.list_commands()
___ engine commands ___
amp		f
hz		f
<ok>
```

This is useful information! It lets us know that the `TestSine` engine responds to two commands:

- `amp`: amplitude
- `hz` : frequency

It also lets us know that both accept float (decimal) values -- that's what the `f` next to each command indicates. For example, we can change the frequency of the sine by executing this in the REPL:

```lua
>> engine.hz(200)
```

Now is a good time to point out the UP ARROW on your keyboard. **When typing into the command line use the up arrow to see the previous things you typed in.** This makes rapid-changing of the frequency much easier.

Also try changing the amplitude by executing `engine.amp(x)`, where `x` is a value between 0.0 to 1.0 (you can certainly give it large values and it'll happily clip).

Back to the script -- if we want to have the engine start up with a particular frequency, we add it to the `init` function:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end
```

Try it. It works!

### numbers and strings

Back to the command line. Let's create some variables:

```lua
>> coins = 4
>> spell = "heal party"
```

We just made two variables. The first assigned the number 4 to the variable `coins`. The second assigned a [string](https://www.lua.org/pil/2.4.html) to the variable `spell`. You can easily confirm that it worked with:

```lua
>> print(coins)
```

This prints just the number to the REPL.

During debugging, you'll find it helpful to make more informative prints by using _string concatenation_, which just means gluing strings together. You can glue strings together with the Lua operator `..` (two periods):

```lua
>> print("i will cast " .. spell .. " for " .. coins .. " coins.")
```

We can also glue commands together in the REPL, to execute many at once, using `;` (semicolon):

```lua
>> engine.hz(300); print(coins)
```

(Lua has a huge [string library](http://lua-users.org/wiki/StringLibraryTutorial).)

### maths

All of the standard arithmetic operators are available:

```lua
>> coins = 99 -- creates a variable 'coins' and assigns it 99
>> coins = coins + 1 -- now coins = 100
>> coins = coins - 10 -- now coins = 90
>> coins = coins * 2 -- now coins = 180
>> coins = coins / 4 -- now coins = 45
>> coins = coins % 2 -- now coins = 1
```

Modulus (`%`) is perhaps unusual. It gives the remainder after a division. so: `11 % 10` would equal 1. We can use this as a trick for confining values to a range, say:

```lua
>> x = x % 10
```

For whatever value of x, it will be wrapped to the range 0-9.

And let's just make sure you know about this early on:

```lua
>> coins = math.random(100)
```

This assigns `coins` a random value up to 100. But also:

```lua
>> engine.hz(math.random(10)*50+100)
```

## use the hardware

So far all of our interaction has been through the command prompt. This is a good way to demonstrate some basic syntax, but the point of norns is interaction -- three keys and three encoders can create a lot of fun.

Let's add a keypress function to our script, after the `init()` function:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  print("key " .. n .. " == " .. z)
end
```

Save and rerun. Then push some keys and you'll get some prints. You'll notice that:

- `n` is the key number
- `z` is the key state -- down (1) or up (0)

Let's modify the keypress function in our script to do something more engaging:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  end
end
```

While running the above, we hear a 200hz tone when we press K3 and a 100hz tone when we release K3. This is all worked out in our `key` function, where we send `(100 + 100 * z)` to our engine -- the value of `z` depends on whether K3 is pressed (`z` = `1`) or released (`z` = `0`).

When we press K3, `z` is equal to `1`, which sends `(100 + 100 * 1)` to our engine.  
When we release K3, `z` is equal to `0`, which sends `(100 + 100 * 0)` to our engine.

### controlling flow

Code is basically a definition of flow -- what should happen when and how? In a lot of ways, code is like a musical score.

In our code above, we've used an `if` statement. `if` statements test a condition and then do stuff if the condition is true:

```lua
if (condition) then
  (do stuff)
end
```

In our code, we used `n == 3` as the condition, which checked to see if the key number was equal to 3.

Other [comparison operators](https://www.lua.org/pil/3.2.html) include:

- `==` (is equal)
- `~=` (not equal)
- `>` (greater than)
- `<` (less than)
- `>=` (greater or equal)
- `<=` (less than or equal)

`if` statements can also be expanded with `elseif` and `else`, for example try changing our script's `key` function to:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  elseif n == 2 then
    engine.hz(300 + 175 * z)
  else
    engine.hz(200 + 300 * z)
  end
end
```

Save and re-run the script, then press K3 with or without holding K2.

### all of the fun

To get data from the encoders let's add to the end of the script:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  elseif n == 2 then
    engine.hz(300 + 175 * z)
  else
    engine.hz(200 + 300 * z)
  end
end

function enc(n,d)
  print("encoder " .. n .. " == " .. d)
end
```

Here, `d` is delta. The encoders report incremental steps of a turn: clockwise is positive, counterclockwise is negative.

## make the robots mad

Let's make a mistake on purpose.

What if we wanted to accumulate encoder turns, to keep track of an absolute position? We might try replacing the `enc` function:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  elseif n == 2 then
    engine.hz(300 + 175 * z)
  else
    engine.hz(200 + 300 * z)
  end
end

function enc(n,d)
  if n == 3 then
    position = position + d
    print("encoder 3 at position: " .. position)
  end
end
```

Try it in your script, then save and run. Upon turning the encoder you'll get an error!

```
lua: /home/we/dust/code/study/study1-manyfutures.lua:19: attempt to perform arithmetic on a nil value (global 'position')
stack traceback:
/home/we/dust/code/study/study1-manyfutures.lua:19: in function 'encoders.callback'
/home/we/norns/lua/encoders.lua:56: in function 'encoders.process'
```

(your line number may be different, but the error is the same)

We made a small mistake.

### what is nil?

From [Programming in Lua](https://www.lua.org/pil/2.1.html): "Lua uses nil as a kind of non-value, to represent the absence of a useful value."

Revisiting our error, we see: `attempt to perform arithmetic on a nil value (global 'position')`

- we tried to perform arithmetic on a non-value
- the non-value was named `position`

Look back at our code -- did we ever establish a *starting* value for `position`? No. Since we can't meaningfully add a void to a number, we receive an error.

To get around this error, we need to establish that `position` indeed exists. We can do that by adding a line inside of `init` which gives `position` a default value:

```lua
function init()
  position = 10
  engine.hz(100)
  print("the end and the beginning they are the same.")
end
```

Now we can try that adding that new `enc` function:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  position = 10
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  elseif n == 2 then
    engine.hz(300 + 175 * z)
  else
    engine.hz(200 + 300 * z)
  end
end

function enc(n,d)
  if n == 3 then
    position = position + d
    print("encoder 3 at position: " .. position)
  end
end
```

### clamping down the fun

Though the encoders are endless, we'll sometimes want changes made by the encoders to be clamped to a specific range. This is where special utilities built for norns come in, specifically one called `util.clamp()`, which accepts three arguments:

- `n`: value
- `min`: minumum
- `max`: maximum

Let's try it in our script by replacing our `enc` function with a clamped version:

```lua
-- study 1
-- code exercise
-- hello

engine.name = "TestSine"

function init()
  position = 10
  engine.hz(100)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  elseif n == 2 then
    engine.hz(300 + 175 * z)
  else
    engine.hz(200 + 300 * z)
  end
end

function enc(n,d)
  if n == 3 then
    position = util.clamp(position + d,-20,20)
    print("encoder 3 at position: " .. position)
  end
end
```

Now when we turn encoder 3, we cannot go outside of -20 to 20.

## make some more mistakes

To acclimate ourselves to issues, let's make a few more common mistakes:

```lua
>> print("we like to party"
```
- returns: `<incomplete>`
- translation: "typo. no closing parenthesis."

```lua
>> print("we like to party')
```
- returns: `<incomplete>`
- translation: "typo. don't switch between single and double quotations in a single string. use pairs of one or the other."

```lua
>> math.random(0.7)
```
- returns: `lua: stdin:1: bad argument #1 to 'random' (number has no integer representation)`
- translation: "this function requires an integer and 0.7 is not an integer"

```lua 
function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  end
```
- returns: `'end' expected (to close 'function' at line 10)`
- translation: "the function you started on line 10 does not have a closing `end` line, so we don't know if you're done defining the function"

**Be sure to keep an eye on the REPL for errors.**

## example: many tomorrows

Putting together the concepts above, this script is demonstrated in the video up top.

```lua
-- many tomorrows
-- norns study 1
--
-- KEY 2 toggle sound on/off
-- KEY 3 toggle octave
-- ENC 2 randomize amplitude
-- ENC 3 change frequency
--
-- first turn on AUX reverb!

engine.name = "TestSine"

function init()
  sound = 1
  level = 1
  octave = 1
  f = 100
  position = 0
  engine.hz(f)
  print("the end and the beginning they are the same.")
end

function key(n,z)
  if n == 2 then
    if z == 1 then
      -- trick below to toggle between 0 and 1
      sound = 1 - sound
      engine.amp(sound * level)
    end
  elseif n == 3 then
    octave = z + 1
    engine.hz(octave * f)
  end
end

function enc(n,d)
  if n == 2 then
    level = math.random(100) / 100
    engine.amp(sound * level)
  elseif n == 3 then
    position = (position + d) % 11
    f = 100 + position * 50
    engine.hz(octave * f)
  end
end
```

## addendum: go global {#addendum-global}

*This section is written for those with prior coding experience, to whom the question of 'local' versus 'global' variables in norns and Lua is curiosity-inducing. If this doesn't describe you, that's okay! Feel free to power through, or simply dog-ear this for later.*

Variables in Lua are *global* by default. This means that the variable is able to be referenced and used throughout the script. Using the `local` keyword makes a variable visible only to the scope within which it's declared.

To see what we mean, execute this in the REPL:

```lua
>> local hidden_spell = "foobarbaz"
```

You'll find that you can’t access `hidden_spell` in the REPL:

```lua
>> print(hidden_spell)
```

...returns `nil` as its output because the REPL only has access to *global* variables.

Locals declared within functions are only visible to that function (including `init`):

```lua
function init()
 local hidden_spell = "foobarbaz"
 cast()
end

function cast()
  print(hidden_spell)  
end
```

...will print `nil` to the REPL, because `hidden_spell` is *local* to the `init` function only.

Locals declared outside of functions are available to other functions within the file:

```lua
function init()
 cast()
end

local hidden_spell = "foobarbaz"

function cast()
  print(hidden_spell)  
end
```

... will print `foobarbaz` to the REPL, because `hidden_spell` is *local* to the entire script since we declared it outside of any specific function.

When scripting, global variables make it incredibly easy to troubleshoot from the REPL. Besides a few very specific phrases (see [the system global variable list](../reference/#system-globals)), you should feel safe using globals in your scripts. Each time a new script runs, the previously-declared global namespace is wiped, so there's no risk of cross-influence.

Declaring locals is often a matter of taste, but also utility + legibility:

```lua
engine.name = "TestSine"

function init()
  sound = 1
  level = 1
  f = 650
  engine.hz(f)
end

function enc(n,d)
  if n == 2 then
    local last_level = level
    level = math.random(100) / 100
    if level ~= last_level then
      engine.amp(sound * level)
    elseif level == last_level then
    -- level didn't change, so change note
      f = 650 / math.random(2,4)
      engine.hz(f)
    end
  end
end
```

## reference

### norns-specific
- `engine.list_commands()` -- list available engine commands (prints to command line)
- `print(x)` -- print value of `x` to REPL
- `init()` -- function which executes at script load
- `key(n,z)` -- function to parse norns keypresses
- `enc(n,d)` -- function to parse norns encoder movement

### general
- `math.random()` -- generates random values, see [this tutorial](http://lua-users.org/wiki/MathLibraryTutorial) for detailed usage
- `if`, `else`, and `elseif` -- conditional statements, see [Lua docs](https://www.lua.org/pil/4.3.1.html) for detailed usage
- `<`, `>`, `==`, etc -- relational operators, see [Lua docs](https://www.lua.org/pil/3.2.html) for detailed usage

## continued
{: .no_toc }

- part 0: [first light](../study-0) // learning to read and edit code
- part 1: many tomorrows
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids, MIDI, clock syncing
  - part 4b: [physical tangent: arc](../study-4b) // arc
- part 5: [streams](../study-5/) // system polls, OSC, file storage
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).