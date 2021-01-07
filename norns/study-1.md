---
layout: default
nav_exclude: true
permalink: /norns/study-1/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/273692952?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# many tomorrows

norns studies part 1: variables, simple maths, keys + encoders

## hello?

hello. ready? remember to stay hydrated.

first, locate yourself such:

- connect to norns via hotspot or network
- navigate web browser to http://norns.local (or type in IP address if this fails)
- you're looking at _maiden_, the editor
- create a new file in the `code` directory: click on the `code` directory and then click the + icon in the scripts toolbar
- rename the file: click the pencil icon in the scripts toolbar

it's blank. full of possibilities. type in the text below:

```lua
-- many tomorrows
-- norns study 1

engine.name = "TestSine"

function init()
  print("the end and the beginning they are the same.")
end
```

click save (the disk icon in the upper right) and then run (the play icon just below that).

if you typed it correctly, you'll hear a sine tone.

## what happened really

the top two lines are comments. in lua a comment begins with two dashes, and with norns the very top comments are special in that they are displayed as the preview text in the script selector. try it:

- get into the norns menu
- enter the script selector
- find your file, select it

you can type as many lines at the top of a script as you want, but note that the norns screen isn't so wide, so keep your lines short. it's helpful to write a description about your script and list the controls. but since so far this does basically nothing we write basically nothing.

but we did do one important thing: we selected an engine.

```lua
engine.name = "TestSine"
```

this line selected the `TestSine` engine--- note that this needs to be in quotes. this is an imperative first step.

next we create the init function, which gets called at script startup. right now all it does is print. but where does it print?

## robot hangout

the COMMAND LINE (aka REPL, read-eval-print loop) is where. it's the window below the editor. messages from matron (the lua machine) will appear here--- you can scroll back to see what it had to say.

when you execute the script with `print("some words")` then `some words` get printed to this place. it's incredibly helpful, despite this being possibly the most boring intro to such an astoundingly interesting music machine.

at the bottom is a `>>` prompt which is where you can type in commands. let's do that.

```lua
print("hello.")
```

and you'll see `hello.` printed in response. norns has _excellent_ manners.

but let's do something even more useful now:

```lua
engine.list_commands()
```

you'll see:

```
engine.list_commands()
--- engine commands ---
amp (f)
hz (f)
------
<ok>
```

this is useful information! for the "TestSine" engine we have two commands:

- `amp`
- `hz`

both are float (decimal) values. given the name "TestSine" we can infer that `amp` is amplitude and `hz` is frequency. so let's change some values:

```lua
engine.hz(200)
```

