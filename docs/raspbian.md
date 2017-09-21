---
layout: page
permalink: /docs/raspbian/
---

## raspbian

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

to get started running and creating applications, check out the [grid studies](https://monome.org/docs/grid-studies/), particular the ones on [pd](https://monome.org/docs/grid-studies/pd/) and [python](https://monome.org/docs/grid-studies/python/).
