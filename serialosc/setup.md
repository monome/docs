---
layout: default
title: setup
---

## Installing serialosc

### MacOS

To install via homebrew:

- install [homebrew](https://brew.sh) on your Mac (or Linux) computer
- execute `brew install serialosc` to install serialosc
- execute `brew services start serialosc` to start serialosc
- execute `brew services list` to confirm serialosc is running

Successful `brew services list` output looks like:

```
Name        Status    User     File
serialosc   started   <you>   ~/Library/LaunchAgents/homebrew.mxcl.serialosc.plist
```

You can also install directly from the [release download](https://github.com/monome/serialosc/releases/latest) but we generally recommend using homebrew.

### Windows

Download the serialosc [release](https://github.com/monome/serialosc/releases/latest) and run the installer. Be sure to restart your device afterward.

## Linux

- [linux setup guide](/docs/serialosc/linux)
- [compiling from source](/docs/serialosc/source)

