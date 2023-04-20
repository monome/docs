---
layout: default
title: serialosc
---

serialosc runs in the background and converts serial communication (over USB) into [OSC](/docs/serialosc/osc). Applications can query serialosc to connect to the grid and arc.

- [Setup](/docs/serialosc/setup) instructions for various platforms
- [Troubleshooting](/docs/serialosc/troubleshooting)
- [OSC Reference](/docs/serialosc/osc/)
- [Serial protocol](/docs/serialosc/serial.txt)

# How it works

## Abstract

Usually, you will not interface with serialosc directly -- instead, you'll likely use a library as an intermediary, like the [`[serialosc]` object in Max](/docs/grid/studies/max) or the [`monomeSC` library for SuperCollider](/docs/grid/studies/sc). Over the years, libraries have been spun up for a lot of environments and languages -- see [our grid studies](/docs/grid/studies) for more about these.

The rest of this document details what these pre-made libraries abstract, for those curious about the underlying mechanics or who wish to build their own.

## Detailed

`serialoscd` keeps watch for connection and disconnection of devices. When connected, a new process is launched 'serialosc-device' which communicates on its own port.

We will assume a theoretical application on port 66666 on localhost is trying to connect to serialosc.

To list the available devices, query `serialoscd` which listens on port 12002:

- to port 12002: `/serialosc/list localhost 66666`

Say we have an 8x16 grid attached, results might look like this:

- received on port 66666: /serialosc/device "m1000000" "monome 128" 21008

Here, port 21008 is where the device is listening. To have this grid send to our application:

- to port 21008: `/sys/port 66666`

Now when keys on the grid are pressed we should see something like:

```
/grid/key 0 0 1
/grid/key 0 2 1
```

...which follow the form `/prefix/key x y z`. Note, the "prefix" is changeable with a message.

To send LED data:

- to port 21008: `/grid/led/all 0` (clear the grid)
- to port 21008: `/grid/led/level/set 2 2 8 (set LED 2,2 to brightness 8)

See [OSC](/docs/serialosc/osc) for the complete list of messages.

All ports are also discoverable via zeroconf as `_monome-osc._udp`.
