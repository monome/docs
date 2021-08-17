---
layout: default
parent: grid
title: + norns
nav_order: 1
has_toc: false
---

# grid + norns / norns shield

*nb. we'll use 'norns' throughout this page as a catch-all for both stock and shield -- the differences between the two iterations do not affect software usability or hardware connectivity*

## getting started

Since grid is part of the fundamental design of norns, it has immediate integration without installing additional packages. However if you've either been using norns / norns shield without a grid, or you're approaching them both for the first time, a bit of setup guidance might be helpful.

#### physical connection

norns has four USB-A ports. Any port can host a grid, so feel free to connect your grid's USB cable to any available port on norns. As you connect, you'll see a lightburst on your grid, which indicates it's receiving power from norns.

#### software configuration

To ensure that norns has registered your grid, navigate to `SYSTEM > DEVICES > GRID`. Here, you'll see something similar to:

```bash
GRID

1. monome 128 m4409455
2. none
3. none
4. none
```

#### what should I use grid + norns for first?

A great starting point is [awake](/docs/norns/play/#awake), which is the script that norns runs after its very first boot-up.

`awake` is a good one to start with because the grid interface mirrors the sequence that you see on the screen -- after loading, you'll see your grid come alive with a playhead + some programmed notes. Press some pads to change notes! That's it :)

Want more? Check out the *community script selections* at the bottom of this page!

### FAQ

#### why don't I see my grid populate in the `GRID` menu?

If you have a [2021 grid](/docs/grid/editions), norns needs to be running the latest software to communicate to it (2021 grid compatibility was added in update `210706`). Follow the steps in the [norns update docs](/docs/norns/wifi-files/#update) to update your software. After the unit restarts, your new grid should be successfully detected by norns.

Still running into trouble seeing your grid in `SYSTEM > DEVICES > GRID` after your norns update? Please email `help@monome.org` and we'll work it out!

#### why are there four `GRID` ports?

The norns software can host a lot more than what might be currently present at its four physical USB ports, including:

- sixteen MIDI devices
- four grids
- four arcs
- four HID devices

The four ports you see on the `GRID` page represent the four *virtual* ports to which norns allocates connected devices of this type.

#### why do I have more than one grid listed?

When you connect a new grid to norns, it will register the grid to the first-available `GRID` port. If you've already connected a grid to your norns (or your norns has had a past life with another grid), this means that the first slot is likely already occupied by a previous grid and norns must allocate to the next-available port.

#### why isn't my grid communicating with any community scripts?

While norns can remember up to four previously-connected grids, it's not very common to use more than one grid at a time. This means that **many community scripts typically communicate with the grid stored at port 1** within the `SYSTEM > DEVICES > GRID` menu.

A problematic `GRID` menu could look like:

```bash
GRID

1. monome 128 m1000437
2. monome 128 m4409455
3. none
4. none
```

or

```bash
GRID

1. none
2. monome 128 m4409455
3. none
4. none
```

In each case, if `monome 128 m4409455` is the grid we want to use then we need to clear it from port 2 and register it to port 1.

The critical thing to remember is that the grid at port 1 is the one which most community scripts target.
{: .label .label-grey}

#### how do I manage the virtual ports on my norns?

To manage the `SYSTEM > DEVICES > GRID` menu's virtual ports:

- use `E2` to select a port
- press `K3` on the port to surface a list of the grids which are currently physically connected to norns
  - if you want to clear the selected port, press `K3` on `none`
  - if you want to assign the selected port, press `K3` on the desired grid

You should also confirm that the community script *does* feature grid functionality -- see the bottom of this page for suggested starting points!

## compatibility

All editions of grid are compatible with norns. Playability is dictated by two factors, size and varibright capability.

### size

Most norns apps are built with 128 grids in mind, which means that critical actions may utilize the full 16x8 range of keys.

Since 256 is a 16x16 grid, it will be able to interact with any app built for a 128 grid. However, there will be a lot of unused real-estate.

Since 64 is a 8x8 grid, an app's critical functions may not be displayed or executable.

Addressing playability due to size is straightforward -- since norns apps are coded in Lua, modifications can be made which either expand or constrict the app's grid interactions.

If you want to adapt a script's grid size, [norns study 4](/docs/norns/study-4) is a good place to start.

### varibrightness

Over the years, the brightness of the grid's LEDs has also evolved. From 2007 - 2010 they were all mono-bright, which meant that the lights were either on or off. Starting in 2011 four stages of "in between" brightness were possible, which opened up new ways of representing data -- eg. a dim light could signal a modifier key whereas a bright light could signal a performative key.

Since 2012, grids have had 16 steps of varibrightness.

Most norns apps are built with 16-step varibright grids in mind. While 4-step and mono-bright grids will still function with these apps, there may be indicators or special functions that require 16 steps of brightness to display.

If you want to adapt a script's LED brightness, [norns study 4](/docs/norns/study-4) is a good place to start.

## community scripts selections

After you [learn how to import apps into your norns](/docs/norns/maiden), here are a few starting points for exploring grid + norns.

- [bistro](https://llllllll.co/t/bistro/45349): a “press cafe” remake (based on [the Max/MSP patch](https://www.youtube.com/watch?v=kj7YScVp_a8) originally by `@stretta`)
- [arcologies](https://llllllll.co/t/arcologies/35752): an interactive environment for designing 2d sound arcologies
- [buoys](https://llllllll.co/t/buoys-v1-2-0/37639): tidal influencer/activator/lightshow
- [loom](https://llllllll.co/t/loom/21091): surprisingly controllable generative sequencer -- notes are played when threads moving across the X and Y axis collide
- [mlr](https://llllllll.co/t/mlr-norns/21145): the original live sample-cutting platform -- load samples or record live audio, then re-pitch + chop + record gestures

Check out the `grid` tag on [norns.community](https://norns.community/t/grid) for many more.
