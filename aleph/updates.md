---
layout: default
nav_exclude: true
permalink: /aleph/updates/
---

# Aleph Updates

The Aleph contains a bootloader which allows for easy software updates.

Before updating, make sure you've got the latest stable aleph software package is hosted on github:

[Aleph: Latest Release](https://github.com/tehn/aleph/releases/latest)

Download the release by clicking the first option under *Downloads*. It will look something like `aleph-150718.zip`. This is a zip archive.

If you're on a Mac, simply double click the `copy.command` file. This will copy the new release to your card, and eject the drive.

Alternatively, it's best to erase the contents of your card first. Be sure to empty the trash afterward. The card needs to be named ALEPH.

Unzip the file. **Copy the three folders to the root of your card**. Eject the card and wait for it to unmount.

### Launching the Bootloader

Insert the card back into the Aleph. Hold down MODE while powering up. This will launch the bootloader. Select the newest version of bees using ENC0 and push SW0 to write. Don't power down early or you'll have to do this again.

**If you don't see any files listed in the bootloader, something's gone wrong with the SD card. Try copying again, and wait a little longer after you eject the drive.**

### Notes

You'll only have to flash a new version of bees when there is a new version available. Re-flashing **will not** fix any problems you might be having– post to the forum if you run into issues.

Remember to check out the [scenes](../scenes) page for details about what's included and how things work.

*Be aware that updating software may break your existing scenes if you've edited or created scenes– but we'll indicate loudly if a new version will break scenes.*

### Card Formatting

If you're having trouble with your SD card it may help to format it. It needs to be formatted as a FAT file system (MS-DOS). On Mac you can do this via `Disk Utility` found in the `/Applications/Utilities` folder.