now is a good time to point out the UP ARROW on your keyboard. when typing into the command line use the up arrow to see the previous things you typed in. this makes rapid-changing of the frequency much easier. also try modulating the amplitude with `engine.amp(0.8)` (amplitude is 0.0-1.0, but you can certainly give it large values and it'll clip happily.)

so back to the script, if we want to have the engine start up with a particular frequency, we add it to the `init` function:

```lua
function init()
  engine.hz(100)
  print("the end and the beginning they are the same.")
end
```

try it. it works!

## numbers and strings

back to the command line. let's throw around some variables:

```lua
coins = 4
spell = "heal party"
```

we just made two variables. the first assigned the number 4, the second a string. you can easily confirm that it worked with:

```lua
print(coins)
```

this prints just the number. you'll find it helpful when debugging to make more informative prints by using _string concatenation_ which just means gluing strings together (or tying them together, if you prefer a more rational metaphor). you do this with the lua operator `..` (two periods):

```lua
print("i will cast " .. spell .. " for " .. coins .. " coins.")
```

(lua has a huge string library, many resources are on the web.)

(also, see addendum on local vs. global variables.)

## maths

all of the normal arithmetic operators are available:

```lua
coins = coins + 1
coins = coins - 10
coins = coins * 2
coins = coins / 4
coins = coins % 2
```

modulus (`%`) is perhaps unusual. it gives the remainder after a division. so: `11 % 10` would equal 1. we can use this as a trick for confining values to a range, say:

```lua
x = x % 10
```

for whatever value of x, it will be wrapped to the range 0-9.

and let's just make sure you know about this early on:

```lua
coins = math.random(100)
```

this assigns `coins` to a random value up to 100. but also:

```lua
engine.hz(math.random(10)*50+100)
```

## where is the fun

so far all of our interaction has been through the command prompt. this is a good way to demonstrate some basic syntax, but the point of norns is interaction. here's how we make an event happen on key presses:

```lua
function key(n,z)
  print("key " .. n .. " == " .. z)
end
```

type this in at the bottom of your script. save and rerun. then push some keys, you'll get some prints.

- `n` is which key number
- `z` is down (1) or up (0)

let's modify the script to do something more engaging:

```lua
function key(n,z)
  if n == 3 then
    engine.hz(100 + 100 * z)
  end
end
```

here we make an `if` statement:

```lua
if (condition) then
  (do stuff)
end
```

above we used `n == 3` as the condition, which checked to see if the key number was equal to 3. other comparison operators include:

- `==` (is equal)
- `~=` (not equal)
- `>` (greater than)
- `<` (less than)
- `>=` (greater or equal)
- `<=` (less than or equal)

`if` statements can also be expanded with `elseif` and `else`:

```lua
if coins > 100 then
  print("this bag is way too heavy")
elseif coins < 0 then
  print("who's calling?")
else
  print("two cups of coffee, please.")
end
```

# all of the fun

to get data from the encoders type this at the end of the script:

```lua
function enc(n,d)
  print("encoder " .. n .. " == " .. d)
end
```

here `d` is delta. the encoders report incremental steps of a turn: clockwise is positive, counterclockwise is negative.

we can accumulate these steps to get an absolute position:

```lua
function enc(n,d)
  if n == 3 then
    position = position + d
    print("encoder 3 at position: " .. position)
  end
end
```

replace your encoder function with this one, save and run. upon turning the encoder you'll get an error!

## the robots are mad

```
lua: /home/we/dust/code/study/study1-manyfutures.lua:19: attempt to perform arithmetic on a nil value (global 'position')
stack traceback:
/home/we/dust/code/study/study1-manyfutures.lua:19: in function 'encoders.callback'
/home/we/norns/lua/encoders.lua:56: in function 'encoders.process'
```

(your line number may be different, but the error the same). we made a small mistake. while you don't need to declare variables, you can't add `nil` to numbers and since:

```lua
position = position + d
```

assumes that `position` already exists, we have to first make it exist. just do that by adding a line inside of `init` which gives `position` a default value:

```lua
function init()
  position = 10
  engine.hz(100)
  print("the end and the beginning they are the same.")
end
```

but you may have already discovered error checking if you made some typos. for example:

```lua
print("we like to party"
```

gives `<incomplete>` (translation: typo. no closing parenthesis.)

so: be sure to keep an eye on the command line for errors.

## example: many tomorrows

putting together the concepts above. this script is demonstrated in the video up top.

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

## addendum

variables in lua are global by default. this means they are visible in any script and in the REPL. use the local keyword to make a variable visible only to the script that declared it:

```lua
local hidden_spell = "foobarbaz"
```

notice that you can’t access hidden_spell in the REPL:

```lua
>> print(hidden_spell)
```

produces the output: `nil`

it's OK to use global variables while you’re experimenting with a script, but it’s a good idea to add the local keyword when you’re done, because global variables can cause problems with other scripts and with the norns system. we're putting together a list of reserved variable names.

## reference

- `engine.list_commands()` -- list available engine commands (prints to command line)

## continued

- part 1: many tomorrows
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids + midi
- part 5: [streams](../study-5/) // system polls, osc, file storage

## community

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to this study welcome, see [monome/docs](http://github.com/monome/docs)
