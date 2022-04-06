---
layout: default
nav_exclude: true
permalink: /norns/reference/params
---

## params

### functions

| Syntax                                                          | Description                                                                                                                                                                                   |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| params.new(id,name)                                             | Create a parameter from scratch (not typical, but useful to have)                                                                                                                             |
| params:add_separator(name)                                      | Create a horizontal line with a title in the parameters menu to demarcate a section of controls (users can press K3 if selected to jump through separators)                                   |
| params:add_group(name,n)                                        | Group `n` controls under `name`, to help collapse parameter menu navigation. Note that groups cannot be made within groups (no nesting).                                                      |
| params:add(args)                                                | Create a parameter by passing an argument table                                                                                                                                               |
| params:add_number(id, name, min, max, default, formatter, wrap) | Create a parameter set for numbers                                                                                                                                                            |
| params:add_option(id, name, options, default)                   | Create a parameter set for option selection (options must be passed as a table)                                                                                                               |
| params:add_control(id, name, controlspec, formatter)            | Create a parameter set for controlspec formatting (see [controlspec](/docs/norns/reference/controlspec) for more details)                                                                     |
| params:add_file(id, name, path)                                 | Create a parameter set for file selection                                                                                                                                                     |
| params:add_text(id, name, text)                                 | Create a parameter set for text entry                                                                                                                                                         |
| params:add_taper(id, name, min, max, default, k, units)         | Create a parameter set for non-linear movement                                                                                                                                                |
| params:add_trigger(id, name)                                    | Create a parameter set for an "on/off" action trigger                                                                                                                                         |
| params:add_binary(id, name, behavior, default)                  | Create a parameter set for either momentary, toggle, or trigger behavior with a default state                                                                                                 |
| params:print()                                                  | Print the index, name, and value for each parameter to the REPL                                                                                                                               |
| params:list()                                                   | Print the names of each parameter to the REPL                                                                                                                                                 |
| params:lookup[id]                                               | Returns the index of a given parameter's string id                                                                                                                                            |
| params:get_id(index)                                            | Returns the string id of a given parameter's index                                                                                                                                            |
| params:string(id)                                               | Returns the string associated with the current value for a given parameter's id                                                                                                               |
| params:set(id,val,silent)                                       | Set a parameter's value, with optional action execution                                                                                                                                       |
| params:set_raw (index, v, silent)                               | Set a parameter's controlspec raw value, with optional action execution                                                                                                                       |
| params:get(id)                                                  | Returns a parameter's current number value                                                                                                                                                    |
| params:get_raw(id)                                              | Returns a parameter's controlspec raw value                                                                                                                                                   |
| params:set_action(id, function)                                 | Assign an action to a parameter's changes                                                                                                                                                     |
| params:t(index)                                                 | Returns a given parameter's type                                                                                                                                                              |
| params:get_range(index)                                         | Returns the min/max range of a parameter                                                                                                                                                      |
| params:get_allow_pmap(index)                                    | Returns whether a parameter is able to be MIDI-mapped (boolean)                                                                                                                               |
| params:hide(id)                                                 | Hides the specified parameter in the UI menu, but parameter index and data is still retained. Use `_menu.rebuild_params()` after hiding to dynamically rebuild the menu UI.                   |
| params:show(id)                                                 | Shows the specified parameter in the UI menu, after it is hidden (not required for default parameter building). Use `_menu.rebuild_params()` after hiding to dynamically rebuild the menu UI. |
| params:visible(id)                                              | Returns whether a parameter is visible in the UI menu (boolean)                                                                                                                               |
| params:write(filename,name)                                     | Save a `.pset` file of all parameters' current states to disk                                                                                                                                 |
| params:read(filename, silent)                                   | Read a `.pset` file from disk, restoring saved parameter states, with an option to avoid triggering parameters' associated actions                                                            |
| params.action_write = function(filename)                        | User script callback whenever a parameter write occurs, passes the `.pset`'s filename                                                                                                         |
| params.action_read = function(filename,name)                    | User script callback whenever a parameter read occurs, passes the `.pset`'s filename and name                                                                                                 |
| params:default()                                                | Read the default `.pset` file from disk, if available                                                                                                                                         |
| params:bang()                                                   | Trigger all parameters' associated actions                                                                                                                                                    |
| params:clear()                                                  | Clear all parameters (system toolkit, not for script usage)                                                                                                                                   |

