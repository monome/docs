---
layout: page
permalink: /crow/faq/
---

# crow questions

<img src="https://cdn.theatlantic.com/assets/media/img/2019/01/31/0319_WEL_Andersen_lead/1920.jpg?1549576567">

- [dictionary](#dictionary)
- [scripts](#scripts)
- [hardware](#hardware)
- [i2c](#i2c-head)

## a short story from Sam

Every day when a crow wakes up, it likes to follow the same daily routine, which may involve flying along complex paths, communicating with other creatures, solving problems, responding to external environmental stimuli, and more.

*When Crow turns on, it runs a script loaded into its flash memory. That script may involve generating control voltage, responding to control voltage/Lua code, acting as a CV expander for Norns, controlling other devices over the I2C bus, and more.*

Typically, the Crow follows its innate biological daily routine.

*Typically, Crow runs the default script, default.lua, aka First.*

However, your Crow is quite smart, and it can learn a new daily routine to follow whenever you want.

*You can upload a User Script onto Crow via druid, Max, or even a Max4Live device in Ableton. Norns scripts will also redefine how Crow behaves.*

Your Crow can return to its innate biological daily routine at anytime by telling it to forget the special daily routine which you delivered to it previously.

*Crow can be restored to its default script by clearing the User Script.*

Your Crow is also highly adaptable and can communicate with you via telephone wires in real-time over the course of a day. This allows it to temporarily deviate from its daily routine. You can request reports about how it feels and what it sees, explore a new path which you radio in to it, change how it responds to environmental stimuli, communicate with other creatures for you, and more! The next day however, it will return to its daily routine, whether that is its biological routine or one which you previously gave it.

*You can send your Crow new code to execute on the fly (pun intended) in real-time. This is done by sending Lua code to it over a USB cable. The code may be composed and sent via druid, Max, Max for Live devices in Ableton, or Norns. That code might redefine how it responds to and generates voltage, it might directly change the state of its inputs or outputs, it might return information to you about its internal state or externally received voltages, it might relay messages to other devices over I2C and more! When you restart Crow, it will return to the behavior defined by the script in flash memory, whether that is default.lua or a User Script.*

## dictionary of crow terms<a name="dictionary"></a>

### i2c

i2c is a communication protocol - it’s a way for devices to talk to each other, like MIDI or USB. In the monome ecosystem (where i2c is sometimes also referred to as “ii”), i2c provides a convenient way to send commands/data between modules. In some situations reducing what could be many patch-cable connections down to a single i2c cable hidden behind the module. For example, crow can use i2c to send unique synthesis commands to Just Friends.

### druid

[druid](https://github.com/monome/druid) is a utility for communicating with crow, both for realtime interaction and the uploading of full scripts. It requires Python to be installed on your computer.

### Lua

Lua is a programming language known for its flexibility to be embedded in applications. [norns](https://monome.org/norns/) uses Lua to allow the creation of scripts to express musical + artistic ideas. crow also speaks Lua, so it extends the norns ecosystem. Using druid, you could upload a Lua script to crow -- in turn, crow would save this and perform the script without a computer attached.

### asl (think a/s/l)

A Slope Language -- the unique syntax developed for crow to describe voltage control events. For example, a sawtooth ramp could be described as starting at 5.0 V and falling to 0.0 V over a period of a second, then looping:

```lua
output[1].action =
    loop{ to( 5.0, 0.0 )
        , to( 0.0, 1.0 )
        }
```

[Learn more here](https://github.com/monome/crow#output-library--asl).

### "event-based"

crow is a blank slate, so it requires instructions to know what you’d like it to do at any given moment. Let's say you want to send voltage from crow's first output to a filter's cutoff frequency. You can automate this instruction by telling crow “please emit 3.33 volts from your first output.” crow is designed to listen to a specific scripting syntax.

Messages to crow must fit a format that crow expects, e.g.:

`crow.output[1].volts = 3.33`

This command tells crow “please emit 3.33 volts from your first output”. There are currently a few things that know how to talk to crow (norns, druid, and the Max/M4L toolkit), but this is certainly not a widely adopted standard.

[Documentation of this syntax](https://monome.org/docs/crow/reference/).

Using one of these tools, though, you could:

- live-code it through druid, typing instructions to crow in real time
- create a Max patch that sends these instructions to crow on demand / as a sequence of events (a version of live-coding without the command line)
- write a norns app that tells crow to wait for triggers at its inputs to create different types of LFOs
- you can upload a full script to crow so that it knows what it’s meant to do when it's not connected to a computer or norns, and it would just await external triggers (like control voltage at its inputs)

## scripts<a name="scripts"></a>

### norns

#### finding community scripts

Search `tags:crow+norns` at llllllll.co (or [click here](https://llllllll.co/search?expanded=true&q=tags%3Acrow%2Bnorns%20order%3Alatest)) to view the scripts on norns which are tagged as having crow integration.

#### writing norns + crow scripts

Visit [crow studies](https://monome.org/docs/crow/norns/) to learn how to integrate crow within scripts on norns.

### druid

#### finding community scripts

Visit [bowery](https://github.com/monome/bowery), a collection of druid scripts which hosts community contributions.

#### writing crow scriots in druid

Visit the [scripting reference](https://monome.org/docs/crow/scripting/) to learn how to use Lua to livecode and create standalone scripts for crow.

#### how large a script can I store on crow in standalone?

Currently, 8kB =~400 lines of Lua.

From Trent:
>I’ve found most scripts I’ve created so far are <100 lines. Lua may be less terse than Teletype, but it has far greater capacity for abstraction. The crow library leverages this to provide many complex features with terse syntax.

eg. 3 lines that create an ADSR envelope triggered by input 1 and sent to output 1:

```lua
output[1].action = adsr()
input[1].change = function(s) output[1](s) end
input[1].mode = 'change'
```

#### how large a script can I build in druid?

Currently, 8kB=~400 lines of Lua.

## hardware<a name="hardware"></a>

### can I use [x thing] to control crow?

Since crow uses a specific communication syntax, it requires some sort of layer between the thing you want to use to control crow and crow itself. Right now, you can use any of these to have immediate fun with crow:

- norns
- druid
- Max
- Max for Live

For example, if you like to use a specific app on your laptop for live-coding, plugging crow into your laptop while running the app will not suddenly translate MIDI to CV. crow won't even show up as a "MIDI device." However, you *could* use the [crow] Max object's help file to package a translator between them. Or you could route the MIDI from your live-coding app into Ableton Live 9/10 Suite and use the Max for Live toolkit to perform this translation.


### can I control two or more crows at the same time from norns or M4L?

Not currently, though it is being actively explored. Both norns and the M4L toolkit communicate with one crow at a time, though you *can* read the two inputs, transmit data over i2c, **and** control all four outputs on a single crow simultaneously.

### can crow make sound on its own?

Not currently. You *can* tell it to run very fast LFO's from its outlets, into audio rate, but this creates instability. For the best experience with crow, consider its outputs to be control-rate generators.

### what is crow's sample rate?

crow internally generates signals at 48kHz (though the user doesn’t have direct access to these samples). crow reads inputs at 1.5kHz.

### what are the differences between crow and Teletype?

| Aspect       | Crow | Teletype |
| ---          | ---  | ---      |
| panel hardware     | 2 CV inputs (1.5 kHz sample rate), 4 CV outputs (48 kHz sample rate), mini USB | 8 trigger inputs, 4 trigger outputs, 1 CV input, 4 CV outputs, potentiometer, USB-A port, button, screen |
| events       | focused on sending and receiving bits of text from something else, and manipulating and reacting to things happening elsewhere in your setup – CV crossing some threshold, receiving an I2C message | focused on running small bits of code in reaction to triggers. These can be any of the 8 trigger inputs patched from elsewhere in your modular, or an internal “metro” (metronome) script that’s triggered at a fixed rate |
| scripting | runs Lua scripts, a general purpose programming language with a higher abstraction level (also used on Norns) | runs scripts written in a specialized, stack-based language (sometimes called “TT-script”) designed for Teletype |
| storage | has larger (8kb) user storage space for scripts | deliberately has a limited amount of code and data that can be in use at any given time |
| USB | is **not** a USB host - it does not supply USB power and is not programmed to talk to USB devices. Other devices (a computer, Norns, etc) have to initiate communication with it and supply USB power | is a USB host, so it can support USB devices and supply power to them. Currently the supported devices are a keyboard, a USB disk so you can make backups of your work, and a Grid (external power required) |
| UI | requires some other device, typically a computer, to send scripts or instructions to it. This can be really convenient, since you can use whatever editor / other tools you like on your computer, and paste chunks of code or whole scripts to Crow as needed. [druid](https://github.com/monome/druid) can be used on any computer to interact with Crow over the serial port. Norns, Max, and Max4Live can also send bits of code to Crow. | has a screen and directly connects to a keyboard so you can write code right on the module with nothing else |
| CV output | very flexible at producing gates and CV. LFOs and envelopes can be arbitrarily specified using the [ASL](https://github.com/monome/crow#output-library--asl) mini-lanugage | can produce both gates and CV. CV can slew on its way to a new value, but can't loop on its own - a script has to initiate each change |

## i2c<a name="i2c-head"></a>

### what the heck are pull-ups + i2c and what do I need to know about them in order to use crow?

Pull-ups are resistors on [i2c-enabled](https://llllllll.co/t/a-users-guide-to-i2c/19219) (or, ii) devices (like crow, Teletype, Ansible, Just Friends, w/). They help control the flow of data as well as direct a bit of power. A "bus" requires only one device to have it's pull-ups enabled in order for data and power to flow correctly. crow's pull-ups are off by default.

If you are connecting crow to another i2c-enabled device *without* a powered-bus between them (eg. if you're connecting crow directly to the i2c connector on Just Friends), then you need to enable crow's pull-ups in order for messages to pass between the two. You can do this through a variety of methods:
- in your norns script, specify: `crow.ii.pullup(true)`
- in druid, execute: `crow.ii.pullup(true)`
- in Max, send the [crow] object a `tell_crow ii.pullup(true)` message

If you are connecting crow to a device which already supplies power through the ii bus (like a Teletype or a powered busboard), then you do not need to enable crow's pull-ups. It will happily piggyback onto the existing bus.

If you accidentally enable crow's pull-ups, they will remain that way until you disable them through any of these methods:
- power-cycle your modular synth (as crow's default is pull-ups disabled)
- in your norns script, specify: `crow.ii.pullup(false)`
- in druid, execute: `crow.ii.pullup(false)`
- in Max, send the [crow] object a `tell_crow ii.pullup(false)` message

nb. There is no real damage risked by enabling pull-ups when you don't need to. You'd need 4+ crows chained together in order to make a potential mess of things. Messages simply will not pass between devices, which will lead to frustration.

### is crow's status as an [i2c leader or follower](https://github.com/monome/crow#leading-the-i2c-bus) automatic or configurable?

It’s automatic, but only because leading and following isn't a property of a single device -- it's a property of communication. crow is very flexible, designed to be agnostic to who/what it's speaking with.

Basically, crow is always listening to other devices (ie following), until it's told to execute a leader-command, at which point it attempts to lead the bus. Once that command / query is complete, it returns to follower mode.
