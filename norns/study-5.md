---
layout: default
nav_exclude: true
permalink: /norns/study-5/
---

<div class="vid"><iframe src="https://player.vimeo.com/video/292401792?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# streams
{: .no_toc }

norns studies part 5: system polls, OSC, file storage

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## numerical superstorm

So far we've explored many ways of pushing data around towards musical ends: metronomes and clocks, spreadsheet-like tables, MIDI and grids, even typing commands directly. There is more.

Polls report data from the audio subsystem, such as amplitude envelope and pitch detection. To see the available polls, execute:

```lua
>> poll.list_names()
```

You'll see:

```
--- polls ---
amp_in_l
amp_in_r
amp_out_l
amp_out_r
cpu_avg
cpu_peak
pitch_in_l
pitch_in_r
------
```

These are the basic system-wide polls. Engines may add [their own polls](/docs/norns/reference/poll) -- for example, softcut adds [polls for buffer playback position](/docs/norns/softcut/#3-cut-and-poll).

Let's set a poll to track the amplitude of the left input:

```lua
>> p = poll.set("amp_in_l")
>> p.callback = function(val) print("in > "..string.format("%.2f",val)) end
>> p.time = 0.25
>> p:start()
```

Play some sound into the left input and you'll see the printed numbers change with the sound level. Try changing `p.time` to update the poll interval.

**Bonus:** when we want numbers displayed a specific way we can use `string.format`. Here we use the format string `"%.2f"` which means we always want two decimals shown. See the [printf reference](http://www.cplusplus.com/reference/cstdio/printf/) for more formatting methods.

To stop the poll:

```lua
>> p:stop()
```

We can also request a single immediate value from the poll:

```lua
>> p:update()
```

Of course instead of just printing out the value of the poll, we should be using it for something more interesting and musical. We'll do that in the example in the end, but first let's smash together even more data.

## numbers through air

[Open Sound Control (OSC)](https://en.wikipedia.org/wiki/Open_Sound_Control) is a network protocol for sending messages supported by numerous sound and media applications. OSC also is how Lua communicates with SuperCollider within the norns ecosystem.

OSC messages look like this:

```
/cutoff 500
```

The first part, `/cutoff`, is the _path_. A series of values and/or strings can come after the path which is the _data_. In this way, an OSC message can be somewhat self-describing: we could assume the message above is to set the cutoff to 500.

We can use OSC in our scripts to interface with the outside world via [WiFi](/docs/norns/wifi-files/). For the following example you'll need to be connected to hotspot or a network. First let's receive a message from [Max/MSP](https://cycling74.com):

![](../study-image/study-5-osc-max-send.png)

norns listens to OSC on port *10111*.
{: .label .label-grey}

This simple max patch sends the message `/hello 42`. Note that you'll need to change the `udpsend` box to match your norns' IP address (which you can find in the SYSTEM menu).

**If you've gone through the previous studies:**

- open your uniquely-named study folder in the maiden file browser
- create a new file in your study folder: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor

<details closed markdown="block">
  <summary>
    <i>If you haven't gone through the previous studies</i>
  </summary>
  {: .text-delta }
- create a new folder in the `code` directory: click on the `code` directory and then click the folder icon with the plus symbol to create a new folder
  - name your new folder something meaningful, like `my_studies` (only use alphanumeric, underscore and hyphen characters when naming)
- create a new file in the folder you created: locate and click on the folder and then click the + icon in the scripts toolbar
- rename the file: select the newly-created `untitled.lua` file, then click the pencil icon in the scripts toolbar
  - after naming it something meaningful to you (only use alphanumeric, underscore and hyphen characters when naming), select the file again to load it into the editor
</details>

The file is blank. Full of possibilities. Type the text below into the editor:

```lua
-- study 5
-- code exercise
-- numbers through air

function osc_in(path, args, from)
  if path == "/hello" then
    print("hi!")
  elseif path == "/x" then
    x = args[1]
  elseif path == "/y" then
    y = args[1]
  elseif path == "/xy" then
    x = args[1]
    y = args[2]
  else
    print(path)
    tab.print(args)
  end
  print("osc from " .. from[1] .. " port " .. from[2])
end

osc.event = osc_in
```

Executing the message from Max will print the following to maiden's REPL:

```
hi!
osc from 192.168.0.109 port 60092
```

In Max, try sending OSC messages with `/x` and `/y` as paths and a single number as data. Path `/xy` will accept *two* numbers and set *both* values. This is how we map OSC paths to functionality within our script!

Notice that we can also extract the address (`from[1]`) and port (`from[2]`) of the sender. The receiving port will typically be different, so if your OSC client doesn't allow receiving port definition, check its ports.

Let's send a message back to Max from our script:

![](../study-image/study-5-osc-max-receive.png)

Above we set up a receive port on *10101*. Here's how we send to it:

```lua
>> dest = {"192.168.1.12",10101}
>> osc.send(dest, "/soup", {1,10})
```

`dest` is the destination we're sending to, so change the IP address to match the address where you received the messages earlier. The second argument is the path, followed by a table (curly brackets) with the data. Please note that even if you want to send a single value, it still has to be inside a table!

If everything is set up correctly, you should see `/soup 1. 10.` appear in the message box in Max.

norns is also auto-discoverable as an OSC device. For example, using [TouchOSC](https://hexler.net/software/touchosc) is very straightforward as "norns" should show up in the config list if both are connected to the same network.

## long term number storage

There will come a time when you have collected too many numbers, and they are precious and you want to save them for later. norns has a filesystem that can store a ton of numbers. Here's the easy way:

```lua
>> my_secret_bits = {2,-1,21,0}
>> tab.save(my_secret_bits, _path.data.."secret.txt")
```

`tab.save` is a function which saves a table to disk. We specify the file as `secret.txt` inside the folder `_path.data` (which is a global for `/home/we/dust/data/`, [see more in the reference](/docs/norns/reference/#helpful-system-commands-and-variables)).

Let's now load the same file to a different table:

```lua
>> summoned_bits = tab.load(_path.data.."secret.txt")
```

A quick check via `tab.print(summoned_bits)` will show that the read was successful:

```
1	2
2	-1
3	21
4	0
```

Let's do some more complex file operations. Here's how you get a folder listing:

```lua
>> listing = util.scandir(_path.home)
>> tab.print(listing)
```

You'll see something resembling this:

```
1    bin/ 
2    dust/
3    maiden/
4    norns/
5    norns-image/
6    update/
7    changelog.txt
8    version.txt
```

`util.scandir` takes one argument which is a folder path, and then it returns a table the folder contents. Too see how file loading works, let's load one of these files and print it out:

```lua
-- study 5
-- long term number storage

function print_file(filepath)
  local f=io.open(filepath,"r")
  if f==nil then
    print("file not found: "..filepath)
  else
    f:close()
    for line in io.lines(filepath) do
      -- this is where you would do something useful!
      -- but for now we'll just print each line
      print(line)
    end
  end
end
```

Let's test it:
```
>> folder = _path.home
>> listing = util.scandir(folder)
>> print_file(folder.."/"..listing[7])
```

The file `changelog.txt` should be printed! Stepping through the `print_file` function:

- argument is a file with path
- checks if the file exists
- uses a `for` loop to iterate on each line of the file

Writing a file is not much more complex:

```lua
f=io.open(_path.data .. "other_test.txt","w+")
f:write("dear diary,\n")
f:write("10011010\n")
f:close(f)
```

## example: streams

Putting together concepts above. This script is demonstrated in the video up top.

Here's a Max patch that uses a `pictslider` object for 2D control. This script is also compatible with the TouchOSC "simple" template.

![](../study-image/study-5-example-pictslider.png)

```lua
-- streams
-- norns study 5
--
-- KEY2 - clear pitch table
-- KEY3 - capture pitch to table
--
-- OSC patterns:
-- /x i : noise 0-127
-- /y i : cut 0-127
-- /3/xy f f : noise 0-1 cut 0-1

engine.name = 'PolySub'

collection = {}
last = -1

function init()
  screen.level(4)
  screen.aa(0)
  screen.line_width(1)

  params:add_control("shape","shape", controlspec.new(0,1,"lin",0,0,""))
  params:set_action("shape", function(x) engine.shape(x) end)
  params:add_control("timbre","timbre", controlspec.new(0,1,"lin",0,0.5,""))
  params:set_action("timbre", function(x) engine.timbre(x) end)
  params:add_control("noise","noise", controlspec.new(0,1,"lin",0,0,""))
  params:set_action("noise", function(x) engine.noise(x) end)
  params:add_control("cut","cut", controlspec.new(0,32,"lin",0,8,""))
  params:set_action("cut", function(x) engine.cut(x) end)
  params:add_control("fgain","fgain", controlspec.new(0,6,"lin",0,0,""))
  params:set_action("fgain", function(x) engine.fgain(x) end)
  params:add_control("cutEnvAmt","cutEnvAmt", controlspec.new(0,1,"lin",0,0,""))
  params:set_action("cutEnvAmt", function(x) engine.cutEnvAmt(x) end)
  params:add_control("detune","detune", controlspec.new(0,1,"lin",0,0,""))
  params:set_action("detune", function(x) engine.detune(x) end)
  params:add_control("ampAtk","ampAtk", controlspec.new(0.01,10,"lin",0,1.5,""))
  params:set_action("ampAtk", function(x) engine.ampAtk(x) end)
  params:add_control("ampDec","ampDec", controlspec.new(0,2,"lin",0,0.1,""))
  params:set_action("ampDec", function(x) engine.ampDec(x) end)
  params:add_control("ampSus","ampSus", controlspec.new(0,1,"lin",0,1,""))
  params:set_action("ampSus", function(x) engine.ampSus(x) end)
  params:add_control("ampRel","ampRel", controlspec.new(0.01,10,"lin",0,1,""))
  params:set_action("ampRel", function(x) engine.ampRel(x) end)
  params:add_control("cutAtk","cutAtk", controlspec.new(0.01,10,"lin",0,0.05,""))
  params:set_action("cutAtk", function(x) engine.cutAtk(x) end)
  params:add_control("cutDec","cutDec", controlspec.new(0,2,"lin",0,0.1,""))
  params:set_action("cutDec", function(x) engine.cutDec(x) end)
  params:add_control("cutSus","cutSus", controlspec.new(0,1,"lin",0,1,""))
  params:set_action("cutSus", function(x) engine.cutSus(x) end)
  params:add_control("cutRel","cutRel", controlspec.new(0.01,10,"lin",0,1,""))
  params:set_action("cutRel", function(x) engine.cutRel(x) end)
  params:bang()

  engine.level(0.02)

  pitch_tracker = poll.set("pitch_in_l")
  pitch_tracker.callback = function(x)
    if x > 0 then
      table.insert(collection,x)
      engine.start(#collection,x)
      last = x
      redraw()
    end
  end
end

function key(n,z)
  if n==2 and z==1 then
    engine.stopAll()
    collection = {}
    last = -1
    redraw()
  elseif n==3 and z==1 and #collection < 16 then
    pitch_tracker:update()
  end
end

local osc_in = function(path, args, from)
  if path == "/x" then
    params:set_raw("noise",args[1]/127)
  elseif path == "/y" then
    params:set_raw("cut",args[1]/127)
  elseif path == "/3/xy" then
    params:set_raw("noise",args[1])
    params:set_raw("cut",1-args[2])
  else
    print(path)
    tab.print(args)
  end
end

osc.event = osc_in

function redraw()
  screen.clear()
  if last ~= -1 then
    screen.move(0,10)
    screen.text(#collection .. " > " .. string.format("%.2f",last))
  else
    screen.move(128,10)
    screen.text_right("...")
  end
  for i,y in pairs(collection) do
    screen.move(4+(i-1)*8,60)
    screen.line_rel(0,-(8 * (math.log(collection[i]))-30))
    screen.stroke()
  end
  screen.update()
end
```

## continued
{: .no_toc }

- part 1: [many tomorrows](../study-1/) //  variables, simple maths, keys + encoders
- part 2: [patterning](../study-2/) // screen drawing, for/while loops, tables
- part 3: [spacetime](../study-3/) // functions, parameters, time
- part 4: [physical](../study-4/) // grids, MIDI, clock syncing
  - part 4b: [physical tangent: arc](../study-4b) // arc
- part 5: streams
- further: [softcut studies](../softcut/) // a multi-voice sample playback and recording system built into norns

## community
{: .no_toc }

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/14109)

Edits to this study welcome, see [monome/docs](http://github.com/monome/docs).