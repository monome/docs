---
layout: default
nav_exclude: true
permalink: /norns/reference/engine
---

## engine

Register a SuperCollider engine

### control

| Syntax                             | Description                                                                                                                                                        |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| engine.name                        | Using the format `engine.name = <engine_name>`, assigning this variable at the start of a script loads a SuperCollider engine as part of a script's initialization |
| engine.COMMAND_NAME(args)          | After an engine is loaded, its SuperCollider commands are made executable to the Lua layer via `engine.COMMAND_NAME(args)` : function                              |
| engine.load(engine_name, callback) | Manually load an engine (via string `engine_name`) and perform a `callback` function : function<br/>Not necessary -- just use `engine.name`!                       |

### query

| Syntax                  | Description                                                     |
| ----------------------- | --------------------------------------------------------------- |
| engine.list_commands()  | Print the commands added by the loaded engine  : function       |
| tab.print(engine.names) | Print the names of all the locally installed engines : function |

### description

The `engine` module manages the interactions between SuperCollider (generally speaking, the sound-making side of norns) and the Lua layer (where commands and performance interfaces are scripted).

The norns core software stack comes equipped with a few basic engines, which do not require any additional user management:

- `PolyPerc`: pulse wave with percussive envelopes which are triggered on updates to the synth's frequency ([source code](https://github.com/monome/norns/blob/main/sc/engines/Engine_PolyPerc.sc))

- `PolySub`: a subtractive polysynth engine ([source code](https://github.com/monome/norns/blob/main/sc/engines/Engine_PolySub.sc))

- `SimplePassThru`: an engine which passes incoming audio through, with control over amplitude ([source code](https://github.com/monome/norns/blob/main/sc/engines/Engine_SimplePassThru.sc))

- `TestSine`: a single, mono sinewave  ([source code](https://github.com/monome/norns/blob/main/sc/engines/Engine_TestSine.sc))

- `None`: a special-case engine which has no functions and is called when a script is cleared or a clean-slate is desired ([source code](https://github.com/monome/norns/blob/15c9cf9304d500b28c7ad04d6ddf4f85a4a6d095/sc/core/CroneEngine.sc#L83-L92))

For engine development overview and best practices, we encourage spending time with our engine-specific studies:

- [rude mechanicals](/docs/norns/engine-study-1/) // introduction to building norns engines with SuperCollider and Lua
- [skilled labor](/docs/norns/engine-study-2/) // extended study of norns engine development: polyphony and realtime parameter changes
- [transit authority](/docs/norns/engine-study-3/) // deep-dive into audio busses, FX, and polls (to communicate from SuperCollider to Lua)

Custom SuperCollider engine files live inside of a project's `lib` folder, as either a single `CroneEngine` file or as `CroneEngine` / Class File pair. Engines can be distributed as part of a larger script or as a standalone project, but note that having multiple copies of the engine's SuperCollider file will cause a [DUPLICATE ENGINES](/norns/help/software/#duplicate-engines) error.

### basic example

```lua
-- basic engine reference example

engine.name = 'PolyPerc' -- loads engine and executes script's init()

s = require 'sequins'

function init()
  print(" ")
  print("available engines:")
  tab.print(engine.names)
  print(" ")
  print("loaded engine:")
  print(engine.name)
  print(" ")
  print("commands for "..engine.name)
  engine.list_commands()

  pan_vals = s{-1,1,0.5,-0.5,0}
  pw_vals = s{0.25,0.9,0.1,0.75,0.3,0.5, 0.8}
  cutoff_vals = s{3000,600,1200,1530,6666}
  base_hz = 300
  hz_divs = s{1,1.5,0.5,1/3,2,0.25}

  clock.run(
    function()
      while true do
        clock.sync(1)
        engine.pan(pan_vals())
        engine.pw(pw_vals())
        engine.cutoff(cutoff_vals())
        engine.release(math.random(3,300)/100)
        engine.hz(base_hz * hz_divs())
      end
    end
  )
end
```

If one is feeling adventurous, you could embrace live-coding gestures by executing these commands through [the maiden REPL](/docs/norns/maiden/#repl):

```bash
>> load_callback = function() print("engine has been loaded!") end
>> engine.load("PolyPerc", load_callback)
>> engine.release(2)
>> engine.hz(300)
>> engine.pan(-1); engine.hz(400)
>> engine.cutoff(4500); engine.pan(0); engine.hz(150)
>> engine.load("None", function() print("clearing engine") end)
```
