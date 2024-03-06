---
layout: default
title: source
nav_exclude: true
---

## compiling from source

```
sudo apt-get install liblo-dev libudev-dev
git clone https://github.com/monome/libmonome.git
cd libmonome
./waf configure
./waf
sudo ./waf install
cd ..

sudo apt-get install libavahi-compat-libdnssd-dev libuv1-dev
git clone https://github.com/monome/serialosc.git --recursive
cd serialosc
./waf configure
./waf
sudo ./waf install
cd ..
```

To run serialosc, execute `serialoscd`.
