---
layout: default
nav_exclude: true
permalink: /modular/dev
---

# development

all code is written in c. you'll need gcc installed.

mac avr32 toolchain setup: [github.com/monome/avr32-toolchain](https://github.com/monome/avr32-toolchain)

monome modules are powered by an avr32 which is preloaded with a bootloader.

see [firmware update](/docs/modular/update) for flashing instructions.

note: there is an unpopulated UART header which allows for proper debugging. we use an FTDI breakout board for communication with the module.

note: there is also an unpopulated reset switch, which allows for faster development.

note: after uploading a new image, the firmware will start immediately, but an additional reset is needed to re-enable USB host (ie, grids).

for developing crow firmware, see [here](https://github.com/monome/crow/blob/master/readme-development.md).
