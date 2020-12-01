---
layout: default
nav_exclude: true
---

# file management on norns

There are a few types of data that you will collect on norns: projects / apps, sound files, and presets. All of these live inside of **dust**, a special folder in norns.

In the [maiden](../maiden) section, we reviewed how to write scripts of your own and how to download scripts from the community. These changes all commit to `dust`, but maiden is not the best way to exchange files between your computer and norns.

### wifi-powered file transfers

These tools can help you confidently add, change, transfer, and remove files from norns:

- [file share](../fileshare): samba is a protocol which allows you to connect norns to a computer (via WIFI) and browse the contents of norns like you would a thumb drive. Use this to import/export audio files or to back up your scripts and presets.
- [SFTP](../sftp): A client which allows you to connect norns to a PC or Mac (via WIFI) and browse the contents of norns like you would a thumb drive. Same uses as above.

Please click either link above to learn more about each method.

### no wifi? (mac + linux)

For times when you are unable to connect norns to WiFi (no dongle, no network, etc), you can back up **dust** to a USB drive. **dust** includes your scripts, sound files, and presets.

First, connect norns to your computer via its power cable. Then, open a terminal and type:

**macOS**:

- `screen /dev/tty.usb`
- then, press TAB to autocomplete your serial number
- then type `115200`

Have doubts? The line should read: `screen /dev/tty.usb[TAB KEY] 115200`

**linux**:

- `dmesg` to see what enumeration number your system gave norns
- you'll get something like this: `FTDI USB Serial Device converter now attached to ttyUSB0`
- then, type: `screen /dev/ttyUSB0` (or whatever enumeration number was given)
- then type `115200`

Have doubts? The line should read: `screen /dev/ttyUSB<enumeration number> 115200`

If you see a blank screen, press ENTER. Then, you’ll be asked for login credentials:

- user: `we`
- password: `sleep`

Insert a USB stick into norns and execute `ls /media/usb` (this should show the contents of the USB stick). If the USB stick is recognized, copy your dust folder with `cp -r /home/we/dust /media/usb`

Shutdown with `sudo shutdown now`
