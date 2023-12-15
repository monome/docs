---
layout: default
parent: help
grand_parent: norns
has_children: false
title: data management
nav_order: 3
---

# norns: data management help
{: .no_toc }

Between this page and the search bar above, you should be able to solve most norns troubles that you'd run into.

If you need additional help, we're here for you! Please send an email to [help@monome.org](mailto:help@monome.org) using this format:

- *What issue did you experience?*
- *What steps are necessary to reproduce the issue?*
- *What additional hardware was connected to norns at the time of the issue? This includes controllers, wifi dongles, external hubs, etc.*
- *Please attach any output printed in [maiden](../maiden/) when the issue occurs*

If you're unable to supply concrete steps to reliably reproduce the issue, this will reduce our efficacy. Please understand if we point you to existing resources and ask you to verify additional info.

For support with specific scripts and libraries, please visit [lines](https://llllllll.co) and search for the script's thread.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## back up norns

All data that you create with norns -- scripts you've downloaded or created, audio you've imported or recorded, MIDI mappings and presets, etc -- is stored in a central location: `dust`.

### via WiFi

To access the `dust` folder from another computer on the same wifi network, follow the steps in the [wifi + files: transfer](../wifi-files/#transfer) docs.

To back up or restore your `dust` folder, follow the steps in the [wifi + files: backup](../wifi-files/#backup) docs.

### via USB

wifi is the most straightforward way to back up your norns. These instructions are provided for times when you are unable to connect norns to wifi (no dongle, no network, etc).
{: .label}

If you have a standard norns, connect it to a second computer via [serial](../advanced-access/#serial). If you have a shield, host a hotspot for it and connect it to a second computer via [ssh](../advanced-access/#ssh). Then, insert a USB stick into norns.

- Make sure the USB stick is detected with `ls /media`
	- you should see `usb` listed, in a different color
	- if you execute `ls /media/usb`, this should show the contents of the USB stick (if there are any)
- Copy your dust folder with `cp -r /home/we/dust /media/usb`
	- if you run into a permission issue, try `sudo cp -r /home/we/dust /media/usb`
	- this will take time! upwards of 15 minutes.
- Shutdown with `sudo shutdown now`

### via SD card (shield only)

On Windows + macOS, the norns partition on your SD card is unfortunately not accessible by simply inserting it into an SD card reader. We recommend using the wifi steps above.

For the adventurous, here are steps to surface the ext4 filesystem: [Windows](https://www.howtogeek.com/112888/3-ways-to-access-your-linux-partitions-from-windows/) and [MacOS](https://www.maketecheasier.com/mount-access-ext4-partition-mac/).

## fresh install

This process will install a clean working system.

**WARNING**: the disk will be completely erased. Be sure to first back up any data you have in `dust`.

Full images are not built for every release, so do not worry if the 'latest' full image is not the same as the current update -- you will update from SYSTEM > UPDATE as part of the last step.

### standard norns {#fresh-standard}

The easiest method to flash the disk image is using either [Etcher](https://www.balena.io/etcher/) or the official [Raspberry Pi Imager](https://www.raspberrypi.com/software/). They are available for Linux, MacOS, and Windows. If Etcher or the Imager do not work for you, or if you prefer the command line, see [this guide](https://github.com/monome/norns-image/blob/master/readme-usbdisk.md).

For a visual guide to the Imager, see [this video from the Raspberry Pi Foundation](https://www.youtube.com/watch?v=ntaXWS8Lk34).

If you'd like a visual companion to the Etcher process, steps 2 and onward are also demonstrated [in this video from monome](https://vimeo.com/523980765#t=220s).

If Etcher or the Imager do not work for you, or if you prefer to use the command line, see [this guide](https://github.com/monome/norns-image/blob/main/readme-usbdisk.md).

Steps:

1. Install Etcher or the Imager. Download [the norns disk image](https://github.com/monome/norns-image/releases/latest): get the **standard** image. It'll download as a `.tgz` file -- extract it onto your computer so you have a remaining `.img` file. Note that on Windows this may take two unzips -- if one unzip returns a `.tar` file, run an additional unzip on the `.tar` to get the `.img`.
2. Power norns down and remove the four bottom screws of the unit.
3. To help simplify the process, please disconnect any other storage devices connected to your computer. Then, plug norns into your computer using its charge cable.  
4. You'll see a switch through a notch in the norns circuit board. It's currently on `run` -- switch it to `disk`. The LED on the back of norns will turn white and remain on until the 6th step.  
  - Be aware of the white reset button at the bottom of the unit when you place norns back down -- if it keeps getting triggered, try placing the unit upright on its bottom edge.
5. Run Etcher / Imager. If using Etcher, you can simply drag the disk image onto the `+` sign -- if using Imager, click `Choose OS` and `Use custom`, then navigate to the disk image file. In Etcher, select the Compute Module as the target -- in Imager, choose the device mounted as `/Volumes/boot`. Press `Flash!` / `Write`, enter your non-norns computer's password, and wait for it to finish + validate.  
  - If you do not see the Compute Module populate, or if it doesn't initialize properly, try starting fresh by unplugging norns from your computer and restarting your computer. As silly as it sounds, a simple restart has resolved this type of issue in our workshop.
  - If you're using a USB adapter or hub and you do not see the Compute Module populate or it doesn't initialize properly, try removing the USB-A connector from the adapter and re-connecting it. If you're on a USB-C Mac, we have seen connection issues when using hubs resolved by using Apple's official USB-C-to-A adapter. 
  - Try swapping the cable for a different one.
  - If you're at this point and running MacOS with [homebrew](https://brew.sh/) installed, try installing `rpiboot` using [these command line instructions](https://github.com/monome/norns-image/blob/main/readme-usbdisk.md#mac-os).  
  - If you're installing for the first time onto a fresh CM3+ using Windows, you'll likely need to install the Raspberry Pi boot drivers and run `rpiboot` before you can image it. Follow [these instructions on the Raspberry Pi site](https://www.raspberrypi.com/documentation/computers/compute-module.html#windows-installer) to make the new CM3+ show up as a USB mass storage device.
6. Once the flash and validation are complete, disconnect USB. Flip the switch on the norns board back to `run`. Secure the bottom back onto the unit.
7. Boot norns (if you completed the expansion, it will take a bit longer to start than normal), [add your network](../wifi-files) and [update via SYSTEM  > UPDATE](../wifi-files/#update)
  - If you perform `SYSTEM > UPDATE` and norns tells you it's `up to date.`, it is! We recommend this step for times when a disk image might not be compiled for an incremental update cycle.
8. If you have a norns with a 32gb CM3+, you will need to expand the file storage, since the fresh install assumes the lowest capacity (4gb). This only needs to be done once, but it's important after a fresh install -- it lets the system know the capacity of your storage.  
  - Connect via [SSH](../advanced-access/#ssh) through a terminal.  
  - Execute: `sudo raspi-config` (*or* execute: `sudo raspi-config --expand-rootfs; sudo shutdown -r now` to skip to the last step without a GUI)
  - Navigate down to `Advanced Options`.  
  - Select `Expand Filesystem` and select `OK`.  
  - Navigate to `Finish` and if prompted to restart, select `OK`. Please note that this will power norns down fully, rather than restart it. That's okay! If you were not presented with an option to restart, simply put norns to sleep after the expansion completes.
  - Please note: norns will take a few minutes to fully boot after the filesystem expansion
  - You can verify the expansion has taken place by pressing K2 on the `SELECT / SYSTEM / SLEEP` screen -- `disk` should show around `26000M` (26 gb).  
9. [Consider changing the default password and address](#change-password)

### shield {#fresh-shield}

Use [Etcher](https://www.balena.io/Etcher/) or the official [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to flash your SD card, [using these shield-specific instructions](../shield/#flashing-microsd-card). Be sure to use a high quality SD card -- if you have any trouble, please try a different card.

If Etcher or the Imager do not work for you, or if you prefer to use the command line, see [this guide](https://github.com/monome/norns-image/blob/main/readme-usbdisk.md).

After flashing your SD card, you'll need to expand the filesystem:  

1. Open a terminal on a computer connected to the same network as your shield  
2. Execute: `ssh we@norns.local`  
  Password: `sleep`
  - if you cannot connect to `we@norns.local`, try replacing `norns.local` with your shield's IP address, discoverable by hitting K2 on the `SELECT / SYSTEM / SLEEP` screen
3. Execute: `sudo raspi-config` (*or* execute: `sudo raspi-config --expand-rootfs; sudo shutdown -r now` to skip to the last step without a GUI)
4. Navigate to `Advanced Options` and hit RETURN  
5. Select `Expand Filesystem` and hit RETURN  
6. Lots of activity will happen. When it's done, power down and reboot. If you get any errors, reboot again.
7. [Connect norns to your network](../wifi-files) and [update via SYSTEM  > UPDATE](../wifi-files/#update)
8. [Consider changing the default password and address](#change-password)

If you have previously connected to a shield (either by this same IP address or simply `norns.local`) in the past, you may see a warning that the 'remote host identification has changed'. this is because the shield now has a new host key. The error will give you a filepath to your hosts file, but if you are on MacOS you can simply execute `rm -f ~/.ssh/known_hosts` in Terminal to erase the previous hosts file and start fresh.

## expanding storage

#### standard norns {#extending-standard}

All new norns built since 2021 come with a CM3+ which offers 32gb of storage. Their full capacity is expanded in the workshop before their initial shipment, but if you've recently reinstalled the norns software on your device, you will need to expand the filesystem in order for the full 32gb to be available.

*Note: If you're running norns 230509 or later, you can simply execute `norns.expand_filesystem()` to automatically perform the steps below.*

- open a terminal on a computer connected to the same network as your norns
  - if you are using Windows, you might need to [install the SSH client](https://www.howtogeek.com/336775/how-to-enable-and-use-windows-10s-built-in-ssh-commands/)
- execute: `ssh we@norns.local`
  - if this doesn't find your norns, you can also use `ssh we@IP_ADDRESS_OF_SHIELD`, eg. `ssh we@192.168.1.100`
- password: `sleep` (you will not see characters while typing, this is normal), press ENTER/RETURN
- execute: `sudo raspi-config` (*or* execute: `sudo raspi-config --expand-rootfs; sudo shutdown -r now` to skip to the last step without a GUI)
- navigate to `Advanced Options` and hit ENTER/RETURN
- select `Expand Filesystem` and hit ENTER/RETURN
- lots of activity will happen and you'll be notified that the 'root partition has been resized'. hit ENTER/RETURN on `<Ok>`
- hit the right arrow twice to navigate to `Finish` and you'll be asked to reboot -- select `<Yes>` (note that norns will power down and will not reboot automatically)
- turn your norns back on and you should ~26000M under `disk` when you hit K2 on the `SELECT / SYSTEM / SLEEP` screen

### shield {#extending-shield}

Since shield's Raspberry Pi runs off of an SD card, which can cover a wide range of capacities, the software doesn't know how much space it's allowed to allocate for itself.

If you notice that shield doesn't seem to see the entire capacity of your microSD card, this is normal! You'll just need to let shield expand its filesystem.

*Note: If you're running norns 230509 or later, you can simply execute `norns.expand_filesystem()` to automatically perform the steps below.*

- open a terminal on a computer connected to the same network as your shield
  - if you are using Windows, you might need to [install the SSH client](https://www.howtogeek.com/336775/how-to-enable-and-use-windows-10s-built-in-ssh-commands/)
- execute: `ssh we@norns.local`
  - if this doesn't find your shield, you can also use `ssh we@IP_ADDRESS_OF_SHIELD`, eg. `ssh we@192.168.1.100`
- password: `sleep` (you will not see characters while typing, this is normal), press ENTER/RETURN
- execute: `sudo raspi-config` (*or* execute: `sudo raspi-config --expand-rootfs; sudo shutdown -r now` to skip to the last step without a GUI)
- navigate to `Advanced` and hit ENTER/RETURN
- select `expand filesystem` and hit ENTER/RETURN
- lots of activity will happen. when it's done, power down and reboot. if you get any errors, reboot again.
- if you SSH back into norns and execute `df -h`, you'll see the newly expanded capacity

## removing logs

If your norns seems more full than it ought to be (check if there's any larger-than-expected TAPE files first!), there's a chance that the logging system has added superfluous files to your storage.

To confirm:

- open a terminal on a computer connected to the same network as your norns
  - if you are using Windows, you might need to [install the SSH client](https://www.howtogeek.com/336775/how-to-enable-and-use-windows-10s-built-in-ssh-commands/)
- execute: `ssh we@norns.local`
  - if this doesn't find your norns, you can also use `ssh we@IP_ADDRESS_OF_SHIELD`, eg. `ssh we@192.168.1.100`
- password: `sleep` (you will not see characters while typing, this is normal), press ENTER/RETURN
- execute `sudo du -h /var/log`
- if `/var/log/journal` is showing as larger than 20 megabytes, you can safely clean up the files inside by executing: `sudo journalctl --vacuum-size=20M`
- execute `sudo du -h /var/log` to confirm the space has been reclaimed

## taking a screenshot {#png}

Capturing a screenshot of your norns can be a helpful tool for creating illustrative documentation or sharing UI ideas.

With your norns powered-on and connected to the same wifi network as your computer, connect to maiden. Then, execute this line in maiden's REPL (replacing `"filename"` with a unique string):

```lua
screen.export_screenshot("filename")
```

This will create a screenshot at `dust/data/<script>/filename.png`. If no script is loaded, screenshots will simply be saved to `data`. Then, use [SMB](/docs/norns/wifi-files/#transfer) or [SFTP](/docs/norns/advanced-access/#sftp) to connect to norns and download the PNGs.

Once downloaded, you might want to adjust the gamma to display the full range of screen levels. If you have [ImageMagick](https://imagemagick.org/index.php) installed on your computer, `cd` to the file's location and execute:

```bash
magick convert <filename> -gamma 1.75  <filename>
```

**Please note:** the image generated by `screen.export_screenshot` is scaled up by 4 and includes a 64-pixel border. If you wish to create a screenshot which retains the exact dimensions of the norns screen, execute this line in maiden's REPL (replacing `"filepath"` with a unique string, eg. `"home/we/dust/data/my_script/screenshot.png"`):

```lua
_norns.screen_export_png("filepath")
```

You can then use [`screen.display_png(filepath, x, y)`](https://monome.org/docs/norns/api/modules/screen.html#Screen.display_png) to display the image on the norns screen.