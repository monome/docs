---
layout: default
nav_exclude: true
permalink: /aleph/dev/tutorial/
---

# Aleph: DSP Dev Tutorial

In the main [DSP Dev Guide](/docs/aleph/dev/dsp) the structure of an Aleph DSP module is outlined and described. For those without a great deal of experience in C or with DSP processes this tutorial will demonstrate a number of simple tasks.

Combining these techniques with novel DSP code you should be well on the way to building your own Aleph modules.

## Add a Master Volume Control

For those with experience in C and DSP coding you can likely jump straight into modifying and building your own modules directly. Here is a number of very simple examples demonstrating how one would go about adding some specific functionality. We start by adding a master volume control to `modules/mix` to demonstrate some simple DSP code and provide a brief checklist when adding parameters to your module.

To start, make a copy of `modules/mix` which we will edit with our added features. You can rename the module if you desire though be aware you'll have to update any instances of `mix` throughout with your new name (including filenames and in the Makefile). Start with the audio processing itself and work backward to parameter creation from there. Of course you can approach this is the inverse way if that better suits your style.

### mix.c :: module_process_frame()

After all the audio inputs are scaled and accumulated, but before we send `outBus` to the physical outputs, we’ll add our scaler for the master volume. Used a 32×32 multiply to implement `outBus * master volume`:

`outBus = mult_fr1x32x32(outBus, masterVol);`

Notice the use of `mult_fr1x32x32()`, a blackfin intrinsic to make certain the command is as clear as possible to the compiler so there is no question as to what kind of input values to expect.

The code simply multiplies the output by a variable, `masterVol`, then passes the output back to the `outBus` variable.

### mix.c :: Declare Variables

The `masterVol` variable represents the volume level to be implemented onto the output bus. as `outBus` is already a fract32 value (between -1 and 1) we’ll make `masterVol` another fract32 though we’ll restrict the range from 0 to +1 to scale evenly from silence to full volume.

In order to change the `masterVol` variable we first need to declare it globally under static variables as it’s a single fract32 and takes very little memory. Place this with the other input values which should be around line75.

`static fract32 masterVol = 0;`

This creates a static variable in the fract32 format with the name `masterVol` and initializes it to a value of 0.

### Add a Parameter

Add a parameter so that we can control master volume from bees (or your avr32 app). there are a number of steps to register a new parameter so be sequential and methodical so as to avoid a step.

#### mix.c // void module_init()

Add the `param_setup()` function for your new parameter, let’s call it `master`, and set the initial level to max volume so it passes audio when first loading the module.

`param_setup(eParam_master, PARAM_AMP_MAX );`

Note that `PARAM_AMP_MAX` is equal to 0x7fffffff, as defined at the top of `params.h`, which is equivalent to a value of ‘1’ in fract32 format.

#### params.h

Add the `eParam` name into `params.h` with:

`eParam_master,`

Inside of `enum params {}`.

#### params.c

Now copy the first `strcpy` block in `fill_param_desc()` and paste it at the top of the function. The best approach is to copy a param descriptor from a similar type of parameter, so `adc0` will do fine as it has the Amp parameter type, like our master volume will also.

After editing the block should look like this:

~~~
strcpy(desc[eParam_master].label, "masterVol");
desc[eParam_master].type = eParamTypeAmp;
desc[eParam_master].min = 0x00000000;
desc[eParam_master].max = PARAM_AMP_MAX;
desc[eParam_master].radix = 16;
~~~

Note we set the label in Bees to be *masterVol* for clarity. The min, max & radix values are all the same as the adc amplitude scalers. You could change the minimum to 0x80000000 (-1 in fract32) to allow a full sweep through to negative multiplication which will invert the signal.

### mix.c :: module_set_param()

We’ve now registered our parameter in all the appropriate places so now any newly received parameter change will affect the `masterVol` variable.

Add a new case into the switch statement referring to `eParam_master`, and pass the received parameter v into the `masterVol` variable like so:

~~~
  // master attenuation value
case eParam_master :
  masterVol = v;
  break;
~~~

This block is passed the value `v` whenever the input is addressed to `eParam_master` from the avr32. It then passes the received variable into the `masterVol` variable. The impact of this change will occur at the next audio sample when the master volume is calculated again.

Save your work and run make deploy to compile your new module. Copy the `mix.ldr` and `mix.dsc` files onto your SD card (into the /mod folder), eject and place in your Aleph to boot. You should now see `mix` in the MODULES page.

