---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/fileselect
---

## fileselect

### function

| Syntax                                   | Description                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
| fs.enter(folder,callback, filter_string) | Invokes `fileselect` with the stated arguments. `folder` is the folder which will be first displayed in `fileselect`. `callback` requires a function which will take the resulting path from `fileselect`. `filter_string` allows the script to filter displayed files by type (`"audio"` or `"all"`) or by format (eg. `".wav"`, `".flac"`, etc) : function |

### example: display audio files only

```lua
fileselect = require('fileselect')

selected_file = 'none'
selected_file_path = 'none'

function callback(file_path) -- this defines the callback function that is used in fileselect
  if file_path ~= 'cancel' then -- if a file is selected in fileselect
    -- the following are some common string functions to help organize the path that is returned from fileselect
    local split_at = string.match(file_path, "^.*()/")
    selected_file_path = string.sub(file_path, 9, split_at)
    selected_file_path = util.trim_string_to_width(selected_file_path, 128)
    selected_file = string.sub(file_path, split_at + 1)
    print(selected_file_path)
    print(selected_file)
  end
redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,10)
  screen.text('selected file path:')
  screen.move(0,20)
  screen.text(selected_file_path)
  screen.move(0,30)
  screen.text('selected file:')
  screen.move(0,40)
  screen.text(selected_file)
  screen.move(0,60)
  screen.text('press K3 to select file')
  screen.update()
end

function key(n,z)
  if n == 3 and z == 1 then
    fileselect.enter(_path.audio,callback, "audio") -- runs fileselect.enter; `_path.audio` in this example is the folder that will open when fileselect is run
  end
end
```

### description

`fileselect` provides a way to navigate directories from a given folder and to select a file from within that folder and any sub-folders. It returns the absolute path of the selected file. If no file is selected, then it returns `"cancel"`.

Note that `fileselect` provides its own handlers for screen redraw, encoders, and keys. `fileselect` automatically redraws the screen when its `.enter` function is invoked. K3 becomes ENTER, K2 becomes BACK. If K2 is pressed when on the top-level of the specified filepath, `fileselect` will exit and return to your script's UI with its own redraw.

In the example's `key` function, we use `_path.audio` as shorthand for `/home/we/dust/audio/`. Here are the other paths aliased within the `_path` table:

```
dust    /home/we/dust/
tape    /home/we/dust/audio/tape/
home    /home/we
code    /home/we/dust/code/
data    /home/we/dust/data/
audio    /home/we/dust/audio/
```
