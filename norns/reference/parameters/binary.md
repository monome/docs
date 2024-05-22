---
layout: default
nav_exclude: true
permalink: /norns/reference/parameters/binary
---

## binary

The *binary* parameter type builds a visible on/off state inside of the norns `PARAMETERS` menu.

Generic instantiation looks like:

```lua
params:add_binary(id, name, behavior, default)
```

- `id` is a string without spaces
- `name` is a string for UI display (can contain spaces)
- `behavior` is a string to define the binary's type: `"momentary"`, `"toggle"`, or `"trigger"`
- `default` is a number to set the parameter's initial value: `1` for on, `0` for off
  - note that this does not apply to the `"trigger"` behavior

This parameter type primarily responds to K3 in the `PARAMETERS` menu. If assigned `"toggle"` behavior, E3 can alternatively be used to flip the state 

Each binary behavior is useful for different musical applications:

- `"momentary"` is active (`1`) while K3 is held and inactive (`0`) when K3 is released
- `"toggle"` switches state (between `1` and `0`) with each K3 press (or E3 clockwise to engage, E3 counter-clockwise to disengage)
- `"trigger"` has no state tracking, but rather performs an associated action with each K3 press