---
layout: default
nav_exclude: true
---

# file share

You can manage projects and delete/rename files via [maiden](../maiden). But sometimes you'll need to copy files between your computer and norns, like audio.

This type of file management is best achieved via samba, a protocol that allows you to directly connect your computer's file browser to norns. If you haven't already, please connect your norns and your computer to the same WIFI network and read on!

## macOS

### connect

Open Finder and hit CMD/Apple-K or navigate to `Go > Connect to Server`.

In the top IP address bar, enter: `smb://norns.local` and click Connect:

![](../image/smb-mac-connect.png)

You may see an "Unsecured Connection" warning, but you can safely ignore it and click Connect.

Login as a Registered User with the following credentials:

- Name: `we`
- Password: `sleep`

...and click Connect one last time!

![](../image/smb-mac-login.png)

Once connected, you can freely navigate through files on norns:

![](../image/smb-mac-tree.png)

## Windows

To use SMB network sharing on Windows 10, navigate to Control Panel > Programs > Programs and Features > Turn Windows features on or off, and turn on the SMB features. 

Reboot.

The norns.local file tree should be available at `\\norns.local`

## file tree

Upon connecting, you'll be in the `dust` folder which contains everything we need. Here's the layout:

```
dust/
  audio/          -- audio files
    tape/             -- tape recordings
    ...
  code/           -- contains scripts and engines
    awake/
    mlr/
    ...
    we/
  data/           -- contains user data created by scripts
    awake/            -- for example, pset data
```

## audio

You can use samba to share audio files between norns and your computer. On norns, these files are stored under `dust/audio` -- depending on which scripts you have installed, you may see many folders under `audio` or just a few.

`tape` is where the TAPE function stores recordings made on your norns.

Feel free to make folders inside `audio` to store various samples, field recordings, single cycle waveforms, etc. Each of those folders can also store subfolders, but please note that you cannot nest more than ten folder layers.

If you are importing audio to norns, please note that 48khz `.wav` files are best.

## backup

If you want to make a backup of your scripts, psets or other data simply make a copy of the `dust` directory found in `/home/we` via samba.

Restoring from this backup is as simple as copying this directory from your computer back to the `/home/we/dust` directory on norns.
