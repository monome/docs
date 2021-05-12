---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/ui/list
---

## List

### control

| Syntax                                | Description                                                                                                                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| UI.List.new (x, y, index, entries)    | Create a new instance of list.<br>`x` and `y` are the screen coordinates where the list will begin: numbers <br>`index` is the default selected item : number <br>`entries` is a list of entries: table |
| my_list:set_index (index)             | Set index for the instance of list : number                                                                                                                                                             |
| my_list:set_index_delta (delta, wrap) | Set index for the instance of list using delta, with wrapping : number, boolean                                                                                                                         |
| my_list:redraw()                      | Redraw page with `list` elements for the instance of list                                                                                                                                               |

### query

| Syntax          | Description                               |
| --------------- | ----------------------------------------- |
| my_list.x       | Returns originating x-coordinate : number |
| my_list.y       | Returns originating y-coordinate : number |
| my_list.index   | Returns current index : number            |
| my_list.entries | Returns list of entries : list            |
| my_list.active  | Returns list's active state: boolean      |

### example

```lua
UI = require("ui")

-- create lists of entries

emotions = {'happy', 'angry', 'sad'}
places = {'park', 'pool', 'school'}
times = {'morning', 'afternoon','evening'}

-- creates instances of lists
list = {}
list[1] = UI.List.new(0,34,1,emotions) 
list[2] = UI.List.new(40,34,2,places)
list[3] = UI.List.new(80,34,3,times)

function redraw()
  screen.clear()
  screen.font_size(8)
  for i=1,3 do -- redraw three lists
    list[i]:redraw()
  end
  screen.move(0,8)
  screen.level(15)
  screen.text('i was '..emotions[list[1].index]..' at the '..places[list[2].index])
  screen.move(0,16)
  screen.text('in the '..times[list[3].index]..'.')
  screen.update()
end

function enc(n,d)
  if n == 1 then
    list[1]:set_index_delta(d,false) -- sets index according to delta of E1, no wrapping
  elseif n == 2 then
    list[2]:set_index_delta(d,true) -- sets index according to delta of E2, with wrapping
  elseif n == 3 then
    list[3]:set_index_delta(d,false) -- sets index according to delta of E2, with no wrapping
  end
  redraw()
end
```

### description

Creates a list in the on-screen UI. With a `screen.font_size` of 8, this UI can accommodate a maximum of six entries. For lists with more entries, see `ScrollingList`.

`UI.List.new` returns a table which should be stored in a variable (in the example, we nest three entries into the `list` table). The various other controls and queries can then be called using the assigned variable in the manner described above.

In the example above, the three instances of `UI.List` are nested into the `list` table: `list[1]`, `list[2]`, and `list[3]`.

The UI is drawn using the `my_list:redraw()` function, which needs to be called when there is a change.
