---
layout: default
title: community scripts
parent: norns
nav_order: 4
redirect_from: /norns/app/
---

## [norns.community](https://norns.community)

Since its release in 2018, norns has grown beyond our earliest imaginings: new functionality, expanded documentation, group tutorials and classes, weekly hangouts, and perhaps most notably a huge explosion of community-contributed scripts. Script-making is also art-making, and the inspiring level of sharing has itself built a community.

[norns.community](https://norns.community) is a centralized place for community projects. It was initiated by monome and was shaped by the talents of `@tyleretters` who added sharp visual styling + data design and `@eigen` who created a dynamic discovery mechanism with tagging and gallery images.

![](/docs/norns/image/community_scripts-images/norns-community.png)

## contribute & gather

The norns ecosystem was created with community as a focus. The exchange of ideas leads to new ideas. As such, you are encouraged to share your creations with the community.

The first step is to host the sources of your script publicly, either as a git repository (e.g. on GitHub, GitLab ...) or web-hosted zip archive.

Be sure you include the following block of information at the top of your script. It will serve as a brief documentation when launching it from norns.

```lua
-- scriptname
-- v1.0.0 @author
-- llllllll.co/t/22222
--
-- short script description
--
-- short usage instructions
```

Then, create a new thread under the [norns Library on lines](https://llllllll.co/c/library).

The URL in your script's brief documentation should point to its corresponding lines Library thread. There's a chicken-egg situation with starting a thread and uploading the project, so you may want to edit and upload your project just after creating a thread.
{: .label}

### community repo

So that anyone can do a one-click install using maiden, we encourage you to register your script in the [community project repo](https://github.com/monome/norns-community/blob/main/community.json). Please submit a pull request with the following information:

```json
    {
      "project_name": "NAME",
      "project_url": "PROJECT_URL",
      "author": "NAME",
      "description": "WORDS",
      "discussion_url": "LINES_URL",
      "documentation_url": "DOC_URL",
      "tags": ["TAG", "TAG", "TAG"]
    },
```

Where `project_url` is the URL to the web-hosted script sources, `discussion_url` is a link to its lines Library thread and `documentation_url` is a link to its documentation page.

Once your pull request is merged into the community catalog, it will automatically appear on [norns.community](https://norns.community/). The website refreshes nightly at 00:00 UTC, on every merge to its main branch, or on demand by admins.

### fork

As you work with norns, you might change community scripts to integrate them into your particular toolkit. Perhaps you need to output specific ranges of MIDI messages, or maybe you're only using Just Intonation these days.

If you wish to share your modifications with the larger community, or if you feel your changes represent a new vision, please review our [living document of forking etiquette guidelines](https://llllllll.co/t/library-forking-etiquette-sharing-modifications/).

## summon {#summon}

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
