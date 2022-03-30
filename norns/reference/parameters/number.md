---
layout: default
nav_exclude: true
permalink: /norns/reference/parameters/number
---

## number

The *number* parameter type is helpful for defining parameters which require discrete incrementing values -- a transposition amount, for example:

```lua
function init()
  params:add{
    type = "number",
    id = "transpose_amount",
    name = "transpose",
    min = -48,
    max = 48,
    default = 0,
    formatter = function(param) return (param:get().." st") end
  }
end
```

If the above seems verbose, this accomplishes the same in fewer words:

```lua
function init()
  params:add_number("transpose_amount", "transpose", -48, 48, 0,
    function(param) return (param:get().." st") end
  )
end
```

The `formatter` can append meaning to a parameter's value (as we did with `st` to indicate *semitone* in the examples above), but it can also be used to completely change the presentation of a raw number, eg:

```lua
MusicUtil = require 'musicutil'

function init()
  params:add{
    type = "number",
    id = "root_note",
    name = "root note",
    min = 0,
    max = 127,
    default = 60,
    formatter = function(param) return MusicUtil.note_num_to_name(param:get(), true) end,
  } 
end
```

In the `PARAMETERS` menu, we see `C3` but if we execute `params:get("root_note")` in the command line, it returns `60`. This helps keep our UI artist-friendly, while we use the raw value to offset an outgoing stream of MIDI.

This parameter type responds to E3 in the `PARAMETERS` menu.