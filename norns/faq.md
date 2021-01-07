---
layout: default
parent: scripting
grand_parent: norns
has_children: false
title: faq
nav_order: 2
has_toc: false
---

# script FAQ

## what is the difference between `require` and `include`?

- `require()` is a built in lua function, `include()` is a norns function

- `require()` looks in more places - see `norns/lua/core/config.lua`

- most importantly, `require()` caches its results, and will not re-run its arguments (unless you use a hack[^1]) the state of a `require`'d module is persisted, and this is significant. consider the following set of files.

`baz.lua`, a module:
```lua
local Baz = {}
Baz.value = 100
return Baz
```

'foo1' and 'foo2' scripts will use the `baz` module twice via `require`, incrementing the module state by 1 and 2 respectively.

`foo1.lua`:
```lua
local baz = require('baz')
print('foo1:baz initial value = ' .. baz.value)
baz.value = baz.value + 1
print('foo1:baz new value = ' .. baz.value)
```

`foo2.lua`:
```lua
local baz = require('baz')
print('foo1:baz initial value = ' .. baz.value)
baz.value = baz.value + 2
print('foo1:baz new value = ' .. baz.value)
```

'bar1' and 'bar2' do the same, but with `dofile`.

`bar1.lua`:
```lua
local baz = dofile('baz.lua')
print('bar1:baz initial value = ' .. baz.value)
baz.value = baz.value + 1
print('bar1:baz new value = ' .. baz.value)
```

`bar2.lua`:
```lua
local baz = dofile('baz.lua')
print('bar2:baz initial value = ' .. baz.value)
baz.value = baz.value + 2
```
