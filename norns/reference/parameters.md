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
| params:add_taper(id, name, min, max, default, k, units)         | Create a parameter set for linear numbers with a formatter                                                                                                                                    |
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
| params:hide(id)                                                 | Hides the specified parameter in the UI menu, but parameter index and data is still retained. Use `_menu.params_rebuild()` after hiding to dynamically rebuild the menu UI.                   |
| params:show(id)                                                 | Shows the specified parameter in the UI menu, after it is hidden (not required for default parameter building). Use `_menu.params_rebuild()` after hiding to dynamically rebuild the menu UI. |
| params:visible(id)                                              | Returns whether a parameter is visible in the UI menu (boolean)                                                                                                                               |
| params:write(filename,name)                                     | Save a `.pset` file of all parameters' current states to disk                                                                                                                                 |
| params:read(filename, silent)                                   | Read a `.pset` file from disk, restoring saved parameter states, with an option to avoid triggering parameters' associated actions                                                            |
| params:default()                                                | Read the default `.pset` file from disk, if available                                                                                                                                         |
| params:bang()                                                   | Trigger all parameters' associated actions                                                                                                                                                    |
| params:clear()                                                  | Clear all parameters (system toolkit, not for script usage)                                                                                                                                   |

### example

```lua
-- coming soon
```

### description

Params are a fundamental component of the norns toolkit. They allow you to associate controls and data to variables and functions within your scripts. They offer MIDI mapping and OSC addresses, as well as state save and restore.

For more information about UI interactions with params, see [the play docs](/docs/norns/play/#parameters).

For more information about scripting with params, see [study 3: spacetime](/docs/norns/study-3/#parameters).