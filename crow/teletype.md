---
layout: default
title: scripting with teletype
parent: crow
nav_order: 6
permalink: /crow/teletype/
---

When connected via [ii/i2c](/docs/ansible/i2c/#what-is-i2c--ii), crow can be used as a simple [Teletype](/docs/teletype) expander, adding two additional inputs and four additional outputs. However, crow can also dramatically extend Teletype's purposefully restricted approach to scripting, by leveraging crow's robust implementation of Lua. In these docs, we'll cover basic methods for calling some of crow's built-in functions from Teletype as well as special scripting techniques to stretch both modules.

Before heading in, make sure to clear any script running on your crow, as Teletype won't overwrite a running script and you might not get expected results from these examples.

## essentials {#essentials}

Like Teletype's built-in outputs, any voltage argument in the following examples is 14-bit, so we'll want to use Teletype's lookup tables to help translate, eg:

- `V x`: lookup volt value `x` (0-10)
- `VV x`: lookup precision volt value `x` (0-1000, for 0.00 to 10.00 volts)
- `N x`: lookup note value `x` (0-127)

### setting CV

**CROW.V x y**: Sets output `x` to value `y`

- `CROW.V 1 V 2` to set crow output 1 to 2 volts
- `CROW.V 1 VV 238` to set crow output 1 to 2.38 volts
- `CROW.V 1 N 7` to set crow output 1 to seven semitones

### slewing cv

**CROW.SLEW x y**: Sets output `x` slew rate to `y` milliseconds

- `CROW.SLEW 1 1000` to set crow output 1's slew rate to 1000 milliseconds
- `CROW.SLEW 1 BPM 97` to set crow output 1's slew rate to one beat at 97 BPM

### actions

**CROW.PULSE x y z t**: Creates a trigger pulse on output `x` with duration `y` (ms) to voltage `z` with polarity `t`

- `CROW.PULSE 2 10 V 5 1` to create a pulse on crow output 2 which lasts 10 milliseconds, at 5 volts, with positive polarity (where duration indicates the pulse's 'on' length)
- `CROW.PULSE 4 BPM 102 V 8 -1` to create a pulse on crow output 2 which lasts a beat's length at 102 BPM, at 8 volts, with negative polarity (where duration indicates the 'off' length before the pulse)

**CROW.AR x y z t**: Creates an envelope on output `x`, rising in `y` ms, falling in `z` ms, and reaching voltage `t`

- `CROW.AR 3 500 40 v 10` to create an envelope on crow output 3 which rises for 500 milliseconds, falls for 40 milliseconds, which will reach 10 volts

**CROW.LFO x y z t**: Starts a ramp LFO on output `x` at rate `y` where 0 = 1Hz (with 1v/octave scaling), `z` sets amplitude, and `t` sets voltage skew (try `V 0` to `V 1`, or `VV 0` to `VV 100`) for asymmetrical triangle waves

- `CROW.LFO 1 V 0 V 5 VV 50` to create a 1Hz LFO on output 1 with a 5V peak, in a triangle shape
- `CROW.LFO 4 VV 879 V 3 VV 80` to create a buzzy ~440hz audio-rate signal on output 4 with a 3V amplitude

*nb. To get approximate voltage arguments for specific Hz values, we use 2^V = Hz as a baseline. This means 0V is 1Hz, which can be scaled to pitches at audio-rate using log2(Hz), eg. log2(440) is approximately 8.79 V, which translates to `VV 879` for Teletype.*

### hardware in/out

**CROW.IN x**: Gets the voltage (as 0-16384) at input `x`

- `CROW.IN 2` to read the value of crow input 2
- `CV 1 CROW.IN 1` to assign the value of crow input 1 to Teletype CV 1

**CROW.OUT x**: Gets the voltage (as 0-16384) at output `x`

- `CROW.OUT 1` to read the value of crow output 1
- `CV 3 CROW.OUT 2` to assign the value of crow output 2 to Teletype CV 3

### reset crow

**CROW.RST**: Calls the function `crow.reset()` on crow, returning it to its default state

## extended scripting {#extended}

While crow is certainly useful as a Teletype hardware extension using the OPs above, the i2c connectivity between crow and Teletype shines brightest when a script running on crow can send and receive data to/from Teletype and vice versa.

In this section, we'll walk through crow *and* Teletype scripting.

### call

Calls are useful to send arguments from Teletype to crow. There are four call types, which are demarcated by the number of arguments you can pass with them.

**CROW.C1 x**: Calls the function `ii.self.call1(x)` on crow  
**CROW.C2 x y**: Calls the function `ii.self.call2(x, y)` on crow  
**CROW.C3 x y z**: Calls the function `ii.self.call3(x, y, z)` on crow  
**CROW.C4 x y z t**: Calls the function `ii.self.call4(x, y, z, t)` on crow

#### example

In our [essentials](#essentials) examples, we relied on Teletype's expectations of crow's capabilities to create events. While crow's [dynamic variables](/docs/crow/reference/#dynamic-variables) are a very exciting component of crow scripting, there's no way for Teletype to conceive of what OPs would be necessary or useful to crow's endlessly re-definable functions. This is where calls come in -- we can establish logic inside of our crow script and simply rely on Teletype to feed new values in.

To start, run this script on crow, which will pass a 1V ramp wave (which cycles every 1 second) through a quantizer:

```lua
-- connect out1 to v/8

function init()
  output[1].scale = {0,2,3,5,7,8,10}

  output[1](loop{ to(0,0)
                , to(dyn{height=1}:step(dyn{step=0}),dyn{time=1})
                })
end

function ii.self.call3(height,step,time)
  output[1].dyn.height = height/100
  output[1].dyn.step = step/100
  output[1].dyn.time = time/100
end
```

In `ii.self.call3`:

- we establish three arguments: `height`, `step` and `time`
- we divide the incoming values for each argument by 100, to allow non-integer values to be sent from Teletype
- we assign the results to different dynamic elements of our crow script

Once the script is running, we'll hear a straightforward sequence.

Let's execute the following in Teletype's LIVE mode:

- `CROW.C3 222 0 100` to expand the `height` (the range of notes played, which also increases perceived rate)
- `CROW.C3 222 0 60` to increase the ramp's base speed
- `	CROW.C3 100 30 100` to increase the `height` by `0.3` with each ramp cycle

### query

Queries are useful to send arguments from Teletype to crow, with crow returning a **single** value back. There are four query types, which are demarcated by the amount of arguments sent to crow.

**CROW.Q0 x**: Returns the result of calling the function `crow.self.query0()`  
**CROW.Q1 x**: Returns the result of calling the function `crow.self.query1(x)`  
**CROW.Q2 x y**: Returns the result of calling the function `crow.self.query2(x, y)`  
**CROW.Q3 x y z**: Returns the result of calling the function `crow.self.query3(x, y, z)`  

#### example

Crow has a built-in sequencer/arpeggiator library named [`sequins`](https://monome.org/docs/crow/reference/#sequins), which can be used to iterate through table data to quickly fill Teletype's patterns.

To start, run this script on crow, which establishes a nested semitone pattern and a query callback:

```lua
function init()
  seq = sequins{0,2,3,5,7,9,sequins{10,5,12,19,15}}
end

function ii.self.query0()
  return seq()
end
```

Let's execute the following in Teletype's LIVE mode:

- `PN.MAP 0: CROW.Q0` to fill the first pattern column (from its start and end point) with the output of the iterated `seq` sequins

Alright, we filled a pattern column with our nested sequins! Let's add some flavor. Run this script on crow:

```lua
function init()
  seq = sequins{0,2,3,5,7,9,sequins{10,5,12,19,15}}
end

function ii.self.query0()
  return seq()
end

function ii.self.call1(x)
  seq:step(x)
end
```

Let's execute the following in Teletype's LIVE mode:

- `PN.MAP 0: CROW.Q0` to fill the first pattern column (from its start and end point) with the output of the iterated `seq` sequins
- `CROW.C1 3` to change the step size of the `seq` sequins iteration
- `PN.MAP 1: CROW.Q0` to fill the second pattern column (from its start and end point) with the output of the iterated `seq` sequins, but with a new step size

## managing multiple crows {#multiple-crows}

If you have multiple crows on the same i2c bus as Teletype (up to four are supported), you might want to specify which crow to target. You can either direct Teletype to only speak to one crow, or you can specify a crow for specific commands.

**CROW.SEL x**: Sets target crow unit to `x`, `1` (default) to `4`

*nb. Each crow should have its i2c address pre-defined using `ii.set_address(x)` via druid.*

- `CROW.SEL 3` to set Teletype's target crow unit to the third one on the bus, where all following `CROW.` commands will go

**CROW1: [...]**: Sends the following crow OPs to unit 1, ignoring the currently-selected unit  
**CROW2: [...]**: Sends the following crow OPs to unit 2, ignoring the currently-selected unit  
**CROW3: [...]**: Sends the following crow OPs to unit 3, ignoring the currently-selected unit  
**CROW4: [...]**: Sends the following crow OPs to unit 4, ignoring the currently-selected unit

- `CROW2: CROW.PULSE 3 100 V 5 1` to create a pulse on crow 2's output 3, which lasts 100 milliseconds, at 5 volts, with positive polarity

**CROWN: [...]**: Sends the following crow OPs to all crows on the bus, starting with the currently-selected unit

- `CROWN: CROW.V 2 VV 230` to set every crow's output 2 to 2.3 volts