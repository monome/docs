---
layout: default
nav_exclude: true
permalink: /serialosc/linux/
---

# Linux setup

_Note: This guide may need link updates! Please let us know: [help@monome.org](mailto:help@monome.org)_.

This is a brief guide for using a monome grid on Linux. This guide covers two Linux distributions: [Ubuntu Linux](https://www.ubuntu.com) and [Arch Linux](https://www.archlinux.org). Once the required packages are installed, check out the [list](/docs/grid/app) of available applications, or read through the [guides](/docs/grid/studies/) on how to create your own.

## Ubuntu Linux

The easiest way to setup things on Ubuntu is to get the precompiled packages from a PPA: [ppa:artfwo/monome](https://launchpad.net/~artfwo/+archive/monome).

	$ sudo add-apt-repository ppa:artfwo/monome
	$ sudo apt-get update
	$ sudo apt-get install libmonome
	$ sudo apt-get install serialosc

## Arch Linux

The easiest way to setup things on Arch is to use the PKGBUILDs available in the AUR. You can either install them manually, or use an AUR helper utility such as [yay](https://github.com/Jguer/yay) or [auracle](https://github.com/falconindy/auracle). Once that's done, you can install the required packages:

- [libmonome](https://aur.archlinux.org/packages/libmonome-git/)
- [serialosc](https://aur.archlinux.org/packages/serialosc-git/)

## Other Linux distributions

If there are no precompiled packages available for your distribution, you can still build libmonome and serialosc from source. Generic build instructions can be found in the "compiling from source" section of the [raspbian install docs](/docs/raspbian/).

## Notes

You'll need to have the `usbserial` and `ftdi_sio` kernel modules loaded before connecting your grid. Most Linux distributions include these modules by default, and should load them as soon as they detect your grid being plugged in. If these USB and serial modules are not available in your kernel, follow your distribution's documentation for configuring, compiling, and installing a custom kernel.

Load the required kernel modules, verify that they're loaded, and start serialosc:

	$ sudo modprobe usbserial ftdi_sio
	$ lsmod
	$ serialosc
	serialosc [m128-000]: connected, server running on port 18872

Unplug your grid so that it saves its current configuration to `~/.config/serialosc/`, including port number. Press `Ctrl-C` to stop `serialosc`.

Now re-run `serialosc`, then plug and unplug your grid to save your config. If you need to change any aspect of your grid, such as its rotation in 90-degree increments, edit `~/.config/serialosc/<your_monome_id>.conf`. You can also set the application prefix, host, and port numbers.

If you get a permissions error when running serialosc:

	$ serialosc
	libmonome: could not open monome device: Permission denied

Add your user to the `uucp` and/or `dialout` groups, so that you can use serial devices. The exact group name will depend on your distribution:

	$ sudo gpasswd -a yourregularuser uucp
	$ sudo gpasswd -a yourregularuser dialout

Then log out, and log back in as your regular user.
