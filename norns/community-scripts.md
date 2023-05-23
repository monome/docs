---
layout: default
title: community scripts + mods
parent: norns
nav_order: 4
redirect_from: /norns/app/
---

## [norns.community](https://norns.community)

Since its release in 2018, norns has grown beyond our earliest imaginings: new functionality, expanded documentation, group tutorials and classes, weekly hangouts, and perhaps most notably a huge explosion of community-contributed scripts. Script-making is also art-making, and the inspiring level of sharing has itself built a community.

[norns.community](https://norns.community) is a centralized place for community projects. It was initiated by monome and was shaped by the talents of `@tyleretters` who added sharp visual styling + data design and `@eigen` who created a dynamic discovery mechanism with tagging and gallery images.

![](/docs/norns/image/community_scripts-images/norns-community.png)

## mods: community modifications {#mods}

With norns update `210927` (September 27 2021), a *mods* system was introduced by `@ngwese`.

Mods are small chunks of code to create custom modifications to the core workings of the norns system software. Mods are features which modify the basic functionality of norns, for all scripts, but is a feature which isn't necessary to include in the foundational norns codebase.

A mod lives in the `dust` folder just like standard norns scripts. Unlike norns scripts, the code in a mod is loaded by matron when it starts up. Mods can modify or extend the Lua environment globally such that the changes are visible to all scripts. Full developer documentation is forthcoming, though this [example mod](https://github.com/monome/norns-example-mod) lays out the basics.

### installing a mod

To install a mod, we'll make use of maiden's [fetch](../maiden/#fetch) feature.

- find a mod you wish to install
	- eg. [gridkeys](https://llllllll.co/t/gridkeys-mod/49431), a mod to use a grid as a MIDI keyboard for any norns script
- copy the URL for the mod's GitHub repository
	- eg. `https://github.com/p3r7/gridkeys`
- in maiden's command line, type `;install` and paste the URL
	- eg. `;install https://github.com/p3r7/gridkeys`
- restart norns using `SYSTEM > RESTART`

### enabling / disabling a mod

By their very nature, mods can have a negative impact on system stability or make system level changes which may not be universally welcome. Even if installed, a mod will *by default* start as unloaded. One must explicitly enable a mod and restart norns before its functionality will be available.

To enable a mod, visit `SYSTEM > MODS` to see the list of installed mods. Mods which are loaded will have a small dot to the left of their name. Use <kbd>E2</kbd> to selected an item in the list and then use <kbd>E3</kbd> to enable or disable as appropriate. Unloaded mods will show a `+` to the right their name to indicate that they will be enabled (and thus loaded) on restart. Loaded mods will show a `-` to the right of their name indicating they will be disabled on restart.

Loaded mods which have a menu will have `>` at the end of their name. Pressing <kbd>K3</kbd> will enter the mod's menu.

## community scripts: summon {#summon}

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/412510077?byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

In the video above, scripts made by the [lines community](https://llllllll.co) are being played by the [lines community](https://llllllll.co).

[orca](https://norns.community/en/authors/collabs/orca) // script: [`@its_your_bedtime`](https://www.instagram.com/its_your_bedtime/) // performance: [`@elia`](https://www.instagram.com/eliapiana/)

[TimeParty](https://llllllll.co/t/timeparty/22837) // script: [`@crim`](https://llllllll.co/u/crim/summary) // performance: [`@Olivier`](https://www.instagram.com/oliviercreurer/)

[mlr](https://llllllll.co/t/mlr-norns/21145) // script: [`@tehn`](https://softbits.bandcamp.com/album/rapid-history) // performance: [`@shellfritsch`](https://linktr.ee/coolmaritime)

[QUENCE](https://llllllll.co/t/quence/29436) // script: [`@spunoza`](https://www.youtube.com/channel/UCYTk7jkyot_w15r_7mqcTuw) // performance: [`@Justmat`](https://www.instagram.com/probably_justmat/)

[Compass](https://norns.community/en/authors/olivier/compass) // script: [`@Olivier`](https://www.instagram.com/oliviercreurer/) // performance: [`@glia`](https://www.instagram.com/zunaito/)

[otis](https://norns.community/en/authors/justmat/otis) // script: [`@Justmat`](https://www.instagram.com/probably_justmat/) // performance: [`@mattlowery`](https://www.instagram.com/mattlowery/)

[Animator](https://llllllll.co/t/animator/28242) // script: [`@crim`](https://llllllll.co/u/crim/summary) // performance: [`@bereenondo`](http://www.instagram.com/bereenondo)

[wrms](https://norns.community/en/authors/andrew/wrms) // script: [`@andrew`](https://www.instagram.com/_and.rew__/) // performance: [`@zanderraymond`](https://www.instagram.com/zanderraymond/)

[cheat codes](https://norns.community/en/authors/dan_derks/cheat_codes_2) // script: [`@dan_derks`](https://www.instagram.com/jailaibookie/) // performance: [`@andrew`](https://www.instagram.com/_and.rew__/)
