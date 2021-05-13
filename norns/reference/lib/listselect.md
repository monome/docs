---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/listselect
---

## listselect

### control

| Syntax                  | Description                                                                                                                                                                                                   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ls.enter(list,callback) | Invokes `listselect` with the stated arguments. `list` is the list which will be selected from in `listselect`. `callback` requires a function which will take the selected item from `listselect` : function |

### example

```lua
listselect = require('listselect')
musicutil = require('musicutil')

function init()
  -- listselect used in params
  params:add_trigger('select_note','select fav note',1)
  params:set_action('select_note', function() listselect.enter(note_list,callback_note) end)

  -- defines the lists that we will be selecting from

  note_list = musicutil.NOTE_NAMES -- this is equivalent to note_list = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}, but we can borrow lists from elsewhere

  -- listselect only takes a 1-d table
  -- if we want to use a more complex set of data, we have to extract what we want from it to make a list
  -- in the following, we extract only the names of scales from musicutil.SCALES

  scale_list = {} -- create a scale name table
  for i,v in ipairs(musicutil.SCALES) do -- typical Lua idiom
    scale_list[i] = musicutil.SCALES[i].name -- extract the name of each scale and add it to our 1-d table
  end

end

function callback_scale(selected_scale) -- this defines the callback function that is used in our KEY 3 listselect
  if selected_scale ~= 'cancel' then -- if an item is selected in listselect
    fav_scale = selected_scale
  end
  redraw()
end

function callback_note(selected_note) -- this defines the callback function that is used in our PARAMETERS-based listselect
  if selected_note ~= 'cancel' then -- if an item is selected in listselect
    fav_note = selected_note
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)

  screen.move(0,10)
  screen.text('my favorite note is:')
  screen.move(0,20)
  if fav_note == nil then
    screen.text('select in params')
  else
    screen.text(fav_note)
  end

  screen.move(0,30)
  screen.text('my favorite scale is:')
  screen.move(0,40)
  if fav_scale == nil then
    screen.text('press K3 to select')
  else
    screen.text(fav_scale)
  end
  
  screen.update()
end

function key(n,z)
  if n == 3 and z == 1 then  
    listselect.enter(scale_list,callback_scale) -- when we press KEY 3, we enter listselect
  end
end
```

### description

`listselect` provides a standard interface for navigating through a list and selecting a desired item. It returns the item selected from the list as a string. If no item is selected, then it returns `cancel`. It can be used in params (see `fav_note` in the example above) or in the script (see `fav_scale` above). It is used in various norns system menus, like `WIFI`. 

Note that `listselect` only takes a "list", that is, just a 1-dimensional series of entries like `{'monday', 'tuesday', 'wednesday'}` and not an array like: 

```
{
  {day = 'monday', weather = 'good'},
  {day = 'tuesday', weather = 'fair'},
  {day = 'wednesday', weather = 'bad'}
}
```

Note also that `listselect` provides its own handlers for screen redraw, encoders, and keys. `listselect` automatically redraws the screen when its `.enter` function is invoked. K3 becomes ENTER, K2 becomes BACK. If K2 is pressed, `listselect` will exit and return to your script's UI with its own redraw.
