---
layout: default
nav_exclude: true
permalink: /aleph/dev/dsp/
---

# Aleph: DSP Dev Guide

## The Hardware

- AD 'Blackfin' BF533: DSP processor where all audio & cv output processing occurs
- Atmel AVR32: Controller where all UI elements, external device connection & cv input is processed.

The DSP runs at 500Mhz with 16b/32b fixed-point arithmetic and 24b fixed-point audio I/O. by default, the sampleratae is 48k but the hardware allows up to 192k. each audio frame is processed one sample at a time for minimal latency. The chip has 64kB of on board SRAM memory that can be accessed at run time, plus an additional 64MB of SDRAM with slower access but enough space for large audio buffers.

## Git Project

The Aleph source can be downloaded from [github.com/monome/aleph.git](https://github.com/monome/aleph.git)

~~~
cd ~ (to install in your user directory)
git clone https://github.com/monome/aleph.git
~~~

For more information on forking the repository to track your changes independently see [Forking](/docs/aleph/forking. If you plan on contributing to the project you will need to follow these steps.

## Toolchain & Source Files

*These instructions are based on a Linux system. Ubuntu was used during development of this tutorial.*

To compile dsp modules you'll need the blackfin-elf-gcc toolchain. General instructions are here: [Blackfin Toolchain Installation](http://blackfin.uclinux.org/doku.php?id=toolchain:installing).

Get the most recent stable release for your architecture (2014R1 gcc-4.3 as of this writing), unpack it and add the binaries to your PATH. The toolchain will be extracted to `./opt/uClinux` by default. Eg:

~~~
cd ~/Downloads
su
tar -xjvf blackfin-toolchain-elf-gcc-4.3-2014R1-RC2.x86_64.tar.bz2
export PATH=$PATH:/opt/uClinux/bfin-elf/bin
~~~

You can now run 'make' from aleph/modules/lines or another module:

~~~
cd ~/aleph/modules/lines
make
~~~

## DSP Source Directories

- aleph/bfin_lib/src: Low-level sources for audio programs. These routines interact with the Blackfin hardware directly and should be changed only with great care to avoid damaging the processor.
- aleph/modules: The module's source for eg. ‘waves’ and ‘lines'
- aleph/dsp: Common audio functions implemented in 32bit fixed-point (envelopes, filters, buffers, oscillators).

## Inside a MODULE eg. aleph/modules/<your_mod>

Follow along with `modules/mix` as it's a simple module with lots of comments specifically intended for describing the basics.

- <your_mod>.lds: Linker script file. No changes are necessary.
- <your_mod>.c: The main source file including audio frame processing and parameter change functions.
- Makefile: Needs to be updated to refer to your module name, and include any additional sources.
- params.c: Parameter descriptor file including reference to parameter scalers.
- params.h: A list of all parameter enums and default variable values.
- version.mk: A simple version control file in the subversion style.
- README

Modules with many parameters will often use an additional file to store parameter set functons called `param_setup.h`. If using this file you need to refer to it in `<your_mod>.c` with `#include param_setup.h`.

## File Structure

### <module_name>.c

#### Header Files

Many standard header files are included. Additional /dsp class library files and additional module files should be included under dsp class headers.

#### typedef struct _<your_mod>Data

Provides memory access to the expanded 64MB SDRAM. Audio buffers and lookup tables should be stored here.

#### Static Variables

Here you need to declare any variables that will be accessed by multiple functions, including any structs in use from dsp classes.

Note the use of the 'fract32' type which is the main type used for audio processing on the blackfin.

#### Static Function Declaration

Declare any custom functions here that are included in your code.

The function definitions themselves come at the end of the file.

Note the standard declaration of `process_cv(void)` which is a function used to iteratively update the cv output in a round-robin; one channel per sample.

### External Functions

All functions that are called from the blackfin hardware, codec and avr32. the following functions are the most common that you will need:

#### module_init(void)

Initialize any DSP classes in use (eg. `filter_1p`). See the appropriate header file in /dsp for a description of that classes init function.

Initialize parameters with `call param_setup` where each parameter is called with `eParam_<param_name>` and pass it a default value.

#### module_process_frame(void)

This function is called every sample at 48kHz directly from the audio codec.

arrays `in[0..3]` and `out[0..3]` refer to the audio I/O hardware of the Aleph.

To improve performance, blackfin fixed-point intrinsics should be used wherever possible in the code. For a list of available intrinsics see: [Blackfin built-in functions](http://blackfin.uclinux.org/doku.php?id=toolchain:built-in_functions).

#### module_set_param(u32 idx, ParamValue v)

A long switch statement which receives parameter changes from the AVR32. These functions are called between audio processing frames and their timing is not guaranteed.

#### Static Function Definitions

Includes any custom functions required by your code. These need to be declared above, before the External Functions. See for eg. `process_cv(void) {}`.

### params.h

Includes user-defined constants that can be called in your code (particularly for `module_init()` in `<your_mod>.c`)

Enumerated parameters are then listed and should match those in `params.c` and `<your_mod>.c`

### params.c

`fill_param_desc()` contains a list of each parameter and it's description.

There are five elements for each parameter:

- label: The name that will be reported to the AVR32 for UI display
- type: Refers to the parameter scaling, used to set the display and refer to a modifying lookup table where appropriate. Options are Bool, Fix, Amp, Integrator, Note and Freq. These are further explained at parameters.
- min & max: Define the limits that the parameter can be set to.
- radix: Sets the display method for the AVR32. Radix is only used for the Fix type parameter, and is the number of bits used to display the integer element of the parameter.

For those wanting to create their own parameter types you'll need to look at `aleph/common/param_common.h`. Read through that file to understand more about the above parameter descriptors.

A final note on the parameter descriptors is that they are not actually blackfin code, and are simply precompiled and loaded into Bees (or similar) in order to know how to display the information to the user.

### Makefile

Include references to any header files that you've used either in the DSP class library, or additional files in your project.

## Compiling your Module

In your module's folder run:

`make deploy`

This will build the appropriate hex file (.ldr) and the parameter descriptor file (.dsc) which can then be loaded onto your SD card and tested in the Aleph.

If you have not changed the parameter list or descriptions, you can simply run:

`make`

This will only rebuild the `.ldr` of your module.

## Roll Your Own

For a brief tutorial on adding parameters, writing the audio loop and using DSP classes see: [Aleph DSP Dev Tutorial](/docs/aleph/dev/tutorial)
