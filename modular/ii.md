---
layout: default
nav_exclude: true
permalink: /modular/ii
---

# ii

Various Monome Eurorack modules can communicate with each other by sending digital messages over an [I2C serial bus](https://en.wikipedia.org/wiki/I%C2%B2C), using any type of cable to connect between pin headers on the rear of each module. Using the I2C bus as a transport, many different modules now support a similar set of control messages, which together constitute the "ii" protocol. This was originally conceived as a way for [Teletype](/docs/modular/teletype) to interact with other devices, but now other devices also support initiating ii transmissions, including [Crow](/docs/crow).

A few quick ii tips:

* Pins on each module will be labeled GND (ground), SCL (clock), and SDA (clock). These should be connected GND <-> GND, SCL <-> SCL, SDA <-> SDA,
and you can connect them with any sort of 2.54mm pitch jumper cable. On all monome and Whimsical Raps modules, and the [TELEX expanders](https://github.com/bpcmusic/telex/),
the pins are in this order: gnd, scl, sda. The order is the same from ground whether all pins are labeled on the board or not.
Take care as other manufacturers may have different pin orderings. You won't damage anything by getting these wired wrong, but modules might crash.
* Trilogy modules support ii, but may need a pin header soldered on. See [here](/docs/modular/iiheader).
* I2C needs power to operate. This is achieved by "pulling up" the clock and data lines to 5V, meaning connecting an appropriate "pullup resistor" between SCL and 5V and between SDA and 5V. Some devices (generally those meant to act as leader devices) have pullup resistors wired, others (generally followers) do not -- some such as Crow make this controllable in software. The right choice of pullup value may depend on the number of devices attached, but in many cases you should probably only have one device pulling the lines up.
* Each device on the bus has an address, which the leader uses to indicate which device it wants to talk to. Some devices support choosing between multiple addresses, others use a fixed address. Generally all followers sharing the same address will respond identically to messages sent to that address.

For more technical information and help, please post on [lines](https://llllllll.co/t/a-users-guide-to-i2c/19219).

## faq

While [ii](/docs/modular/ii) setups with a few devices are usually
straightforward (e.g., connect headers between Teletype and Just
Friends - done!), as networks involve more modules there can be some
important considerations to keep things working. Here are some common
user questions about ii networks involving several modules, focused on
questions related to Monome devices specifically.  Lots of other great
information and links are available on
[lines](https://llllllll.co/t/a-users-guide-to-i2c/19219).

### Do I need to use a Teletype "backpack"?

The newer Teletype PCBs (black) provide more power to the I2C bus and
provide more ii headers, allowing for somewhat larger ii networks out
of the box. Older (green) Teletypes can often only support 2-3
followers without needing a [powered busboard
(DIY)](https://llllllll.co/t/teletype-busboard/9579). Minimizing the
total length of wire on your bus can also help -- daisy chain rather
than using a star.

### Can I use Crow and Teletype simultaneously on the same ii bus?

Yes and no. The I2C specification is designed to allow multiple
leaders to attempt writing to the bus simultaneously. However, only a
single device in the network can be sending data at any given time. If
multiple devices transmit at once, there is a possibility of one
module locking up, or other odd behavior. As a result this type of
setup is not currently supported, though some users have found varying
degrees of success using multiple leaders.

However, Crow's pullup resistors can be enabled or disabled in software,
allowing it to be easily used as a leader or a follower. Support for
controlling some of Crow's functionality from Teletype is planned.
