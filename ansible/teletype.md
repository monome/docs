---
layout: default
title: teletype
parent: ansible
nav_order: 7
redirect_from: /modular/ansible/teletype/
---

## Ansible + Teletype

The [Ansible](/docs/ansible) and [Teletype](/docs/teletype) Eurorack modules can be connected via pin headers on the back of these modules, making remote control of Ansible possible from Teletype scripts.

Teletype firmware 1.3 or newer is required for Ansible support.

With no USB device plugged in Ansible continues to run the most recently used application. For example, Kria can continue playing.

By hitting the `preset` key (next to the USB port) with no device plugged, Ansible will toggle into Teletype mode. In this mode the Ansible's outputs and inputs function as an extender, fitting naturally into the Teletype system.

This requires the Ansible to be on the internal [ii](/docs/modular/ii) bus, a 6 conductor ribbon behind the panel. Be sure to align the red stripe when connecting. For more information about different modules that can be connected to the ii bus and how this works, see [here](https://llllllll.co/t/a-users-guide-to-i2c/19219).

The following is a quick reference of Teletype ops that Ansible can process. For more details see the Teletype manual.

### Output

By default Ansible's 4 TR outputs and 4 CV outputs are mapped as TR 5-8 and CV 5-8. All Teletype output commands are available:

```
TR 5 1          // set Ansible TR 1 to 1
TR 5            // read Ansible TR 1
TR.TOG 6        // toggle Ansible TR 2
TR.POL 7 0      // reverse polarity for Ansible TR 3 pulse
TR.TIME 7 250   // set Ansible TR 3 pulse time to 250 ms
TR.PULSE 7      // pulse Ansible TR 3
TR.TIME 7       // read Ansible TR 3 pulse time

CV.SLEW 5 100   // set Ansible CV 1 slew to 100 ms
CV 5 V 10       // set Ansible CV 1 to 10 volts
CV 5            // read Ansible CV 1
CV.SET 5 0      // set Ansible CV 1 to 0, no slew
CV.SLEW 5       // read Ansible CV 1 slew
CV.OFF 6 V 1    // set Ansible CV 2 offset to 1 volt
CV.OFF 6        // read Ansible CV 2 offset
```

### Input

Ansible's `In 1`, `In 2`, `Key 1`, and `Key 2` are mapped to `STATE` 9-12 respectively.

```
STATE 9         // read Ansible In 1
STATE 10        // read Ansible In 2
STATE 11        // read Ansible Key 1
STATE 12        // read Ansible Key 1
```

### II Address for Multiple Ansible

If using more than one Ansible connected to Teletype, the II address can be set by holding the `preset` key in combination with `Key 1` and `Key 2`. There is no visual confirmation, simply hold the combination for 2 seconds. The set address is saved to flash and will persist with power cycling.

The address is according to the following:

```
Address         Key 1   Key 2
0               off     off
1               on      off
2               off     on
3               on      on
```

Mappings for input and output are shifted for each address:

```
Address         Out     In
0               5-8     9-12
1               9-12    13-16
2               13-16   17-20
3               17-20   21-24
```

## Parameter control via Teletype

Teletype can control various parameters for Kria, Meadowphysics, Levels, and Cycles.

### Kria

Kria's tracks can be clocked individually by the `KR.CLK` op, this must be enabled using the toggles on the far top-left column of Kria's scale page.

```
KR.PRE x        read preset x
KR.PRE          return current preset number
KR.PERIOD x     set internal clock period to x
KR.PERIOD       return current internal clock period
KR.PAT x        set pattern to x
KR.PAT          return current pattern
KR.SCALE x      set scale to x
KR.SCALE        return current scale
KR.POS x y z    set position to z for track x parameter y
                a value of 0 for x means all tracks
                a value of 0 for y means all parameters
                parameters: 
                0 - all
                1 - trigger
                2 - note
                3 - octave
                4 - duration
                5 - trigger ratcheting
                6 - alternate note
                7 - glide
KR.POS x y      return position of track x parameter y
KR.L.ST x y z   set loop start to z for track x parameter y
KR.L.ST x y     return loop start of track x parameter y
KR.L.LEN x y z  set length to z for track x parameter y
KR.L.LEN x y    return loop length of track x parameter y
KR.RES x y      set position to loop start for track x parameter y
KR.CV x         current CV value of output x
KR.MUTE x y     set the mute of track x to y (where y=1 is muted, y=0 is not.)
                if x is 0, set all mutes to state y
KR.TMUTE x      toggle mute for Kria track x (0 = all)
                toggle will _invert current state_.
KR.CLK x        send to clock track x (0 == all) IF track is enabled to be clocked
                by Teletype (see above)
KR.DIR x y      set track direction
KR.DIR x        get track direction
KR.DUR x        get track duration
KR.CUE p        cue pattern p to play next
KR.PG  p        show kria UI page p
```

### Meadowphysics

```
ME.PRE x        read preset x
ME.PRE          return current preset number
ME.SCALE x      set scale to x
ME.SCALE        return current scale
ME.PERIOD x     set internal clock period to x
ME.PERIOD       return current internal clock period
ME.OFF x        stop channel x (0 = all)
ME.RES x        reset channel x (0 = all) (also used as "start")
ME.CV x 	      get current CV value of output x
```

### Earthsea

```
ES.PRESET x     select preset

ES.MODE x       select edge mode
                0 - drone
                1…15 - fixed (value specifies trigger length)
                -1 - recorded timing
                (NB: this is different to original Earthsea)

ES.CLOCK x      clock. (you probably want to insert a dummy cable into
                the clock input to stop the internal clock)

ES.RESET x      reset to position x

ES.PATTERN x    select pattern x

ES.TRANS x      transpose by specified number of semitones (can be negative)

ES.STOP x       stop playback/recording

ES.MAGIC x      runes:
                1 - half speed
                2 - double speed
                3 - linearize on
                4 - linearize off
                5 - set forward dir
                6 - set reverse dir
```

### Levels

```
LV.PRE x        read preset x
LV.PRE          return current preset number
LV.RES x        reset. x = 0 for soft reset (will reset on next ext clock), 1 for hard reset
LV.POS x        set current position
LV.POS          return current position
LV.L.ST x       set loop start
LV.L.ST         return current loop start
LV.L.LEN x      set loop length
LV.L.LEN        return current loop length
LV.L.DIR x      set loop direction
LV.L.DIR        return current loop direction
```

### Cycles

```
CY.PRE x        read preset x
CY.PRE          return current preset number
CY.RES x        reset channel x (0 = all)
CY.POS x y      set position of channel x to y (scaled 0-255) (x = 0 means all)
CY.POS x        return position of channel x (scaled 0-255)
CY.REV x        reverse direction of channel x (0 = all)
```

### MIDI

_Supported as of Teletype firmware 1.4 and Ansible firmware 1.4._

```
MID.SLEW t      set pitch slew time in ms (applies to all allocation styles expect FIXED)
MID.SHIFT o     shift pitch cv by standard tt pitch value (e.g. N 6, V -1, etc)


ARP.HLD h       0 disables key hold mode, other values enable
ARP.STY y       set base arp style [0-7] (see above for style list)
ARP.GT v g      set voice gate length [0-127], scaled/synced to course divisions of voice clock
ARP.SLEW v t    set voice slew time in ms

ARP.RPT v n s   set voice pattern repeat, n times [0-8], shifted by s semitones [-24, 24]

ARP.DIV v d     set voice clock divisor (euclidean length), range [1-32]
ARP.FIL v f     set voice euclidean fill, use 1 for straight clock division, range [1-32]
ARP.ROT v r     set voice euclidean rotation, range [-32, 32]
ARP.ER v f d r  set all euclidean rhythm

ARP.RES v       reset voice clock/pattern on next base clock tick

ARP.SHIFT v o   shift voice cv by standard tt pitch value (e.g. N 6, V -1, etc)
```

### General

These ops affect Ansible regardless of what app is running.

```
ANS.G x y z    simulate setting the state of grid button (x, y) to z (1 = held, 0 = off)
ANS.G.P x y    simulate pressing grid button (x, y)
ANS.G.LED x y  read the brightness of grid LED (x, y), 0-15
ANS.A n d      simulate turning arc encoder n by d ticks (+/-)
ANS.A.LED n x  read arc encoder n, LED x (0-63 clockwise)
ANS.APP x      get/set the currently running app
```
