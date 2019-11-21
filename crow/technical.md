---
layout: default
parent: crow
title: technical
nav_order: 8
permalink: /crow/technical/
---

# Technical

## Calibration

Crow has an in-built calibration mechanism to allow the inputs and outputs to accurately follow and output values. This functionality is primarily for use with volt-per-octave signals, though of course this accuracy can be used for any number of other purposes!

All modules come pre-calibrated from the factory, so you'll likely never need to think about this, but just in case, recalibration and data inspection is allowed.

### cal.test()

The `cal.test()` function causes crow to re-run the calibration process.

**You must remove all patch cables from the jacks for this process to work correctly!**

Calling `test` without any arguments runs the calibration as per normal, while running `test('default')` will not run the calibration process, but instead return to default values, in case you're having problems with the calibration process.

### cal.print()

This helper function is just for debugging purposes. Calling it will simply dump a list of values showing the scaling & translation of voltages that were measured during the calibration process. If you're really curious try resetting to the defaults then printing, followed by a `test()` and `print()` to see the difference.

## Environment Commands

The below commands should be integrated into a host environment as macros or commands. In particular, the user shouldn't need to worry about typing them explicitly. norns should provide higher-level functions that send these low-level commands & split up larger code pieces automatically.

The following commands are parsed directly from usb, so should work even if the Lua environment has crashed. nb: start/execute/write-script won't work correctly if the env is down though. Use `^^clearscript` first.

nb: only the first char after the `^^` symbol matters, so the host can simply send a 3 char command (eg `^^s`) for brevity & speed

- `^^startscript`: sets crow to reception mode. following code will be saved to a buffer.
- `^^executescript`: crow will restart. buffered code will be error-checked and run immediately.
- `^^writescript`: crow will restart. buffered code will be error-checked, written to flash, then run.
- `^^clearscript`: clears a saved user script. use this if your script is crashing crow. or you want a clean slate.
- `^^First`: restarts crow and sets `First` as the default script to run on boot, and runs it.
- `^^printscript`: requests crow to print the current user script saved in flash over usb to the host. prints a note if no user script exists or First is running.
- `^^bootloader`: jump directly to the bootloader.
- `^^reset`: reboots crow (not just Lua env). nb: causes usb connection to be reset.
- `^^kill`: restarts the lua environment but doesn't run the user script.
- `^^identity`: returns serial number.
- `^^version`: returns current firmware version.


### Recovering from an unresponsive state

It's entirely possible to upload crow scripts that will make crow unresponsive and require clearing of the on-board script.

The gentlest way to deal with this situation is to send the `^^clearscript` command over usb

- druid: `^^c`
- norns: `crow.clear()`

If your crow is connected to your computer through usb + properly powered, but druid reports it `can't find crow device`:

- download the [most recent firmware](https://github.com/monome/crow/releases)
- [force the bootloader](../update/#forcing-the-bootloader)
- **macOS + Linux**: open `osx_linux-erase_userscript.command`
- **Windows**: open `windows-erase_userscript.bat`
