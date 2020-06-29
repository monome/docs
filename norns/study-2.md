---
layout: default
nav_exclude: true
permalink: /norns/study-2/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/274939031?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# patterning

norns studies part 2: screen drawing, for/while loops, tables

## ways of seeing

norns offers a view into its thoughts through a charmingly low-resolution screen. the 128 by 64 pixels can display 16 gradations from black to white.

each script defines what happens on the screen. an interface can be as complex or simple as you like.

start here:

```lua
-- patterning
-- norns study 2

engine.name = "PolySub"

function redraw()
  screen.clear()
  screen.move(0,40)
  screen.level(15)
  screen.text("The relationship between what we see and what we know")
  screen.update()
end
```

the familiar bits: start with some comments which are displayed in the menu selector, and then choose a sound engine to load. this time we're using `PolySub`.

`redraw` is new. it's the function that is called whenever the screen needs to be refreshed. if you don't have a redraw function in your script the screen will remain black.

let's step through:

- `screen.clear()` erases the screen
- `screen.move(0,40)` moves the current position to (x,y) = (0,40) in pixels. the top left of the screen is (0,0). as you move right x is increasing, and as you move down y is increasing.

![](../study-image/coordinate_system.gif)

- `screen.level(15)` sets the brightness. 0 = black, 15 = white. in between you get grays.
- `screen.text("The relationship between what we see and what we know")` prints some words.
- `screen.update()` refreshes the screen, updating the contents.

this is a pretty typical (despite being simple) drawing function. we set some attributes (such as level), set a position (with move) and then draw something (in this case, text). and don't forget `update` or nothing will happen!

## reveal

let's make something more interactive then. replace `redraw()` and add the other functions below:

```lua
function init()
  color = 3
  number = 84
end

function redraw()
  screen.clear()
  screen.level(color)
  screen.font_face(10)
  screen.font_size(20)
  screen.move(0,50)
  screen.text("number: " .. number)
  screen.update()
end

function key(n,z)
  color = 3 + z * 12
  redraw()
end

function enc(n,d)
  number = number + d
  redraw()
end
```

we're calling `redraw()` when we get encoder or key data in order to display the newest information. you can call `redraw()` conditionally whenever the screen needs to be updated: this may be on a keypress or a metro or on grid input or midi notes.

and `redraw()` can itself have much more logic involved. for example, we may want to use different modes or pages, such as:

```lua
function init()
  color = 3
  number = 84
  mode = 0
end

function redraw()
  if mode == 0 then
    screen.clear()
    screen.level(color)
    screen.font_face(10)
    screen.font_size(20)
    screen.move(0,50)
    screen.text("number: " .. number)
    screen.update()
  elseif mode == 1 then
    screen.clear()
    screen.move(0,20)
    screen.text("WILD")
    screen.update()
  end
end

function key(n,z)
  if n == 3 then
    mode = z
  else
    color = 3 + z * 12
  end
  redraw()
end

function enc(n,d)
  number = number + d
  redraw()
end
```

press KEY3 to toggle the mode.

a few new commands found their way in as well:

- `screen.font_face()` selects the font face
- `screen.font_size()` selects the font size

## so many commands

what in the world is `font_face 10`? how am i going to remember all of these commands?

this is a moment when you'll appreciate the reference docs. they live on norns and you can load them up right alongside maiden:

