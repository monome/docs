---
layout: page
permalink: /docs/modular/ii/
---

# ii

Various Monome Eurorack modules can communicate with each other by sending digital messages over an [I2C serial bus](https://en.wikipedia.org/wiki/I%C2%B2C), using any type of cable to connect between pin headers on the rear of each module. Using the I2C bus as a transport, many different modules now support a similar set of control messages, which together constitute the "ii" protocol. This was originally conceived as a way for [Teletype](/docs/modular/teletype) to interact with other devices, but now other devices also support initiating ii transmissions, including [Crow](/docs/crow).

A few quick ii tips:

* Pins on each module will be labeled GND (ground), SDA (data), and SCL (clock). These should be connected GND <-> GND, SDA <-> SDA, SCL <-> SCL, and you can connect them with any sort of 2.54mm pitch jumper cable.
* Trilogy modules support ii, but may need a pin header soldered on. See [here](/docs/modular/iiheader).
* I2C needs power to operate. This is achieved by "pulling up" the clock and data lines to 5V, meaning connecting an appropriate "pullup resistor" between SCL and 5V and between SDA and 5V. Some devices (generally those meant to act as leader devices) have pullup resistors wired, others (generally followers) do not -- some such as Crow make this controllable in software. The right choice of pullup value may depend on the number of devices attached, but in many cases you should probably only have one device pulling the lines up.
* Each device on the bus has an address, which the leader uses to indicate which device it wants to talk to. Some devices support choosing between multiple addresses, others use a fixed address. Generally all followers sharing the same address will respond identically to messages sent to that address.

For more technical information and help, please post on [lines](https://llllllll.co/t/a-users-guide-to-i2c/19219).