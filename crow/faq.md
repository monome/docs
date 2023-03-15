---
layout: default
parent: crow
title: help
nav_order: 9
permalink: /crow/faq/
---

# crow questions
{: .no_toc }

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## dictionary of crow terms {#dictionary}

### i2c

[i2c](/docs/modular/ii) is a communication bus - it’s a way for devices to talk to each other, similar to MIDI or USB. In the monome ecosystem, an i2c protocol called "ii" provides a convenient way to send commands & data between modules. In some situations reducing what could be many patch-cable connections down to a single i2c cable hidden behind the module. For example, crow can send unique synthesis commands to [Just Friends](https://www.whimsicalraps.com/products/just-friends), accessible only with the ii protocol.

### druid

[druid](https://github.com/monome/druid) is a utility for communicating with crow, both for realtime interaction and the uploading of full scripts. It requires Python3+ to be installed on your computer.

### Lua

Lua is a programming language known for its flexibility to be embedded in applications. [norns](https://monome.org/norns/) uses Lua to allow the creation of scripts to express musical + artistic ideas. crow also speaks Lua, so it extends the norns ecosystem. Using druid, you could upload a Lua script to crow -- in turn, crow would save this and perform the script without a computer attached.

### ASL

A Slope Language -- the unique syntax developed for crow to describe voltage control events over time. For example, a sawtooth ramp could be described as starting at 5.0 V and falling to 0.0 V over a period of one second, then looping:

```lua
output[1].action =
    loop{ to( 5.0, 0.0 )
        , to( 0.0, 1.0 )
        }
```

[Learn more here](/docs/crow/reference/#asl).

### "event-based"

crow is a blank slate, so it requires instructions to know what you’d like it to do at any given moment. Let's say you want to send voltage from crow's first output to a filter's cutoff frequency. You can automate this instruction by telling crow “please emit 3.33 volts from your first output.” crow is designed to listen to a specific scripting syntax.

Messages to crow must fit a format that crow expects, e.g.:

```lua
output[1].volts = 3.33
```

Or on norns: `crow.output[1].volts = 3.33`

This command tells crow “please emit 3.33 volts from your first output”. For a list of all of crow's commands, see the [scripting reference](../reference).

Using the scripting reference, you could:

- live-code through druid, typing instructions to crow in real time
- create a Max patch that sends instructions to crow on demand / as a sequence of events (a version of live-coding without the command line)
- write a norns script that tells crow to wait for triggers at its inputs to create different types of envelopes
- you can upload a full script to crow so that it knows what it’s meant to do when it's not connected to a computer or norns, and it would just await external triggers or control voltage at its inputs

## scripting

### how large a script can I run or store on crow in standalone?

crow can support a Lua script up to 16kb in size, which is ~700 lines. Most crow scripts are less than 100 lines -- the ones in [bowery](https://github.com/monome/bowery/tree/main) provide very good examples.

Lua has incredible capacity for abstraction. The crow library leverages this to provide many complex features with terse syntax.

For example, here are 3 lines that create an ADSR envelope triggered by input 1 and sent to output 1:

```lua
output[1].action = adsr()
input[1].change = function(s) output[1](s) end
input[1].mode = 'change'
```

### Max

#### what are the formatting differences between druid + Max syntax?

In Max, you use the exact same commands as you would in druid -- the only difference is you need to wrap them in quotes to make sure they are a single chunk, and prepend that chunk with `tell_crow`.

In druid:
`output[1].volts = 3`

In Max:
`tell_crow “output[1].volts = 3”`

The quotes are crucial because they make sure the Lua command is treated a single chunk.

#### best practices

The `[sprintf]` object is the easiest way to format messages to crow. Using the `symout` argument, the `[sprintf]` object outputs a string as a single symbol -- ideal for sending to crow as a Lua chunk.

*Example: control the voltage of an assignable output*

![](images/max-faq-1.png)

- `[sprintf symout "output[%i].volts = %.2f"]` creates a string that accepts an integer (output ID) through its first inlet and a 2-decimal float (voltage) through its second inlet
- since `[sprintf]`'s second inlet is *cold*, we use `[t b f]` to send a bang to `[sprintf]`'s first inlet to force the output whenever the float (voltage) changes
- we send the string to `[prepend tell_crow]` to format the instruction
- and finally, we send that formatted message to `[crow]`!

## hardware

### one of crow's inputs doesn't seem to respond to triggers

If you are running a script or device that uses crow's inputs (perhaps for clocking), but crow doesn't seem to be receiving the triggers, try executing the following commands in druid/maiden/max: `crow.reset()` and `crow.clear()` (or `^^r` and `^^c`).

### can I use [x thing] to control crow?

Since crow uses a specific communication syntax, it requires some sort of layer between the thing you want to use to control crow and crow itself. Right now, you can use any of these to have immediate fun with crow:

- norns
- druid
- Max
- Max for Live

For example, if you like to use a specific app on your laptop for live-coding, plugging crow into your laptop while running the app will not suddenly translate MIDI to CV. crow won't even show up as a "MIDI device." However, you *could* use the [crow] Max object's help file to package a translator between them. Or you could route the MIDI from your live-coding app into Ableton Live 11 Suite and use the Max for Live toolkit to perform this translation.

### can I control two or more crows at the same time from norns?

Not currently, though it is being actively explored.

### can crow make sound on its own?

Yes! The `oscillate` ASL action allows audio rate through any of crow's outputs. See [the reference](/docs/crow/reference/#actions) for more details.

### what is crow's sample rate?

crow internally generates signals at 48kHz (though the user doesn’t have direct access to these samples). crow reads inputs at 1.5kHz.

### what are the differences between crow and Teletype?

| Aspect       | crow | Teletype |
| ---          | ---  | ---      |
| panel hardware     | 2 CV inputs (1.5 kHz sample rate), 4 CV outputs (48 kHz sample rate), mini USB | 8 trigger inputs, 4 trigger outputs, 1 CV input, 4 CV outputs, potentiometer, USB-A port, button, screen |
| events       | focused on sending and receiving bits of text from something else, and manipulating and reacting to things happening elsewhere in your setup – CV crossing some threshold, receiving an I2C message | focused on running small bits of code in reaction to triggers. These can be any of the 8 trigger inputs patched from elsewhere in your modular, or an internal “metro” (metronome) script that’s triggered at a fixed rate |
| scripting | runs Lua scripts, a general purpose programming language with a higher abstraction level (also used on Norns) | runs scripts written in a specialized, stack-based language (sometimes called “TT-script”) designed for Teletype |
| storage | has larger (8kb) user storage space for scripts | deliberately has a limited amount of code and data that can be in use at any given time |
| USB | is **not** a USB host - it does not supply USB power and is not programmed to talk to USB devices. Other devices (a computer, Norns, etc) have to initiate communication with it and supply USB power | is a USB host, so it can support USB devices and supply power to them. Currently the supported devices are a keyboard, a USB disk so you can make backups of your work, and a Grid (external power required) |
| UI | requires some other device, typically a computer, to send scripts or instructions to it. This can be really convenient, since you can use whatever editor / other tools you like on your computer, and paste chunks of code or whole scripts to crow as needed. [druid](https://github.com/monome/druid) can be used on any computer to interact with crow over the serial port. Norns, Max, and Max4Live can also send bits of code to crow. | has a screen and directly connects to a keyboard so you can write code right on the module with nothing else |
| CV output | very flexible at producing gates and CV. LFOs and envelopes can be arbitrarily specified using the [ASL](https://github.com/monome/crow#output-library--asl) mini-lanugage | can produce both gates and CV. CV can slew on its way to a new value, but can't loop on its own - a script has to initiate each change |

## i2c

### is crow's status as an [i2c leader or follower](https://github.com/monome/crow#leading-the-i2c-bus) automatic or configurable?

It’s automatic, but only because leading and following isn't a property of a single device -- it's a property of communication. crow is very flexible, designed to be agnostic to who/what it's speaking with.

Basically, crow is always listening to other devices (ie following), until it's told to execute a leader-command, at which point it attempts to lead the bus. Once that command / query is complete, it returns to follower mode.
