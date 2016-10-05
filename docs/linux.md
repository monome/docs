---
layout: page
permalink: /docs/linux/
---

# Linux setup

_Note: This guide may need link updates! Please let us know: [help@monome.org](mailto:help@monome.org)_.

This is a step-by-step guide for using a monome grid on [Ubuntu Linux](http://www.ubuntu.com "http://www.ubuntu.com"). The monome will be controlled by Max/MSP software running under [Wine](http://www.winehq.org "http://www.winehq.org"). While there are a few “native” applications written in PureData, ChucK, or C, the vast majority of software is written for the [Max/MSP](http://www.cycling74.com "http://www.cycling74.com") environment, which is only available for MacOSX and Windows.

This guide focuses on [Ubuntu Studio](http://www.ubuntustudio.org "http://www.ubuntustudio.org"), but the instructions should be pretty similar for other Linux distributions. Package names may differ. If you use a source-based distribution such as [Gentoo](http://www.gentoo.org "http://www.gentoo.org"), you probably already have the necessary build tools and development libraries installed.

This guide will show you how to run Max/MSP applications in Wine, which will be connected to the [JACK](http://www.jackaudio.org "http://www.jackaudio.org") audio server, using the low-latency [WineASIO](http://sourceforge.net/projects/wineasio "http://sourceforge.net/projects/wineasio") driver. Once JACK is working with WineASIO and Max/MSP, you can connect any native Linux applications that are JACK-aware: in short, you can create a professional setup using only free software.

## Pre-compiled Linux packages

The easiest way to setup things on Ubuntu is to get the precompiled packages from a PPA: [ppa:artfwo/monome](https://launchpad.net/~artfwo/+archive/monome "https://launchpad.net/~artfwo/+archive/monome"). If you use these pre-built packages, you can skip right down to the WineASIO section below.

## Prerequisites

You'll need to have [libmonome](http://github.com/monome/libmonome "http://github.com/monome/libmonome") and [serialosc](http://github.com/monome/serialosc "http://github.com/monome/serialosc") installed before you can use any applications with your monome. [serialosc](/docs/app:serialosc "app:serialosc") converts the monome's native serial data format into OSC messages that the applications use. Downloading, building, and installing these utilities will be covered later in this guide.

You'll also need to have the `usbserial` and `ftdi_sio` kernel modules loaded before connecting your monome. Ubuntu includes these modules by default, and _should_ load them as soon as it detects your monome being plugged in. If these modules are not available in your kernel, follow your distribution's documentation for configuring, compiling, and installing a custom kernel. The modules should be located somewhere in the USB device section. Manually loading the kernel modules is covered later in this document.

You'll also need JACK installed; it comes mostly preconfigured on Ubuntu. It is assumed that you know how to configure JACK for your own system. jackd2 is recommended, as it offers better support for modern multi-core CPUs, among other [important features.](http://trac.jackaudio.org/wiki/Q_differenc_jack1_jack2 "http://trac.jackaudio.org/wiki/Q_differenc_jack1_jack2")

## 1 Preparing your system: toolchain

Remember, you can always use `synaptic` or the Ubuntu Software Center to install these packages. In the interests of readability, this guide will use console commands. Using the console makes it easier to script some these steps, which greatly speeds up the configuration process every time you want to use your monome.

First, you'll need to get your toolchain working, since you'll have to build some software from source code.

`build-essential` provides the compiling tools, while `gcc-multilib` is only necessary if you're using a 64-bit (x86-64) environment. `gcc-multilib` will bring in the necessary packages for compiling 32-bit software (WineASIO). If `gcc-multilib` is not installed on your x86-64 system, the compile will fail because `/usr/include/gnu/stubs-32.h` is missing. 32-bit x86 users only need to install `build-essential`.

## 2 Preparing your system: serialosc

The first things to build are `libmonome` and `serialosc`, so you need to install their dependencies.

	$ sudo apt-get install git libconfuse-dev liblo-dev libudev-dev libavahi-compat-libdnssd1 libavahi-compat-libdnssd-dev

There are no released tarballs of `libmonome` or `serialosc` yet, so you'll have to checkout their source code from git. This is much easier than it sounds!

	$ mkdir git
	$ cd git
	$ git clone https://github.com/monome/libmonome.git
	$ git clone https://github.com/monome/serialosc.git

Build `libmonome` first:

	$ cd libmonome
	$ ./waf configure
	$ ./waf
	$ sudo ./waf install

Now build `serialosc`:

	$ cd ../serialosc
	$ ./waf configure
	$ ./waf
	$ sudo ./waf install

Next, plug in your monome and run `serialosc` from a terminal. You should see something like this:

	$ serialosc
	serialosc [m128-000]: connected, server running on port 18872

Unplug your monome so that it saves its current configuration to `~/.config/serialosc/`, including port number. Press `Ctrl-C` to stop `serialosc`.

Now restart `serialosc`, then plug and unplug your monome to get your config saved. If you need to change any aspect of your monome, such as its rotation in 90-degree increments, edit `~/.config/serialosc/<your_monome_id>.conf`. You can also set the application prefix, host, and port numbers.



## 3 Install and configure Wine and WineASIO

Now you need to install the latest version of Wine and its development libraries. You need at least Wine 1.3.2 Add the KXStudio PPA, which has the latest version, optimized for realtime audio work:

	$ sudo add-apt-repository ppa:kxstudio-team/ppa

Now install wine and its development libraries:

	$ sudo apt-get install wine1.3 wine1.3-dev

You'll also need the jack2 development libraries:

	$ sudo apt-get install libjack-jackd2-dev

Now that Wine and JACK are installed, it's time to install the Steinberg ASIO SDK, which provides some code needed to compile WineASIO.

First, you'll need to [register](http://www.steinberg.net/nc/en/company/developer/sdk_download_portal/create_3rd_party_developer_account.html "http://www.steinberg.net/nc/en/company/developer/sdk_download_portal/create_3rd_party_developer_account.html") a [developer account](http://www.steinberg.net/en/company/developer.html "http://www.steinberg.net/en/company/developer.html") on Steinberg's website to get the ASIO `asiosdk-2.2` download. Registration is free; you'll be sent an email with the download details.

Next, download the latest version of [wineasio](http://sourceforge.net/projects/wineasio/ "http://sourceforge.net/projects/wineasio/"). As of April 2011, it's [version 0.9.0](http://sourceforge.net/projects/wineasio/files/wineasio-0.9.0.tar.gz/download "http://sourceforge.net/projects/wineasio/files/wineasio-0.9.0.tar.gz/download").

Unpack both archives:

	$ tar xzvf wineasio-0.9.0.tar.gz
	$ unzip asiosdk2.2.zip

Copy the ASIO header file into the WineASIO source directory:

	$ cd wineasio
	$ cp ../ASIOSDK2/common/asio.h .

Compile and install WineASIO:

	$ make
	$ sudo make install

Next, configure Wine to use the WineASIO library you just installed:

	$ regsvr32 wineasio.dll

Now you need to configure Wine:

	$ winecfg

In the window that pops up, verify that Wine is set to Windows XP mode, in the “Windows Version” area of the **Applications** tab. Next, go to the **Audio** tab. Make sure that _only_ the ALSA driver is selected! _Do not_ select JACK; the WineASIO driver will connect via ALSA. Check that the “Default Sample Rate” matches your JACK settings (in `qjackctl`). If your sound card's native sample rate is 48000, you need to adjust the `winecfg` dropdown to 48000 rather than the default 44100.

Switch to the **Graphics** tab, and make sure that “Emulate a virtual desktop” is turned **off**. This is important; otherwise you won't be able to drag-and-drop files from your Linux desktop to Max/MSP applications such as [mlr](/docs/mlr).

At this point, go ahead and configure JACK by launching `qjackctl`. Make sure you have a stable low-latency system now. WineASIO works best when you've already got a low-latency environment properly setup.



## 4 Install Max/MSP

Now that WineASIO and JACK are installed and configured, you need to install Max/MSP. [Download](http://cycling74.com/downloads/ "http://cycling74.com/downloads/") the latest Max5 runtime from Cycling74 The most recent Windows version is [5.1.8](http://www.filepivot.com/projects/maxmspjitter/files/Max5Runtime_45300.zip "http://www.filepivot.com/projects/maxmspjitter/files/Max5Runtime_45300.zip"). You _don't_ need to purchase the full version of Max5 The runtime (on the right side of the download page) works just fine. You only need to purchase the full version if you intend to write your own Max/MSP applications.

Unpack the runtime and install it with Wine:

	$ unzip Max5Runtime_45300.zip
	$ msiexec /i Max5_RT.msi

Click through the Max5 installer; by default, it will be installed to `~/.wine/drive_c/Program\ Files/Cycling\ \'74/Max\ Runtime\ 5.0/MaxRT.exe`.

At this point, you might want to create a small launcher script to avoid having to type out that long command in a terminal every time you want to start Max:

	$ sudo nano -w /usr/local/bin/max5.sh

(Put the following text inside of it)

`wine ~/.wine/drive_c/Program\ Files/Cycling\ \'74/Max\ Runtime\ 5.0/MaxRT.exe`

Make the file executable:

	$ sudo chmod +x /usr/local/bin/max5.sh

You can now start Max/MSP just by typing `max5.sh` on the commandline. You can also use the program menu. Wine automatically adds a menu entry for each program you install, so it should already be present in your menu. Navigate to:

**Menu** → **Wine** → **Programs** → **Cycling '74** → **Max Runtime 5.1.8** → **Max Runtime 5.1**

Start Max using your script or the program menu, and enjoy the popup. The monome applications, called _patches_, will be launched from within Max, by choosing **File → Open**.

Go ahead and download some monome patches. Check the [application list](http://docs.monome.org/doku.php?id=app "http://docs.monome.org/doku.php?id=app") to see what's available.

Before you can use them, you'll need to replace the `serialosc.maxpat` file each one ships with a [specially modified version](https://github.com/nightmorph/monome/raw/master/serialosc.maxpat "https://github.com/nightmorph/monome/raw/master/serialosc.maxpat"). This is because the version shipped with each monome patch relies on Bonjour (for Windows/Mac) to dynamically discover monome devices, which conflicts with the already-running Avahi service. Wine doesn't run Bonjour correctly; it will never connect to `serialosc`.

This modified `serialosc.maxpat` instead sets static ports, so that Bonjour doesn't have to run in the background. You'll need to edit this file in a few places so that **your ports** are used, based on your `~/.config/serialosc/` config file.

[Download](https://github.com/nightmorph/monome/raw/master/serialosc.maxpat "https://github.com/nightmorph/monome/raw/master/serialosc.maxpat") the [modified file](https://github.com/nightmorph/monome/raw/master/serialosc.maxpat "https://github.com/nightmorph/monome/raw/master/serialosc.maxpat") and edit it for your server and application ports; check the [instructions](https://github.com/nightmorph/monome/blob/master/README "https://github.com/nightmorph/monome/blob/master/README") on github. Copy the file into each monome patch folder that you intend to use.


## 5 Install Bonjour and the Max zeroconf objects

Even though you're using static ports for your monome, not the dynamic ports set and discovered by Bonjour, you still have to install Bonjour for Windows so that Max works correctly.

First, download the [Bonjour services](http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe "http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe") and install them with Wine:

	$ wine BonjourPSSetup.exe

You don't have to install the “Apple Updater” component; it won't work on Linux anyway.

Next, download the [MS Visual C++ runtime library](http://www.microsoft.com/downloads/en/details.aspx?FamilyID=9b2da534-3e03-4391-8a4d-074b9f2bc1bf&displaylang=en&pf=true "http://www.microsoft.com/downloads/en/details.aspx?FamilyID=9b2da534-3e03-4391-8a4d-074b9f2bc1bf&displaylang=en&pf=true") that the Max5 zeroconf objects need. Install it by running `wine vcredist_x86.exe`.

Download the [Max zeroconf objects](https://github.com/cassiel/zeroconf/blob/master/dist/win32/zeroconf_20110226_win32.zip "https://github.com/cassiel/zeroconf/blob/master/dist/win32/zeroconf_20110226_win32.zip"), unzip them, and copy them into this directory:

`~/.wine/drive_c/Program\ Files/Cycling\ \'74/Max\ Runtime\ 5.0/Cycling\ \'74/max-externals/`


## 6 Connect JACK, start Max, and make music

Start JACK. You can do this by launching `qjackctl` and pressing Start.

Again, make sure you have good settings for low latency, but not so low that JACK is unstable or you get a lot of “xruns.” You may need to increase your **Periods/Buffer** and **Frames/Period** settings to avoid buffer underruns, which generate xruns that can ruin your recordings or cause dropouts in your audio.

_Note:_ a realtime kernel and proper realtime tweaks can greatly lower your perceived latency, though configuring them is beyond the scope of this guide. Refer to the [Ubuntu Studio Wiki](https://help.ubuntu.com/community/UbuntuStudioPreparation "https://help.ubuntu.com/community/UbuntuStudioPreparation") as a starting point. On a standard Ubuntu kernel (low-latency, not realtime), it's possible achieve a latency of just 8ms to 10ms using an onboard Intel HDA chip. For this kind of generic Intel HDA chip, **Frames/Period** is set to **512**, and **Periods/Sample** is set to **3**. Proper JACK configuration will go a long way toward a smooth experience.

Plug in your monome and load the kernel modules, then verify that they're loaded:

	$ sudo modprobe usbserial ftdi_sio
	$ lsmod

Run `serialosc`. If the Max/MSP app you intend to run has a **Connect** button, you should be able to click it and have it automatically connected to your monome. However, your monome still can't talk to the app, you'll need to manually specify the prefix.

You can do this in `~/.config/serialosc/<your_monome_id>.conf` or by sending an OSC message from the commandline. Check the application's [wiki page](http://docs.monome.org/doku.php?id=app "http://docs.monome.org/doku.php?id=app") to verify its prefix.

Here's an example `serialosc` config file for [polygome](/docs/app:polygome "app:polygome"):

	$ cat ~/.config/serialosc/m128-000.conf
	server {
	  port = 18872
	}
	application {
	  osc_prefix = "/gome"
	  host = "127.0.0.1"
	  port = 8000
	}
	device {
	  rotation = 180
	}

Or, once you've started `serialosc`, you can just open up another terminal and use `oscsend` to change the prefix without having to restart `serialosc`. Another example for `polygome`. Notice that after the hostname (`localhost`) the port number from the saved config file is used:

	$ oscsend localhost 18872 /sys/prefix s gome

Next, start any JACK-aware audio applications: recorders, plugins, software synths, etc. _before_ starting Max/MSP. These need to be running ahead of time so that Max knows what it can connect to. Make sure to properly hook up your devices using JACK; for example, if you started [fluidsynth](http://www.fluidsynth.org/ "http://www.fluidsynth.org/") (or [qsynth](http://qsynth.sourceforge.net/ "http://qsynth.sourceforge.net/")), you'll need to go to the Audio tab of `qjackctl` and connect `fluidsynth` to the system playback device. Otherwise you won't get any sound out of `fluidsynth`! Once your JACK apps are running and connected, start Max using the script created earler:

	$ max5.sh

Open one of the downloaded monome patches using the Max5 **File → Open** dialog.

_Note:_ you might want to store the patches in a folder deep within `~/.wine/drive_c/`. Otherwise you'll have to hit the “Up” arrow quite a bit every time you want to load a patch or file from `/home/`.

Once the patch is loaded, you should be all set. You can drag and drop audio files and samples from your browser if it's an [mlr](/docs/app:mlr "app:mlr")-style patch. If the patch controls a MIDI audio device, be sure to select its JACK-provided title from the dropdown. You'll need to change it from the default **client-qjackctl** to the proper application name using the dropdown. For example, if you started `fluidsynth`, polygome sees it as **Synth input port**.

That's it; your monome should be hooked up and ready to make noise. Go play!

## Optional: monomeserial

While [serialosc](/docs/app:serialosc "app:serialosc") is the way of the future, you can still use older, unported applications with `monomeserial`. When you build and install `libmonome`, `monomeserial` comes with it.

To use it, just run `monomeserial`, specifying the standard data ports, followed by the prefix of the application you intend to run. It's counterintuitive, but the Linux version of `monomeserial` doesn't seem to respond to the “set prefix” button in most applications. Check the app's [wiki page](/docs/setup:app "setup:app") to verify its prefix. Here's an example for [polygome](/docs/app:polygome "app:polygome"):

	$ monomeserial -s 8080 -a 8000 gome

_Note:_ you can use the `-r` switch to change the orientation of your device, in 90 degree increments. Read `man monomeserial` for more information.

Once `monomeserial` is running, proceed with starting your JACK applications, then Max/MSP.

_Important:_ **You cannot run `monomeserial` and `serialosc` at the same time!** Things will break. Nothing will work. You can only run one serial communication router at a time.

## Optional: miscellaneous utilities

Included with libmonome is a program for setting the number of grids on your device, `mk-set-grids`. Normally, this is done just once, when building your monome. However, this can also be useful if half of your monome stops accepting button presses or lighting up LEDs, as has been [known to happen](http://post.monome.org/comments.php?DiscussionID=11315 "http://post.monome.org/comments.php?DiscussionID=11315").

Should this occur, don't panic! You can run the Linux-native `mk-set-grids` utility included with libmonome. **Make sure you aren't running `serialosc` or `monomeserial` when you reset your grids!**

This example is for a 128 (2 grids of 64 buttons), plugged in and showing as `/dev/ttyUSB0`. Be sure to run `ls /dev` to see your device's ID.

	$ mk-set-grids -d /dev/ttyUSB0 -g 2
	successfully set active grids on /dev/ttyUSB0

## Optional: VSTHost

There are many Windows VSTs that _should_ “just work” on Linux, using your DAW's plugin hosting abilities, [dssi-vst](http://breakfastquay.com/dssi-vst/ "http://breakfastquay.com/dssi-vst/"), or similar applications. However, since you're already using Wine to run Max/MSP, you may want to try out a free, lightweight VST host to run inside Wine: [VSTHost](http://www.hermannseib.com/english/vsthost.htm "http://www.hermannseib.com/english/vsthost.htm"). Download the x86 version, unzip it, and move all the files to their own folder for safekeeping. You can run it with `wine vsthost.exe` – thanks to the magic of JACK and WineASIO, you should be able to connect your instruments to your favorite VSTs.


## Gentoo Linux instructions

Until this document is rewritten, this is a brief addendum for Gentoo Linux users.

* Add the [overnight](http://github.com/nightmorph/overnight "http://github.com/nightmorph/overnight") overlay.

* Build and install the required monome applications with Portage:

	# echo media-libs/libmonome >> /etc/portage/package.accept_keywords
	# echo net-misc/serialosc >> /etc/portage/package.accept_keywords
	# emerge -av serialosc

* Continue with the guide, substituting the Debian package names with their equivalents in Portage.

Also available in the overlay is media-sound/[rove](/docs/app:rove "app:rove"), a Linux-native mlr-style sample cutter.

You may get a permissions error when running serialosc:

	$ serialosc
	libmonome: could not open monome device: Permission denied`

Just add your user to the `uucp` group, so that they can use serial devices:

	# gpasswd -a yourregularuser uucp

(EDIT: on recent versions of Ubuntu i believe the relevant group is called “dialout”.)

Then log out, and log back in as your regular user.