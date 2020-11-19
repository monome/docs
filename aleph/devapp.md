---
layout: default
nav_exclude: true
permalink: /aleph/dev/app/
---

# Aleph: Standalone App Overview

An example application called “mix” showing how to make a customized application to take the place of Bees for the Aleph. The majority of information is written in comments in the referenced code: [github.com/monome/aleph/tree/master/apps/mix/src](https://github.com/monome/aleph/tree/master/apps/mix/src).

This document is largely a reference to point you to the right piece of code.

## Toolchain setup

### Mac OS X

To build from source see: [droparea's github](https://github.com/droparea/avr32-toolchain)

### Linux

Visit Atmel's [download site](http://www.atmel.com/tools/ATMELAVRTOOLCHAINFORLINUX.aspx) and download/install the following packages. You will need to sign up for an account to download the files:

- Atmel AVR 32-bit Toolchain 3.4.2 - Linux 32-bit (don't get 64bit)
- Atmel AVR 8-bit and 32-bit Toolchain (3.4.2) 6.1.3.1475 - Header Files

### Windows

Download and install AVR Studio from Atmel's site. You will need to sign up for an account to download the files:

- [AVR Studio](http://www.atmel.com/tools/ATMELSTUDIO.aspx)

## Github

Note that in order to share your creations with the Aleph community you'll need to clone and fork the Aleph github repo. see [Forking](/docs/aleph/forking) for details.

## Overview

This is a very basic application for the Aleph hardware to demonstrate development for the control system which runs on the AVR32. DSP on the Aleph runs on the Blackfin BF533, which the AVR32 communicates with via SPI.

Most use of the Aleph to this point has used Bees, which is a flexible/routable/extensible environment written for the AVR32. This application takes the place of Bees.

Creating your own application allows you to radically alter the functionality of the Aleph and leverage the AVR32's processing power in more focussed ways than Bees. In general this is for specialized projects where adding an operator to Bees could not acheive the desired results.

## app/mix

The code on github is extensively inline commented. Here's a guide to the files:

### config.mk

Makefile for this application.

### src/app_mix.c

Main program file. `app_init()` and `app_launch()` are here, called from the AVR32 framework on startup.

Here the DSP program is loaded via SPI. In this example the DSP is included in the code as a binary (as `src/aleph-mix.ldr.inc`) but DSP can be loaded via a file on the SD card (see [Bees](/docs/aleph/bees) for how this works).

The event handlers are assigned at `assign_event_handlers()` and then `app_launch()` finishes, returning to the main loop. The AVR32 framework main loop simply checks the event hander continuously, so your program code fundamentally lives in these handlers, which is in the following file.

### src/handler.c

Here are located the handlers themselves i.e. `handler_Switch2()` etc, and the event assignment function `assign_event_handlers()` which was called from `src/app_mix.c`

Handler functions receive a single signed 32 bit argument. For switches this is 0 or 1 (on/off) and for encoders it is the delta rotation. In this case the handlers are calling `ctl_xxx` functions from `src/ctl.c` which send parameter changes to the DSP.

### src/ctl.c

This file contains data strutures and functions to change parameters of the DSP program.

Used here are scaler lookups defined in `src/scaler.c` for interpolation and db conversion.

Also this is where screen rendering is called, functions defined in `src/render`.c

### src/app_timers.c

Lastly, `src/app_timers.c` contains software timers used for screen refresh and encoder data collection. Initialization is called from `app_launch()` and callbacks are set up.
