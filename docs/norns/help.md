---
layout: page
permalink: /docs/norns/help/
---

# norns: help

## error messages

### DUPLICATE ENGINES

Supercollider fails to load if you have multiple copies of the same engine inside of `dust`.

To solves this [connect](../#connect) via wifi and open [maiden](../#maiden). Type `;restart` into the maiden REPL at the bottom (the `>>` prompt).

This will restart the audio components and output their logs. If there's a duplicate class an error message like the following will be shown:

```
DUPLICATE ENGINES:
/home/we/dust/code/ack/lib/Engine_Ack.sc Engine_Ack.sc
/home/we/dust/code/we/lib/Engine_Ack.sc Engine_Ack.sc
### SCRIPT ERROR: DUPLICATE ENGINES
```

Remove one of the offending scripts/classes and execute `SYSTEM > RESTART` from the norns menu.

### LOAD FAIL

This simply means there is an error in the script you're trying to load.

Connect via wifi and open maiden to see the error message when you again try to load the script.

A common problem may be a MISSING INCLUDE. Check the output for something like:

```
### MISSING INCLUDE: ack/lib/ack
### SCRIPT ERROR: load fail
/home/we/dust/code/ash/playfair.lua:21: MISSING INCLUDE: ack/lib/ack
```

The script `playfair` requires `ack`, so go find it in the Library and add the file to `dust/code/`.

### SUPERCOLLIDER FAIL

This indicates that something is wrong with Supercollider, which could be due to various issues.

- If an update was recently applied, it may be necessary to manually re-apply it.
- If this doesn't help, you may need to re-flash your norns with a clean image (after backing up any of your data).
- If this doesn't fix it, there may be a hardware issue: e-mail info@monome.org.


## manual update

- Download and copy update file to a FAT-formatted USB drive
- Insert the disk to norns and power up.
- Connect via serial (see instructions above).
- Copy file to `~/update/`:

```
sudo cp /media/usb0/*.tgz ~/update/
```

- Unpack and run update:

```
cd ~/update
tar xzvf norns190409.tgz
cd 190409
./update.sh
```

- Upon completion type `sudo shutdown now` to shut down.


## fresh install

- current image: [190801](https://monome.nyc3.digitaloceanspaces.com/norns190801.img.tgz) - 1.1G (please conserve bandwidth by not repeatedly downloading)

By far the easiest method to flash the disk image is using [etcher](https://www.balena.io/etcher/). It is available for Linux, MacOS, and Windows.

**WARNING** - flashing a disk completely erases the contents and replaces it with a clean install. Be sure to first back up any data you have in `dust`.

Steps:

1. Install etcher and get the disk image. Extract the disk image so you have a remaining `.img` file.
2. Remove the four bottom screws of the norns.
3. Plug the norns power into your laptop.
4. You'll see a switch through a notch in the circuit board, flip this to DISK.
5. Run etcher. Select the disk image. Select the Compute Module as the target. Push go and wait for it to finish.
6. Disconnect USB. Flip the switch back to RUN. Put the bottom back on.

If you prefer the command line see [this guide](https://github.com/monome/norns-image/blob/master/readme-usbdisk.md).
