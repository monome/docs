---
layout: default
parent: crow
has_children: true
title: scripting
nav_order: 4
has_toc: false
---

# scripting

Scripts describe to crow how it should function in a particular patch. Through scripts, crow's identity morphs between [quantizer](https://github.com/monome/bowery/blob/main/snippets/quantize.lua), [euclidean sequencer](https://github.com/monome/bowery/blob/main/euclidean.lua), [clock divider](https://github.com/monome/bowery/blob/main/snippets/clock_divider.lua), or [interrelated lfo generator](https://github.com/monome/bowery/blob/main/snippets/acquaintances.lua).

You don't need to know how to program before you're able to write a script. Wanting to learn is the only true prerequisite, the same as any other language. 

We've developed and collected a number of crow-specific resources. Through these pages, you'll learn more about the approachable programming interface at the core of crow, across different environments:

- [scripting with druid](../scripting-druid) // writing text-based crow scripts with a laptop or desktop computer
- [scripting with norns](../norns) // integrating crow into norns scripts far beyond clocking
- [scripting with teletype](../teletype) // navigating crow's [i2c](/docs/modular/ii)-based relationship with [Teletype](/docs/teletype)
- [script reference](../reference/) // the full crow API with functional examples
- [maps](../maps/) // text + videos exploring crow as a musical framework