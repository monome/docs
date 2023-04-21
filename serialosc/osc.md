---
layout: default
title: osc
nav_exclude: true
redirect_from: /osc/
permalink: /serialosc/osc/
---

# osc : opensound control / serialosc protocol

What is serialosc? How does it work?

## discovering and connecting to serialosc devices

The serialosc server listens on port 12002.

When devices are connected, serialosc spawns new ports for each device. querying the server allows you to discover the port number for each device.

### messages sent to serialosc server

| message                              | description                                                                                                                                                                        |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/serialosc/list si <host> <port>`   | Request a list of the currently connected devices, sent to host:port                                                                                                               |
| `/serialosc/notify si <host> <port>` | Request that next device change (connect/disconnect) is sent to host:port. to keep receiving the notifications, send another message to /serialosc/notify from the notify handler. |

### messages received from serialosc server

| message                                    | description                                          |
| ------------------------------------------ | ---------------------------------------------------- |
| `/serialosc/device ssi <id> <type> <port>` | Currently connected device id and type, at this port |
| `/serialosc/add s <id>`                    | Device added                                         |
| `/serialosc/remove s <id>`                 | Device removed                                       |

## to serialosc device

### sys

These messages can be sent to a serialosc device to change settings:

| message                     | description                                                         |
| --------------------------- | ------------------------------------------------------------------- |
| `/sys/port i <port>`        | Change destination port                                             |
| `/sys/host s <host>`        | Change destination host                                             |
| `/sys/prefix s <prefix>`    | Change message prefix (filtering)                                   |
| `/sys/rotation i <degrees>` | Rotate the grid by degrees, where degrees is one of 0, 90, 180, 270 |

### info

Request information (settings) about this device.

`/info` can take the following arguments:

| message                      | description                                         |
| ---------------------------- | --------------------------------------------------- |
| `/sys/info si <host> <port>` | Send /sys/info messages to host:port                |
| `/sys/info i <port>`         | Send to localhost:port                              |
| `/sys/info`                  | Send to current destination application's host:port |

example:

    to serialosc:
        /sys/info localhost 9999
    from serialosc to localhost:9999:
        /sys/id m0000045
        /sys/size 8 16
        /sys/host localhost
        /sys/port 23849
        /sys/prefix /nubs
        /sys/rotation 270

## from serialosc

These messages are sent from serialosc to the destination port.

### sys

The messages below are sent after a `/sys/info` request is received:

| message           | description                  |
| ----------------- | ---------------------------- |
| `/sys/port i`     | Reports destination port     |
| `/sys/host s`     | Reports destination host     |
| `/sys/id s`       | Reports device id            |
| `/sys/prefix s`   | Reports prefix               |
| `/sys/rotation i` | Reports grid device rotation |
| `/sys/size ii`    | Reports grid device size     |

## to device

### grid

| message                                | description                                      |
| -------------------------------------- | ------------------------------------------------ |
| `/grid/led/set x y s`                  | Set led at (x,y) to state s (0 or 1)             |
| `/grid/led/all s`                      | Set all leds to state s (0 or 1)                 |
| `/grid/led/map x_offset y_offset s[8]` | Set a quad (8×8, 64 buttons) in a single message |

#### map

Each number in the `map` list is a bitmask of the buttons in a row, one number in the list for each row. The message will fail if the list doesn't have 8 entries plus offsets.

Taken apart:

    (/grid/led/map)  <- the message/route
                   (8 8)  <- the offsets (must be multiples of 8)
                        (1 2 4 8 16 32 64 128)  <- the bitmasks for each row

_examples_

```
/grid/led/map 0 0 4 4 4 4 8 8 8 8
/grid/led/map 0 0 254 253 125 247 239 36 191 4
```

#### row

```
/grid/led/row x_offset y s[..]
```

Set a row in a quad in a single message. Offsets must be multiples of 8. Note that offsets for 64-sized grids should always be 0.

Each number in the list is a bitmask of the buttons in a row, one number in the list for each row being updated.

_examples (for 256)_

```
/grid/led/row 0 0 255 255
/grid/led/row 8 5 255
```

_examples (for 64)_

```
/grid/led/row 0 0 232
/grid/led/row 0 3 129
```

#### col

```
/grid/led/col x y_offset s[..]
```

Set a column in a quad in a single message. Offsets must be multiples of 8. Note that offsets for 64-sized grids should always be 0

Each number in the list is a bitmask of the buttons in a column, one number in the list for each row being updated.

_examples (for 256)_

```
/grid/led/col 0 0 255 255 (updates quads 1 and 3)
/grid/led/col 13 8 255 (updates quad 4 due to offset.)
```

_examples (for 64)_

```
/grid/led/col 0 0 232
/grid/led/col 6 0 155
```

#### variable brightness

Valid values for 'l' below are in the range [0, 15].

January 2011 devices only support four intensity levels (off + 3 brightness levels). The value passed in /level/ messages will be “rounded down” to the lowest available intensity as below:

- [0, 3] - off
- [4, 7] - low intensity
- [8, 11] - medium intensity
- [12, 15] - high intensity

Devices from June 2012 (and after) allow all 16 intensity levels.

```
/grid/led/level/set x y l
/grid/led/level/all l
/grid/led/level/map x_off y_off l[64]
/grid/led/level/row x_off y l[..]
/grid/led/level/col x y_off l[..]
/grid/led/intensity i
```

#### tilt

    /tilt/set n s

Set active state of tilt sensor n to s (0 or 1, 1 = active, 0 = inactive).

### arc

Note that LED 0 is north. LED numbers increase clockwise.

| message                 | description                                                                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `/ring/set n x l`       | Set LED `x` (0-63) on encoder `n` (0-1 or 0-3) to level `l` (0-15)                                                                               |
| `/ring/all n l`         | Set all LEDs on encoder `n` (0-1 or 0-3) to level `l` (0-15)                                                                                     |
| `/ring/map n l[64]`     | Set all LEDs on encoder `n` (0-1 or 0-3) to 64 member array `l[64]`                                                                              |
| `/ring/range n x1 x2 l` | Set LEDs on encoder `n` (0-1 or 0-3) between (inclusive) `x1` and `x2` to level `l` (0-15). Direction of set is always clockwise, with wrapping. |

## from device

### grid

    /grid/key x y s

Key state change at (`x`,`y`) to `s` (0 or 1, 1 = key down, 0 = key up).

### tilt

    /tilt n x y z

Position change on tilt sensor `n`, integer (8-bit) values (`x`, `y`, `z`).

### arc

    /enc/delta n d

Position change on encoder `n` by value `d` (signed). Clockwise is positive.

    /enc/key n s

Key state change on encoder `n` to `s` (0 or 1, 1 = key down, 0 = key up).