---
layout: default
title: source
nav_exclude: true
---

## compiling from source

```
sudo apt-get install liblo-dev
git clone https://github.com/monome/libmonome.git
cd libmonome
./waf configure
./waf
sudo ./waf install
cd ..

sudo apt-get install libudev-dev libavahi-compat-libdnssd-dev libuv1-dev
git clone https://github.com/monome/serialosc.git
cd serialosc
git submodule init && git submodule update
./waf configure --enable-system-libuv
./waf
sudo ./waf install
cd ..
```

to run serialosc, execute `serialoscd`.

