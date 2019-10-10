---
layout: page
permalink: /docs/crow/faq/
---

# crow questions

## Dictionary of crow terms

### i2c

i2c is a communication protocol - it’s a way for devices to talk to each other, like MIDI or USB. In the monome ecosystem (where i2c is sometimes also referred to as “ii”), i2c provides a convenient way to send commands/data between modules. In some situations reducing what could be many patch-cable connections down to a single i2c cable hidden behind the module. For example, crow can use i2c to send unique synthesis commands to Just Friends.

### Druid

[Druid](https://github.com/monome/druid) is a utility for communicating with crow, both for realtime interaction and the uploading of full scripts. It requires Python to be installed on your computer.

### Lua

Lua is a programming language known for its flexibility to be embedded in applications. [norns](https://monome.org/norns/) uses Lua to allow the creation of scripts to express musical + artistic ideas. crow also speaks Lua, so it extends the norns ecosystem. Using Druid, you could upload a Lua script to crow -- in turn, crow would save this and perform the script without a computer attached.

### asl (like a/s/l)

A Slope Language -- the unique syntax developed for crow to describe voltage control events. For example, a sawtooth ramp could be described as starting at 5.0 V and falling to 0.0 V over a period of a second, then looping:

```lua
output[1].action =
    loop{ to( 5.0, 0.0 )
        , to( 0.0, 1.0 )
        }
```

[Learn more here](https://github.com/monome/crow#output-library--asl).

## What does it mean that crow is "event-based"?

crow is a blank slate, so it requires instructions to know what you’d like it to do at any given moment. Let's say you want to send voltage from crow's first output to a filter's cutoff frequency. You can automate this instruction by telling crow “please emit 3.33 volts from your first output.” crow is designed to listen to a specific scripting syntax.

Messages to crow must fit a format that crow expects, e.g.:

`crow.output[1].volts = 3.33`

This command tells crow “please emit 3.33 volts from your first output”. There are currently a few things that know how to talk to crow (norns, druid, and the Max/M4L toolkit), but this is certainly not a widely adopted standard.

[Documentation of this syntax is in progress](https://monome.org/docs/crow/reference/).

Using one of these tools, though, you could:
- live-code it through Druid, typing instructions to crow in real time
- create a Max patch that sends these instructions to crow on demand / as a sequence of events (a version of live-coding without the command line)
- write a norns app that tells crow to wait for triggers at its inputs to create different types of LFOs
- you can upload a full script to crow so that it knows what it’s meant to do when it's not connected to a computer or norns, and it would just await external triggers (like control voltage at its inputs)

## Can I use [x thing] to control crow?

Since crow uses a specific communication syntax, it requires some sort of layer between the thing you want to use to control crow and crow itself. Right now, you can use any of these to have immediate fun with crow:
- norns
- Druid
- Max
- Max for Live

For example, if you like to use a specific app on your laptop for live-coding, plugging crow into your laptop while running the app will not suddenly translate MIDI to CV. crow won't even show up as a "MIDI device." However, you *could* use the [crow] Max object's help file to package a translator between them. Or you could route the MIDI from your live-coding app into Ableton Live 9/10 Suite and use the Max for Live toolkit to perform this translation.

### How do I know which norns apps are updated for crow?

Searching `tags:crow+norns` at llllllll.co (or [click here](https://llllllll.co/search?expanded=true&q=tags%3Acrow%2Bnorns%20order%3Alatest)) will show all the scripts on norns which are tagged as having crow integration.

### Can crow make sound?

Not currently. You *can* tell it to run very fast LFO's from its outlets, into audio rate, but this creates instability. For the best experience with crow, consider its outputs to be control-rate generators.

## What is crow's sample rate?

crow internally generates signals at 48kHz (though the user doesn’t have direct access to these samples). crow reads inputs at 1.5kHz.

## Can I control two or more crows at the same time from norns or M4L?

Not currently, though it is being actively explored. Both norns and the M4L toolkit communicate with one crow at a time, though you *can* read the two inputs, transmit data over i2c, **and** control all four outputs on a single crow simultaneously.

## What the heck are pull-ups + i2c and what do I need to know about them in order to use crow?

Pull-ups are resistors on [i2c-enabled](https://llllllll.co/t/a-users-guide-to-i2c/19219) (or, ii) devices (like crow, Teletype, Ansible, Just Friends, w/). They help control the flow of data as well as direct a bit of power. A "bus" requires only one device to have it's pull-ups enabled in order for data and power to flow correctly. crow's pull-ups are off by default.

If you are connecting crow to another i2c-enabled device *without* a powered-bus between them (eg. if you're connecting crow directly to the i2c connector on Just Friends), then you need to enable crow's pull-ups in order for messages to pass between the two. You can do this through a variety of methods:
- in your norns script, specify: `crow.ii.pullup(true)`
- in Druid, execute: `crow.ii.pullup(true)`
- in Max, send the [crow] object a `tell_crow ii.pullup(true)` message

If you are connecting crow to a device which already supplies power through the ii bus (like a Teletype or a powered busboard), then you do not need to enable crow's pull-ups. It will happily piggyback onto the existing bus.

If you accidentally enable crow's pull-ups, they will remain that way until you disable them through any of these methods:
- power-cycle your modular synth (as crow's default is pull-ups disabled)
- in your norns script, specify: `crow.ii.pullup(false)`
- in Druid, execute: `crow.ii.pullup(false)`
- in Max, send the [crow] object a `tell_crow ii.pullup(false)` message

nb. There is no real damage risked by enabling pull-ups when you don't need to. You'd need 4+ crows chained together in order to make a potential mess of things. Messages simply will not pass between devices, which will lead to frustration.

## Is crow's status as an [i2c leader or follower](https://github.com/monome/crow#leading-the-i2c-bus) automatic or configurable?

It’s automatic, but only leader is currently working. Basically crow is always following (ie listening), until it executes a leader-command, at which point it attempts to lead the bus. Once that command / query is complete, it returns to follower mode.

## How large a script can I store on crow in standalone?

Currently, 8kB =~400 lines of Lua.

From Trent:
>I’ve found most scripts I’ve created so far are <100 lines. Lua may be less terse than Teletype, but it has far greater capacity for abstraction. The crow library leverages this to provide many complex features with terse syntax.

eg. 3 lines that create an ADSR envelope triggered by input 1 and sent to output 1:

```lua
output[1].action = adsr()
input[1].change = function(s) output[1](s) end
input[1].mode = 'change'
```

## How large a script can I build in Druid?

Currently, 2kB.

This PR https://github.com/monome/crow/pull/193 would bring the maximum "run" size to be 8kB in line with the maximum upload size.
