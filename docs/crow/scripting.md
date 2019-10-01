---
layout: page
permalink: /docs/crow/scripting/
---

(image)

## Scripting

### Almost here! We're still preparing this section.

Crow communicates Lua via USB in clear text:

```console
to crow >     print("caw!")
crow says >   caw!
```

Which allows the weaving of musical structure:

```console
to crow >     x = math.random(12)
              print(x)
crow says >   3
to crow >     output[1].slew = 0.9
              output[1].volts = x

(CV output 1 ramps to 3 volts over 0.9 seconds)
```

Crow can also store a complete script, as in the following example:

```lua
notes = {0,7,5,11,12,3}
step = 1

input[1].mode("change",2.0,0.5,"rising")
input[1].change = function()
  if step > #notes then step = 1
  else step = step + 1 end
  output[1].volts = notes[step]/12
end
```

A rising trigger on input 1 will advance a sequence of voltages on output 1.

The [reference guide](reference) provides a table of crow-specific commands.

Additional Lua references:

- [programming in lua (first edition)](https://www.lua.org/pil/contents.html)
- [lua 5.3 reference manual](https://www.lua.org/manual/5.3/)
- [lua-users tutorials](http://lua-users.org/wiki/TutorialDirectory)
- [lua in 15 mins](http://tylerneylon.com/a/learn-lua/)
