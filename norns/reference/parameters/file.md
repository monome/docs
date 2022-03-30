---
layout: default
nav_exclude: true
permalink: /norns/reference/parameters/file
---

## file

The *file* parameter type provides an easy way to load files into scripts, such as audio files into [softcut](/docs/norns/api/modules/softcut.html) buffers:

```lua
function init()
  params:add{
    type = "file",
    id = "sample_1",
    name = "sample 1",
    path = _path.audio,
    action = function(file) load_audio(file) end
  }
  softcut.enable(1,1)
  softcut.fade_time(1,0.01)
  softcut.level(1,1)
  softcut.loop(1,1)
  softcut.loop_start(1,0)
  redraw()
end

function load_audio(file)
  loaded_file = file
  local ch,samples,samplerate=audio.file_info(file)
  local duration = (samples/48000) < 280 and (samples/48000) or 280
  print("loading "..file)
  softcut.buffer_clear_channel(1)
  softcut.buffer_read_mono(file,0,0,duration,1,1)
  softcut.loop_end(1,duration)
  softcut.position(1,0)
  softcut.play(1,1)
end

function redraw()
  screen.clear()
  screen.move(0,30)
  if params:string("sample_1") ~= "" then
    screen.text("loaded: "..params:string("sample_1"))
  else
    screen.text("load sample via params")
  end
  screen.update()
end
```

Since file selection in a musical context is most often sample-based, the file parameter will cycle through the files in a folder by turning E3 while the parameter is highlighted. Try it yourself by running the code above and loading a sample from a folder of samples, eg. the `tehn` folder.

To perform this cycling from your script interface, you can use `params:delta(x)` -- this is true of any parameter type. To add this to the code above, simply drop in:

```lua
function enc(n,d)
  if n == 3 then
    params:delta("sample_1",d)
  end
end
```

This parameter type responds to K3 and E3 in the `PARAMETERS` menu. K3 will enter the file selector and E3 will cycle through the files in the shared folder.