### example

```lua
MusicUtil = require "musicutil"
math.randomseed(os.time())

function init()
  params:add_separator("test script")
  params:add_group("example group",3)
  for i = 1,3 do
    params:add{
      type = "option",
      id = "example "..i,
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
  params:add_option("grocery list","grocery list",groceries,1)
  params:add_control("frequency","frequency",controlspec.FREQ)
  params:add_file("clip sample", "clip sample")
  params:set_action("clip sample", function(file) load_sample(file) end)
  params:add_text("named thing", "my name is:", "")
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
  params:set("grocery list",math.random(params:get_range("grocery list")[1],params:get_range("grocery list")[2]))  
end
```

### parameter types

norns can support many types of parameter declarations, to facilitate the 'right' type of control for the musical task at hand.

The types, with linked examples, are:

- [number](./parameters/number)
- [option](./parameters/option)
- [control](./parameters/control)
- [file](./parameters/file)
- taper
- trigger
- binary
- text


### PSET save/load callback

Parameters are designed to make MIDI mapping and saving control values for a script very straightforward, using the [PMAP](/docs/norns/control-clock/#pmaps) and [PSET](/docs/norns/play/#saving-presets) functionality. However, you may find that you need to generate and save data which doesn't fit the parameters model, like tables of sequencer steps (though `awake` does show [how to efficiently work with patterns as parameters](https://github.com/tehn/awake/blob/73d4accfc090aaab58f1586eaf4d9cf54d3cff01/awake.lua#L62-L86)).

If you wish to perform additional actions when a PSET is saved or loaded, such as saving or loading non-params data into your script, `params.action_write` and `params.action_read` are two script-definable callback functions which are triggered whenever a PSET is saved or loaded. Here's a quick overview of their use:

```lua
function init()
  params.action_write = function(filename,name)
    print("finished writing '"..filename.."' as '"..name.."'")
  end
  params.action_read = function(filename)
    print("finished reading '"..filename.."'")
  end
end
```

Run the above and save a few PSETs in the `PARAMETERS > PSET` menu. You'll see the `action_write` callback print after each is saved. Try loading them back and you'll see the `action_read` callback print after each is read.

When paired with other norns utilities, like `tab.save` and `tab.load`, the `params.action_write` / `params.action_read` combination can help you save/restore script-generated tables while keeping the parameters UI clear, eg:

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
  params.action_write = function(filename,name)
    print("finished writing '"..filename.."' as '"..name.."'")
    os.execute("mkdir -p ".._path.data..'/params-example/'..name..'/')
    -- save to 'data/params-example/[the PSET's name]/notes.data':
    tab.save(note_data,_path.data..'/params-example/'..name..'/notes.data')
  end
  params.action_read = function(filename)
    print("finished reading '"..filename.."'")
    local loaded_file = io.open(filename, "r")
    if loaded_file then
      io.input(loaded_file)
      local pset_name = string.sub(io.read(), 4, -1) -- grab the PSET name from the top of the PSET file
      io.close(loaded_file)
      -- load saved PSET note data into our note_data table:
      note_data = tab.load(_path.data..'/params-example/'..pset_name..'/notes.data')
      my_seq:settable(note_data) -- send this restored table to the sequins
    end
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


### description

Parameters are a fundamental component of the norns toolkit. They allow you to associate controls and data to variables and functions within your scripts. They offer MIDI mapping and OSC addresses, as well as state save and restore.

For more information about UI interactions with params, see [the play docs](/docs/norns/play/#parameters).

For more information about scripting with params, see [study 3: spacetime](/docs/norns/study-3/#parameters).