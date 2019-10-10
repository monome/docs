---
layout: page
permalink: /docs/crow/technical/
---

# Technical

## Calibration

Crow has an in-built calibration mechanism to allow the inputs and outputs to
accurately follow and output values. This functionality is primarily for use with
volt-per-octave signals, though of course this accuracy can be used for any number
of other purposes!

All modules come pre-calibrated from the factory, so you'll likely never need to
think about this, but just in case, recalibration and data inspection is allowed.

### cal.test()

The `cal.test()` function causes crow to re-run the calibration process.

**You must remove all patch cables from the jacks for this process to work correctly!**
Calling `test` without any arguments runs the calibration as per normal, while
running `test('default')` will not run the calibration process, but instead return
to default values, in case you're having problems with the calibration process.

### cal.print()

This helper function is just for debugging purposes. Calling it will simply dump
a list of values showing the scaling & translation of voltages that were measured
during the calibration process. If you're really curious try resetting to the defaults
then printing, followed by a `test()` and `print()` to see the difference.


## Environment Commands

The below commands should be integrated into a host environment as macros or
commands. In particular, the user shouldn't need to worry about typing them
explicitly. norns should provide higher-level functions that send these low-level
commands & split up larger code pieces automatically.

The following commands are parsed directly from usb, so should work even if the lua
environment has crashed. nb: start/end script won't work correctly if the env is
down though. Use `^^clearscript` first.

nb: only the first char after the `^^` symbol matters, so the host can
simply send a 3 char command (eg `^^s`) for brevity & speed

- `^^startscript`: sets crow to reception mode. following code will be saved to a buffer
- `^^endscript`: buffered code will be error-checked, eval'd, and written to flash. crow returns to repl mode.
- `^^clearscript`: clears onboard flash without touching lua. use this if your script is crashing crow.
- `^^printscript`: requests crow to print the current user script saved in flash over usb to the host. prints a warning if no user script exists.
- `^^bootloader`: jump directly to the bootloader.
- `^^reset` / `^^restart`: reboots crow (not just lua env). nb: causes usb connection to be reset.
- `^^kill`: restarts the lua environment
- `^^identity`: returns serial number.
- `^^version`: returns current firmware version.


### Recovering from an unresponsive state

It's entirely possible to upload crow scripts that will make crow unresponsive
and require clearing of the on-board script.

The gentlest way to deal with this situation is to send the `^^clearscript`
command over usb, which may be followed by `^^reset`

- Druid: `^^c` then `^^r`
- Norns: `crow.clear()` then `crow.reset()`
