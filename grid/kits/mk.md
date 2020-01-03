---
layout: default
nav_exclude: true
---

# mk: monome kit

this page includes a huge list of information about the mk: monome kit. you might need to scroll down a ways, but all the old information is stored here for historical reference.

## help

here are a few pointers for non-functioning kits or potential bug-bears to be sorted:

### single key press triggers entire row

are there any solder bridges on the connectors of the grid board? it seems that two signals are bridging. if you don't find any bridges, try swapping the ribbon cables. if the problem moves to a different row, the ribbon cable is defective (contact us). if the row doesn't move, it's a soldering problem.

### key press does not register

check the diode works and is in the correct orientation with a multimeter (compare with working buttons, www.google.com/#q=multimeter+test+diode). working outwards from the diode, check the 'star', then check that the ends of the diode are connected to the row/column lines (it may look like it's connected but use a multimeter to make sure).




## assembly:

what you'll need:

- soldering iron
- solder
- flush wire cutters

### mk: driver

dimensions: 1.3" x 2.1" (height approx 0.45")

![](/docs/kits/images/tech-mk-assembly-mk-driver12.jpg)

the final goal. know your goal!

![](/docs/kits/images/tech-mk-assembly-mk-driver01.jpg)

#### kit contents

- circuit board
- ribbon cable
- ic: MAX7221
- ic: 74HC165
- ic: 74HC138E
- resistor network
- (2) 0.1uF ceramic disc capacitors
- 10uF electrolytic capacitor
- 10k resistor
- (2) 2x7 right angle headers
- (2) 2x8 straight headers

note: the 2×3 header is not included in the kit and is not needed for normal operation. it’s helpful if you need to reflash the bootloader, which is highly unlikely.

each part has a corresponding location on the board which is marked in white text. there are only a few places where you can insert something backwards, and i’ve tried to highlight these parts with big arrows and **loud text.**

![](/docs/kits/images/tech-mk-assembly-mk-driver02.jpg)

start with the IC's. insert all three. you will probably need to pre-bend the legs (press one side of the IC against a flat surface to bend all at once). **be sure you place the 138 where it belongs, and the 165 where it belongs, according to text on the circuit board!**

**very important!** the arrows above indicate the alignment. the little half-circles must match.

![](/docs/kits/images/tech-mk-assembly-mk-driver03.jpg)

flip the board over. start with opposite corners of each chip to ensure they won't fall out.

you're striving for pretty, smooth solders joints that look like nice little mountains. if your solder joint looks ugly, simply reheat the joint by briefly holding the iron against the joint.

![](/docs/kits/images/tech-mk-assembly-mk-driver04.jpg)

you don't want to overheat any one chip so i'd suggest alternating which chip you're soldering which give them a chance to cool down.

![](/docs/kits/images/tech-mk-assembly-mk-driver05.jpg)

insert the resistor network (long black thing with legs on one side.)

**important!** see arrow above. line up little dot as shown. there is a matching dot on the circuit board.

![](/docs/kits/images/tech-mk-assembly-mk-driver07.jpg)

disc capacitors and resistor. pre-bend the resistor as shown. insert components, flip board, bend legs out of the way. (resistor position shown in next photo.) orientation does not matter for these parts.

![](/docs/kits/images/tech-mk-assembly-mk-driver08.jpg)

**important!!** the long leg of the electrolytic capacitor must go into the hole marked with the plus sign. in other words, the white stripe on the can (showing a negative sign) goes in the hole without the plus sign.

![](/docs/kits/images/tech-mk-assembly-mk-driver06.jpg)

clip all of the dangling legs. be sure you clip them short enough so that the nubs don't touch any other metal bits.

![](/docs/kits/images/tech-mk-assembly-mk-driver09.jpg)

progress so far for comparison.

![](/docs/kits/images/tech-mk-assembly-mk-driver10.jpg)

**important!** insert the short legs of the right angle header so that the long legs stick out the side.

![](/docs/kits/images/tech-mk-assembly-mk-driver11.jpg)

solder on the 2x8 headers. again, insert short legs down so long legs stick up.

![](/docs/kits/images/tech-mk-assembly-mk-driver13.jpg)

the other right angle header is for the logic board.

![](/docs/kits/images/tech-mk-assembly-mk-driver14.jpg)

when connecting the cable ensure the same orientation for both the logic board and driver. shown above, the flat side is up on both connections.

### mk: keypad

![](/docs/kits/images/tech-mk-assembly-mk-keypad01.jpg)

you'll need some tweezers for this part. and you don't need a tiny soldering iron tip-- i actually prefer a normal sized tip. shown above, i line up all of the diodes for easy placement-- otherwise you spend a lot of time mid-soldering just flipping and lining up diodes. i've put them in columns so the indicator line is all to the right (see below for a photo of the indicator line.)

![](/docs/kits/images/tech-mk-assembly-mk-keypad04.jpg)

i also suggest pre-soldering a little blob on one pad per diode. this way you can reheat the pad with the iron while holding the tweezers in the other hand.

![](/docs/kits/images/tech-mk-assembly-mk-keypad02.jpg)

**very important!** align the line mark on the diode with the solid white mark on the diode symbol.

![](/docs/kits/images/tech-mk-assembly-mk-keypad03.jpg)

- soldering iron in one hand, tweezers in the other
- pick up a diode (lined up correctly)
- reheat pad with solder on it
- place diode, with one leg stabbing into hot solder
- hold momentarily, withdraw soldering iron
- let go of diode with tweezers

i normally solder the entire panel then go back and solder the other leg of each diode.

![](/docs/kits/images/tech-mk-assembly-mk-keypad09.jpg)

**important!** the LEDs must be inserted with the correct orientation. shown above, the long leg of the LED goes in the hole marked with the white line.

i generally insert all of the LEDs at once, use cardboard to hold them all down, then flip the whole thing onto the table for soldering.

![](/docs/kits/images/tech-mk-assembly-mk-keypad10.jpg)

solder and clip the legs.

![](/docs/kits/images/tech-mk-assembly-mk-keypad05.jpg)

the connector has no orientation. center the part so the legs on each side are evenly spaced.

![](/docs/kits/images/tech-mk-assembly-mk-keypad06.jpg)

you can optionally use a bit of tape to hold the part down, though i was able to add solder to one leg without the part moving. be sure each leg gets a nice, smooth connection.

when soldering the second connector, be sure not to lean the iron against the plastic of the first connector! it'll melt. be careful not to lean on the diodes as well. generally this isn't a problem unless you're doing something acrobatic. take it slow.

![](/docs/kits/images/tech-mk-assembly-mk-keypad07.jpg)

both connectors soldered.


### attach driver to grid

![](/docs/kits/images/tech-mk-mk06.jpg)

**note! the cable is hooked up incorrectly in this photo.**

the cable points towards the outside of the grid. we suggest you attach the cable between the driver and logic before attaching the driver to the grid.


### firmware flash

the mk ships standard with 8x8 firmware. if you're using a different size or want encoder support, it's time to flash your firmware. see below.










## mk: firmware flash

the monome kit has a bootloader which means you can flash the device's firmware without using an external programmer.

a few different firmwares are available, and we'll produce a few more. since these are open source you're encouraged to extend the firmware and share them here.

you'll need access to the logic board for this process.

**these firmwares require serialosc to function.** they will not work with monomeserial.

### install toolchain

download and install.

- osx: [crosspack](http://www.obdev.at/products/crosspack/index.html)
- windows: [winavr](http://sourceforge.net/projects/winavr/files/)
- linux: [avrdude](http://www.bsdhome.com/avrdude/)

### select firmware version

[download the mk source files](http://github.com/tehn/mk)

download then unzip.

the individual firmwares will be inside the folder `firmware`.

remember where you saved these files!

### find or change your serial number

the following step requires you know your serial number.

you can do this in windows in the device manager (get details on the usb port.)

on os x and linux, open a terminal and type:

~~~
ls -lrt /dev | grep tty.usbserial
~~~

mk kits initially were distributed with serial numbers starting with mk (eg `mk0000412`). if this is the case on your device, you need to change it to have only an m prefix (eg `m0000023`). one `m` followed by 7 numbers.

these applications let you easily change your serial number:

- os x: http://dangerousprototypes.com/2010/01/27/pirate-rename-get-a-nicely-named-serial-device/
- win: http://www.ftdichip.com/Support/Utilities/FT_Prog_v1.9.zip
- linux: https://github.com/nedko/ftdi245r_serial

### set your serial number

the programming script (makefile) needs to be edited for your unique serial number. your serial number looks something like `m0000315`

within the firmware folder, edit Makefile with a text editor.

at the top, edit the line:

~~~
SERIAL = /dev/tty.usbserial-m0000001
~~~

so that your serial number replaces `m0000001`.

you can find your serial number by running monomeserial (and various other ways).

**windows users:** instead of a serial number, you need to specify the COM port your device is on, so this line would look something like:

~~~
SERIAL = COM4
~~~

you can find your serial number by diving in (this is for xp): `system properties > device manager > USB serial port`.

you'll want to change the COM port to something between 1 and 4: `properties > port settings > advanced`.

it's ok if (for example) COM4 says it's used. just select it anyway (unless you know for certain you have something hooked up to it.)

### activate bootloader

![](/docs/kits/images/tech-mk-flash-mk-flash.jpg)

**make sure the device is connected via usb.**

using a small length of wire (or something conductive) short the two pins (holes) shown. simply touch one end of the wire to each hole. you won't get any visual or audible cue that this actually did anything, but have faith. you've reset the chip into bootloader mode.

don't leave the wire touching. just touch it momentarily then take it away.

### flash device using bootloader

**make sure that you're not running serialosc or any other application  which will use the serial port for this device.**

open a terminal or command line.

navigate to the folder containing the firmware files you downloaded earlier, for example:

~~~
cd ~/Desktop/mk/firmware/encoders
~~~

now to flash the device, enter command:

~~~
make 8x8
~~~

where `8x8` is the size of your device. options are 0x0, 8x8, 16x8, 16x16

you'll see something like this:

~~~
salt:encoders tehn$ make 8x8
avrdude -p m325 -b 115200 -P /dev/tty.usbserial-m0000001 -c arduino -e -V -D -U flash:w:mk8x8.hex:i

avrdude: AVR device initialized and ready to accept instructions

Reading | ################################################## | 100% 0.00s

avrdude: Device signature = 0x1e9505
avrdude: erasing chip
avrdude: reading input file "mk.hex"
avrdude: writing flash (5956 bytes):

Writing | ################################################## | 100% 0.56s

avrdude: 5956 bytes of flash written

avrdude: safemode: Fuses OK

avrdude done.  Thank you.
~~~

hard reset your device by disconnecting usb and reconnecting. you're done.







## mk: 40h keypad compatibility

the new mk logic and driver boards are compatible with older 40h keypad kits. however, if you're using multiple 40h keypad kits tiled together into a larger grid, you'll have to rotate the boards in order to maintain proper keypad spacing:

![](/docs/kits/images/tech-mk-alt-mk-40h-grids.jpg)

keep all connectors on the outside of the grid (same applies to a 16x16).

the mk driver is connected as shown below:

![](/docs/kits/images/tech-mk-alt-mk-40h-hookup.jpg)

we've written a alternate version of the firmware which performs all of the necessary software rotations so that your rotated boards will work correctly. these firmwares are succeeded with `-old` in their titles, for example `encoders-old`.

new logic boards ship standard with the `encoders` firmware, so if you're using 40h keypad kits, you'll need to flash your firmware with `encoders-old`.







## aux:enc assembly guide

you'll need to first install the encoder firmware on your mk: https://github.com/tehn/mk.

![](/docs/kits/images/tech-mk-aux-enc-kit01.jpg)

included components shown above:

- pcb
- 8 x encoders
- pin header (to be split into two 2x10)
- 16 SMD capacitors
- ribbon
- 2 x ribbon connectors

### capacitors

![](/docs/kits/images/tech-mk-aux-enc-kit02.jpg)

above, start with the capacitors. add solder to one pad. then heat the pad while holding a capacitor with tweezers. place the capacitor while the solder is hot.

![](/docs/kits/images/tech-mk-aux-enc-kit03.jpg)

solder the other side.

![](/docs/kits/images/tech-mk-aux-enc-kit04.jpg)

repeat for other capacitors.

### encoders

![](/docs/kits/images/tech-mk-aux-enc-kit06.jpg)

insert the encoders from the opposite side as the capacitors, so that you're soldering on the same side as the capacitors.

![](/docs/kits/images/tech-mk-aux-enc-kit07.jpg)

### connectors

![](/docs/kits/images/tech-mk-aux-enc-kit05.jpg)

cut the big header into two 2x10 sections. there will be some pins leftover.


![](/docs/kits/images/tech-mk-aux-enc-kit08.jpg)

note the insertion side.

### ribbon

![](/docs/kits/images/tech-mk-aux-enc-kit09.jpg)

you may cut the ribbon shorter if desired. attach the ribbon connectors as shown. if the ribbon is lying flat, both connectors should face the same direction.

we'd suggest using a clamp, though these can be seated by applying direct and strong pressure using a different tool (very large pliers, for example.)

### connection

![](/docs/kits/images/tech-mk-aux-enc-kit10.jpg)

connect as shown.




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

### sources

- http://jameco.com
- http://digikey.com
- http://mouser.com
- http://farnell.com

### part numbers

jameco:
- [yellow](https://www.jameco.com/webapp/wcs/stores/servlet/ProductDisplay?langId=-1&productId=333307&catalogId=10001&storeId=10001&krypto=9x3mj8umRTrJxBvnUjFLCEHwwfqEcCu0785jSS9FO%2FOcGKdPLDgN7YhW5Vt4JwfZGooXAwwlC2Rp%0D%0A%2B%2Fj%2BTznKdvMAuGBvvz28&ddkey=http:StoreCatalogDrillDownView)
- [blue](http://www.jameco.com/webapp/wcs/stores/servlet/Product_10001_10001_334749_-1)
