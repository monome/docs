---
layout: default
nav_exclude: true
permalink: /norns/study-2/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/274939031?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# patterning
{: .no_toc }

norns studies part 2: screen drawing, for/while loops, tables

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

- [**conditions**](https://www.tutorialspoint.com/lua/lua_decision_making.htm): something to be evaluated or tested to help a script make decisions. We'll use `if`/`elseif`/`else` statements to demarcate what should happen when, using `==` to symbolize "is equal to" and `~=` to symbolize "is not equal to", eg:

  ```lua
  if performance == "good" then
      cheer()
  else
      politely_clap()
  end
  ```
 
  Note that `==` and `=` are two different things! `=` is how we assign a value to a variable.

- [**loop**](https://www.tutorialspoint.com/lua/lua_loops.htm): a task which should be repeated, which has its own counter built-in, eg:

	```lua
	for voices = 1,5 do
	  play_note()
	end
	```

- [**nesting**](https://www.tutorialspoint.com/lua/lua_nested_loops.htm): performing a task *inside* of another task, typically as a `for` loop or conditional, eg:

	```lua
	for measures = 1,16 do
	  for beats = 1,4 do
	    play_note()
	  end
	end
	```

- [**tables**](https://www.tutorialspoint.com/lua/lua_tables.htm): the only data structure available in Lua to create lists, arrays, dictionaries, etc. You construct them with curly brackets / braces **{ }**. Tables can be indexed with numbers or strings, using square brackets **[ ]**, and can be manipulated to grow or shrink as we need. You can think of tables like a musical scale, or a grocery list, or an entire score, eg:

	```lua
	major_scale = {0,2,4,5,7,9,11}
	grocery_list = {["eggs"] = 12,["bag_of_spinach"] = 2,["onion"] = 3,["feta"] = 1}
	my_song = {"intro","verse","chorus","verse","chorus","twenty_minute_jam_session","abrupt_stop"}
	```

## ways of seeing

norns offers a view into its thoughts through a charmingly low-resolution screen. The 128 by 64 pixels can display 16 gradations from black to white.

Each script defines what happens on the screen. An interface can be as complex or simple as you like.

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
-- study 2
-- code exercise
-- ways of seeing

engine.name = "PolySub"

function redraw()
  screen.clear()
  screen.move(0,40)
  screen.level(15)
  screen.text("The relationship between what we see and what we know")
  screen.update()
end
```

The familiar bits:

- start with some comments which are displayed in the menu selector
- choose a sound engine to load (this time we're using `PolySub`)

However, `redraw` is new. It's the function that's called whenever the screen needs to be refreshed. If you don't have a `redraw` function in your script the screen will remain black.

Let's step through the example's `redraw`:

- `screen.clear()` erases the screen.
- `screen.move(0,40)` moves the current position to (x,y) = (0,40) in pixels.
	- the top left of the screen is (0,0)
	- as you move right, x is increasing
	- as you move down, y is increasing

![](../study-image/coordinate_system.gif)

- `screen.level(15)` sets the brightness. 0 = nothing, 15 = full. In between you get gradients.
- `screen.text("The relationship between what we see and what we know")` prints a string (which even extends beyond our screen's boundaries).
- `screen.update()` refreshes the screen, updating the contents.

This is a pretty typical (despite being simple) drawing function. We set some attributes (such as `level`), set a position (with `move`) and then draw something (in this case, `text`). **Don't forget `update`, or else nothing will happen!**

### reveal

Let's make something more interactive. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- reveal

function init()
  level = 3
  number = 84
end

function redraw()
  screen.clear()
  screen.level(level)
  screen.font_face(10)
  screen.font_size(20)
  screen.move(0,50)
  screen.text("number: " .. number)
  screen.update()
end

function key(n,z)
  level = 3 + z * 12
  redraw()
end

function enc(n,d)
  number = number + d
  redraw()
end
```

What's happening:

- we use a variable called `level` to keep track of our display level
- we use a variable called `number` to keep track of a number
- we call `redraw()` when we interact with the `key`s or `enc`s in order to display the latest information
- we track `key` state (remember: `z` returns 1 for down, 0 for up) and use that to change the `level` of our text
- we track `enc` turns (remember: `d` is the delta of our rotation) and use that to change the `number` displayed

You can call `redraw()` conditionally whenever the screen needs to be updated: this may be on a keypress or a metro or on grid input or midi notes.

### conditional reveal

`redraw()` can itself have much more logic involved. For example, we may want to endow our script with different modes or pages. We'll use conditions to check the state of certain variables to make decisions about what should happen and when it should happen.

Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- conditional reveal

function init()
  level = 3
  number = 84
  mode = 0
end

function redraw()
  screen.clear()
  if mode == 0 then
    screen.level(level)
    screen.font_face(10)
    screen.font_size(20)
    screen.move(0,50)
    screen.text("number: " .. number)
    screen.update()
  elseif mode == 1 then
    screen.move(0,20)
    screen.text("WILD")
    screen.update()
  end
end

function key(n,z)
  if n == 3 then
    mode = z
  else
    level = 3 + z * 12
  end
  redraw()
end

function enc(n,d)
  number = number + d
  redraw()
end
```

And press KEY3 to toggle the mode.

Note that `mode = 0` and `mode == 0` are *not* the same thing -- the latter assigns the value `0` to the variable `mode`, whereas the former checks to see if the value of `mode` is equal to `0`.

A few new commands found their way in as well:

- `screen.font_face()` selects the font face  
- `screen.font_size()` selects the font size

**Be sure not to call `screen` functions outside of your script's `redraw()` function, otherwise your script will draw over the norns system menus.**

## so many commands

If you're worried about remember all of these norns scripting functions, you'll appreciate the reference docs. They live on norns and you can load them up from maiden by hovering over the `?` in the bottom left corner and selecting 'API'.

[There's also a web-accessible version here](https://monome.org/docs/norns/api/index.html).

Navigate to `Modules > screen` and then `Functions > screen.font_face`. Behold, a list of the available fonts!

But wait, there's so much in here! Lines and rectangles?!

### which path

In your `conditional reveal` code, add this below `screen.text("WILD")`:

```lua
    screen.aa(1)
    screen.line_width(2)
    screen.move(60,30)
    screen.line(80,40)
    screen.line(90,10)
    screen.close()
    screen.stroke()
```

That's one wild smooth triangle.

- `screen.aa()` sets anti-aliasing: 0 = off, 1 = on
- `screen.line_width()` sets the line width in pixels (decimals ok)
- `screen.line()` draws a line from the current position to the specified position
- `screen.close()` closes the path (makes a line to the start position)
- `screen.stroke()` renders the path (also check out `screen.fill()`)

Check out the rest of the reference docs for more drawing bliss and get out your code paintbrush.

## procedural

We've already looked at `if` / `elseif` / `else` for basic control. Let's look at a few other techniques.

### repeat...until

Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: repeat

function init()
  x = 3
  repeat
    print("we learn by repetition")
    x = x - 1
  until x == 0
end
```

Check the REPL for results.

The `repeat ... until` loop construct follows this form:

```lua
repeat
  (commands)
until (condition == true)
```

This is sometimes helpful because `(commands)` are always run at least once.

<details closed markdown="block">
  <summary>
    <i>Try writing out in words why the code snippet did what it did...</i>
  </summary>
  {: .text-delta }
- When the script initializes, variable `x` is set to `3`. We then enter a `repeat` loop where "we learn by repetition" is `print`ed, then `x` is set to itself *minus* `1`. So now, `x` is equal to `2`. We check to see if `x` is equal to `0`, but it's not, so we `repeat`.

- "we learn by repetition" is `print`ed a second time, then `x` is set to itself *minus* `1`, which means `x` is now equal to `1` -- since `x` is still not equal to `0`, we `repeat`.

- "we learn by repetition" is `print`ed a third time, then `x` is set to itself *minus* `1`, which means `x` is now equal to `0` -- since `x` is now equal to `0`, we can stop `repeat`ing!
</details>

### 'while' loop

Here's another loop construct. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: while

function init()
  x = 3
  while x > 0 do
    print("still learning")
    x = x - 1
  end
  print("done learning")
end
```

This construct can be abstracted to:

```lua
while (condition == true) do
  (commands)
end
```

<details closed markdown="block">
  <summary>
    <i>Try writing out in words why the code snippet did what it did...</i>
  </summary>
  {: .text-delta }
- When the script initializes, variable `x` is set to `3`. We then enter a `while` loop where our condition is whether `x` is greater than `0`. Since `3` is greater than `0`, "still learning" is `print`ed, then `x` is set to itself *minus* `1`. So now, `x` is equal to `2`. The loop continues.

- We check our condition of `x > 0` -- `2` is greater than `0`, so we continue. "still learning" is `print`ed, then `x` is set to itself *minus* `1`. So now, `x` is equal to `1`. The loop continues.

- We check our condition of `x > 0` -- `1` is greater than `0`, so we continue. "still learning" is `print`ed, then `x` is set to itself *minus* `1`. So now, `x` is equal to `0`. The loop continues.

- We check our condition of `x > 0` -- `0` is NOT greater than `0` (`0` is equal to `0`), so our `while` loop is broken and we can move on to the rest of the code and `print` "done learning".
</details>

These are very similar and can often be used interchangeably. It's best to pick one which best describes what you're trying to accomplish, so that the script is human-readable.

### 'for' loop

You'll notice in the previous examples we've been adding a value modifier on each iteration of the loop (eg. `x = x - 1`). There is one more loop construct that you'll likely use quite often. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: for

function init()
  for i=1,3 do
    print("believe! " .. i)
  end
end
```

This will print the following to the REPL:

```
believe! 1
believe! 2
believe! 3
```

`for` is special for a few reasons:

- the syntax can have it create its own counter variable (in the above case, `i`)
- the counter is incremented on each iteration of the loop

Let's draw some things with `for` loops. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: for

function init()
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  for x = 0,16 do
    screen.move(x*8, 10)
    screen.line(128 - x*8, 50)
    screen.stroke()
  end
  screen.update()
end
```

### nested 'for' loops

You can also nest multiple `for` loops inside one another. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: nested for

function init()
  for i = 0,3 do
    for j = 1,4 do
      print(i,j)
    end
  end
end
```

The following will print to the REPL:

```
0	1
0	2
0	3
0	4
1	1
1	2
1	3
1	4
2	1
2	2
2	3
2	4
3	1
3	2
3	3
3	4
```

<details closed markdown="block">
  <summary>
    <i>Try writing out in words why the code snippet did what it did...</i>
  </summary>
  {: .text-delta }

- When the script initializes, a `for` loop establishes a temporary variable named `i` that will iterate from `0` to `3`
  - inside of that `i` loop, another `for` loop establishes a temporary variable named `j` that will also iterate from `1` to `4` and `print` the current values of `i` and `j`
- For each single iteration of `i`, `j` will go through its entire loop
  - when `i` is `0`, `j` will loop through `1` to `4` and then `i` can progress to `1`
  - when `i` is `1`, `j` will loop through `1` to `4` and then `i` can progress to `2`
  - when `i` is `2`, `j` will loop through `1` to `4` and then `i` can progress to `3`
  - when `i` is `3`, `j` will loop through `1` to `4`
- Since `i` stops at `3`, the loop finishes!
</details>

#### simple loops lead to complex compositions

Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: simple loops

function init()
  redraw()
end

function redraw()
  screen.clear()
  screen.aa(1)
  screen.level(15)
  screen.line_width(0.5)
  for upper = 0,4 do
    for lower = 0,4 do
      screen.move(upper*31, 0)
      screen.line(lower*31, 60)
      screen.stroke()
    end
  end
  screen.update()
end
```

Why did this code snippet do what it did?

## tables everywhere

In Lua, tables are 'associative arrays' -- think spreadsheets. When making music, we get pretty psyched about spreadsheets because they're a way of storing, looking up, and manipulating a lot of data. **Tables are constructed with curly brackets: {}**

Execute the following on the command line:

```lua
>> nothing = {}
<ok> -- matron says "ok" when things are okay.
```

After you construct this table, matron tells you `<ok>`. We now have a variable, `nothing`, which is an empty table.

Elements of a table have a **key** (or **index**) which can be either a number or a string. Let's add some data to `nothing` by executing the following on the command line:

```lua
>> nothing[4] = 101
<ok>
>> nothing["lasers"] = "off"
<ok>
```

Again, matron will simply tell you `<ok>`. But how do we *know* that we've added these elements to our `nothing` table? Let's pass the name of our table as an argument to the `tab.print()` function:

```lua
>> tab.print(nothing)
4	101
lasers	off
<ok>
```

We can also query individual elements, by using bracket notation:

```lua
>> print(nothing[4])
101
<ok>
>> print(nothing["lasers"])
off
<ok>
```

(Need a symbol refresher? Revisit [first light](../study-0/#curly-braces-brackets-and-parentheses)!)

### make the robots mad: misusing syntax

Table keys are very specific -- these are unique identifiers which point to specific data!

For elements keyed with a string, you can choose your syntax:

```lua
>> print(nothing["lasers"])
off
<ok>
>> print(nothing.lasers)
off
<ok>
```

So `nothing["lasers"]` is the same as `nothing.lasers`, but what about:

```lua
>> print(nothing[lasers])
nil
<ok>
```

Why doesn't *this* syntax work?

Because `nothing.lasers` is just another way to represent `nothing["lasers"]` -- **a table indexed by a string**. However, `nothing[lasers]` is a table indexed by the value of the variable `lasers`, which hasn't been defined!

For example:

```lua
>> print(lasers)
nil
<ok>
```

Because value of `lasers` is nil (which is true of all undefined variables), `nothing[nil]` is nil.

### insert + remove

Let's start with a new table by executing the following on the command line:

```lua
>> drumzzz = {1,0,0,0,1,0,1,0}
<ok>
```

This constructs a new table `drumzzz` with 8 elements.

When initializing a table with values (like `drumzzz`) the values are keyed incrementally starting from 1. So:

- `drumzzz[1] = 1`
- `drumzzz[2] = 0`
- `drumzzz[3] = 0`
- `drumzzz[4] = 0`
- `drumzzz[5] = 1`

We can insert and remove elements from an integer-keyed table in different ways, depending on the arguments we supply our functions:

- `table.insert(table, [pos,] value)`
	- inserts a value into the table at specified position
	- if no position is provided, value will be inserted at the end of the table
- `table.remove(table [, pos])`
	- removes the value at a specified position from the table
	- if no position is provided, the value at the end of the table will be removed

([source](https://www.tutorialspoint.com/lua/lua_tables.htm))

For example:

```lua
>> table.insert(drumzzz, 11)
<ok>
```

The above code snippet will create a 9th element in `drumzzz`, which will contain the value `11`.


Let's insert another element, but we'll add it to the beginning of the table:

```lua
>> table.insert(drumzzz, 1, -1)
<ok>
```

By inserting `-1` at the beginning of `drumzzz` (at position 1), we also shift the existing elements ahead by one, eg:

```lua
>> tab.print(drumzzz)
1	-1
2	1
3	0
4	0
5	0
6	1
7	0
8	1
9	0
10	11
<ok>
```

Let's remove the element at position 1, shifting the remaining elements back:

```lua
>> table.remove(drumzzz, 1)
-1
<ok>
```

This is new! `table.remove` will actually return the value it's removing from the table. Interesting...

Check the contents of `drumzzz` to see if it worked!

### the joy of data

We can get the length of a table using the `#` operator:

```lua
>> drumzzz = {1,1,0,0,1,0,1,0}
<ok>
>> print(#drumzzz)
8
<ok>
```

Let's use the `#` operator to display the whole table as steps in a sequence. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: joy of data

drumzzz = {1,1,0,0,1,0,1,0}

function redraw()
  screen.clear()
  for i=1,#drumzzz do
    screen.move(i*8, 40)
    screen.line_rel(0,10)
    if drumzzz[i] == 1 then
      screen.level(15)
    else
      screen.level(3)
    end
    screen.stroke()
  end
  screen.update()
end
```

A few new techniques:

- `for i=1,#drumzzz do` means that the loop is performed for every element in `drumzzz` (which is 8 times)
- we use each element in the table to move along the screen's x axis with `screen.move(i*8, 40)`
- after each movement, we call the `screen.line_rel()` function (which draws a line relative to the previous point) and specify (0,10) -- no movement in the x axis, 10 pixels down in the y axis
- if the current element is 1, we draw a bright line -- otherwise, we draw a dark line

### nested tables

So far, we've been working with one-dimensional tables -- each time, we end up constructing a single lane of information. But tables can live inside tables! This is useful for two-dimensional structures, where we might want to create an array of many rows and columns. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: nested tables

function init()
  steps = { {1,0,0,0},
            {0,1,0,0},
            {0,0,1,0},
            {0,0,0,1} }
end
```

(We typed this on multiple lines for visualization, but you can write it all in one line.)

You can now query this table with coordinates as indices on the command line:

```lua
>> steps[1][1] -- top-left
1
>> steps[4][2] -- four down, two across
0
```

We can constructed nested tables manually as we did above, but we could also use nested 'for' loops and conditionals to create them algorithmically. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: nested tables

function init()
  steps = {} -- a one-dimensional table
  for row = 1,4 do -- rows 1 to 4
    steps[row] = {} -- create a table for each row
    for column = 1,4 do -- columns 1 to 4
      if row == column then -- eg. if coordinate is (3,3)
        steps[row][column] = 1
      else -- eg. if coordinate is (3,2)
        steps[row][column] = 0
      end
    end
  end
end
```

### indexing with strings

One last table-talking-point -- let's make a table with *string* indices instead of numerical indices. Clear the previous code and start anew with:

```lua
-- study 2
-- code exercise
-- procedural: indexing

function init()
  moon = {}
  moon.color = 15
  moon.phase = 0
  moon.hollowness = "?"
end
```

Let's try some of the surveying techniques demonstrated in previous sections:

```lua
>> tab.print(moon)
color	15
hollowness	?
phase	0
<ok>
>> #moon
0
```

Wait wait wait -- `moon` definitely has elements, so why does `#moon` return `0`? Because Lua's *length* operator (`#`) is defined by **integer** indices -- so **strings** are simply not counted.

But what if we want to do something with each of the elements of the `moon` table? Well, if we try to do something like:

```lua
for i = 1,#moon do
  -- stuff
end
```

...then nothing will happen, because our `for` loop is iterating from 1 to 0 (which is what `#moon` returns).

So how do we iterate through the pairs (eg. `color` and `15`)?

In this case, we can use Lua's [`pairs` function](https://www.lua.org/pil/4.3.5.html) to iterate through all of the keys and their values, regardless of whether the index is a number or string.

Let's modify our previous code to use the basic DNA of a `for` loop which goes through `pairs` of keys and their values:

```lua
-- study 2
-- code exercise
-- procedural: indexing

function init()
  moon = {}
  moon.color = 15
  moon.phase = 0
  moon.hollowness = "?"
  for key,value in pairs(moon) do
    print(key .. " = " .. value)
  end
end
```

And you'll see the following printed to the REPL:

```lua
color = 15
hollowness = ?
phase = 0
```

Better yet, let's get it on the screen:

```lua
-- study 2
-- code exercise
-- procedural: indexing

function init()
  moon = {}
  moon.color = 15
  moon.phase = 0
  moon.hollowness = "?"
  for key,value in pairs(moon) do
    print(key .. " = " .. value)
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,0)
  line = 1
  for key,value in pairs(moon) do
    screen.move(0,line*10)
    screen.text(key)
    screen.move(127,line*10)
    screen.text_right(value)
    line = line + 1
  end
  screen.update()
end
```

## example: patterning

Putting together concepts above. This script is demonstrated in the video up top.

```lua
-- patterning
-- norns study 2

engine.name = "PolyPerc"

function init()
  engine.release(3)
  notes = {} -- create a 'notes' table
  selected = {} -- create a 'selected' table to track playing notes
  
  -- lets create a 5x5 square of notes:
  for m = 1,5 do -- a 'for' loop, where m = 1, then m = 2, etc
    notes[m] = {} -- use m as an vertical index for 'notes'
    selected[m] = {} -- use m as a vertical index for 'selected'
    for n = 1,5 do -- another 'for' loop, where n = 1, then n = 2, etc
      -- n is our horizontal index
      notes[m][n] = 55 * 2^((m*12+n*2)/12) -- this is just fancy math to get some notes
      selected[m][n] = false -- all start unselected
    end
  end
  light = 0
  number = 3 -- our maximum number of notes to play at one time
end

function redraw()
  screen.clear()
  for m = 1,5 do
    for n = 1,5 do
      screen.rect(0.5+m*9,0.5+n*9,6,6) -- (x,y,width,height)
      l = 2
      if selected[m][n] then
        l = l + 3 + light
      end
      screen.level(l)
      screen.stroke()
    end
  end
  screen.move(10,60)
  screen.text(number)
  screen.update()
end

function key(n,z)
  if n == 2 and z == 1 then
    -- clear selected notes
    for x=1,5 do
      for y=1,5 do
        selected[x][y] = false
      end
    end
    -- choose new random notes
    for i=1,number do
      selected[math.random(5)][math.random(5)] = true
    end
  elseif n == 3 then
    -- find notes to play
    if z == 1 then -- key 3 down
      for x=1,5 do
        for y=1,5 do
          if selected[x][y] then
            engine.hz(notes[x][y])
          end
        end
      end
      light = 7 -- adds 7 to the square's screen level
    elseif z == 0 then -- key 3 up
      light = 0 -- adds 0 to the square's screen level
    end
  end
  redraw()
end

function enc(n,d)
  if n==3 then
    -- clamp number of notes from 1 to 4
    number = util.clamp(number + d,1,4)
  end
  redraw()
end
```

## reference
### norns-specific
- `redraw()` -- function to refresh the norns screen
- `screen` -- module to draw specific things to the norns screen, see [`screen` API docs](https://monome.org/docs/norns/api/modules/screen.html) for detailed usage

### general
- `repeat` and `until` -- perform action until condition is true, see [Lua docs](https://www.lua.org/pil/4.3.3.html) for detailed usage
- `while` -- perform action while condition is true, see [Lua docs](https://www.lua.org/pil/4.3.2.html) for detailed usage
- `for` -- perform action a specific number of times, see [Lua docs](https://www.lua.org/pil/4.3.4.html) for detailed usage
- `{}` -- tables help store, look up, and manipulate lots of data, see [Lua docs](https://www.lua.org/pil/2.5.html) for detailed usage

## continued
{: .no_toc }

- part 0: [first light](../study-0/) // learning to read and edit code
- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: patterning
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids, MIDI, clock syncing
  - part 4b: [physical tangent: arc](../study-4b) // arc
- part 5: [streams](../study-5/) // system polls, OSC, file storage
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).
