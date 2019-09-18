---
layout: page
permalink: /docs/crow/
---

![](/images/crow.jpg)

# Crow

Crow speaks and listens and remembers bits of text. A scriptable USB-CV-II machine.

Crow communicates Lua via USB in clear text:

```
to crow >     print("caw!")
crow says >   caw!
```

Which allows the weaving of musical structure:

```
to crow >     x = math.random(12)
              print(x)
crow says >   3
to crow >     output[1].slew = 0.9
              output[1].volts = x

(CV output 1 ramps to 3 volts over 0.9 seconds)
```

Crow integrates with norns, and also connects to computers running Max, Max for Live, and other applications which speak serial. We created a simple application called Druid to facilitate conversation. Crow becomes a programmable CV and II interface.

Crow also stores a complete script, so that without a USB connection it can continue to run, responding to CV input and II messages.

A collaboration by Whimsical Raps and monome.


## Specifications

- Eurorack, 2hp width, 41mm depth
- Power consumption: 60mA @ +12v, -15mA @ -12V, no 5V
- 2 input, 4 output, 16bit [-5V,10V] range
- Rear II connector with switchable pullups
- 3.5mm stereo MIDI input on top jack
- full Lua scripting environment


## Installation

Align the 10-pin ribbon cable so the red stripe corresponds to the white indicator on the rear of the module’s circuit board. This is toward the lower edge of the module.

If you would like to use the II functionality, be sure to observe the orientation of the connector. The white stripe indicates GND.


## First

**@trentgill** (brief details of the default script)


## Norns

[norns crow subpage](norns)

## Max

**@dndrks**

To utilize the `crow` object in Max/MSP, you'll want to drop the entire `crow_max` folder into Max's search path. There are two ways to do this: (a.) add the folder to your current User Library or (b.) create your own path directly to the folder. We suggest (a.), since it's a bit cleaner.

a. Open Max > Options > File Preferences > highlight User Library > the rightmost icon in the bottom bar should illuminate. Clicking this icon will open the User Library folder, where you can drop the `crow_max` folder. Restart Max and you should be able to instantiate the `crow` object!

b. Open Max > Options > File Preferences > the leftmost icon in the bottom bar (+) will allow you to define your own user path. You'll see a new entry appear at the bottom of the list. Select 'choose' in the Path column and select your downloaded `crow_max` folder.

(image of a basic max-crow thing. dd: perhaps the i2c/Just Friends tab from the maxhelp file?)


## Max for Live

**@dndrks**

After downloading the `crow_m4l` folder, place it wherever you'd prefer on your harddrive. Open Ableton Live 9 or 10 and drag the folder into Live's browser, under PLACES.

If you are updating a previous installation, just replace the previous `crow_m4l` folder's contents with the new files.

(image of ableton-m4l-crow device)


## Druid

("livecoding" and script uploading)

(how to install, example usage)

(image of editor+druid)


## Scripting

Short (standalone) lua example.

[scripting](scripting) - standalone examples (mirror "rising")

[reference](reference) - standalone functions and tables

- [programming in lua (first edition)](https://www.lua.org/pil/contents.html)
- [lua 5.3 reference manual](https://www.lua.org/manual/5.3/)
- [lua-users tutorials](http://lua-users.org/wiki/TutorialDirectory)
- [lua in 15 mins](http://tylerneylon.com/a/learn-lua/)



## Updates

[current firmware version](https://github.com/monome/crow/releases)

You can check the version of the firmware on a crow several ways:

- Norns: open maiden and type `crow.version` into the command prompt REPL.
- Druid: type `^^version`.
- Max/M4l: **@dndrks** maybe have it printed somewhere on connect??

[bootloader instructions](update) - step by step guide to update the crow firmware.


## Technical

[technical](technical) - calibration, ^^ commands?


## Help

Community discussion happens at [llllllll.co](https://llllllll.co). Come say hello!

Contact *help@monome.org* with further questions.


## Development

Crow continues to evolve and you can follow development on github:

[https://github.com/monome/crow](https://github.com/monome/crow)

Crow is open-source and is built on the efforts of other open source projects. Contributions are welcome.
