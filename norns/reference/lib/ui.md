---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/ui
---

## UI

### description

A library to simplify the creation and use of UI elements in scripts. It offloads the code for each of the elements from your script and allows you to focus on the content.

`ui` provides the tools for creating, updating, and querying different UI elements which can be used for:

- providing multiple pages in your script;
- using multiple tabs for different features; 
- displaying lists or scrolling lists;
- displaying information in dials or sliders;
- creating "pop-up" messages for errors or for feedback to users; or
- displaying a playback icon with different statuses. 

The UI elements can also be used in combination in a single script. 

`ui` handles the redrawing of the elements on the screen. The structure of each of the UI elements also provides a convenient way of structuring your script itself, and the state of the UI elements can be queried very simply. 

Contributed by @markeats. 

### features

| Feature                          | Description               |
| -------------------------------- | ------------------------- |
| [dial](./dial)                   | Dial UI element           |
| [list](./list)                   | List UI element           |
| [message](./message)             | Message UI element        |
| [pages](./pages)                 | Pages UI element          |
| [scrollinglist](./scrollinglist) | Scrolling list UI element |
| [slider](./slider)               | Slider UI element         |
| [tabs](./tabs)                   | Tabs UI element           |
| [playback icon](./playbackicon)  | Playback icon UI element  |

### example

For an example in the wild of how some of these elements fit together, see @markeat's [passersby](https://github.com/markwheeler/passersby) script.

