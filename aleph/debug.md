---
layout: default
nav_exclude: true
permalink: /aleph/debug/
---

# Debugging Aleph

If you encounter a problem, you can help us debug it:

- Use the most recent build labelled ”-dbg”
- Open a terminal connection to Aleph's USB device port. For Ubuntu:

~~~
sudo apt-get install minicom
sudo minicom -b 500000 -D /dev/ttyACM0
~~~

*NB: In Bees 0.5+ baudrate is 115200 (this is probably temporary), so for now use:*

`sudo minicom -b 115200 -D /dev/ttyACM0`

*NB: On ubuntu 10.04 the above instructions did not work for me. I successfully used:*

`cu -l /dev/ttyACM0 -s 115200`

For other systems, something similar applies: Aleph should show up as a peripheral modem of some kind. Connect to it with a terminal at 115200 baud and standard settings otherwise.

Flash `aleph-bees-n.n.n-dbg.hex` to Aleph and observe terminal output.

Contact us directly: help@monome.org

Attach the output of the debug process above .

## Tracking Issues

Known issues are logged and tracked via the [Aleph github page](https://github.com/monome/aleph/issues).

See here for a list of known issues and requested improvements.

If you find a bug and can reliably reproduce it, feel free to create an *Issue* outlining the steps to reproduce. Attach a debug report as above if possible.

If you're not sure exactly what's going on, or want to discuss potential new features, best to post to the [Lines forum](http://llllllll.co).
