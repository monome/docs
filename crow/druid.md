---
layout: default
parent: crow
title: druid
nav_order: 2
permalink: /crow/druid/
has_children: no
---

# druid

![](../images/druid-start.png)

To communicate with crow we'll use `druid`, a command-line tool that lets you send & receive text, as well as run & upload scripts.

## preparation

First we'll collect & install a few tools, starting with `Python` which is the environment that runs `druid`. Don't worry, you don't ever have to type any Python code into `druid`.

`druid` requires Python 3.5+, but let's get the most recent version (3.8 as of this writing, November 2019):

- macOS: [download from the Python website](https://www.python.org/downloads/)
- Windows: search `Python 3.8` in the Microsoft Store (it's free)
	- the Microsoft Store is the most straightforward way to install Python on Windows, but if you choose to install from the Python website directly then please follow [these instructions](https://docs.google.com/document/d/11Bnly-JOBh4_mWSyIGmEIpE_YO-6VH179KSHEWTZr2M/edit)
- Linux: in a terminal run `sudo apt-get install python3 python3-pip` or equivalent

Now load up a terminal so we can check Python is installed and get the next pieces:

- macOS: Open `terminal`
- Windows: Use `PowerShell` and open by right-clicking and `Run as administrator`
- Linux: Your choice! `gnome-terminal` is likely your default

Check if Python is installed and working:

```
python3 -V
```

Which should print `Python 3.8` or something similar. If this doesn't work for you, try removing the `3` and just run `python -V`.

No luck? Post to the [lines thread](https://llllllll.co/t/crow-help-druid/25864) & we'll figure it out (and update this doc).

Now it's time to install `druid`!

## install druid

### install druid on macOS + Linux

In a terminal, execute:

```
pip3 install monome-druid
```

NB: If you see an error like "ERROR: Could not install packages due to an EnvironmentError...", try running the command with `sudo` to gain the required privileges:

```bash
# you'll be asked to enter your password after typing this:
sudo pip3 install monome-druid
```

Now druid should be ready to use, you might need to close and reopen the terminal to get access to it.

### install druid on Windows

In PowerShell, execute:

```
python -m pip install pyserial asyncio prompt_toolkit
```

Then:

```
pip3 install --upgrade setuptools
```

Finally:

```
pip3 install monome-druid
```

#### Windows errors

After the installation is complete, you may see a message like this one:

>WARNING: The script druid.exe is installed in 'C:\Users\USERNAME\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0\LocalCache\local-packages\Python38\Scripts' which is not on PATH.

If you do, copy the entire path listed (the stuff between the `'`s), open your Start menu, search "path" and select "Edit the system environment variables".

On the dialogue that appears, click the Environment Variables button. In the "User variables for USERNAME" dialogue box, select Path and click Edit. On the next dialogue, click the New button, and paste in the path you copied earlier.

Click OK until all the dialogue boxes are gone.

## loading druid

Let's load up `druid` to test if everything works as expected. With crow connected to your device with USB and your modular case turned on, execute:

```
druid
```

You should see druid open with the following message up top:

```
//// druid. q to quit. h for help

<crow connected>
```

If you see `<crow disconnected>` instead, make sure your modular case with crow is turned on, and the USB cable is connected.

If `druid` responds with `can't open serial port` you probably don't have the required permissions to open the device.

### Permissions

If `druid` says `can't open serial port` you probably don't have the required permissions to open the device. To remedy this add yourself to the correct group, which can be determined by running (on Linux):

```
ls -l /dev/ttyACM0
crw-rw---- 1 root dialout 166, 0 Oct  9 20:28 /dev/ttyACM0
#                  ^ the group
```

In this case the group is called `dialout` but it's sometimes also called `uucp`.

To add yourself to the `dialout` group run

```
sudo gpasswd -a <your username> <the group name found above>
```

After this logout and login again or simply restart.
