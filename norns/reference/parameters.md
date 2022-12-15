---
layout: default
nav_exclude: true
permalink: /norns/reference/params
---

## params
{: .no_toc }

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### functions

| Syntax                                                          | Description                                                                                                                                                                                     |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| params.new(id, name)                                            | Create a parameter from scratch (not typical, but useful to have)                                                                                                                               |
| params:add_separator(id, name)                                  | Create a horizontal line with a title in the parameters menu to demarcate a section of controls (users can press K3 on any selected separator to jump through the menu's additional separators) |
| params:add_group(id, name, n)                                   | Group `n` controls under `name`, to help collapse parameter menu navigation. Note that groups cannot be made within groups (no nesting).                                                        |
| params:add(args)                                                | Create a parameter by passing an argument table                                                                                                                                                 |
| params:add_number(id, name, min, max, default, formatter, wrap) | Create a parameter set for numbers                                                                                                                                                              |
| params:add_option(id, name, options, default)                   | Create a parameter set for option selection (options must be passed as a table)                                                                                                                 |
| params:add_control(id, name, controlspec, formatter)            | Create a parameter set for controlspec formatting (see [controlspec](/docs/norns/reference/controlspec) for more details)                                                                       |
| params:add_file(id, name, path)                                 | Create a parameter set for file selection                                                                                                                                                       |
| params:add_text(id, name, text)                                 | Create a parameter set for text entry                                                                                                                                                           |
| params:add_taper(id, name, min, max, default, k, units)         | Create a parameter set for non-linear movement                                                                                                                                                  |
| params:add_trigger(id, name)                                    | Create a parameter set for an "on/off" action trigger                                                                                                                                           |
| params:add_binary(id, name, behavior, default)                  | Create a parameter set for either momentary, toggle, or trigger behavior with a default state                                                                                                   |
| params:print()                                                  | Print the index, name, and value for each parameter to the REPL                                                                                                                                 |
| params:list()                                                   | Print the names of each parameter to the REPL                                                                                                                                                   |
| params:get_id(index)                                            | Returns the string id of a given parameter's index                                                                                                                                              |
| params:lookup_param(index)                                      | Returns the param object at index; useful for useful for meta-programming tasks like changing a param once created                                                                              |
| params:string(id)                                               | Returns the string associated with the current value for a given parameter's id                                                                                                                 |
| params:set(id,val,silent)                                       | Set a parameter's value, with optional action execution                                                                                                                                         |
| params:set_raw (index, v, silent)                               | Set a parameter's controlspec raw value, with optional action execution                                                                                                                         |
| params:get(id)                                                  | Returns a parameter's current number value                                                                                                                                                      |
| params:get_raw(id)                                              | Returns a parameter's controlspec raw value                                                                                                                                                     |
| params:set_action(id, function)                                 | Assign an action to a parameter's changes                                                                                                                                                       |
| params:t(index)                                                 | Returns a given parameter's type                                                                                                                                                                |
| params:get_range(index)                                         | Returns the min/max range of a parameter                                                                                                                                                        |
| params:get_allow_pmap(index)                                    | Returns whether a parameter is able to be MIDI-mapped (boolean)                                                                                                                                 |
| params:hide(id)                                                 | Hides the specified parameter in the UI menu, but parameter index and data is still retained. Use `_menu.rebuild_params()` after hiding to dynamically rebuild the menu UI.                     |
| params:show(id)                                                 | Shows the specified parameter in the UI menu, after it is hidden (not required for default parameter building). Use `_menu.rebuild_params()` after hiding to dynamically rebuild the menu UI.   |
| params:visible(id)                                              | Returns whether a parameter is visible in the UI menu (boolean)                                                                                                                                 |
| params:write(filename, name)                                    | Save a `.pset` file of all parameters' current states to disk                                                                                                                                   |
| params:read(filename, silent)                                   | Read a `.pset` file from disk, restoring saved parameter states, with an option to avoid triggering parameters' associated actions                                                              |
| params:delete(filename, name, pset_number)                      | Delete a `.pset` file from disk                                                                                                                                                                 |
| params:default()                                                | Read the default `.pset` file from disk, if available                                                                                                                                           |
| params:bang()                                                   | Trigger all parameters' associated actions                                                                                                                                                      |
| params:clear()                                                  | Clear all parameters (system toolkit, not for script usage)                                                                                                                                     |

### additional tools

The function calls listed above are supplemented by additional helpers + extensions, which are formatted differently.

| Syntax                                                       | Description                                                                                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| params.lookup[id]                                            | A table call (note the square brackets) which returns the index of a given parameter's string id                          |
| params.action_write = function(filename, name, pset_number)  | User script callback whenever a parameter write occurs, which passes the `.pset`'s filename + UI name + PSET number       |
| params.action_read = function(filename, silent, pset_number) | User script callback whenever a parameter read occurs, which passes the `.pset`'s filename + `silent` state + PSET number |
| params.action_delete = function(filename, name, pset_number) | User script callback whenever a parameter delete occurs, which passes the `.pset`'s filename + name + PSET number         |

### example

```lua
MusicUtil = require "musicutil"
math.randomseed(os.time())

function init()
  params:add_separator("test_script_header", "test script")
  params:add_group("example_group", "example group", 3)
  for i = 1,3 do
    params:add{
      type = "option",
      id = "example_"..i,
      name = "parameter "..i,
      options = {"hi","hello","bye"},
      default = i
    }
  end
  params:add_number(
    "note_number", -- id
    "notes with wrap", -- name
    0, -- min
    127, -- max
    60, -- default
    function(param) return MusicUtil.note_num_to_name(param:get(), true) end, -- formatter
    true -- wrap
    )
  local groceries = {"green onions","shitake","brown rice","pop tarts","chicken thighs","apples"}
  params:add_option("grocery_list","grocery list",groceries,1)
  params:add_control("frequency","frequency",controlspec.FREQ)
  params:add_file("clip_sample", "clip sample")
  params:set_action("clip_sample", function(file) load_sample(file) end)
  params:add_text("named_thing", "my name is:", "")
  params:add_taper("taper_example", "taper", 0.5, 6.2, 3.3, 0, "%")
  params:add_separator()
  params:add_trigger("trig", "press K3 here")
  params:set_action("trig",function() print("boop!") end)
  params:add_binary("momentary", "press K3 here", "momentary")
  params:set_action("momentary",function(x) print(x) end)
  params:add_binary("toggle", "press K3 here", "toggle",1)
  params:set_action("toggle",function(x)
    if x == 0 then
      params:show("secrets")
    elseif x == 1 then
      params:hide("secrets")
    end
    _menu.rebuild_params()
  end)
  params:add_text("secrets","secret!!")
  params:hide("secrets")
  params:print()
  random_grocery()
end

function load_sample(file)
  print(file)  
end

function random_grocery()
  local ranged_list = params:get_range("grocery_list")
  params:set("grocery_list",math.random(ranged_list[1],ranged_list[2]))
end
```

### parameter types

norns can support many types of parameter declarations, to facilitate the 'right' type of control for the musical task at hand.

The types, with a few linked examples, are:

- [number](./parameters/number)
- [option](./parameters/option)
- [control](./parameters/control)
- [file](./parameters/file)
- taper
- trigger
- binary
- text

### IDs + collisions

Every parameter has its own ID, as well as a display string, which helps differentiate scripting syntax from what you see in the `PARAMETERS` UI menu.

eg.

```lua
params:add_number(
  'a_special_number', -- ID, used for scripting
  '*special number*', -- name, displayed in PARAMETERS UI menu
  0, -- min
  127, -- max
  63 -- default
)
```

A parameter's ID is special -- it's how the norns system communicates back and forth with the parameter the ID represents.

If a script overwrites a parameter's ID, norns will make some noise about it because some aspects of the previous instance of the ID are overwritten, which can cause unexpected results in a  script. For example:

```lua
function init()
  params:add_number(
    'a_special_number', -- ID, used for scripting
    '*special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    127, -- max
    63 -- default
  )
  params:add_number(
    'a_special_number', -- ID, used for scripting
    '*another special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    10, -- max
    4 -- default
  )
  print(params:get('a_special_number'))
end
```

Will cause the following to print to matron:

```bash
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!! ERROR: parameter ID collision: a_special_number
! please contact the script maintainer - this will cause a load failure in future updates
! BEWARE! clobbering a script or mod param
```

But more importantly, `print(params:get('a_special_number'))` will never reference the earlier instance of `a_special_number` -- it returns `4` at the script load, because `a_special_number`'s original default value of 63 was overwritten by a new default value of 4.

Separators and groups also have ID's, to assist with visibility (using `params:hide` and `params:show`, in conjunction with `_menu.rebuild_params()`). Since these parameter types don't reference actions, if IDs for either of these two parameter types are reused for another separator or group, norns will automatically 'steal' the ID and print a notice to matron. For example:

```lua
function init()
  params:add_separator('number_separator', 'first number')
  params:add_number(
    'a_special_number', -- ID, used for scripting
    '*special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    127, -- max
    63 -- default
  )
  params:add_separator('number_separator', 'second number')
  params:add_number(
    'another_special_number', -- ID, used for scripting
    '*another special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    10, -- max
    4 -- default
  )
  print(params:get('a_special_number'), params:get('another_special_number'))
end
```

Will print:

```bash
! stealing separator ID <number_separator> from earlier separator
```

If the separator or group uses a parameter ID already established for another parameter type, norns will *not* steal it. For example:

```lua
function init()
  params:add_separator('number_separator', 'first number')
  params:add_number(
    'a_special_number', -- ID, used for scripting
    '*special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    127, -- max
    63 -- default
  )
  params:add_separator('reverb', 'second number') -- uses a system parameter ID!
  params:add_number(
    'another_special_number', -- ID, used for scripting
    '*another special number*', -- name, displayed in PARAMETERS UI menu
    0, -- min
    10, -- max
    4 -- default
  )
  print(params:get('a_special_number'), params:get('another_special_number'))
end
```

Will print:

```bash
! separator ID <reverb> collides with a non-separator parameter, will not overwrite
```

*nb. while norns allows spaces in a parameter ID, it is best practice to use underscores*

### PSET save/load/delete callback

Parameters are designed to make MIDI mapping and saving control values for a script very straightforward, using the [PMAP](/docs/norns/control-clock/#pmaps) and [PSET](/docs/norns/play/#saving-presets) functionality. However, you may find that you need to generate and save data which doesn't fit the parameters model, like tables of sequencer steps (though `awake` does show [how to efficiently work with patterns as parameters](https://github.com/tehn/awake/blob/73d4accfc090aaab58f1586eaf4d9cf54d3cff01/awake.lua#L62-L86)).

If you wish to perform additional actions when a PSET is saved, loaded or deleted, such as managing non-params data into your script, `params.action_write` /  `params.action_read` / `params.action_delete` are script-definable callback functions which are triggered whenever a PSET is saved, loaded, or deleted. Here's a quick overview of their use:

```lua
function init()
  params.action_write = function(filename,name,number)
    print("finished writing '"..filename.."' as '"..name.."' and PSET number: "..number)
  end
  params.action_read = function(filename,silent,number)
    print("finished reading '"..filename.."' as PSET number: "..number)
  end
  params.action_delete = function(filename,name,number)
    print("finished deleting '"..filename.."' as '"..name.."' and PSET number: "..number)
end
```

Run the above and save a few PSETs in the `PARAMETERS > PSET` menu. You'll see the `action_write` callback print after each is saved. Try loading them back and you'll see the `action_read` callback print after each is read. Try deleting any and you'll see the `action_delete` callback print after each is deleted.

When paired with other norns utilities, like `tab.save` and `tab.load`, `params.action_write` / `params.action_read` / `params.action_delete` can help you manage script-generated tables while keeping the parameters UI clear, eg:

```lua
MusicUtil = require 'musicutil' -- see https://monome.org/docs/norns/reference/lib/musicutil
engine.name = 'PolyPerc' -- an included norns engine
s = require 'sequins' -- see https://monome.org/docs/norns/reference/lib/sequins

function init()
  base_note = math.random(30,50)
  my_seq = s{}
  notes_array = MusicUtil.generate_scale_of_length(base_note, "dorian", 16)
  generate_random_notes()
  play = false

  -- here, we set our PSET callbacks:
  params.action_write = function(filename,name,number)
    print("finished writing '"..filename.."' as '"..name.."'", number)
    os.execute("mkdir -p "..norns.state.data.."/"..number.."/")
    tab.save(note_data,norns.state.data.."/"..number.."/note.data")
  end
  params.action_read = function(filename,silent,number)
    print("finished reading '"..filename.."'", number)
    note_data = tab.load(norns.state.data.."/"..number.."/note.data")
    my_seq:settable(note_data) -- send this restored table to the sequins
  end
  params.action_delete = function(filename,name,number)
    print("finished deleting '"..filename, number)
    norns.system_cmd("rm -r "..norns.state.data.."/"..number.."/")
  end

end

function generate_random_notes()
  note_data = {}
  for j = 1,64 do
    -- auto-generate 64 steps of notes:
    note_data[j] = MusicUtil.snap_note_to_array(math.random(base_note, base_note+28),notes_array)
  end
  my_seq:settable(note_data) -- send this table of notes to the sequins
end

function play_notes()
  while true do
    clock.sync(1/3)
    engine.hz(MusicUtil.note_num_to_freq(my_seq())) -- PolyPerc accepts 'hz' arguments
    redraw()
  end
end

function key(n,z)
  if n == 3 and z == 1 then
    -- a simple start/stop mechanism
    -- can also be set to MIDI/Link transport: https://monome.org/docs/norns/clocks/#transport-callbacks
    play = not play
    if play then
      sequencer = clock.run(play_notes)
    else
      clock.cancel(sequencer)
      my_seq:reset()
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(120,55)
  screen.text_right(play and "K3: stop" or "K3: play")
  screen.move(30,30)
  screen.text(my_seq.ix..": "..note_data[my_seq.ix])
  screen.update()
end
```

### bundling PSETs with a script

When sharing a script with others, it may be desirable to bundle it with pre-made PSETs to give artists a collection of known starting points.

As you ready your script for sharing, you can use the standard PSET save UI in norns to build and name PSETs -- they will be saved under your device's `dust/data/(script)` folder. Then, create a `dust/code/(script)/data` folder and copy the generated PSET files from `dust/data/(script)` into it.

Behind the scenes, norns checks if a `dust/data/(script)` folder already exists on a script's first run -- if it doesn't, norns then checks if a `dust/code/(script)/data` folder exists. If it does and the folder has any `.pset` files in it, norns copies them from `code/(script)/data` to `dust/data/(script)`, which surfaces the PSETs in the on-screen UI menu.

As the PSET-bundled script is first loaded onto a norns which doesn't already have a corresponding `dust/data/(script)` folder, you will see the following print to matron:

```lua
# script clear
# script load: /home/we/dust/code/(script)/(script).lua
### initializing data folder
### copied default psets
# script run
```

To test, you can simply delete your `dust/data/(script)` folder *after* copying the `.pset` files to `dust/code/(script)/data`, and a fresh boot of the script will copy all the bundled PSETs into `dust/data/(script)`.

### adjusting parameter attributes after creation

Any created parameter can be adjusted after it has been built by using `params:lookup_param(index)`.

For example:

```lua
function init()
  params:add{
    type = 'control',
    id = 'loop_start',
    name = 'loop start',
    controlspec = controlspec.def{
      min = 0,
      max = 10,
      warp = 'lin',
      step = 1/100,
      default = 0,
      units = 's',
      quantum = 0.01
    }
  }
end
```

Using maiden's command line, we can query the `loop_start` parameter object:

```lua
>> tab.print(params:lookup_param('loop_start'))
action	function: 0x44d328
t	3
allow_pmap	true
name	loop start
controlspec	table: 0x425aa8
raw	  0
save	true
id	loop_start
```

And we can further inspect the parameter's `controlspec` def:

```lua
>> tab.print(params:lookup_param('loop_start').controlspec)
wrap	false
maxval	10
quantum	0.01
minval	0
step	0.01
warp	table: 0x490218
units	s
default	0
```

We can then modify the object with scripting (also, switching to `params:add_control` to reduce verbosity):

```lua
function init()
  params:add_option('loop_length','loop length', {'10 seconds','60 seconds'}, 1)
  params:set_action('loop_length',
    function(x)
      if x == 1 then
        params:lookup_param('loop_end').controlspec.maxval = 10
        params:lookup_param('loop_end').controlspec.quantum = 1/100
      elseif x == 2 then
        params:lookup_param('loop_end').controlspec.maxval = 60
        params:lookup_param('loop_end').controlspec.quantum = 1/600
      end
    end
  )
  params:add_control('loop_start', 'loop start', controlspec.new(0,10,'lin',1/100,0,'s',1/100))
  params:add_control('loop_end', 'loop end', controlspec.new(0,10,'lin',1/100,10,'s',1/100))
end
```

While scripting parameters after the script is running can be tons of fun, it's important to be mindful of the nuances of the object that you're modifying!

In the above example, we want changes to the `loop_end` parameter to delta +/- 0.1 seconds. When the controlspec's `maxval` is 10, our `quantum` of 1/100 yields 0.1 second changes (since 10 * 0.01 is 0.1). But when we change our `maxval` to 60, a `quantum` of 1/100 means each delta will increment or decrement by 1/100 *of the full 60 second range* -- this yields 0.6 second changes. So, we need to adjust the `quantum` to `1/600` when the range is 60 seconds, and we need to return the `quantum` to `1/100` when the range is 10 seconds.

Here's another example:

```lua
function init()
  color_options = {
    {'Red','Yellow','Blue'}, -- color_options[1]
    {'Orange', 'Green', 'Violet'}, -- color_options[2]
    {'Red-Orange', 'Yellow-Orange', 'Yellow-Green', 'Blue-Green', 'Blue-Violet', 'Red-Violet'}, -- color_options[3]
  }
  params:add_option('colors', 'colors', color_options[1], 1)
  
  params:add_option('color_set', 'color set', {'Primary','Secondary','Tertiary'}, 1)
  params:set_action('color_set',
    function(x)
      local color_param = params:lookup_param('colors')
      color_param.options = color_options[x]
      color_param.count = #color_options[x]
      color_param.selected = 1
    end
  )
end
```

Again, it's important to be mindful of the nuances of the object that you're modifying! For example:

- if we don't change the `color_param.count`, we can't select past the third color in our `Tertiary` color set

- if we don't reset `color_param.selected`, then we will receive errors if our currently selected color is beyond the number of options in our new color set

When in doubt, use `tab.print` to understand the parameter object you're hoping to modify, or study [the params source code](https://github.com/monome/norns/tree/main/lua/core/params).

### description

Parameters are a fundamental component of the norns toolkit. They allow you to associate controls and data to variables and functions within your scripts. They offer MIDI mapping and OSC addresses, as well as state save and restore.

For more information about UI interactions with params, see [the play docs](/docs/norns/play/#parameters).

For more information about scripting with params, see [study 3: spacetime](/docs/norns/study-3/#parameters).
