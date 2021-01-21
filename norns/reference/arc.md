---
layout: default
nav_exclude: true
permalink: /norns/reference/arc
---

## arc

### control

| Syntax                              | Description                                                                                                                      |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| my_arc = arc.connect(n)             | Assign this connected arc to a script, defaults to port 1 unless n is specified                                                  |
| my_arc:led(ring, x, val)            | Set state of single LED on a specific ring of this connected arc, accepts val 0 (off) - 15 (full bright)                         |
| my_arc:all(val)                     | Set state of all LEDs of this connected arc, expects val 0 (off) - 15 (full bright)                                              |
| my_arc:segment(ring, from, to, val) | Create an anti-aliased point to point arc segment/range on a specific ring of this connected arc, 'from' and 'to' expect radians |
| my_arc:refresh()                    | Update any dirty LEDs on this connected arc                                                                                      |
| my_arc.delta(n, delta)              | Pass encoder delta events to a script : function                                                                                 |
| arc.add()                           | User script callback when any arc is connected                                                                                   |
| arc.remove()                        | User script callback when any arc is disconnected                                                                                |

### query

| Syntax               | Description                              |
| -------------------- | ---------------------------------------- |
| my_arc.device        | Returns identifiers for this arc : table |
| my_arc.device.id     | Returns this arc's id : number           |
| my_arc.device.port   | Returns this arc's port : number         |
| my_arc.device.name   | Returns this arc's name : string         |
| my_arc.device.serial | Returns this arc's serial : string       |

### example

```lua
-- none yet
```

### description

Connects a script to a connected [arc](https://monome.org/docs/arc), to add high-resolution bi-directional control data. LEDs can be redrawn either by directly targeting LED positions (numbers 1 through 64, with wrapping) or LED segments (radians with wrapping). Like the norns hardware encoders, arc encoders can control script data.
