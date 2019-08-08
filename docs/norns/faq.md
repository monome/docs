# FAQ

## what is the difference between `require` and `include`?

- `require()` is a built in lua function, `include()` is a norns function

- `require()` looks in more places - see `norns/lua/core/config.lua`

- most importantly, `require()` caches its results, and will not re-run its arguments (unless you use a hack[^1]) the state of a `require`'d module is persisted, and this is significant. consider the following set of files. 

`baz.lua`, a module:
```
local Baz = {}
Baz.value = 100
return Baz
```

'foo1' and 'foo2' scripts will use the `baz` module twice via `require`, incrementing the module state by 1 and 2 respectively.

`foo1.lua`:
```
local baz = require('baz')
print('foo1:baz initial value = ' .. baz.value)
baz.value = baz.value + 1
print('foo1:baz new value = ' .. baz.value)
```

`foo2.lua`:
```
local baz = require('baz')
print('foo1:baz initial value = ' .. baz.value)
baz.value = baz.value + 2
print('foo1:baz new value = ' .. baz.value)
```

'bar1' and 'bar2' do the same, but with `dofile`.

`bar1.lua`:
```
local baz = dofile('baz.lua')
print('bar1:baz initial value = ' .. baz.value)
baz.value = baz.value + 1
print('bar1:baz new value = ' .. baz.value)
```

`bar2.lua`:
```
local baz = dofile('baz.lua')
print('bar2:baz initial value = ' .. baz.value)
baz.value = baz.value + 2
print('bar2:baz new value = ' .. baz.value)
```

`test.lua`:
```
dofile('foo1.lua')
dofile('foo2.lua')
dofile('bar1.lua')
dofile('bar2.lua')
```

result:

```
> lua5.3 test.lua 
foo1:baz initial value = 100
foo1:baz new value = 101
foo2:baz initial value = 101
foo2:baz new value = 103
bar1:baz initial value = 100
bar1:baz new value = 101
bar2:baz initial value = 100
bar2:baz new value = 102
```

viz., `foo2` inherits the state change from `foo1`, but `bar1` and `bar2` each get their own module state by re-executing `baz.lua`.

---

[^1] you can clear a package from the `require` cache manually. this is a hack:
```
	package.loaded[baz] = nil
	_G[baz] = nil -- also remove from global namespace
```
