---
layout: default
title: raspbian
nav_exclude: true
redirect_from: /raspbian/
permalink: /serialosc/raspbian/
---

# raspbian

## precompiled packages

monome software packages from the [ubuntu ppa](https://launchpad.net/~artfwo/+archive/ubuntu/monome) work great on raspbian. to install them on raspbian stretch, add the repository signing key first:

```
gpg --keyserver keyserver.ubuntu.com --recv DD9300F1
gpg --export --armor DD9300F1 | sudo apt-key add -
```

then add the repository url to your sources.list:

```
echo "deb http://ppa.launchpad.net/artfwo/monome/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/monome.list
```

finally run:

```
sudo apt update
sudo apt install serialosc
```

the package is configured to start serialosc automatically on boot and save the grid state under `/var/lib/serialosc`. to disable this behaviour, simply run:

```
sudo systemctl disable serialosc.service
```

## compiling from source

while this build script is specific to raspbian stretch (for the raspberry pi), there's a good change it'll work with other embedded linux distributions and devices.

this script will install `libmonome` and `serialosc`. these are essential for communicating with grids and arcs on linux.

```
sudo apt-get install liblo-dev
git clone https://github.com/monome/libmonome.git
cd libmonome
./waf configure
./waf
sudo ./waf install
cd ..

sudo apt-get install libudev-dev libavahi-compat-libdnssd-dev
git clone https://github.com/monome/serialosc.git
cd serialosc
git submodule init && git submodule update
./waf configure
./waf
sudo ./waf install
cd ..
```

to run serialosc, execute `serialoscd`.

(todo: startup scripts for autolaunching serialosc)

to get started running and creating applications, check out the [grid studies](https://monome.org/docs/grid/studies/), particular the ones on [pd](https://monome.org/docs/grid/studies/pd/) and [python](https://monome.org/docs/grid/studies/python/).
