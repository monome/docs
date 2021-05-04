---
layout: default
nav_exclude: true
permalink: /norns/reference/lib/ui/pages
---

## Pages

### control

| Syntax                                  | Description                                            |
| --------------------------------------- | ------------------------------------------------------ |
| UI.Pages.new (index, total_pages)      | Create a new instance or set of pages, with `index` being the page index (ie, the "open" page) and `total_pages` being the number of pages in the set             |
| my_pages:set_index (index)             | Set page index : number |
| my_pages:set_index_delta (delta, wrap) | Set page index using delta, with wrapping : number, boolean |
| my_pages:redraw ()                     | Redraw page with `Pages` elements                           |

### query

| Syntax        | Description                            |
| ------------- | -------------------------------------- |
| my_pages.index     | Returns current index : number         |
| my_pages.num_pages | Returns total number of pages : number |

### example

```lua
UI = require("ui")

chapter = {}

-- create three sets of pages:
chapter[1] = UI.Pages.new(2,10)
chapter[2] = UI.Pages.new(3,5)
chapter[3] = UI.Pages.new(1,2)

id = 2

function redraw()
  screen.clear()
  chapter[id]:redraw()
  screen.level(8)
  screen.font_size(30)
  screen.move(40,40)
  screen.text_center(chapter[id].index.."/"..chapter[id].num_pages)
  screen.update()
end

function key(n,z)
  -- change chapter index:
  if z == 1 then
    id = n
    redraw()
  end
end

function enc(n,d)
  -- change pages in current chapter:
  if n == id then
    chapter[n]:set_index_delta(d,false)
    redraw()
  end
end
```

### description

Creates a set of pages with a minimal on-screen UI, a "scrollbar" on the right side of the screen which shows the number of pages and lights up to indicate the `index`, ie, the active page. 

The UI is drawn using the `my_pages:redraw()` function, which needs to be called when there is a change in the instance of pages or the `index`.

`UI.Pages.new` returns a table which should be stored in a variable `my_pages`. The various other controls and queries can then be called using `my_pages` in the manner described above. 

In the example above, `my_pages` is the relevant `chapter` (ie, `chapter[1]`, `chapter[2]`, or `chapter[3]`) which stores each instances of `UI.Pages.new`.



