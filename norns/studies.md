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

Comprehensive lessons on individual elements of norns scripting. Through these resources, you'll learn how to translate your musical ideas into scripts and how to extend those scripts to speak with all kinds of friends.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### core concepts

Tutorials written by monome.

*Note: all of these resources assume you're on the latest version of the norns software. if you have any questions about updating, please see [this section of the docs](/docs/norns/wifi-files/#update). note that if you are running software version `220129` or earlier, you will need to complete a fresh installation -- [more details here](/docs/norns/wifi-files/#jan292022).*

**For the best learning experience, we recommend one lesson per week.** A slower pace makes it easier to experiment and uncover the simplicity + musicality of the underlying code.

**norns: introductory studies**

- [first light](../study-0/) // learning to see. edit a script.
- [many tomorrows](../study-1/) // variables, simple maths, keys + encoders
- [patterning](../study-2/) // screen drawing, for/while loops, tables
- [spacetime](../study-3/) // functions, parameters, time
- [physical](../study-4/) // incorporating grids, midi, clock syncing
  - [physical tangent: arc](../study-4b) // incorporating arc
- [streams](../study-5/) // system polls, osc, file storage

**norns: extended API techniques**

- [softcut](../softcut/) // a multi-voice sample playback and recording system built into norns
- [clocks](../clocks/) // create timed and clock-synced function calls: loops, repetition, and delays
- [grid recipes](../grid-recipes/) // short snippets of code for canonical grid interactions

**norns: SuperCollder**

- [rude mechanicals](../engine-study-1/) // introduction to building norns engines with SuperCollider and Lua
- [skilled labor](../engine-study-2/) // extended study of norns engine development: polyphony and realtime parameter changes
- [transit authority](../engine-study-3/) // deep-dive into audio busses, FX, and polls (to communicate from SuperCollider to Lua)

### contributed knowledge

Resources developed by other learners, script authors, and designers from our community.

- [norns study group](https://discord.gg/Y2fmdZBAfp) // a community run discord server for asynchronous and video study sessions
- [athenaeum](https://github.com/northern-information/athenaeum) // a repository of study, spike, and sample scripts from [Tyler Etters](https://nor.the-rn.info)
- [norns: tutorial](https://llllllll.co/t/norns-tutorial/23241) // chunked examples that reveal the idiosyncrasies of the core norns concepts from [Devine Lu Linvega](https://xxiivv.com)
- [norns development](https://github.com/p3r7/awesome-monome-norns/blob/main/README.md#development-general) // general development notes from Jordan Besly's [awesome monome norns](https://github.com/p3r7/awesome-monome-norns) repo
- [lua libs index](https://norns.community/libs-and-engines#community-lua-libs) // overview of norns library extensions (ibid.)

### learning SuperCollider

SuperCollider is a free and open-source platform for making sound, which powers the synthesis layer of norns. Many norns scripts are a combination of SuperCollider (where a synthesis engine is defined) and Lua (where the hardware + UI interactions are defined). SuperCollider can be run on most any computer -- you do not need a norns to dig into these resources!

For those who want to explore creating new synthesis engines for norns, we've developed [rude mechanicals](../engine-study-1/), [skilled labor](../engine-study-2/), and [transit authority](../engine-study-3/). These studies walk through building norns engines from scratch with SuperCollider and Lua, as well as showcasing extended techniques for audio routing and bi-directional communication between SuperCollider and Lua.

We also highly recommend:

- Zack Scholl's video series, produced in partnership between monome and Music Hackspace: [Tone to Drone](https://musichackspace.org/product/tone-to-drone-introduction-to-supercollider-for-monome-norns/) and [Ample Samples](https://musichackspace.org/product/ample-samples-introduction-to-supercollider-for-monome-norns/).
- Eli Fieldsteel's [YouTube series](https://youtu.be/yRzsOOiJ_p4)
- Nathan Ho's [collected SuperCollider tips](https://nathan.ho.name/posts/supercollider-tips/)

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

### learning Lua

While you don't need to master the entire Lua language to make the most of norns, you eventually may be interested in checking out more traditional programming texts.

- [lua cheatsheet](https://devhints.io/lua)
- [programming in lua (first edition)](https://www.lua.org/pil/contents.html)
- [lua 5.3 reference manual](https://www.lua.org/manual/5.3/)
- [lua-users tutorials](http://lua-users.org/wiki/TutorialDirectory)
- [lua in 15 mins](http://tylerneylon.com/a/learn-lua/)

Ask questions and share what you're making at [llllllll.co](https://llllllll.co/t/norns-studies/14109)

Edits to these pages welcome, see [monome/docs](http://github.com/monome/docs)
