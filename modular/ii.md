---
layout: default
nav_exclude: true
permalink: /modular/ii
---

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

##  what is ii and I2C?

**ii** is a flexible communication protocol which
allows modules to send commands to each other digitally, which opens up
possibilities that patch cables can’t facilitate. This digital networking is
described as a ‘bus’.

Various monome eurorack modules can communicate with each other by sending digital messages over an [I2C serial bus](https://en.wikipedia.org/wiki/I%C2%B2C), using any type of cable to connect between pin headers on the rear of each module. Using the I2C bus as a transport, many different modules now support a similar set of control messages, which together constitute the ii protocol. This was originally conceived as a way for [Teletype](/docs/modular/teletype) to interact with other devices, but now other devices also support initiating ii transmissions, including [Crow](/docs/crow).

An I2C bus consists of 3 lines - ground (GND), data (SDA) and clock (SCL).
The data and clock lines are “pulled high” via pull-up resistors to 5V and
data is transferred when these lines are “low”, thus power is also needed
for the bus to operate.

Both monome’s [Teletype](/docs/teletype) and [crow](/docs/crow) provide power
over the i2c bus – however, Ansible does not. If you are in need of additional
power or are planning to add more than three or four i2c-capable modules to your
bus, we suggest invest in a powered bus board like the [Txb](https://store.bpcmusic.com/products/telexb).

![](../images/ii_overview.png)

While ii setups are usually straightforward, requiring the connection of
matching ii headers (GND <-> GND, SCL <-> SCL, SDA <-> SDA) via 2.54mm
connectors, there are a few consideration to keep things working:

* Best practice is to daisy chain modules together. Several modules provide dual
headers, allowing you to connect one module to the next. If your module only has
one set of ii pins, like the [Disting Ex](https://www.expert-sleepers.co.uk/distingEX.html),
place this at the end of the chain.

* Make sure to align your ii connections correctly, with each of the corresponding
pins. These are usually marked on the PCB – a white line is often used to refer
to the ground pin. Note that the vertical order of the pins on each module may
be reversed from another in your case – always check to see where the GND line is!

* Keep your cables as short as possible to reduce the risk of dropped data.

For additional information, please check out the helpful [i2c/ii guide](https://llllllll.co/t/a-users-guide-to-i2c/19219) available on lines.

## ii tips

A few quick ii tips:

* Pins on each module will be labeled GND (ground), SCL (clock), and SDA (clock). These should be connected GND <-> GND, SCL <-> SCL, SDA <-> SDA,
and you can connect them with any sort of 2.54mm pitch jumper cable. On all monome and Whimsical Raps modules, and the [TELEX expanders](https://github.com/bpcmusic/telex/), the pins are in this order: gnd, scl, sda. The order is the same from ground whether all pins are labeled on the board or not.  
Take care as other manufacturers may have different pin orderings. You won't damage anything by getting these wired wrong, but modules might crash.
* Trilogy modules support ii, but may need a pin header soldered on. See [here](/docs/modular/iiheader).
* I2C needs power to operate. This is achieved by "pulling up" the clock and data lines to 5V, meaning connecting an appropriate "pullup resistor" between SCL and 5V and between SDA and 5V. Some devices (generally those meant to act as leader devices) have pullup resistors wired, others (generally followers) do not -- some such as Crow make this controllable in software. The right choice of pullup value may depend on the number of devices attached, but in many cases you should probably only have one device pulling the lines up.
* Each device on the bus has an address, which the leader uses to indicate which device it wants to talk to. Some devices support choosing between multiple addresses, others use a fixed address. Generally all followers sharing the same address will respond identically to messages sent to that address.

## faq

While ii setups with a few devices are usually
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
