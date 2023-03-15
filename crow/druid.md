---
layout: default
parent: crow
title: druid
nav_order: 2
permalink: /crow/druid/
has_children: no
---

# druid
{: .no_toc }

![](../images/druid-start.png)

To communicate with crow we'll use `druid`, a command-line tool that lets you send and receive text, as well as run and upload scripts.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## preparation

First we'll collect and install a few tools, starting with `Python` which is the environment that runs `druid`. Don't worry, you don't ever have to type any Python code into `druid`.

`druid` requires Python 3.6+, but let's get the most recent version (3.11 as of this writing, March 2023):

- macOS: [download from the Python website](https://www.python.org/downloads/)
- Windows: search `Python 3.11` in the Microsoft Store (it's free)
	- the Microsoft Store is the most straightforward way to install Python on Windows, but if you choose to install from the Python website directly then please follow [these instructions](https://docs.google.com/document/d/11Bnly-JOBh4_mWSyIGmEIpE_YO-6VH179KSHEWTZr2M/edit)
- Linux: in a terminal run `sudo apt-get install python3 python3-pip` or equivalent

Now load up a terminal so we can check Python is installed and get the next pieces:

- macOS: Open `terminal`
- Windows: Use `PowerShell` and open by right-clicking and `Run as administrator`
- Linux: Your choice! `gnome-terminal` is likely your default

Check if Python is installed and working:

```bash
python3 -V
```

Which should print `Python 3.11` or something similar. If this doesn't work for you, try removing the `3` and just run `python -V`.

Now it's time to install `druid`!

## install druid

### install druid on macOS + Linux

In a terminal, execute:

```bash
pip3 install monome-druid
```

NB: If you see an error like "ERROR: Could not install packages due to an EnvironmentError...", try running the command with `sudo` to gain the required privileges:

```bash
# you'll be asked to enter your password after typing this:
sudo pip3 install monome-druid
```

*Close and reopen your terminal*, then run `druid` to start scripting.

### update

To update when there's a new [release](https://github.com/monome/druid/releases), use

```bash
pip3 install --upgrade monome-druid
```

NB: If you see an error like "The script druid is installed in '/Users/your/Library/Python/3.8/bin' which is not on PATH...", you can open up `~/.zshrc` and add this line: `export PATH="$PATH:/$HOME/Library/Python/3.8/bin"`. Note macOS switched from bash to zsh with 10.15 (Catalina.) If you on on a previous version of macOS, you will probably have to add this line to your `~/.bash_rc` instead.

### install druid on Windows

In PowerShell, execute:

```powershell
python -m pip install pyserial asyncio prompt_toolkit
```

Then:

```powershell
python -m pip install --upgrade setuptools
```

Finally:

```powershell
python -m pip install monome-druid
```

To update when there's a new [release](https://github.com/monome/druid/releases), use

```powershell
python -m pip install --upgrade monome-druid
```

#### Windows errors

After the installation is complete, you may see a message like this one:

>WARNING: The script druid.exe is installed in 'C:\Users\USERNAME\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0\LocalCache\local-packages\Python38\Scripts' which is not on PATH.

If you do, copy the entire path listed (the stuff between the `'`s), open your Start menu, search "path" and select "Edit the system environment variables".

On the dialogue that appears, click the Environment Variables button. In the "User variables for USERNAME" dialogue box, select Path and click Edit. On the next dialogue, click the New button, and paste in the path you copied earlier.

Click OK until all the dialogue boxes are gone.

On Windows 7, druid may be unable to connect with crow. Try using Zadig (instructions [here](/docs/crow/manual-update/#windows)) to install the "USB Serial (CDC)" driver instead of the "WinUSB" driver.

## running druid

With crow connected to your device with USB and your modular case turned on, execute:

```bash
druid
```

You should see druid open with the following message up top:

```
//// druid. q to quit. h for help

<crow connected>
```

If you see `<crow disconnected>` instead, make sure your modular case with crow is turned on, and the USB cable is connected. If everything is connected but still not connecting, close your Terminal application and restart it.

If `druid` responds with `can't open serial port` you probably don't have the required permissions to open the device. See below.

### Permissions

If `druid` says `can't open serial port` you probably don't have the required permissions to open the device. To remedy this add yourself to the correct group, which can be determined by running (on Linux):

```bash
ls -l /dev/ttyACM0
crw-rw---- 1 root dialout 166, 0 Oct  9 20:28 /dev/ttyACM0
#                  ^ the group
```

In this case the group is called `dialout` but it's sometimes also called `uucp`.

To add yourself to the `dialout` group run

```bash
sudo gpasswd -a <your username> <the group name found above>
```

After this logout and login again or simply restart.

## advanced

### websockets

It's possible to send lines of text to druid (which are forwarded to crow) using websockets. Druid listens on port `6666`.

This allows you to execute crow commands from outside of druid, for example within your text editor.

Though other scriptable editors should be able to send data to a websocket, we'll explore `vim` as an example.

In `vim` here's how to bind the keystroke `CTRL-\` which executes the current line:

```
map <C-\> :silent .w !websocat ws://localhost:6666 -1<CR>
```

And here's how to bind the keystroke `F5` to execute all highlighted lines as one block, enabling e.g. function definitions:

```
vmap <F5> :w<Home>silent <End> !sed -e '1i\```' -e '$a\```' <bar> websocat ws://localhost:6666<CR>
```

Copy either or both of the lines above to your `.vimrc` to make it permanent. This command requires [websocat](https://github.com/vi/websocat).