Load the module, attach an audio source to an input and turn up input and output stages. you should now be able to change the `adc0` and `masterVol` parameters and observe them affecting the volume of the output.

## Using a DSP Class: Smoothing masterVol

After implementing the `masterVol` above you might notice tiny clicks or discontinuities when changing the volume very quickly. To prevent this, and to create smooth volume changes, we can implement a slew time on changes to the `masterVol` param. We'll use an included DSP class from the `aleph/dsp` folder called `filter_1p`.

`filter_1p` is a simple integrator, which has the same effect as a 1pole lowpass filter when run at audio rate. It functions by comparing a destination value to the current value and shifts toward that value at a given rate. That rate is our filter coefficient which is similar to a frequency cutoff, but more accurately represents a time-constant. The important thing to note is that the coefficient sets the amount of time for the input to converge to the destination.

To see how it works, study the file: `aleph/dsp/filter_1p.c`

### mix.c :: #include

Before we can use a DSP class we need to #include it in our source so that the compiler knows where to find the code. At the top of `mix.c` you'll see a section called `– dsp class headers` where you can add references to any of the files in the /dsp folder. In our case the `filter_1p.h` will already be listed because `module/mix` is already using it. To use other classes you would add them here as well.

### mix.c :: Static Variables

Each `filter_1p` is referred to by a struct which is essentially a bundle of variables with a named memory address. We need to declare this struct in the appropriate section. It should look something like:

`static filter_1p_lo masterSlew;`

Notice we've named our struct `masterSlew` which is how we'll refer to it henceforth.

### mix.c :: void module_init()

After declaring the struct we need to initialize the new `filter_1p` to give it a defined state. we do this in `module_init()` inside the external functions section. If you look at aleph/dsp/filter_1p.h you'll find the following init function:

~~~
// initialize
extern void filter_1p_lo_init(filter_1p_lo* f, fract32 in);
~~~

`extern void` describes a function that can be called from elsewhere in your program, the function is called `filter_1p_lo_init` and it expects a pointer called `f` and an initial state called `in`. This is mostly overkill though - all we need to know is to call the `init` function, refer to it by name `masterSlew`, and set it an initial value `0`. Add the following to around line130 in mix.c:

~~~
filter_1p_lo_init( &(masterSlew), 0 );
mix.c // module_process_frame()
~~~

Now that we've setup our `filter_1p` we need to implement it into our audio sample process. Copy the approach of the `adcSlew` updates which simply tells the `filter_1p` to calculate a new value and move a step closer to the destination value. Add the following line:

`masterVol = filter_1p_next( &(masterSlew) );`

Here we're passing the output of the `filter_1p` into the `masterVol` variable. While this completes the changes to the frame process, we've put the cart ahead of the horse...

### mix.c :: module_set_param()

To complete the transition to a slewed `masterVol` control we need to change the action that occurs when a `masterVol` parameter is received. Our existing code states:

~~~
case eParam_masterVol :
  masterVol = v;
  break;
~~~

This sends the received param, `v`, directly into the `masterVol` variable. To slew this input value, apply the received value `v` to the input of `masterSlew`, setting a new destination value. Looking at `filter_1p.h` again we find:

~~~
// set input value
extern void filter_1p_lo_in(filter_1p_lo* f, fract32 val);
~~~

Change the `case eParam_masterVol` to the following:

`filter_1p_lo_in( &(masterSlew), v );`

### Add a Slew Parameter

The above has implemented a `filter_1p` to slew the input values for the `masterVol` control. what it hasn't done is create a new parameter to control the rate at which this slew occurs. The process is almost identical to that for adding the `masterVol` control from the previous section, so try and add this new param yourself. You'll need to:

- Add a `param_setup()` entry for `masterSlew` in `module_init()`. use the constant `PARAM_SLEW_DEFAULT`.
- Add a new case to `module_set_param()` for `eParam_masterSlew`.
- In params.h add a reference to `eParam_masterSlew`.
- In params.c add a parameter descriptor similar to that of `adcSlew0`.

### Makefile :: Refer to filter_1p

Finally whenever you use a new dsp class structure you'll need to add a reference to the Makefile so the compiler can find the appropriate files. around line13 you'll find:

~~~
# add sources from here/audio library.
module_obj = mix.o \
  $(audio)/filter_1p.o \
~~~

`filter_1p` is already included, but the process is the same for additional classes that you use in your programs.

Compile your code again and copy to the SD card and you should be up and running with a variably smoothed response on the master volume control.
