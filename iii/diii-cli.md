---
layout: default
title: diii-cli
has_children: false
nav_exclude: true
has_toc: false
---

# diii-cli

`diii` is a command line utility to manage and live-code iii devices. Also available is a [chromium-based version](/docs/iii/diii).

# Setup

Install [uv](https://docs.astral.sh/uv/#installation), a Python project manager.

Using the command line, navigate to the folder where you want to install `diii`:

```
mkdir ~/diii
cd ~/diii
uv venv
source .venv/bin/activate
uv pip install monome-diii
```

## Run

```
cd ~/diii
source .venv/bin/activate
diii
```

A few quick commands:

```
^^r         reboot device
^^b         reboot into bootloader mode
```

To upload a script:

```
u step.lua
```

To re-upload the same script, you can just execute `u`.

All other commands will be passed to the device's Lua environment and any results will be printed.

```
  q to quit. h for help

> x=6

> print(x)
6

> q
```

To quit, execute `q` or CTRL-C.

## Command Line Interface

Sometimes you don't need the repl, but just want to upload/download scripts to/from device. You can do so directly from the command line with the `list`, `upload` and `download` commands.

### List

```
diii list
```

Lists files currently on device.

### Upload

```
diii upload script.lua
```

Uploads the provided lua file `script.lua` to device and stores it in flash.

### Download

```
diii download script.lua
```

Prints the file `script.lua` which is on the device, if it exists. If you'd like to save the file to the local disk, do this:

```
diii download script.lua > script.lua
```

## Source

Based on [druid](https://monome.org/docs/crow/druid/).

Source is at [github.com/monome/diii](https://github.com/monome/diii).
