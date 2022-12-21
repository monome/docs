---
layout: default
parent: computer
grand_parent: grid
has_children: false
title: Mark Eats Sequencer
nav_exclude: true
has_toc: false
---

# Mark Eats Sequencer (macOS)

While grid is a completely open tool, re-imaginable by the artist who's using it, let's begin with a few fixed starting points.

Mark Eats Sequencer is a fantastic first foray into grid + computer play. It's a completely standalone step sequencer application, which can pipe MIDI to Ableton Live, Logic Pro, or any other DAW. With eight channels and sixteen sixteen-step patterns, it's a sequencing powerhouse that will help orient you to the flexibility of grid.

[→ download Mark Eats Sequencer](https://www.markeats.com/sequencer/)

## integration with a DAW

Mark Eats Sequencer's documentation is fantastic (be sure to go to `Help > User Guide` in the application), but since using a standalone music-making application outside of a DAW is less common these days, here are a few tips to help get MIDI out of Mark Eats Sequencer and into a DAW. These will apply to most any DAW, including Ableton Live and Logic Pro.

### sync to DAW's clock

To sync Mark Eats Sequencer with a DAW's clock, open the Sequencer's preferences and ensure that `Sync > Clock source` is set to `To Mark Eats Sequencer`. This means that the Sequencer will be listening for start/stop/reset signals from another program on your computer.

In the DAW's clock settings, you'll just need to ensure that you are sending synchronization signals to the `To Mark Eats Sequencer` destination. In Ableton Live, this is the `Sync` setting under `Sequencer > Preferences > Link/Tempo/MIDI > MIDI Ports`:

![](/docs/grid/images/mark-eats_ableton-live.png)

In Logic Pro, choose `To Mark Eats Sequencer` as a destination under `Preferences > MIDI > MIDI Project Sync Settings` and enable `Clock`:

![](/docs/grid/images/mark-eats_logic-pro.png)

### send MIDI to DAW

When you open Mark Eats Sequencer, it establishes itself as a virtual MIDI device for the rest of the applications on your computer, so very little setup is needed to direct the MIDI traffic from Sequencer to instruments in a DAW. By default, Sequencer sends data from Pages 1 - 6 on MIDI channels 1 - 6 and Drums 1 + 2 on MIDI channels 11 + 12.

Each DAW has slightly different workflows for selecting which MIDI device should control which instrument, but here are some quick tips for Ableton Live and Logic Pro:

#### Ableton Live

Under `Preferences Link/Tempo/MIDI > MIDI Ports`, ensure that `Track` is selected next to `In: From Mark Eats Sequencer`. Then, navigate to the `MIDI From` section of any track:

-  change `All Ins` to `From Mark Eats Sequencer`
-  change `All Channels` to whichever channel that corresponds to the Sequencer Page you want to use for this track
-  either change `Monitor` to `In` *or* leave it as `Auto` and Arm Recording for the track (see Live's manual for more details)

![](/docs/grid/images/mark-eats_ableton-live_routing.png)


#### Logic Pro

Under `Preferences > MIDI > Inputs`, ensure that `From Mark Eats Sequencer` is selected. Then, navigate to any track's Track inspector:

- change `MIDI In Port` from `All` to `From Mark Eats Sequencer`
- change `MIDI In Channel` from `All` to whichever channel that corresponds to the Sequencer Page you want to use for this track
- enable recording on any track you want to hear

![](/docs/grid/images/mark-eats_logic-pro_routing.png)