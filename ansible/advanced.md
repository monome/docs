---
layout: default
title: advanced
parent: ansible
nav_order: 7
has_children: false
has_toc: false
---

## Advanced configuration

### ii leader mode

Ansible can be used as a leader device for the [ii](/docs/modular/ii)
bus, controlling one or more follower modules using trigger and CV
information sent from Ansible. Since Ansible is not wired to supply
power to the ii bus, another leader module or a powered busboard is
required to use Ansible as a leader. Having [Crow](/docs/crow) or
[Teletype](../teletype/) connected to the same ii bus is sufficient.

When Ansible is acting as a ii leader, it can no longer receive ii
commands from other leaders like Teletype or Crow. Note also that
sending messages from multiple leader devices simultaneously on the
same ii bus does work in some tested scenarios, but may increase the
risk of buggy behavior including modules locking up and needing a
power cycle.

Currently, the only interface for turning on leader mode uses a grid.
In any grid application, go to the preset page by pressing the button
next to the USB port. Follower device toggles are arranged vertically,
just left of center. From top to bottom:

* [Just Friends](/docs/teletype/jt-1) can be used as a synthesis
  voice or function generator.

* [TELEXo](https://github.com/bpcmusic) can be used as a set of 4
  enveloped oscillators, or 4 CV/gate pairs.

* [ER-301](http://www.orthogonaldevices.com/er-301) can be sent
  gates and CV.

Multiple followers may be active at once. Toggling any follower on
enters leader mode, and deactivating all followers exits leader mode.
Leader mode causes Ansible to send ii messages on any CV or gate
change in any Ansible app, with Ansible's four gate/CV tracks
assignable to different follower behaviors.

To access more configuration, hold the lit key at the bottom of this
column, then tap any follower toggle. This accesses detailed
configuration for a particular follower, and pressing other follower
toggles will change which follower you are configuring. To exit this
mode and return to the main preset page, tap the key at the bottom of
the column again.

On the follower configuration view, the bottom left keys
(corresponding to Kria track select keys) toggle which tracks drive
which follower, so you can send the first 2 tracks to one device and
the last 2 tracks to another. By default all tracks are sent to all
enabled followers.

The top-left portion of the page is an octave shift for the
follower. This will shift all pitches sent to the follower by the
programmed number of octaves, with the initially selected center key
generally corresponding to middle C. This can be useful for working
with multiple followers that have different interpretations of "zero"
pitch.

In the top right of the follower configuration page, you can select
the operating mode for the follower. These modes have different
meanings for different followers.

* Just Friends, left to right: allocate notes polyphonically
  (`JF.MODE` = 1 and `JF.NOTE` is sent for each gate), map each track
  to one output as a synth voice (`JF.MODE` = 1 and `JF.VOX` is sent),
  map each track to one output as a function generator (`JF.MODE` = 0
  and `JF.VTR` is sent). In Kria, the velocity value is calculated
  based on the duration parameter.

* TELEXo, left to right: map each track to the corresponding enveloped
  oscillator (`TO.OSC` is sent for pitch and `TO.ENV` is sent for gate
  on/off), map each track to the corresponding gate/CV pair (`TO.TR` /
  `TO.CV`).

* ER-301 can be sent gate and CV commands, with the 4 tracks
  corresponding to the first 4 `SC` channels.


### USB disk mode

If you insert a USB disk into Ansible, you can save presets to a JSON
file on disk, or restore presets from such a file. In addition to
archiving or sharing app presets, this can be useful for making
backups before updating to a new firmware revision, because future
versions will be able to load files saved by older versions. The drive
must be formatted with a FAT filesystem, FAT32 is probably your best
bet. Note that Ansible can be a little picky about USB disks it will
talk to, it's possible you may need to try a couple for this to
work. If you attach an [FTDI cable](/docs/modular/dev), Ansible prints
a fair amount of diagnostic information to the UART which may be
helpful for troubleshooting loading errors.

To save presets:

* Press KEY 2. the white LED turns on to indicate that the device is
  armed for saving.

* Press the MODE key to cancel, or press KEY 2 again to write the
  presets Ansible has stored in flash to the file
  `ansible-presets.json` on the root of the drive.

An existing `ansible-presets.json` file will be overwritten. The white
LED blinks while saving and turns off when done. Wait for this LED and
any busy indicator on the disk to stop blinking before removing the
drive, or the file may be corrupted. If an error is encountered during
writing the backup, both the white and orange LEDs will turn on until
the drive is removed or the MODE key is pressed. A full save takes
about 20 seconds.

To load presets:

* Press KEY 1. The ORANGE LED turns on to indicate that the device is
  armed for loading.

* Press the MODE key to cancel, or press KEY 1 again to read a
  `ansible-presets.json` file from the disk into Ansible's flash
  storage.

The orange LED blinks while reading and turns off when done. Wait for
this LED and any busy indicator on the disk to stop blinking before
removing the drive. If an error is encountered during loading the
backup, both the white and orange LEDs will turn on until the drive is
removed or the MODE key is pressed. Before loading, Ansible makes an
additional backup of its flash contents in the file
`ansible-backup.bin`, and will attempt to restore presets from this
file if they were partially overwritten by a load operation that did
not complete successfully. If this happens for some unforeseen reason, it may be
possible to recover your Ansible presets from this file, please post
on [lines](https://llllllll.co/t/preset-save-to-usb-disk/10113). A
full load takes about 20 seconds.

To save or load presets for only the currently running app, hold the
MODE key while inserting the disk. This can take
considerably less time than saving/loading everything, and for some apps
is fast enough that the LED won't have time to blink at all.

The JSON files are fairly human-editable, but modifying them with
out-of-bounds data may result in strange Ansible behavior.

If you are running an Ansible firmware version that does not support
disk backups (v1.6.1 or lower), or you have an `ansible.hex` file from
an older firmware, it is possible to convert a direct backup of a
firmware image (`ansible.hex`) into JSON files that newer Ansible
firmwares can load, and "carry forward" your existing presets to the
latest firmware. This conversion is done via the
[extract](https://github.com/monome/ansible/tree/master/tools/flash_tools)
Python program. If you need help converting a backup, please post on
[lines](https://llllllll.co/t/preset-save-to-usb-disk/10113) and
include the firmware version you are starting from in your post if
known.

### Tuning

Using a grid as a control surface, it is possible to correct for
mismatches between CV outputs or to entirely reprogram Ansible's
tuning table. Scales may be loaded from a JSON preset file, or may be
modified with a Grid interface via the tuning page.

First, enter Kria. Hold Key 2 (config). The
Scale page key from Kria remains highlighted with Key 2 held. Press it
to enter tuning mode. You can let go of Key 2 now to stay in tuning mode,
and tap Key 2 again at any time to go back to Kria.

The top four rows, as in Kria's trigger page, correspond to tracks,
with the center 12 keys highlighted to represent the 12 note slots in
the tuning table between two "octaves".  An *octave* in this section
will mean a group of 12 note slots, where the first note slot in an
octave group is the octave's *waypoint*.  The currently selected note
slot is brightly highlighted, and the currently playing note slots are
highlighted for all tracks.

All tracks and therefore all trigger outputs are on by default. You
can toggle trigger outputs off and on with the leftmost column of the
top 4 rows. Touching the same note slot key that is already selected a
second time will also toggle the corresponding track's trigger output.

The bottom two rows control the pitch of the selected note slot
relative to its current value.  The bottom row provides keys for
increasing (keys on the right) or decreasing (keys on the left) the
value that will be sent to the DAC to set the pitch CV when the
currently selected note slot is played. From the center out these are
+/- 1, 2, 4, 8, ... +/- 128 on the outermost keys. Increments which
would go out of bounds have their corresponding keys unlit, so in
the initial position the left side of this row is off.

The row above the bottom row displays and sets the absolute DAC value
of the note slot. As the DAC value increases, the leftmost key will
get brighter, then it will turn off and the next key over will get
brighter, etc., with keys that have already been passed staying dimly
lit, visualizing the full CV range of the track. You can touch a key
on this row to jump quickly between DAC values.

The 10 keys on the left side of the next row up are for selecting an
octave -- you can pick one of ten banks of 12 note slots each.
The right side of this row (third from the bottom) is for load/save functionality.

* The key to the left which is separate from the other two is the
  panic key -- press it to restore your saved tuning table from flash,
  long-press it to go back to the factory default equal temperament
  tuning table. This long press does not save anything, so you can
  quick press the key again to go back to the tuning table you have
  saved, if that's different from the factory default.

* The first key on the right will apply a constant offset to every
  tuning slot of each CV channel, corresponding to the adjustments you
  have made to the lowest slot of each track. Quick press it to apply
  these offsets. Long press it to apply offsets and then save.

* The second key on the right is for interpolating the tuning table
  between octave values. Quick press it to do a piecewise-linear fit
  between the values programmed for each octave. Long press it to fit
  between octaves and then save. What this means is that a straight
  line will be drawn between each waypoint, that is, the first note
  slot of each octave, and note slots in between will be assigned the
  values along that line. This makes it possible to define different
  CV responses for each output, such as one that gets lower in pitch
  as the note index increases, or one that gets lower in the middle,
  or an S-curved response that changes frequency more rapidly toward
  the center of the note range.

* The key furthest to the right can be long-pressed to save all note
  slots with their tunings exactly as currently programmed.

You can leave the tuning page to experiment with your tuning on other
Grid apps, but note that tuning changes are not saved to flash until
you explicitly save them using one of the rightmost keys on the third
row up of the tuning page.
