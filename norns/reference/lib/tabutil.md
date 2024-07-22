---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/tabutil
---

## tab
{: .no_toc }

Table utilities.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### control

| Syntax                                      | Description                                                                                                                                                                                                                                                                                                        |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| tab.print(t)                                | Prints the contents of table `t`.                                                                                                                                                                                                                                                                                  |
| tab.sort(t)                                 | Return a lexigraphically-sorted array of keys for a table.                                                                                                                                                                                                                                                         |
| tab.count(t)                                | Count the number of entries in a table; unlike `table.getn()` or `#table`, `nil` entries won't break the loop.                                                                                                                                                                                                     |
| tab.contains (t, e)                         | Search table `t` for element `e`. Returns boolean.                                                                                                                                                                                                                                                                 |
| tab.invert(t)                               | Given a simple table of primitives `t`, "invert" it so that values become keys and vice versa. Returns inverted table.                                                                                                                                                                                             |
| tab.key(t, e)                               | Search table `t` for element `e`, return its key.                                                                                                                                                                                                                                                                  |
| tab.lines(str)                              | Split multi-line string `str` (with line breaks) into table of strings. Returns table of strings.                                                                                                                                                                                                                  |
| tab.save(t, filename)                       | Save table `t` to disk as `filename`.                                                                                                                                                                                                                                                                              |
| tab.load(saved_file)                        | Load tab.save()'d table from file `saved_file`.                                                                                                                                                                                                                                                                    |
| tab.readonly{params}                        | Create a read-only proxy for a given table, following the provided `params`. Notice the use of curly braces here!<br/>* `params.table` is the table to proxy<br/>* `params.except` is a list of writable keys<br/>* `params.expose` limits which keys from `params.table` are exposed<br/>Returns read-only table. |
| tab.gather(default_values, custom_values)   | Returns a new table, gathering values first from `default_values`, then from `custom_values` (nils are ignored).                                                                                                                                                                                                   |
| tab.update(table_to_mutate, updated_values) | Mutate table `table_to_mutate`, updating values from another table `updated_values`.                                                                                                                                                                                                                               |
| tab.select_values (t, condition)            | Create a new table with all values from table `t` that pass the test implemented by the provided function `condition`.                                                                                                                                                                                             |

### description

