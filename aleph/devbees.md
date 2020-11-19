---
layout: default
nav_exclude: true
permalink: /aleph/dev/bees/
---

# Aleph: Bees OP Dev Guide

An overview on programming operators for Bees.

## Toolchain setup

### Mac OS X

To build from source see: [droparea's github](https://github.com/droparea/avr32-toolchain)

### Linux

Visit Atmel's [download site](http://www.atmel.com/tools/ATMELAVRTOOLCHAINFORLINUX.aspx) and download/install the following packages. You will need to sign up for an account to download the files:

- Atmel AVR 32-bit Toolchain 3.4.2 - Linux 32-bit (don't get 64bit)
- Atmel AVR 8-bit and 32-bit Toolchain (3.4.2) 6.1.3.1475 - Header Files

### Windows

Download and install AVR Studio from Atmel's site. You will need to sign up for an account to download the files:

- [AVR Studio](http://www.atmel.com/tools/ATMELSTUDIO.aspx)

## Overview

An operator is a control module that can be dynamically created within Bees. It has INPUTS and OUTPUTS that accept and send parameter data, respectively. Bees networks are created by connecting OUTPUTS of operators to other operators' INPUTS. Operators typically transform input somehow. But they can also modify the screen, talk USB, run timers, etc. For the scope of this introduction we'll simply do some math on the inputs. See existing operators for examples of other tasks.

### Github

Note that in order to share your creations with the Aleph community you'll need to clone and fork the Aleph github repo. see [Forking](/docs/aleph/forking) for details.

## op: FADE

Here are the steps to create a new operator. We'll be making an operator to crossfade between two input values.

The goal:

- Three inputs A, B, and X
- One output VAL
- X is 0-128
- When X is 0, VAL is A
- When X equals 128, VAL equals B
- When X equals 64, VAL is a split mix of A and B
- Intermediate values will linearly mix A and B to VAL

### Copy an existing operator as a starting point

From /aleph/apps/bees/

~~~
cp src/ops/op_add.c src/ops/op_fade.c
cp src/ops/op_add.h src/ops/op_fade.h
~~~

### Edit config.mk

Add the following around line 54 (keep alphabetized):

~~~
$(APP_DIR)/src/ops/op_fade.c
~~~

### Edit src/op.c

Add this line to the userOpTypes list (around line 31):

~~~
eOpFade,
~~~

And then add to the op_registry around line 280:

~~~
{
.name = "FADE",
.size = sizeof(op_fade_t),
.init = &op_fade_init,
.deinit = NULL
},
~~~

### Edit src/op.h

Increase the number NUM_USER_OP_TYPES by one (around line 23) Then add your new enum to the END of the list around line 83):

~~~
eOpFade,
~~~

### Edit src/op_derived.h

Add to the header file list:

~~~
#include "ops/op_fade.h"
~~~

### Edit src/op_fade.h

See file. Basically all instances of “add” changed to “fade” Changed internal variables for A, B, X.

### Edit src/op_fade.c

Finally, where the functionality happens. See code for inline comments. Of fundamental importance are the functions op_fade_in_a() etc. This is where something happens when input is received.
