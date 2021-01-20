---
layout: default
nav_exclude: true
permalink: /norns/reference/encoders
---

## encoders

### control

| Syntax                   | Description                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| norns.enc.accel(n,accel) | Set encoder n's acceleration value, which adds resistance to an encoder's initial turn delta (default 1) |
| norns.enc.sens(n,sens)   | Set encoder n's sensitivity value, which adds uniform resistance to an encoder's turn delta (default 1)  |
| enc(n,d)                 | Pass encoder delta events to a script : function                                                         |

### query

none

### example

```lua
-- none yet
```

### description

Deciphers the norns hardware encoders for script use. Acceleration and sensitivity can be defined per-script, for unique control over interactions.
