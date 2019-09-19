---
layout: page
permalink: /docs/crow/norns/
---

(image: norns + eurorack)

# Rising: Crow Studies

Crow serves as a CV and ii interface for norns.

It may be helpful to first explore the [norns studies](https://monome.org/docs/norns/study-1/) to provide context for how to integrate crow's new functionality.

Download: [github.com/monome/crow-studies](https://github.com/monome/crow-studies)

(Note: be sure your norns is [updated](https://monome.org/docs/norns/#update) to version 190920 or later).

Crow will automatically be detected and interfaced upon connection to norns. Presently only a single crow is supported.

## 1. Output

![](../images/1-output.png)

Run `1-output.lua`.

This sets up an knob and screen interface for one very simple command:

```
crow.output[1].volts = 3.33
```

This sets output 1 to 3.33v.

Crow's voltage range is -5.0 to 10.0 for outputs 1 to 4.

## 2. Input

## 3. ii

## 4. Extended Output (ASL)

## Reference
