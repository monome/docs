---
layout: default
nav_exclude: true
permalink: /norns/reference/gamepad
---

## gamepad

### control

| Syntax                                      | Description                                                                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| gamepad.button(b,val)                       | User script callback for non-directional button presses : function                                           |
| gamepad.dpad(axis,val)                      | User script callback for directional pad presses : function                                                  |
| gamepad.axis(sensor_axis, sign)             | User script callback for sensor axis changes : function                                                      |
| gamepad.analog(sensor_axis, val, half_reso) | User script callback for analog sensor  changes (analog direction pad, joystick, trigger buttons) : function |

### query

`gamepad`'s states are all held in the `gamepad.state` table:

```lua
gamepad.state = {
  DPDOWN = false,
  DPUP = false,
  LDOWN = false,
  LUP = false,
  LLEFT = false,
  LRIGHT = false,
  RDOWN = false,
  RUP = false,
  RLEFT = false,
  RRIGHT = false,
  TLEFT = false,
  TRIGHT = false,
  -- aggregated
  DOWN = false,
  UP = false,
  LEFT = false,
  RIGHT = false,
}
```

### callbacks

#### `gamepad.button(button_name, state)`

- triggered when a button is pressed or released

- dpad arrows don't count as buttons and one should use `gamepad.dpad` for this use-case

- `button_name` can take the value: `A`, `B`, `X`, `Y`, `L1`, `L2`, `R1`, `R2`, `START`, `SELECT`

- `state` is either `true` (pressed) or `false` (released)

#### `gamepad.dpad(axis, sign)`

- triggered when a dpad arrow is pressed or released

- `axis` can take the value `X` or `Y`

- sign is either `-1` or `1` (for each side of an axis) or `0` (released).

#### `gamepad.axis(sensor_axis, sign)`

- similar to `gamepad.dpad`, but triggered by a sensor axis change

- `sensor_axis` can take the value: `dpady`, `dpadx`, `lefty`, `leftx`, `righty`, `rightx`, `triggerleft`, `triggerright` (same naming convention as SDL)

- sign is either `-1` or `1` for each half-travel or `0` (centered)

- please note that for `triggerleft` and `triggerright`, the resting (released) position is usually `-1` instead of `0`

#### `gamepad.analog(sensor_axis, val, half_reso)`

- triggered by change of value from an analog sensor (analog direction pad, joystick, trigger buttons)

- `sensor_axis` can take the value: `lefty`, `leftx`, `righty`, `rightx`, `triggerleft`, `triggerright` (same naming convention as SDL)

- sends the raw sensor value (`val`) normalized around 0 as well as `half_reso`, the min/max value attainable on each side of the travel; `val` can only go between `-half_reso` and `half_reso`

### examples

#### digital A button is pressed

- `gamepad.state.A` is set to `true`
- `gamepad.button('A', true)`

#### digital dpad down is pressed

- `gamepad.state.DPDOWN` is set to `true`
- `gamepad.axis('dpady', -1)`
- `gamepad.dpad('Y', -1)`

#### analog dpad down is pressed

- `gamepad.state.DPDOWN` is set to `true`
- `gamepad.analog('dpady', -100, 128)` (example values)
- `gamepad.axis('dpady', -1)`
- `gamepad.dpad('Y', -1)`

#### analog left stick down is pressed

- `gamepad.state.LDOWN` is set to `true`
- `gamepad.analog('lefty', -100, 128)` (example values)
- `gamepad.axis('lefty', -1)`

#### analog left shoulder button is pressed

- `gamepad.state.TLEFT` is set to `true`
- `gamepad.analog('triggerleft', 230, 255)` (example values)
- `gamepad.axis('triggerleft', 1)`
- `gamepad.trigger_button('L2', true)`

### description

Deciphers gamepad input and executes user-assignable callbacks. Since many gamepads do not adhere to standard HID event codes, this library relies uses SDL `sensor_axis`codes (eg. `dpadx`, `leftx`...) with controller mapping profiles to create a more predicable experience.

Plug + play models:

- iBUFFALO Classic USB Gamepad
- Xbox 360
- Retrolink B00GWKL3Y4 ((S)NES-style, also sold by under other brands: iNNext, Elecom...)

Contributed and maintained by [`@p3r7`](https://github.com/p3r7/)
