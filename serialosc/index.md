---
layout: default
title: serialosc
nav_order: 8
has_children: true
has_toc: false
---

# serialosc

serialosc runs in the background and converts serial communication (over USB) into [OSC](/docs/serialosc/osc). Applications can query serialosc to connect to the grid and arc.

- [Setup](/docs/serialosc/setup) instructions for various platforms
- [Troubleshooting](/docs/serialosc/troubleshooting)
- [OSC Reference](/docs/serialosc/osc/)
- [Serial protocol](/docs/serialosc/serial.txt)

## How it works

### Abstract

Usually, you will not interface with serialosc directly -- instead, you'll likely use a library as an intermediary, like the [`[serialosc]` object in Max](/docs/grid/studies/max) or the [`monomeSC` library for SuperCollider](/docs/grid/studies/sc). Over the years, libraries have been spun up for a lot of environments and languages -- see [our grid studies](/docs/grid/studies) for more about these.

The rest of this document details what these pre-made libraries abstract, for those curious about the underlying mechanics or who wish to build their own.

### Detailed

`serialoscd` keeps watch for connection and disconnection of devices. When connected, a new process is launched 'serialosc-device' which communicates on its own port.

We will assume a theoretical application on port 66666 on localhost is trying to connect to serialosc. We'll also assume you have `liblo` installed, which includes `oscsend` and `oscdump`.

First, connect your grid to your computer. Then, open a terminal window and set up an OSC monitor:

- `oscdump 6666`

Open another terminal window. To list the available devices, we'll query `serialoscd` which listens on port 12002, and we'll route the response to our monitor:

- `oscsend localhost 12002 /serialosc/list si localhost 6666`

Say we have an 8x16 grid attached, results might look like this:

- `e83daeee.d2ea63b5 /serialosc/device ssi "m46674021" "monome 128" 17675`

Here, port 17675 is where the device is listening. To have this grid send to our application:

- `oscsend localhost 17675 /sys/port i 6666`

Now when keys on the grid are pressed we should see something like:

```
<timestamp> /monome/grid/key iii 9 3 1
<timestamp> /monome/grid/key iii 9 3 0
```

...which follow the form `/prefix/grid/key x y z`. Note, that while the "prefix" defaults to `/monome`, it's changeable with any string. For example, to change our prefix to `/blinky`:

- `oscsend localhost 17675 /sys/prefix s "/blinky"`

Note that when a grid is disconnected + reconnected, its prefix will return to `/monome`.

To send LED data:

- `oscsend localhost 17675 /monome/grid/led/level/set iii 2 2 8` (set LED 2,2 to brightness 8)
- `oscsend localhost 17675 /monome/grid/led/all i 0` (clear the grid)

See [OSC](/docs/serialosc/osc) for the complete list of messages.

All ports are also discoverable via zeroconf as `_monome-osc._udp`.