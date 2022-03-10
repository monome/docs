---
layout: default
parent: norns
title: help
nav_order: 6
---

# norns: help
{: .no_toc }

Between this page and the search bar above, you should be able to self-solve most norns troubles that you'd run into.

If you need additional help, we're here for you! Please send an email to help@monome.org using this format:

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

## HARDWARE

### replacing parts

#### wifi nub
{: .no_toc }

If you have lost your nub, you can purchase a new one [here](https://www.amazon.com/150Mbps-Adapter-LOTEKOO-Wireless-Raspberry/dp/B06Y2HKT75/ref=pd_sbs_147_28?_encoding=UTF8&pd_rd_i=B06Y2HKT75&pd_rd_r=36242006-c576-11e8-a606-db11b044450e&pd_rd_w=5lyNC&pd_rd_wg=ZzAMD&pf_rd_i=desktop-dp-sims&pf_rd_m=ATVPDKIKX0DER&pf_rd_p=53dead45-2b3d-4b73-bafb-fe26a7f14aac&pf_rd_r=24C4PSVWK71S15YGJS6D&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=24C4PSVWK71S15YGJS6D) or email help@monome.org for a replacement (10 USD, shipping included, only US).

If you have experienced signal strength issues and wish to replace your wifi dongle completely, you may wish to purchase a [high gain antenna adapter](https://www.amazon.com/Panda-Wireless-PAU06-300Mbps-Adapter/dp/B00JDVRCI0).

#### charger
{: .no_toc }

The charger that comes with norns is GEO151UB-6020 and its power specs are 2A / 5.25V. A direct replacement can be purchased [from Adafruit](https://www.adafruit.com/product/1994).

#### battery
{: .no_toc }

Before you purchase a new battery, please consider that your norns may not be reporting battery performance accurately. To test, fully drain the battery and then charge it fully.

If performance does not improve, then a direct replacement can be purchased [from Adafruit](https://www.adafruit.com/product/2011) or by emailing help@monome.org for a replacement (20 USD, shipping included, only US).

#### encoders
{: .no_toc }

If your encoders feel "jumpy", you can verify that your encoders are in need of repair by performing this simple test:

- navigate to the LEVELS page
- turn a level all the way up and continue to turn the encoder
- if the level jumps and does not remain at maximum, then you might want to replace that encoder

For in-depth testing, see [this thread on lines](https://llllllll.co/t/norns-jumpy-defect-encoders/18856).

We do *not* recommend at-home repair, as the encoders are extremely sensitive to heat and require quick, confident soldering. To arrange repair / replacement, please email `help@monome.org` with the following info:

- your order number (if you purchased the unit from monome directly)
- if you did not purchase from monome, please provide any details you have about the unit's prior life
- use a small screwdriver to remove the bottom plate and let us know if your board is either black or forest green

### extending storage

#### standard norns

Many of the original standard norns came equipped with a CM3 (Compute Module 3) which has 4gb of storage. This can be replaced with a CM3+ (Compute Module 3+) for up to 32gb of storage. Just search `raspberry pi cm3+ 32gb` to find a retailer.

There is no soldering needed, but you will have to disassemble your norns a bit. Please follow this tutorial video:

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/523980765?byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

*nb. if you are unable to use the `screen` Terminal commands shown in the video, you can expand your filesystem following the shield steps listed in the next section*

#### shield

Since shield's Raspberry Pi runs off of an SD card, which can cover a wide range of capacities, the software doesn't know how much space it's allowed to allocate for itself.

If you notice that shield doesn't seem to see the entire capacity of your microSD card, this is normal! You'll just need to let shield expand its filesystem:

- open a terminal on a computer connected to the same network as your shield
  - if you are using Windows, you might need to [install the SSH client](https://www.howtogeek.com/336775/how-to-enable-and-use-windows-10s-built-in-ssh-commands/)
- execute: `ssh we@norns.local`
  - if this doesn't find your shield, you can also use `ssh we@IP_ADDRESS_OF_SHIELD`, eg. `ssh we@192.168.1.100`
- password: `sleep` (you will not see characters while typing, this is normal), press ENTER/RETURN
- execute: `sudo raspi-config`
- navigate to `Advanced` and hit ENTER/RETURN
- select `expand filesystem` and hit ENTER/RETURN
- lots of activity will happen. when it's done, power down and reboot. if you get any errors, reboot again.
- if you SSH back into norns and execute `df -h`, you'll see the newly expanded capacity

### wifi troubleshooting

Since shield's Raspberry Pi has built-in wifi, these steps apply to standard norns only
{: .label}

If you are not actively using the wifi nub, it's best not to keep it plugged in. It uses a lot of power, draining both battery and system resources.
{: .label .label-grey}

If you are consistently unable to connect your norns to wifi through the ['Network Connect' steps outlined here](../play/#network-connect), please perform the following steps:

1. Try getting very close to your wifi router. Bad signal can make it seem nonfunctional.

2. Plug the wifi nub into a non-norns computer (laptop/desktop ; MacOS/Windows/Linux) and confirm that the nub functions as expected. If your nub is defective, please email help@monome.org for a replacement.

3. If you are prompted to update the nub's drivers, please do so. Even if there are no updates available, sometimes the simple task of searching for an update resolves connectivity issues. When this process completes, plug the nub back into norns.

4. If norns is still unable to connect to wifi, connect the power cable to your non-norns computer and follow the `serial` steps outlined [here](../advanced-access/#serial). Once you perform this serial login, try executing `nmtui` for a graphical interface of the wifi utilities, which may have better luck connecting to a network:
   
    ![](/docs/norns/image/terminal-nmtui-main.png)

5. If you are still unable to connect, please email help@monome.org with the following information:
   
   - Whether your nub was able to successfully connect with a non-norns computer
   - Screenshots of the terminal screens in step 4
   - Your router config (WPA, WEP, etc)

### norns shield boot troubleshooting

If your shield does not seem to be booting, the first thing to check is if the "startup tone" is occurring from your shield's output. Connect headphones or a speaker to shield's output (demarcated by the outward-facing arrow) and power it up -- within 20 seconds or so, you should hear a sine-like tone which indicates the norns OS has been successfully loaded.

If you do not hear a startup tone, the norns OS is not booting. The best next step is re-flashing your SD card following [these steps](../shield/#flashing-microsd-card).

- If you do not hear a startup tone after a successful re-flash, we recommend confirming that your Raspberry Pi is operational. The easiest way to do this is to remove the Pi from the shield, attach it to an HDMI monitor/TV, and power the Pi separately. If the Pi is operational, you'll see a rainbow square on your monitor/TV.
  - If your Pi is operational, your shield might require repair/re-touching. See the *`next steps`* section below.
  - If your Pi is not operational, replacing the Pi should resolve the issue.

- If you do hear a startup tone after a successful re-flash, but do not see any activity on the screen, the screen or the header might be a point of failure. See the *`next steps`* section below.

**next steps**

- If you purchased a fully-built unit (no soldering) from monome, please email help@monome.org for service or replacement.
- If you soldered the unit yourself, please post images of the board to [this thread](https://llllllll.co/t/diy-norns-shield/27638/). Note that this is a community resource, so please be respectful of time and energy limitations.
- If you purchased it from a third-party who soldered the components, please reach out to them for resolution.

### grid connectivity troubleshooting

If you've recently received a new grid, you may find that scripts do not seem to be connecting to it.

To troubleshoot:

- ensure your norns is up to date via `SYSTEM > UPDATE` (see [wifi + files](../wifi-files/#update) for more info)
- many scripts assume that an artist only has access to one grid (versus many MIDI controllers), and automatically connect to the first slot under `SYSTEM > DEVICES > GRID`.
  - disconnect all grids
  - press `K3` on slot 1, select `none`, press `K3`
  - press `K3` on slot 2, select `none`, press `K3`
  - ..repeat for any slot that doesn't say `none`
  - connect your new grid + it should populate slot 1!


### audio input/output hardware specs {#audio-specs}

**Codec**

Standard norns has audio codec CS4270. In 2022, we revised the shield circuit to CS4271, due to global component shortage -- [more info here](https://llllllll.co/t/norns-shield-2022/52960).

The codec is externally clocked with a crystal (for no jitter), and the sample rate is fixed at 48k.

**Inputs**

The standard norns input jacks are configured for balanced or unbalanced. Input impedance is 10k.

The shield has only one stereo input.

**Outputs**

The standard norns output jacks are configured for balanced or unbalanced. Output impedance is 590 ohm. Output from the codec is connected to the headphone driver as well.

The shield has only one stereo output. Revision 210330 outputs 1.75V peak-to-peak, which is roughly *consumer line level*.

**Headphone driver**

The standard norns headphone driver is a TPA6130A2. Volume is controlled via i2c with a simple protocol, so no driver is necessary. The i2c lines are connected to i2c0.

The shield does not have a separate headphone output.

### can I plug modular signals into norns directly? {#modular-levels}

NO!
{: .label .label-red}

norns (both standard and shield) has line-level inputs only -- sending modular signals, which run very hot, through these inputs may result in damage. Please attenuate your modular signals before sending them into norns with an interface module like [Intellijel's Audio Interface](https://www.modulargrid.net/e/intellijel-audio-interface-ii).

### how do I send MIDI to/from norns from/to another computer? {#midi-host}

Since norns is a MIDI host and other computers are *also* MIDI hosts, norns is not able to send/receive MIDI to/from a DAW or computer directly over its USB charge port.

- connect a [Roland UM-ONE mk2](https://www.roland.com/us/products/um-one_mk2/) to norns with USB, which will create a DIN-MIDI input and output for norns -- then connect UM-ONE MIDI to your computer using another USB-MIDI interface
- build this [DIY USBMIDI host-to-host adapter from `@okyeron`](https://llllllll.co/t/2host-a-diy-usbmidi-host-to-host-adapter/23472)
- use a USB host MIDI router like [Sevilla Soft's MIDI USB-USB](https://sevillasoft.com/index.php/midi-usb-usb)

### shield: can I use the Pi's HDMI output to mirror the shield's screen?

No.

The norns OS is primarily developed for/on the standard norns hardware, which makes use of a compute module which has a smaller form factor than the traditional Pi board and does not have any of the additional I/O. This allows standard units to provide pro-audio I/O, a battery, and an overall roomier layout while maintaining a small footprint.

Avoiding the additional CPU headroom required to support external video output also allows us to optimize the capabilities of norns, to provide standard norns and shield users with the same foundational software experience.

## SOFTWARE

### recovering from freezes {#frozen}

If you experience a freeze that you can't recover from, there's a special button combination which will gently restart the software.

- First, press and hold K3

- While K3 is held, press and hold K2

- While K3 and K2 are held, press and hold K1

- Hold all three keys down for 10 seconds

*The order of the keypresses matters: K3 then add K2 then add K1*
{: .label}

If multiple attempts of this combination fail, these options are last resorts:

- standard norns have a little white button on the rear side which provides a hard reset

- shields do not have a reset button, so the only option is to pull power

Use the brute-force approach only if you cannot recover using the suggested method
{: .label .label-grey}

### adding + updating scripts {#update-scripts}

maiden (the web-based editor built into norns) features a [project manager](../maiden/#project-manager) to help facilitate project discovery, installation, and upgrades.

To add a script that isn't hosted on maiden, you can [fetch it using maiden's REPL](../maiden/#fetch.)

If you are updating a project through maiden's project manager that was not originally installed via the project manager, you will receive an error that the project cannot be found in the catalog. Please delete the previously installed version and reinstall through project manager, which establishes the necessary git files for future updates.

lines also has a dedicated [Library](https://llllllll.co/search?q=%23library%20tags%3Anorns) for projects tagged `norns`. In each project's thread, you'll find in-depth conversation as well as performance examples and tutorials. Projects for norns are primarily built and maintained by the lines community, so any questions/trouble with a specific project should be directed to its thread.

### clear a currently-running script {#clear-script}

Press K1 to toggle from PLAY to HOME. Highlight `SELECT` and hold K1 -- you'll see `CLEAR` in the middle of the screen. Press K3 to clear the currently running script.

### error messages

#### DUPLICATE ENGINES

Supercollider fails to load if you have multiple copies of the same class, which are commonly contained in duplicate `.sc` files inside of `dust` (the parent folder for the projects installed on norns).

To typically solve this, [connect](../play/#network-connect) via wifi and open [maiden](../maiden). Type `;restart` into the maiden _matron_ REPL at the bottom (the `>>` prompt).

This will restart the audio components and output their logs. If there's a duplicate class an error message like the following will be shown:

```
DUPLICATE ENGINES:
/home/we/dust/code/ack/lib/Engine_Ack.sc Engine_Ack.sc
/home/we/dust/code/we/lib/Engine_Ack.sc Engine_Ack.sc
### SCRIPT ERROR: DUPLICATE ENGINES
```

In this example, the `Engine_Ack.sc` engine is duplicated in two projects: `ack` and `we`. Using maiden, you would expand each project's `lib` folder to reveal the duplicated `Engine_Ack.sc`. After you remove one of the offending engines, execute `SYSTEM > RESTART` from the norns menu.

If the issue persists or maiden does not report duplicate engines, please email help@monome.org. Keep in mind that unless you're familiar with Supercollider, do not tamper with its internal folder structure. All typical norns functionality can be handled through the maiden project manager or the `dust` folder.

#### LOAD FAIL

This simply means there is an error in the script you're trying to load.

Connect via wifi and open maiden to see the error message when you again try to load the script.

A common problem may be a missing engine. Check the output for something like:

```
### SCRIPT ERROR: missing Timber
```

In this example, the script requires `Timber`, so go find it in the Project Manager and install it. If you had just recently installed `Timber`, you need to restart your norns through SLEEP or entering `;restart` in the matron REPL.

#### SUPERCOLLIDER FAIL

This indicates that something is wrong with SuperCollider, which could be due to various issues. First always just try rebooting via `SYSTEM > SLEEP`.

If you're able to load maiden, there are two tabs in the main REPL area (above the `>>` prompt at the bottom of your screen). The first tab is for `matron`, the control program that runs scripts -- the other is `sc` for SuperCollider. Click into the `sc` tab and type `;restart` into the REPL. That should show you what is going on inside of SuperCollider.

- You might have a [duplicate engine](#duplicate-engines).
- You might be [missing a required engine](#load-fail).
- If an update was recently applied, it may be necessary to [manually re-apply it](#manual--offline-update-).
- If this doesn't help, you may need to re-flash your norns with a clean image (after backing up any of your data).
- If this doesn't fix it, there may be a hardware issue: e-mail help@monome.org.

#### FILE NOT FOUND

If a newly-renamed script throws a `file not found` error in maiden, it is likely because the system has not registered the name change -- even though you see the new name in the UI. Perform a hard refresh on your browser ([how?](https://fabricdigital.co.nz/assets/How-to-hard-refresh-browser-infographic.jpg)).

### reboot via maiden

To reboot matron, the Lua layer of norns, execute `;restart` in the `matron` tab of the maiden REPL.

To reboot SuperCollider, the synthesis layer of norns, execute `;restart` in the `supercollider` tab of the maiden REPL.

To perform a quick reboot of the entire norns stack (for instance, when installing a script with a synth engine), reboot SuperCollider *then* reboot matron.

## DATA MANAGEMENT

### back up norns

All data that you create with norns -- scripts you've downloaded or created, audio you've imported or recorded, MIDI mappings and presets, etc -- is stored in a central location: `dust`.

#### via wifi

To access the `dust` folder from another computer on the same wifi network, follow the steps in the [wifi + files: transfer](../wifi-files/#transfer) docs.

To back up or restore your `dust` folder, follow the steps in the [wifi + files: backup](../wifi-files/#backup) docs.

#### via usb

wifi is the most straightforward way to back up your norns. These instructions are provided for times when you are unable to connect norns to wifi (no dongle, no network, etc).
{: .label}

If you have a standard norns, connect it to a second computer via [serial](../advanced-access/#serial). If you have a shield, host a hotspot for it and connect it to a second computer via [ssh](../wifi-files/#ssh). Then, insert a USB stick into norns.

- Make sure the USB stick is detected with `ls /media`
	- you should see `usb` listed, in a different color
	- if you execute `ls /media/usb`, this should show the contents of the USB stick (if there are any)
- Copy your dust folder with `cp -r /home/we/dust /media/usb`
	- if you run into a permission issue, try `sudo cp -r /home/we/dust /media/usb`
	- this will take time! upwards of 15 minutes.
- Shutdown with `sudo shutdown now`

#### via sd card (shield only)

On Windows + MacOS, the norns partition on your SD card is unfortunately not accessible by simply inserting it into an SD card reader. We recommend using the wifi steps above.

For the adventurous, here are steps to surface the ext4 filesystem: [Windows](https://www.howtogeek.com/112888/3-ways-to-access-your-linux-partitions-from-windows/) and [MacOS](https://www.maketecheasier.com/mount-access-ext4-partition-mac/).

### fresh install

This process will install a clean working system.

**WARNING**: the disk will be completely erased. Be sure to first back up any data you have in `dust`.

Full images are not built for every release, so do not worry if the 'latest' full image is not the same as the current update -- you will update from SYSTEM > UPDATE as part of the last step.

#### standard norns

The easiest method to flash the disk image is using [etcher](https://www.balena.io/etcher/). It is available for Linux, MacOS, and Windows. If etcher does not work for you, or if you prefer the command line, see [this guide](https://github.com/monome/norns-image/blob/master/readme-usbdisk.md).

If you'd like a visual companion to this process, steps 2 and onward are also demonstrated [in this video](https://vimeo.com/523980765#t=220s).

Steps:

1. Install etcher. Download [the norns disk image](https://github.com/monome/norns-image/releases/latest): get the **standard** image. It'll download as a `.tgz` file -- extract it onto your computer so you have a remaining `.img` file.
2. Power norns down and remove the four bottom screws of the unit.
3. Plug norns into your laptop using its charge cable.
4. You'll see a switch through a notch in the norns circuit board. It's currently on `run` -- switch it to `disk`.
5. Run etcher. Select the disk image. Select the Compute Module as the target. Press `Flash!`, enter your non-norns computer's password, and wait for it to finish.
6. Once the flash is complete, disconnect USB. Flip the switch on the norns board back to `run`. Secure the bottom back onto the unit.
7. If you have a norns with a 32gb CM3+ (purchased October 2020 and thereafter), you will need to expand the file storage.  
   7a. Re-connect USB, power norns up, and connect via [serial](../advanced-access/#serial) through a terminal.  
   7b. Execute `sudo raspi-config` and enter *sleep* as the password.  
   7c. Navigate down to `Advanced`.  
   7d. Select `Expand Filesystem` and press OK.  
   7e. After it's completed, put norns to sleep.  
8. Boot norns + [connect to your network](../wifi-files) and [update via SYSTEM  > UPDATE](../wifi-files/#update)
9. [consider changing the default password and address](#change-password)

#### shield

Use [etcher](https://www.balena.io/etcher/) to flash your SD card, [using these shield-specific instructions](../shield/#flashing-microsd-card). Be sure to use a high quality SD card -- if you have any trouble, please try a different card.

If etcher does not work for you, or if you prefer to use the command line, see [this guide](https://github.com/monome/norns-image/blob/main/readme-usbdisk.md).

After flashing your SD card, you'll need to expand the filesystem:  

1. Open a terminal on a computer connected to the same network as your shield  
2. Execute: `ssh we@norns.local`  
  Password: `sleep`
3. Execute: `sudo raspi-config`  
4. Navigate to Advanced and hit RETURN  
5. Select `Expand Filesystem` and hit RETURN  
6. Lots of activity will happen. When it's done, power down and reboot. If you get any errors, reboot again.
7. [Connect norns to your network](../wifi-files) and [update via SYSTEM  > UPDATE](../wifi-files/#update)
8. [Consider changing the default password and address](#change-password)

If you have previously connected to a shield (either by this same IP address or simply `norns.local`) in the past, you may see a warning that the 'remote host identification has changed'. this is because the shield now has a new host key. The error will give you a filepath to your hosts file, but if you are on MacOS you can simply execute `rm -f ~/.ssh/known_hosts` in Terminal to erase the previous hosts file and start fresh.

### manual / offline update

For this process, we'll use the phrase `execute` to mean "type this text into your terminal and press return/enter to run it."

- Download and copy the [latest release's`.tgz` update file](https://github.com/monome/norns/releases) to a FAT-formatted USB drive
- Take note of the `.tgz` file's name, as it is important (eg. `norns210706` is specific to the July 06 2021 update in YYMMDD format)
- Insert the USB drive into norns and boot up your norns
- If using a standard norns, connect via [serial](../advanced-access/#serial). If using a shield, connect via [ssh](../wifi-files/#ssh)
- Copy file to `~/update/` by executing the following:

```
sudo cp /media/usb0/*.tgz ~/update/
```

- Once you see the command prompt again, enter the update folder by executing:

```
cd ~/update
```

- Remember that special filename (eg. `norns210706`)? We'll need it to unpack to the update folder by executing:

```
tar xzvf norns210706.tgz
```

- You'll see a flurry of activity, but after a few dozen seconds you'll get to the command prompt again. Now, we'll go into the the update folder by executing:

```
cd 210706
./update.sh
```
*nb. make sure to replace `210706` in the above with the date reflected in the file you downloaded. If you're in doubt, simply execute `ls` and you'll be shown two files: the `.tgz` and the folder it unpacked. We want to copy the name of the folder exactly.*

You'll see something similar to the following printed in your terminal:

```bash
[ ok ] Restarting nmbd (via systemctl): nmbd.service.
[ ok ] Restarting smbd (via systemctl): smbd.service.
CM3
'/home/we/maiden/dist/sources/base.json' -> '/home/we/dust/data/sources/base.json'
'/home/we/maiden/dist/sources/community.json' -> '/home/we/dust/data/sources/community.json'
ln: failed to create symbolic link '/home/we/bin/maiden': File exists
ln: failed to create symbolic link '/home/we/bin/maiden-repl': File exists
```

*nb. those last two failures are benign*

- Finally, execute `sudo shutdown now` and norns will shut down

If performing these steps on a shield, you won't see the standard shutdown message reminding you to wait until the non-red LED goes out -- you still need to wait!
{: .label .label-red}

Once you restart your device, hit K2 on the SELECT / SYSTEM / SLEEP screen and you should see the update's date listed on the right side of the screen!

### change default password + address {#change-password}

Since all norns units come configured with the same username + password, we encourage you to personalize + protect your setup by changing the default hostname and password for the `we` user.

#### via SYSTEM menu {#system-password}

In the norns SYSTEM menu, there's a `PASSWORD` entry which will open up a text selector for you to enter a new password. This will be the password you use to connect to your norns via SSH and hotspot.

While you can simply reset this password again via this menu option, we encourage you to set it to something memorable so you don't worry about troubleshooting connectivity in a critical moment.

#### change Samba password {#samba}

The `smb://` remote login password does *not* automatically change when you perform the changes above. To set Samba's login credentials to match the newly set user password, log in to the norns via [ssh](../wifi-files/#ssh) and execute:

```
sudo smbpasswd -a we
```

You'll be prompted to set a new SMB password -- we encourage setting it to match with the password you created via the SYSTEM menu.

#### hostname

To change the hostname for maiden access, log in to the norns via [ssh](../wifi-files/#ssh) and execute:

```
sudo raspi-config
```

This will lead you to the [Raspberry Pi Software Configuration Tool](https://www.raspberrypi.org/documentation/computers/configuration.html), where you can follow these steps:

- press ENTER on `1 System Options`
- press ENTER on `S4 Hostname`
- press ENTER on `<ok>` and type in a new hostname for your norns device (no need to type `.local`
- navigate down to `Finish` and press ENTER -- if asked to reboot, please do
- the unit will restart after a few seconds

Now, you'll be able to use your new hostname for maiden access (what once was `norns.local` will now be `your_unique_name.local`!) and your new password for ssh access!

### taking a screenshot {#png}

Capturing a screenshot of your norns can be a helpful tool for creating illustrative documentation or sharing UI ideas.

With your norns powered-on and connected to the same wifi network as your computer, connect to maiden. Then, execute this line in maiden's REPL (replacing <FILENAME> with something unique):

```lua
_norns.screen_export_png("/home/we/dust/<FILENAME>.png")
```

Use [SMB](../fileshare/) or [SFTP](../sftp/) to connect to norns and download the PNGs you just created from the `dust` folder. You'll notice the PNG is kinda tiny and the colors are inverted. Let's fix that with [ImageMagick](https://imagemagick.org/script/download.php).

With ImageMagick installed on your computer, [download this bash script](../norns-convert_screenshots.bash) and place it in the same folder as your downloaded screenshots. In terminal, `cd` to the folder and execute:

```bash
./norns-convert_screenshots.bash
```

That will clean up all the PNGs to render how they do on the norns screen.

*nb. You may need to execute `chmod u+x ./norns-convert_screenshots.bash` beforehand, or use `sudo ./norns-convert_screenshots.bash` if permission is denied.*

If you wish to do this manually, execute the following (replacing <PATH+FILENAME> with the entire path to your downloaded PNG):

```bash
magick convert <PATH+FILENAME>.png -gamma 1.25 -filter point -resize 400% -gravity center -background black -extent 120% <PATH+FILENAME>.png
```

For example:

```bash
magick convert /Users/dndrks/Downloads/mlr.png -gamma 1.25 -filter point -resize 400% -gravity center -background black -extent 120% /Users/dndrks/Downloads/mlr.png
```

## MORE {#more-faq}

- Imported audio must be 48khz, bit depth is irrelevant.

- Line noise while usb charge + audio input are both coming from the same laptop (ground loop) can be defeated with [an isolator](https://llllllll.co/t/external-grid-power-ext5v-alternative/3260).

- If a connected MIDI controller is not functioning as expected, it may be due to a known limitation in scripts that do not explicitly allow for MIDI control from channels other than channel 1. Either reassign your MIDI controller to channel 1 or insert this [bit of code](https://llllllll.co/t/norns-scripting-best-practices/23606/2) into a script.

- All grid editions will work with norns, but some apps may be coded for varibright levels that your hardware may not support.

- norns does not have built-in bluetooth + the OS is not currently designed to take advantage of bluetooth.