[http://norns.local/doc](http://norns.local/doc)

navigate to `screen` and then `font_face`. behold, a list of the available fonts!

but what is this! lines and rectangles?!

## which path

add this below `screen.text("WILD")`:

```lua
    screen.aa(1)
    screen.line_width(2)
    screen.move(60,30)
    screen.line(80,40)
    screen.line(90,10)
    screen.close()
    screen.stroke()
```

that's one wild smooth triangle.

- `screen.aa()` sets anti-aliasing: 0 = off, 1 = on
- `screen.line_width()` sets the line width in pixels (decimals ok)
- `screen.line()` draws a line from the current position to the specified position
- `screen.close()` closes the path (makes a line to the start position)
- `screen.stroke()` renders the path (also check out `screen.fill()`)

check out the rest of the reference docs for more drawing bliss and get out your code paintbrush.

## procedural

we've already looked at `if` / `ifelse` / `else` for basic control. let's look at a few other techniques:

```lua
x = 3
repeat
  print("we learn by repetition")
  x = x - 1
until x == 0
```

the `repeat ... until` loop construct follow this form:

```lua
repeat
  (commands)
until (condition == true)
```

this is sometimes helpful because `(commands)` are always run at least once.

here's another loop construct:

```lua
x = 3
while x > 0 do
  print("still learning")
  x = x - 1
end
```

which can be abstracted to:

```lua
while (condition == true)
  (commands)
end
```

these are very similar and can often be used interchangeably. it's best to pick one which best describes what you're trying to accomplish, so that the script is readable.

you'll notice in the previous examples we've been adding a value modifier on each iteration of the loop (ie `x = x - 1`). there is one more loop construct that you'll likely use quite often:

```lua
for i=1,3 do
  print("believe! " .. i)
end
```

this will print:

```
believe! 1
believe! 2
believe! 3
```

`for` is special for a few reasons:

- the syntax can have it create its own counter variable (in the above case, `i`)
- the counter is incremented on each iteration of the loop

let's draw some things (put this inside `redraw()`):

```lua
screen.clear()
screen.level(15)
for x = 0,16 do
  screen.move(x*8, 10)
  screen.line(128 - x*8, 50)
  screen.stroke()
end
screen.update()
```

you can also nest multiple `for` loops inside one another. think about how this works:

```lua
screen.clear()
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
```

## tables everywhere

in lua, tables are associative arrays. think spreadsheets. (when making music myself i get pretty psyched about spreadsheets.)

it's a way of storing, looking up, and manipulating a lot of data.

```lua
nothing = {}
drumzzz = {1,0,0,0,1,0,1,0}
```

tables are created with curly brackets. above, `nothing` is am empty table, `drumzzz` is a table with 8 elements.

elements of a table can be keyed with an index (number) or a string. let's add some data (you can try things out on the command line):

```lua
nothing[4] = 101
nothing["lasers"] = "off"
```

for elements keyed with a string, you can use a different syntax:

```lua
print(nothing.lasers)
```

this prints `off` if you did the assignment above. but note that:

```lua
print(nothing[lasers])
```

is an error! because `lasers` is nil (variable not defined), so `nothing[nil]` is nil.

when initializing a table with values (like `drumzzz`) the values are keyed incrementally starting from 1. so:

- `drumzzz[1] = 1`
- `drumzzz[2] = 0`
- `drumzzz[3] = 0`
- `drumzzz[4] = 0`
- `drumzzz[5] = 1`

we can insert and remove elements from a table:

```lua
table.insert(drumzzz, 11)
table.insert(drumzzz, 1, -1)
table.remove(drumzzz, 1)
```

- first we insert `11` at the end. afterwards we have: `{1,0,0,0,1,0,1,0,11}`
- next we insert `-1` at the beginning (at position 1), shifting the existing elements ahead. `{-1,1,0,0,0,1,0,1,0,11}`
- last we remove the element at position 1, shifting the remaining elements back. `{1,0,0,0,1,0,1,0,11}`

## the joy of data

we can get the length of a table using the `#` operator:

```lua
drumzzz = {1,0,0,0,1,0,1,0}
print(#drumzzz)
```

this prints `8`, which is the number of elements in the table. let's use this to display the whole table as steps in a sequence:

```lua
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
```

a few new techniques are here: `for i=1,#drumzzz do` means that the loop is performed for every element in `drumzzz` (which is 8 times). we use each element in the table to determine if we're going to draw a white line or a dark line. also new here is the `screen.line_rel()` function, which draws a line relative to the previous point. we specify (0,10) which is no movement in the x axis, and 10 pixels down in the y axis. we could have just written `screen.line(i*8, 50)`, but then consider trying some different spacing and positioning: `screen.move(i*4, 30)`. using the relative line function, you only change the `move` line and the relative coordinates follow, rather than having to change both lines.

tables can live inside tables! this is useful for two-dimensional structures.

```lua
steps = { {1,0,0,0},
          {0,1,0,0},
          {0,0,1,0},
          {0,0,0,1} }
```

i've typed this on multiple lines for visualization, but you can write it all in one line. you can now address this table with coordinates:

- `steps[1][1]` is 1 (top left)
- `steps[4][2]` is 0 (four down, two across)

one last table-talking-point. let's make a table with non-indexed elements:

```lua
moon = {}
moon.color = 15
moon.phase = 0
moon.hollowness = "?"
```

`#moon` will not return a length because these elements are not indexed. but we can use a technique to iterate through the list:

```lua
for key,value in pairs(moon) do
  print(key .. " = " .. value)
end
```

or better yet, let's get it on the screen:

```lua
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
```

## example: patterning

putting together concepts above. this script is demonstrated in the video up top.

```lua
-- patterning
-- norns study 2

engine.name = "PolyPerc"

function init()
  engine.release(3)
  notes = {}
  selected = {}
  -- build a scale, clear selected notes
  for m = 1,5 do
    notes[m] = {}
    selected[m] = {}
    for n = 1,5 do
      notes[m][n] = 55 * 2^((m*12+n*2)/12)
      selected[m][n] = 0
    end
  end
  light = 0
  number = 3
end

function redraw()
  screen.clear()
  for m = 1,5 do
    for n = 1,5 do
      screen.rect(0.5+m*9,0.5+n*9,6,6)
      l = 2
      if selected[m][n] == 1 then
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
    -- clear selected
    for x=1,5 do
      for y=1,5 do
        selected[x][y] = 0
      end
    end
    -- choose new random notes
    for i=1,number do
      selected[math.random(5)][math.random(5)] = 1
    end
  elseif n == 3 then
    -- find notes to play
    if z == 1 then
      for x=1,5 do
        for y=1,5 do
          if selected[x][y] == 1 then
            engine.hz(notes[x][y])
          end
        end
      end
      light = 7
    else
      light = 0
    end
  end
  redraw()
end

function enc(n,d)
  if n==3 then
    -- clamp number of notes from 1 to 4
    number = math.min(4,(math.max(number + d,1)))
  end
  redraw()
end
```


## continued

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: patterning
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids + midi
- part 5: [streams](../study-5/) // system polls, osc, file storage

## community

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to this study welcome, see [monome/docs](http://github.com/monome/docs)
