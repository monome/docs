---
---

# norns update

be sure to `SYNC` backup any scripts/audio you've added to norns. they should be preserved, but backup just in case of trouble.

_note: if you're actively developing the norns codebase be sure to push any changes you've made as the ~/norns folder will be deleted and replaced_.

## procedure

- download newest update file from [monome/norns](https://github.com/monome/norns/releases). it will have a filename like `norns180603.tgz` where `180603` is the date/version.
- copy this file to the root folder of a FAT-formatted USB thumbdrive.
- insert the thumbdrive into norns and boot up.
- in the menu, go to `SYSTEM > UPDATE`.
- the file is now being copied and prepared.
- you'll be asked to reboot. use SLEEP.
- on next boot the update will install, then the device will shut down.
- start the machine.

## confirming

see `SYSTEM` menu for a version number.

## alternate method

if the disk method isn't working or you need to re-run the update follow these instructions.

- plug in wifi, enable hotspot, connect to norns with laptop
- use [sftp](https://monome.org/docs/norns/sftp/) to transfer the update file (ie `norns181023.tgz`) to the folder:

```
/home/we/update/
```
- while connected to hotspot, open a command line (terminal) and type:

```
ssh we@172.24.1.1
```
- the password is `sleep`
- then type:
```
norns/stop.sh
cd update
ls *.tgz
```
- you should see something like:
```
norns181023.tgz
```
- proceed to type:
```
tar xzvf norns181023.tgz
tar xzvf 181023.tgz
cd 181023
./update.sh
```
- note that the version numbers will be different for your specific update.
- once complete:
```
sudo shutdown now
```
- everything will disconnect. power up again to check it worked.
