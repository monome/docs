---
layout: default
title: development
parent: aleph
nav_order: 2
permalink: /aleph/development/
---

# Aleph Development

## Development Guides

General instructions on getting started developing for the aleph are available in the following three development guides. They largely consist of thoroughly commented code with some accompanying documentation to point you at the relevant parts.

### Bees OP Dev Guide

To expand the functionality of Bees the simplest method is to create or modify operators. This guide will walk you through the process of creating the new operator `FADE` which is now distributed as part of Bees:

[op: FADE dev guide](/docs/aleph/dev/bees)

### Standalone Application Overview

While Bees is the primary application that runs on the AVR 32 in aleph, it is possible to create your own application to replace Bees. This might be appropriate if you need to leverage more power out of the processor for specific tasks, or want to implement alternate methods of interacting with the aleph hardware:

[Standalone App Overview](/docs/aleph/dev/app)

### DSP Dev Guide

This guide walks through the process of building and modifying the DSP programs for the Aleph. These modules run independently of Bees or standalone apps and are coded for the Blackfin DSP chip.

[DSP Dev Guide](/docs/aleph/dev/dsp)

## Repository

[github.com/monome/aleph](https://github.com/monome/aleph)

The README contains extensive notes on code layout and toolchain setup.

The repo has 3 branches:

- dev : Where active changes are made. do be careful that your changes don't break anyone's workflow (e.g. un-added new source files)
- exp : An alternative to 'dev' for sharing changes that are known to break things. should be needed only rarely.
- master : From which releases are made. contains most recent code, and build files as well.

To build Bees, run 'make' in aleph/apps/bees. This produces aleph-bees-x.y.z-dbg.hex by default. 'make R=1' produces a release build, aleph-bees-x.y.z.hex (you must also run a 'make clean' if switching between debug and release.)

To build a module, run 'make deploy' in e.g. aleph/modules/lines. This produces lines.ldr, a blackfin executable, as well as lines.dsc, the parameter descriptor file. 'make' alone just builds the .ldr, which is fine if you aren't making changes to the parameter descriptors.

To contribute to the codebase:

- Make your own fork of 'aleph' on github
- Work on the 'dev' branch
- Submit pull requests for your changes.

(Much more detailed instructions here: [Forking](/docs/aleph/forking))

### Releases

Pretty often, I'll make a release tag. This is a datestamped git tag pointed at a commit in the master branch. (Why datestamped? See 'Versions' section below.)

[github.com/monome/aleph/releases](https://github.com/monome/aleph/releases)

Making a release entails doing these things:

- Checkout master and merge from dev
- Check commit history, update CHANGELOG and version numbers if needed.
- Rebuild all components that changed. For bees, there is a “make deploy” target that produces both debug and relase.
- Add the new, version-tagged .hex files to master.
- Run 'git tag [datestamp] -m [changelog additions since last release]'
- Push to master

### Versions

The Aleph repository includes several indepenent software components. Each may be developed at a different pace, so they have different version numbers.

In particular, each dsp module (.ldr) and each application (.hex) should be versioned. This is so that we can track compatibility between a given app and any module(s) associated with it.

Each version number follows the format of Semantic Versioning. (visit [http://semver.org](http://semver.org) for details.)

Right now, each Makefile searches for `version.mk` which defines major, minor, and patch numbers in separate make variables.

For Bees (and other applications that use Makefile.avr32.in), these numbers are concatenated into a string and appended to the filename of a copy of the .hex output. Unless it is a release build ('make R=1'), the string ”-dbg” is also appended. This entire string (“X.Y.Z” or “X.Y.Z-dbg”) is also passed by the preprocessor to a static AppVersion variable.

For DSP modules, there is no debug/release option. Version numbers are passed to the program and reported over SPI when queried.

## Hardware Expansion

The Aleph hardware is open source:

[github.com/tehn/aleph-hardware](https://github.com/tehn/aleph-hardware)

While the majority of aleph development will concern software, there is the possibility to augment the capabilities of the aleph with hardware.

### ii

*ii* is a digital communication protocol. We plan on co-designing with anyone interested. It is a 3.5mm stereo jack (for easy cabling) that uses the i2c bus. The bus is addressable (multiple devices on a chain), fast (400k), and easy to implement on various platforms (eg, an arduino).

In the immediate future we will use *ii* for inter-aleph communication while continuing to develop a simple kit and framework for creating hardware extensions. The protocol is being actively developed and any contributions are welcomed.

### Bipolar CV Outs

The aleph delivers CV outs in the range of [0,10] volts which covers the most common range for control voltages in commercial synthesizers. if you would prefer to convert the outputs to bipolar you will need an external voltage offset. These can be purchased commercially or could be a good diy project. An example schematic is posted below. Board layout files will be provided if there is demand:

![](../images/cv-offset-fixed.png)

![](../images/cv-offset-variable.png)

These schematics provide fixed & variable offset options respectively.
