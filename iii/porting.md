---
layout: default
title: porting
has_children: false
nav_exclude: true
has_toc: false
---

# Porting

A few checklists and tips for porting to lua to iii.

## from v1.0.0

- Time units changed from ms to second. Multiply your time units by 1000 for metro, get_time(), and slews. Time units are now a float (decimal) and not an int (whole number).
- `metro` syntax now is the same as on norns.

Example old script:
```
m = metro.new(tick, 500) -- autostarts
metro.stop(m)
```

Updated new script:
```
m = metro.init(tick, 0.5)
m:start()
m:stop()
```

- event functions have been renamed

Old:
```
midi_rx()
grid(x,y,z)
arc(n,d),
arc_key(z)
```

New:
```
event_midi()
event_grid(x,y,z)
event_arc(n,d)
event_arc_key(z)
```

- If a script uses psets, add `pset_init(script_name)` so that files get saved with a prefix.

- `linlin` arg order changed: `linlin(n, slo, shi, dlo, dhi)`

