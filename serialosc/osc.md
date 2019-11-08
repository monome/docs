---
layout: default
title: osc
nav_exclude: true
permalink: /serialosc/osc/
---

# osc : opensound control / serialosc protocol

what is serialosc? how does it work?

## discovering and connecting to serialosc devices

serialosc server listens on port 12002.

when devices are connected, serialosc spawns new ports for each device. querying the server allows you to discover the port number for each device. (this supersedes the zeroconf method, which is still in place for legacy compatibility).

### messages sent to serialosc server

    /serialosc/list si <host> <port>

request a list of the currently connected devices, sent to host:port

    /serialosc/notify si <host> <port>

request that next device change (connect/disconnect) is sent to host:port. to keep receiving the notifications, send another message to /serialosc/notify from the notify handler.

### messages received from serialosc server

    /serialosc/device ssi <id> <type> <port>

currently connected device id and type, at this port

    /serialosc/add s <id>

device added

    /serialosc/remove s <id>

device removed

## to serialosc device

### sys

these messages can be sent to a serialosc device to change settings.

    /sys/port i <port>

change destination port

    /sys/host s <host>

change destination host

    /sys/prefix s <prefix>

change message prefix (filtering)

    /sys/rotation i <degrees>

rotate the monome by degrees, where degrees is one of 0, 90, 180, 270. this replaces /cable

    /sys/info si <host> <port>

    /sys/info i <port>

    /sys/info

### info

request information (settings) about this device

/info can take the following arguments:

    /info si <host> <port> (send /sys/info messages to host:port)

    /info i <port> (send to localhost:port)

    /info (send to current destination application's host:port)

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

these messages are sent from serialosc to the destination port.

the messages below are sent after a /sys/info request is received.

### sys

    /sys/port i report destination port

    /sys/host s report destination host

    /sys/id s report device id

    /sys/prefix s report prefix

    /sys/rotation i report grid device rotation

    /sys/size ii report grid device size

## to device

### grid

    /grid/led/set x y s

set led at (x,y) to state s (0 or 1).

    /grid/led/all s

set all leds to state s (0 or 1).

    /grid/led/map x_offset y_offset s[8]

Set a quad (8×8, 64 buttons) in a single message.

Each number in the list is a bitmask of the buttons in a row, one number in the list for each row. The message will fail if the list doesn't have 8 entries plus offsets.

taken apart:

    (/grid/led/map)  <- the message/route
                   (8 8)  <- the offsets
                        (1 2 4 8 16 32 64 128)  <- the bitmasks for each row

_examples_

```
/grid/led/map 0 0 4 4 4 4 8 8 8 8
/grid/led/map 0 0 254 253 125 247 239 36 191 4
```

Offsets must be mutliples of 8.

```
/grid/led/row x_offset y s[..]
```

Set a row in a quad in a single message.

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

Offsets must be mutliples of 8. Offsets for monome64 should always be zero.

```
/grid/led/col x y_offset s[..]
```

Set a column in a quad in a single message.

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

Offsets must be mutliples of 8. Offsets for monome64 should always be zero.

```
/grid/led/intensity i
```

variable brightness:

Valid values for 'l' below are in the range [0, 15].

January 2011 devices only support four intensity levels (off + 3 brightness levels). The value passed in /level/ messages will be “rounded down” to the lowest available intensity as below:

- [0, 3] - off
- [4, 7] - low intensity
- [8, 11] - medium intensity
- [12, 15] - high intensity

June 2012 devices allow the full 16 intensity levels.

```
/grid/led/level/set x y l
/grid/led/level/all l
/grid/led/level/map x_off y_off l[64]
/grid/led/level/row x_off y l[..]
/grid/led/level/col x y_off l[..]
```

### tilt

    /tilt/set n s

set active state of tilt sensor n to s (0 or 1, 1 = active, 0 = inactive).

### arc

led 0 is north. clockwise increases led number. These can be viewed and tested in the browser at http://nomeist.com/osc/arc/

    /ring/set n x l

set led x (0-63) on encoder n (0-1 or 0-3) to level l (0-15)

    /ring/all n l

set all leds on encoder n (0-1 or 0-3) to level l (0-15)

    /ring/map n l[64]

set all leds on encoder n (0-1 or 0-3) to 64 member array l[64]

    /ring/range n x1 x2 l

set leds on encoder n (0-1 or 0-3) between (inclusive) x1 and x2 to level l (0-15). direction of set is always clockwise, with wrapping.

## from device

### grid

    /grid/key x y s

key state change at (x,y) to s (0 or 1, 1 = key down, 0 = key up).

### tilt

    /tilt n x y z

position change on tilt sensor n, integer (8-bit) values (x, y, z)

### arc

    /enc/delta n d

position change on encoder n by value d (signed). clockwise is positive.

    /enc/key n s

key state change on encoder n to s (0 or 1, 1 = key down, 0 = key up)


# serial


