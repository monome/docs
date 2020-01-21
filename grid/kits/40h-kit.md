---
layout: default
nav_exclude: true
---

# 40h kit

herein lies a large slew of very old information that should help you assemble an original 40h_kit if an unassembled one still exists out there in the wild.


## help

here are a few pointers for non-functioning kits or potential bug-bears to be sorted:

### single key press triggers entire row

are there any solder bridges on the connectors of the grid board? it seems that two signals are bridging. if you don't find any bridges, try swapping the ribbon cables. if the problem moves to a different row, the ribbon cable is defective (contact us). if the row doesn't move, it's a soldering problem.

### key press does not register

check the diode works and is in the correct orientation with a multimeter (compare with working buttons, www.google.com/#q=multimeter+test+diode). working outwards from the diode, check the 'star', then check that the ends of the diode are connected to the row/column lines (it may look like it's connected but use a multimeter to make sure).



## logic kit assembly

parts labeled visually:

![](/docs/kits/images/tech-kits-a01.jpg)

note: the 2×5 header is not included in the kit and is not needed for normal operation. it’s helpful if you plan on reprogramming the firmware (which you more than likely will not be doing.)

each part has a corresponding location on the board which is marked in white text. there are only a few places where you can insert something backwards, and i’ve tried to highlight these parts with big red arrows. the order of parts soldering presented here is suggested based on part height (lowest to highest) which makes for easy assembly (parts won’t fall out when you flip the board over against the table, so you don’t have to use tape, etc.) here we go.

### iset resistor and crystal

bend leads of resistor, insert, solder, inspect, clip leads. the orientation of these parts doesn’t matter.

![](/docs/kits/images/tech-kits-a02.jpg)

![](/docs/kits/images/tech-kits-a03.jpg)

![](/docs/kits/images/tech-kits-a04.jpg)

![](/docs/kits/images/tech-kits-a05.jpg)

### 74HC164 and 75HC165

**super super important! make sure the half-circles match! don’t put this in backwards, you’ll be very sad later.**

you’ll see on the board they’re marked as LS parts, disregard this. you might have trouble getting the leads into the holes, so bend all of the legs on one side just slightly by tilting the part against a hard surface.

![](/docs/kits/images/tech-kits-a06.jpg)

![](/docs/kits/images/tech-kits-a07.jpg)

![](/docs/kits/images/tech-kits-a08.jpg)

![](/docs/kits/images/tech-kits-a09.jpg)

### resistor network

**important! the dot must go towards the outside as shown!**

![](/docs/kits/images/tech-kits-a10.jpg)

### sockets

don’t insert the chips before soldering these parts. note that these parts are theoretically optional, though we highly highly suggest using them, which will make fixing problems much easier, in addition to swapping your firmware physically with a new chip, or replacing a burned out driver, etc.

again, line up the half-circles. this sockets have more of a square bite than a half-circle.

![](/docs/kits/images/tech-kits-a11.jpg)

![](/docs/kits/images/tech-kits-a12.jpg)

### ceramic capacitors

the orange ones, 0.1uF and 22pF respectively. the 22pF have a small “2” whereas the 0.1uF have a small “1” on them. orientation doesn’t matter. insert, bend leads, solder, clip. solder hot and quickly, as the ground planes will sink your heat (solder will cool faster than you’d like.)

![](/docs/kits/images/tech-kits-a13.jpg)

![](/docs/kits/images/tech-kits-a14.jpg)

### electrolitic capacitor

the black can, marked 10uF.

**do not insert this backwards!** the white line is (-) which is the short lead. insert the long lead into the (+) side.

![](/docs/kits/images/tech-kits-a15.jpg)

![](/docs/kits/images/tech-kits-a16.jpg)

### headers and UM245R

the headers are were the key and led matrices connect. the 5×2 is for jtag programming, which you don’t need if you’re never going to use it.

the UM245R is gives us USB. aren’t you glad you didn’t have to solder that surface-mount chip? don’t change the jumper positions, it won’t work if you do.

![](/docs/kits/images/tech-kits-a17.jpg)

### finished

![](/docs/kits/images/tech-kits-a18.jpg)

![](/docs/kits/images/tech-kits-a19.jpg)




## grid assembly and connection

###led orientation

![](/docs/kits/images/tech-kits-led_orient.jpg)

arrange your board as shown. the long leg of the led **must** be on the left, with the board in this position. insert leds and bend the leads to the opposite sides while holding the led in place. **take care aligning each led.**


### tip!

Maybe a helpful tip that might save you some time and frustration (It did for me):

Load ALL leds correctly as described above (long and short leg) while holding the board (faceplate facing you) at a 60-90 degree angle from the table.

![](/docs/kits/images/tech-kits-leds1_480.jpg)

When they are all inserted, take a sheet of paper and hold it in front to the "led side" (so they don't fall out of their holes) while laying it gently face down on the table with the legs sticking up (see picture below). When it's on the table, push and shake a little so that every led finds an "ok position". They don't have to be perfectly aligned..you'll correct this later.

![](/docs/kits/images/tech-kits-leds2_480.jpg)

**Now solder on one leg (on each of the 64 leds). Don't (do not) solder both legs! This is just to hold them in place.** Once that is done, lift the board up to the 90 degree angle from the table. Hold the board with the left hand (if you are right handed) while pushing one finger on one led (with the same left hand), while you solder the led's leg with your right hand from the other side. Once the solder melts, you find that the led finds its own "naturally aligned position" when you apply pressure. The led can get quite hot, but you will survive (or adapt to the speed of soldering).

If it doesn't automatically "drop" into a natural position when the solder melts, you just have to push slightly in a different direction with your finger on the left hand. Once it's aligned, move on to the next led.

When they are all "re-soldered" on just one leg, flip the board around and check if they are all aligned. Fix the ones that are a bit tilted. When everything looks good, put the board on the table face down again (leds down, like the picture) and solder the other (second) leg on each led.

Done. Now just cut the legs off right above the solder.

### diode orientation

![](/docs/kits/images/tech-kits-diode_orient.jpg)

for soldering the diodes we suggest first putting a dab of solder on one pad, then place the diode with tweezers while that first dab of solder is hot. then you can go back and solder the other leg.

solder on the headers last, otherwise they’ll make assembly more difficult.

### ribbon assembly

![](/docs/kits/images/tech-kits-a24.jpg)

### ribbon connection to grid pcb

![](/docs/kits/images/tech-kits-a23.jpg)


## 4x4x4 wiring

**Note: LEDY/KEYY wiring should be connected 1-8 to the logic board from right (1) to left (8). **

![](/docs/kits/images/tech-kits-4x4x4grid.jpg)
![](/docs/kits/images/tech-kits-4x4x4logic.jpg)


## further considerations

logic board dimensions are 2.6” x 3.4” and height is 0.75” (the usb port being the highest point.) you might be able to do some creative modification to lower this height requirement (such as removing the standoffs from the ftdi breakout board or replacing the type A port with a type B).

![](/docs/kits/images/tech-kits-vertical_height.jpg)



## monome 40h thrulogic part list

this list takes the form:
quantity / part-name / source(distributor/manufacturer) / partnumber

source abbreviations:

'dk' = http://www.digikey.com/

'maxim' = http://www.maxim-ic.com/

'ftdi' = http://www.ftdichip.com/

'jameco' = http://www.jameco.com/



### logic


1 ftdi um245r     ftdi    um245

1 atmega32-16pu   dk      ATMEGA32-16PU

1 max7221cng+     maxim   MAX7219CNG+

1 74hc164       dk      296-8248-5-ND

1 74hc165       dk      296-8251-5-ND

1 sip-10 res net    dk      770-101-R100KP-ND

1 cry16mhz hc49/us  dk      X1103-ND

3 0.1u cap      jameco    151118

2 0.22p cap     jameco    15407

1 10u cap       dk      P975-ND

1 10k res       jameco    691104

1 dip40 socket    jameco    683227

1   dip24 socket    jameco    683163

2 8x2 header      jameco    117917

1 5x2 header      jameco    117917



### grid

64  diodes        dk      1N4148WTPMSTR

2 8x2 rt-headers    jameco    139563

2 ribbon cable    jameco    37671

4 ribbon con      jameco    119467





## led selection

you'll be able to source LEDs from various places. generally we'd suggest buying new LEDs-- surplus LEDs are often unreliable and may die early, so keep extras.

### parameters

**size:** 3mm

you could also use surface mount LEDs-- 1206 or 0805 work well. solder them on similarly to the diodes.

**brightness:** suggested 500mcd - 2000mcd

lower will be too dim, higher may create a bright "spot" in the middle of the pads. note that the kit has brightness control via software, and you could also switch the iset resistor on the driver to lower the brightness (but not increase brightness).

**angle**: as wide as possible!

a 20 degree angle may result in a bright spot. a 50 degree angle should uniformly light up the entire pad.

**Vf and current:** below 4.5V, 20ma

most LEDs fall into this range.

**color:** your choice.



## source

[schems, boards, firmwares](http://github.com/monome/40h)
