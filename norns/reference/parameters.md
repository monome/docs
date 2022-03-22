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

#### PSET save/load callback

Params are designed to make MIDI mapping and saving control values for a script very straightforward, using the [PMAP](/docs/norns/control-clock/#pmaps) and [PSET](/docs/norns/play/#saving-presets) functionality. However, you may want to perform additional actions when a PSET is saved or loaded, such as saving or loading non-params data into your script.

`params.action_write` and `params.action_read` are two script-definable callback functions which are triggered whenever a PSET is saved or loaded. Here's a quick overview of their use:

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

### description

Params are a fundamental component of the norns toolkit. They allow you to associate controls and data to variables and functions within your scripts. They offer MIDI mapping and OSC addresses, as well as state save and restore.

For more information about UI interactions with params, see [the play docs](/docs/norns/play/#parameters).

For more information about scripting with params, see [study 3: spacetime](/docs/norns/study-3/#parameters).