Tables are data structures which contain arrays, dictionaries, collections of symbols, etc. If you're familiar with other programming languages, Lua treats tables like associative arrays and they're the *only* "container" in the language. See this section of [Programming In Lua](https://www.lua.org/pil/11.html) for more information.

### simple table query and manipulation

In this example, we'll demonstrate how to use this library's basic functions to query tables in Lua, as well as how to use actions like `sort` and `invert`.

```lua
-- tabutil example: simple table query and manipulation

values = {
  400,
  391,
  202,
  12039,
}

mana = {
  white = {"order", "peace", "light"},
  blue = {"intellect", "logic", "manipulation"},
  black = {"power", "death", "corruption"},
  red = {"freedom", "chaos", "fury"},
  green = {"life", "nature", "evolution"}
}

steps = {
  [1] = {midi_notes = {42,49,35}},
  [4] = {midi_notes = {37,30}},
  [9] = {midi_notes = {48,41,53}}
}

simple = {
  "apple",
  "banana",
  "cherry"
}

multiline_string = [[hello!!
this is a big old chunk of text.
it's something which i'd like to break up
into a few table entries.]]

function init()
  print(" ")
  print("each entry in table 'values':")
  tab.print(values)

  print(" ")
  print('alpha-sorted mana:')
  local sorted_mana = tab.sort(mana)
  tab.print(sorted_mana)

  print(" ")
  print("~~~ how many 'steps'? ~~~")
  print("tab.count counts all non-nil entries: " .. tab.count(steps))
  print("#steps doesn't breaks with nil entries: " .. #steps)

  print(" ")
  print("is intellect associated with blue mana?")
  print(tab.contains(mana.blue, 'intellect'))
  print("is 331 in the 'values' table?")
  print(tab.contains(values, 331))
  print("does step 9's midi notes contain 53?")
  print(tab.contains(steps[9].midi_notes, 53))

  print(" ")
  print("which position is banana in?")
  local inverted_simple = tab.invert(simple)
  print(inverted_simple.banana)
  print("...testing another way to find banana's position...")
  print("banana is in position: "..tab.key(simple, 'banana'))

  print(" ")
  print("breaking up the big multiline_string...")
  local linebroken = tab.lines(multiline_string)
  for i = 1, tab.count(linebroken) do
    print("line "..i..": "..linebroken[i])
  end
end
```

### table save and load

In this example, we'll demonstrate how to save a table to the norns disk (under `dust/data/<scriptname>/test-table.txt`) and load it again in future sessions.

```lua
-- tabutil example: table save and load

function init()
  random_file_exists = util.file_exists(norns.state.data.."test-table.txt")
  random_values = {
    math.random(100),
    math.random(100),
    math.random(100)
  }
end

function key(n,z)
  if n == 3 and z == 1 then
    local filename = norns.state.data.."test-table.txt"
    tab.save(random_values, filename)
    print("saved some random values to "..filename)
    random_file_exists = true
  elseif random_file_exists and n == 2 and z == 1 then
    local filename = norns.state.data.."test-table.txt"
    random_values = tab.load(filename)
  end
  redraw()
end

function enc(n,d)
  random_values[n] = util.clamp(random_values[n] + d, 0, 100)
  redraw()
end

function redraw()
  screen.clear()
  for i = 1,#random_values do
    screen.move(0,10*i)
    screen.text("value "..i..": "..random_values[i])
  end
  screen.move(120,50)
  screen.text_right(random_file_exists and "K2: load saved values" or "")
  screen.move(120,60)
  screen.text_right("K3: save current values")
  screen.update()
end
```

### advanced table manipulation

Often, newcomers to Lua will be surprised by the results of this code:

```lua
notes = {30,50,72}

function octave_up()
  local new_notes = notes
  for i = 1,3 do
    new_notes[i] = new_notes[i]+12
  end
  print("new notes:")
  tab.print(new_notes)
  print("old notes:")
  tab.print(notes)
end

function init()
  print("starting notes:")
  tab.print(notes)
  clock.run(
    function()
      clock.sleep(1)
      octave_up()
    end
  )
end
```

A common assumption is that `new_notes = notes` goes through and assigns all the values of `notes` to `new_notes`, resulting in two unique tables. However, upon running the script, we see:

```bash
# script init
starting notes:
1    30
2    50
3    72
new notes:
1    42
2    62
3    84
old notes:
1    42
2    62
3    84
# these ID's are unique each run, but they're always the same as each other:
table: 0x4aced0    table: 0x4aced0
```

This is because `new_notes = notes` simply *aliases* or *links* `notes` with `new_notes` -- they refer to the same piece of data, as we can see with `print(notes, new_notes)` at the end of `octave_up()`. So even though `new_notes` is *local* to our `octave_up` function, any change to it will also propagate to `notes`.

In order to make an independent copy of a table, we can use `tab.select_values`, which allows us to specify a table from which to conditionally select values for a new table to be made:

```lua
notes = {30,50,72}

function octave_up()
  local new_notes = tab.select_values(notes,function() return true end)
  for i = 1,3 do
    new_notes[i] = new_notes[i]+12
  end
  print("new notes:")
  tab.print(new_notes)
  print("old notes:")
  tab.print(notes)
  print(notes, new_notes)
end

function init()
  print("starting notes:")
  tab.print(notes)
  clock.run(
    function()
      clock.sleep(1)
      octave_up()
    end
  )
end
```

Upon running the script, we see:

```bash
# script init
starting notes:
1    30
2    50
3    72
new notes:
1    42
2    62
3    84
old notes:
1    30
2    50
3    72
table: 0x5ae3d8    table: 0x448998
```

This even works for nested tables, by re-building the top-most part of the data structure:

```lua
mana = {
  white = {"order", "peace", "light"},
  blue = {"intellect", "logic", "manipulation"},
  black = {"power", "death", "corruption"},
  red = {"freedom", "chaos", "fury"},
  green = {"life", "nature", "evolution"}
}

function init()
  new_mana = tab.select_values(mana, function() return true end)
  print(mana, new_mana, mana == new_mana and "| tables are the same :(" or "| tables are different!")
  new_mana.green = {"death", "factory", "stagnation"}
  print("old green mana")
  tab.print(mana.green)
  print("new green mana")
  tab.print(new_mana.green)
end
```

We can also use `tab.select_values` to selectively gather values which meet certain conditions without having to worry about building complex functions:

```lua
sequence = {60,42,54,55,57,39,70}

function init()
  hi_notes = tab.select_values(sequence, function(value,key) return value >= 55 end)  
  lo_notes = tab.select_values(sequence, function(value,key) return value < 55 end)
  print('high notes')
  tab.print(hi_notes)
  print('low notes')
  tab.print(lo_notes)
end
```

### gather and update

The `tab` library also provides two functions for merging and weaving tables together.

#### gather

If tables `t1` and `t2` share keys / indices, `tab.gather(t1,t2)` will use `t2` to overwrite as much of `t1` as it can. For example, this code:

```lua
t1 = {60, 55, 57, 70, 59}
t2 = {39, 42, 54}

function init()
  local t3 = tab.gather(t1,t2)
  tab.print(t3)
end
```

Will result in:

```bash
1    39
2    42
3    54
4    70
5    59
```

Any time `t2`'s indices cross over with `t1`, the value in `t1` will be replaced with the value from `t2`. **Note that the resulting table is always as many entries deep as the first table provided.**

If tables `t1` and `t2` do not share indices, the resulting table changes in response. As `gather` iterates through each of `t1`'s indices, it checks to see if `t2` holds a corresponding entry at that index -- if yes then it will choose `t2`'s value for the new table, otherwise it will migrate `t1`'s value:

```lua
t1 = {
  [1] = 60,
  [5] = 55,
  [7] = 57,
  [10] = 70,
  [15] = 59
}

t2 = {
  [5] = 39,
  [6] = 42,
  [8] = 16,
  [10] = 54,
  [12] = 60
}

function init()
  t3 = tab.gather(t1,t2)
end
```

Will result in table `t3` with these indices and values:

```bash
t3[1] = 60 # from t1
t3[5] = 39 # from t2
t3[7] = 57 # from t1
t3[10] = 54 # from t2
t3[15] = 59 # from t1
```

#### update

Rather than using `t1`'s indices to generate a new table, `update` will include all index/value pairs from `t2` as well as overwrite any values for indices shared with `t1`. **Unlike `tab.gather`, `tab.update` can result in tables with more entries than the first table provides.**

For example:

```lua
t1 = {
  [1] = 60,
  [5] = 55,
  [7] = 57,
  [10] = 70,
  [15] = 59
}

t2 = {
  [5] = 39,
  [6] = 42,
  [8] = 16,
  [10] = 54,
  [12] = 60
}

function init()
  t3 = tab.update(t1,t2)
end
```

Will result in table `t3` with these indices and values:

```bash
t3[1] = 60 # from t1
t3[5] = 39 # from t2: value overwrite
t3[6] = 42 # from t2: new index and value added
t3[7] = 57 # from t1
t3[8] = 16 # from t2: new index
t3[10] = 54 # from t2: value overwrite
t3[12] = 60 # from t2: new index and value added
t3[15] = 59 # from t1
```
