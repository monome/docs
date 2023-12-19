---
layout: default
parent: norns
title: help
nav_order: 6
---

# norns: help

Between the search bar above and the links below, you should be able to solve most norns troubles that you'd run into:

- [hardware](../help/hardware) // replacement parts, WiFi, boot issues, connectivity, audio specs
- [software](../help/software) // system logs, script updates, error messages
- [data](../help/data) // backing up, fresh installation, expanding storage, removing logs, taking a screenshot

### additional assistance

If you need additional assistance, we're here for you! Please send an email to [help@monome.org](mailto:help@monome.org) using this format:

- *What issue did you experience?*
- *What steps are necessary to reproduce the issue?*
- *What additional hardware was connected to norns at the time of the issue? This includes controllers, wifi dongles, external hubs, etc.*
- *Please attach any output printed in [maiden](../maiden/) when the issue occurs*

If you're unable to supply concrete steps to reliably reproduce the issue, this will reduce our efficacy. Please understand if we point you to existing resources and ask you to verify additional info.

For support with specific scripts and libraries, please visit [lines](https://llllllll.co) and search for the script's thread.

### buying used

While monome's [warranty](https://monome.org/policy.html) only covers direct sales, we will still do everything we can to keep our devices out of landfills. We offer incredibly reasonable and quick repairs through our workshop (for norns, typically $90-125 USD + shipping) and guidance for any applicable at-home service. Just reach out to us by emailing help@monome.org with a description of the issue, including any photos or videos which would help us precisely identify the best course of action.

Please note that we cannot offer hardware support or repairs for norns shields which were not fabricated and assembled by monome or 'fates' devices. Please reach out to the seller for post-purchase support.

Before purchasing, be sure to confirm with the seller the storage capacity of the unit. Here are [instructions for standard norns](/docs/norns/help/hardware/#confirm-cm3); shields have swappable SD cards.

When you receive your unit, we highly recommend starting with a [fresh installation of the core software](/docs/norns/help/data/#fresh-install). This will help avoid poor initial experiences due to the previous owner's software configurations.

From there:

- [connect norns to WiFi](/docs/norns/wifi-files/#connect)
- [perform a system update](/docs/norns/wifi-files/#update)
- once norns is connected to WiFi, use a browser on a computer connected to the same network to connect to [maiden](/docs/norns/maiden/), which opens a communication channel between your computer and norns
- access the [project manager](/docs/norns/maiden/#project-manager) and you'll see all the community scripts available for installation

### miscellaneous helpful information

- Imported audio must be 48khz, bit depth is irrelevant.
- Line noise while usb charge + audio input are both coming from the same laptop (ground loop) can be defeated with [an isolator](https://llllllll.co/t/external-grid-power-ext5v-alternative/3260).
- If a connected MIDI controller is not functioning as expected, it may be due to a script that does not explicitly allow for MIDI control from virtual ports other than port 1. Either reassign your MIDI controller to port 1 or insert this [bit of code](https://llllllll.co/t/norns-scripting-best-practices/23606/2) into the script.
- All grid editions will work with norns, but some scripts may be coded for varibright levels that your hardware may not support.
- norns does not have built-in Bluetooth and the software is not currently designed to take advantage of Bluetooth via USB adapter.