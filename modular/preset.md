---
layout: default
nav_exclude: true
permalink: /modular/preset
---

# preset management

it is possible to connect your module to a computer in order to save and restore preset data. _beware, this is command-line heavy._

WARNING. while we're confident with this procedure, it is an advanced use and command line familiarity is assumed. _if you brick your module, we can fix it, but we will require you pay round trip shipping._

have dfu-programmer installed, as described in the [firmware update](/docs/modular/update) section.

- open a terminal.
- get into a folder where you want to store your files.
- power up the module while holding the PRESET key. this starts the WW in bootloader mode.
- connect a USB A-A cable to the computer.

to save your current preset data, type:

	dfu-programmer at32uc3b0256 read > n.hex

where "n.hex" is the name of your file. it must have .hex as an extension.

at this point your unit is still in bootloader mode. you are not done. you now want to either:

- reactivate the module, if you were simply backing up your progress,
- restore an previous preset data file, or
- start with a fresh, blank preset bank

to re-activate your module:

	dfu-programmer at32uc3b0256 launch

to restore a "n.hex" file (get into bootloader mode first):

	dfu-programmer at32uc3b0256 erase
	dfu-programmer at32uc3b0256 flash n.hex
	dfu-programmer at32uc3b0256 launch


to clear out the presets and start fresh, simply flash a factory firmware, downloaded from the github. see [firmware update](/docs/modular/update).


_note:_ the entire flash is read and written, including the program data, so there is no portability between firmware versions. (ie, presets from WW 1.1 will not work with WW 1.4).
