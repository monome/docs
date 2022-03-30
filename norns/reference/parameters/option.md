---
layout: default
nav_exclude: true
permalink: /norns/reference/parameters/option
---

## option

The *option* parameter type uses a table to populate a list of strings in the `PARAMETERS` menu, like when a script wants to know which MIDI device to send data to:

```lua
function init()
  midi_device_names = {}
  for i = 1,#midi.vports do
    midi_device_names[i] = i..": "..midi.vports[i].name
  end
  
  params:add{
    type = "option",
    id = "target_midi_device",
    name = "MIDI target",
    options = midi_device_names,
    default = 1,
    action = function(id) out_device = midi.connect(id) end
  }
  
  params:bang() -- this creates var 'out_device' and connects it to port 1
  
end
```

Note that in this example, we've declared an `action` which is called when the parameter changes values. We also used `params:bang()` to force `out_device` into existence and connect it to port 1 as a default.

Like with our number example, we can also declare our option parameter by using `params:add_option`:

```lua
function init()
  midi_device_names = {}
  for i = 1,#midi.vports do
    midi_device_names[i] = i..": "..midi.vports[i].name
  end
  
  params:add_option("target_midi_device", "MIDI target", midi_device_names, 1)
  params:set_action("target_midi_device", function(id) out_device = midi.connect(id) end)
  
  params:bang() -- this creates var 'out_device' and connects it to port 1
  
end
```

Note that using this type of helper requires a separate `set_action` declaration if we want to assign an action to occur when the parameter changes values.

We have two ways of querying the value of this parameter type. To get the *index* of the table:

```lua 
>> params:get("target_midi_device")
```

To get the *string* that's presented in the `PARAMETERS` menu:

```lua
>> params:string("target_midi_device")
```

This parameter type responds to E3 in the `PARAMETERS` menu.