---
layout: default
parent: scripting
grand_parent: norns
has_children: false
title: studies
nav_order: 1
has_toc: false
---

# norns studies
{: .no_toc }

comprehensive lessons on individual elements of norns scripting. through these resources, you'll learn how to translate your musical ideas into scripts and how to extend those scripts to speak with all kinds of friends.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### norns: core concepts

tutorials written by monome.

*nb. all of these resources assume you're on the latest version of the norns software. if you have any questions about updating, please see [this section of the docs](/docs/norns/wifi-files/#update). note that if you are running software version `220129` or earlier, you will need to complete a fresh installation -- [more details here](/docs/norns/wifi-files/#jan292022).*

**for the best learning experience, we recommend one lesson per week.** a slower pace makes it easier to experiment and uncover the simplicity + musicality of the underlying code.

- [first light](../study-0/) // learning to see. edit a script.
- [many tomorrows](../study-1/) // variables, simple maths, keys + encoders
- [patterning](../study-2/) // screen drawing, for/while loops, tables
- [spacetime](../study-3/) // functions, parameters, time
- [physical](../study-4/) // incorporating grids, midi, clock syncing
- [streams](../study-5/) // system polls, osc, file storage
- [softcut](../softcut/) // a multi-voice sample playback and recording system built into norns
- [clocks](../clocks/) // create timed and clock-synced function calls: loops, repetition, and delays
- [grid recipes](../grid-recipes/) // short snippets of code for canonical grid interactions
- [rude mechanicals](../engine-study-1/) // introduction to building norns engines with SuperCollider
- [skilled labor](../engine-study-2/) // extended study of norns engine development

### norns: contributed knowledge

resources developed by other learners, script authors, and designers from our community.

- [norns study group](https://discord.com/invite/y2TYJ4ts) // a community run discord server for asynchronous and video study sessions
- [athenaeum](https://github.com/northern-information/athenaeum) // a repository of study, spike, and sample scripts from [Tyler Etters](https://nor.the-rn.info)
- [norns: tutorial](https://llllllll.co/t/norns-tutorial/23241) // chunked examples that reveal the idiosyncrasies of the core norns concepts from [Devine Lu Linvega](https://xxiivv.com)
- [norns development](https://github.com/p3r7/awesome-monome-norns/blob/main/README.md#development-general) // general development notes from Jordan Besly's [awesome monome norns](https://github.com/p3r7/awesome-monome-norns) repo
- [lua libs index](https://norns.community/libs-and-engines#community-lua-libs) // overview of norns library extensions (ibid.)

### learning SuperCollider

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined). SuperCollider can be run on most any computer -- you do not need a norns to dig into these resources!

for those who want to explore creating new synthesis engines for norns, we've developed [rude mechanicals](../engine-study-1/), a study which walks through building a norns engine from scratch with SuperCollider and Lua.

we also highly recommend Zack Scholl's video series, produced in partnership between monome and Music Hackspace: [Tone to Drone](https://musichackspace.org/events/tone-to-drone-introduction-to-supercollider-for-monome-norns-live-session/) and [Ample Samples](https://musichackspace.org/events/ample-samples-introduction-to-supercollider-for-monome-norns-live-session/).

**please note** that if you're new to SuperCollider, you'll likely make some unexpectedly loud / sharp sounds. to protect your ears and equipment, we recommend that you install the [SafetyNet Quark](https://github.com/adcxyz/SafetyNet), both within SuperCollider on your computer and on your norns. This Quark ensures that the output volume of SuperCollider won't reach levels which would damage your hearing. To add this to your norns, simply enter the following line within the Maiden repl, under the `SuperCollider` tab:

```lua
Quarks.install("SafetyNet")
```

#### SuperCollider language fundamentals
{: .no_toc }
- [written tutorial](https://composerprogrammer.com/teaching/supercollider/sctutorial/tutorial.html#chapter1)
- [first steps to colliding atoms](https://doc.sccode.org/Tutorials/Getting-Started/02-First-Steps.html)
- [how to get your code to play](https://doc.sccode.org/Reference/play.html)
- [what is a function?](https://doc.sccode.org/Reference/Functions.html)
- [if , while , for , etc](https://doc.sccode.org/Reference/Control-Structures.html)
- [supercollider server explained](https://doc.sccode.org/Guides/ClientVsServer.html)
- [j concepts in supercollider](https://doc.sccode.org/Guides/J-concepts-in-SC.html)
- [how to use an interpreter with supercollider ](https://doc.sccode.org/Guides/How-to-Use-the-Interpreter.html)
- [node](https://doc.sccode.org/Classes/Node.html)
- [bus](https://doc.sccode.org/Classes/Bus.html)

some additional starting points for learning:

- [Eli Fieldsteel's *fantastic* YouTube series](https://youtu.be/yRzsOOiJ_p4)
- [norns SuperCollider engines index](https://norns.community/libs-and-engines#supercollider-engines)

### learning Lua

while you don't need to master the entire Lua language to make the most of norns, you eventually may be interested in checking out more traditional programming texts.

- [lua cheatsheet](https://devhints.io/lua)
- [programming in lua (first edition)](https://www.lua.org/pil/contents.html)
- [lua 5.3 reference manual](https://www.lua.org/manual/5.3/)
- [lua-users tutorials](http://lua-users.org/wiki/TutorialDirectory)
- [lua in 15 mins](http://tylerneylon.com/a/learn-lua/)

ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

edits to these pages welcome, see [monome/docs](http://github.com/monome/docs)
