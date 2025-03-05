---
layout: default
parent: arc
title: norns
nav_order: 1
has_toc: false
---

# arc and norns

<div class="vid"><iframe src="https://player.vimeo.com/video/312196152?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

A great starting point is [angl](https://llllllll.co/t/ash-a-small-collection/21349), which is part of the `ash` collection from monome. It's featured in the video above and can be installed via [maiden](/docs/norns/maiden).

For additional script suggestions, check out the [*selections*](#community) at the bottom of this page.

## getting started

### physical connection

norns has four USB-A ports. Any port can host an arc, so feel free to connect your arc's USB cable to any available port on norns. As you connect, you'll see a lightburst on your arc, which indicates it's receiving power from norns.

### software configuration

To ensure that norns has registered your arc, navigate to `SYSTEM > DEVICES > ARC`. Here, you'll see something similar to:

```bash
ARC

1. monome arc
2. none
3. none
4. none
```

## FAQ

### how do I manage the virtual ports on my norns?

To manage the `SYSTEM > DEVICES > ARC` menu's virtual ports:

- use `E2` to select a port
- press `K3` on the port to surface a list of the arcs which are currently physically connected to norns
  - if you want to clear the selected port, press `K3` on `none`
  - if you want to assign the selected port, press `K3` on the desired arc

You should also confirm that the community script *does* feature arc functionality -- see the bottom of this page for suggested starting points!

### why are there four `ARC` ports?

The norns software can host a lot more than what might be currently present at its four physical USB ports, including:

- sixteen MIDI devices
- four grids
- four arcs
- four HID devices

The four ports you see on the `ARC` page represent the four *virtual* ports to which norns allocates connected devices of this type.

### why do I have more than one arc listed?

When you connect a new arc to norns, it will register the arc to the first-available `ARC` port. If you've already connected an arc to your norns (or your norns has had a past life with another arc), this means that the first slot is likely already occupied by a previous arc and norns must allocate to the next-available port.

### why isn't my arc communicating with any community scripts?

While norns can remember up to four previously-connected arcs, it's not very common to use more than one arc at a time. This means that **many community scripts typically communicate with the arc stored at port 1** within the `SYSTEM > DEVICES > ARC` menu.

A potentially troublesome `ARC` menu could look like:

```bash
ARC

1. monome arc
2. monome arc
3. none
4. none
```

Above, there are two arcs registered, but perhaps only one is physically connected. In this case, we need to clear arc from port 2 and register it to port 1.

The arc at port 1 is the one which most community scripts target.
{: .label .label-grey}

## compatibility

All [editions](/docs/arc/editions) of arc are compatible with norns.

## community scripts selections {#community}

After you [learn how to add scripts to your norns](/docs/norns/maiden), here are a few starting points for exploring arc and norns.

- [4 Big Knobs](https://llllllll.co/t/4-big-knobs/42190): send control voltages out of [crow](/docs/crow)
- [arcify](https://llllllll.co/t/arcify/22133): map arc to norns parameters
- [easygrain](https://llllllll.co/t/easygrain/21047): granulator with arc support
- [larc](https://llllllll.co/t/larc/39790): three play-heads, one rec-head

Check out [norns.community](https://norns.community) for many more.
