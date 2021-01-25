---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/intonation
---

## intonation

### control

| Syntax                            | Description                                                                                             |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- |
| my_var = require 'intonation'     | Invoke the `intonation` library in your script and assign it to a variable                              |
| my_normal = my_var.normal()       | Builds a table of notes containing a small variation of ptolemaic 5-limit with closer minor 7th : table |
| my_ptolemy = my_var.ptolemy()     | Ptolemaic 12-tone (5-limit)  - very similar to `normal` except for m7 : table                           |
| my_overtone = my_var.overtone()   | Ben Johnston's overtone scale identical to Jeff Snyder's "otonal" scale : table                         |
| my_undertone = my_var.undertone() | Subharmonic mirror of the overtone scale - Jeff Snyder calls this "utonal" after Partch : table         |
| my_lamonte = my_var.lamonte()     | La Monte Young's 'well-tuned piano' : table                                                             |
| my_zarlino = my_var.zarlino()     | Gioseffo Zarlino's 16-tone (5-limit) : table                                                            |
| my_partch = my_var.partch()       | Harry Partch 43-tone (11-limit, plus some) : table                                                      |
| my_gamut = my_var.gamut()         | Jeff Snyder's full [168-tone gamut](http://scatter.server295.com/full-dissertation.pdf) : table         |

### query

None beyond executing standard `tab.` utils.

### example

```lua
JI = require 'intonation'
lamonte = JI.lamonte()
engine.name = 'PolyPerc'

function init()
  engine.release(clock.get_beat_sec()/8)
end

function strum()
  for i=1,#lamonte do
    engine.hz(300*lamonte[i])
    clock.sleep(1/24)
  end
end

function key(n,z)
  if n == 3 and z == 1 then
    clock.run(strum)
  end
end
```

### description

Just Intonation tables for easy exploration of pitch relationships. Each table provides multipliers, which can be queried by executing, for example,`tab.print(my_overtone)`, which returns:

```lua
1	1.0
2	1.0625
3	1.125
4	1.1875
5	1.25
6	1.3125
7	1.375
8	1.5
9	1.625
10	1.6875
11	1.75
12	1.875
```
