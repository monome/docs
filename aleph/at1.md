---
layout: default
nav_exclude: true
permalink: /aleph/tutorial-1/
---

# Aleph Tutorial 1

## Making a Scene

After Tutorial 0 you may well think ‘this is cool, but i want to <insert cool thing here>’, and that is totally expected and encouraged! This tutorial is aimed to help you build your own network of operators and connect them to a dsp MODULE to do interesting things.

Firstly, it’s probably a good idea to point out that bees is being constantly improved, and it’s good to check you’ve got the most up-to-date version once in a while. Go to the aleph updates page and you’ll see a link to the aleph github with the newest known-working version of bees & all official modules. Instructions for updating are included at that location. The whole process shouldn't take more than 5 minutes.

### Connections

Before getting started with building a scene, make sure you have a sound source (eg. Guitar, ipod, synthesizer) attached to input 1, and your headphones / speakers attached to outputs 1 & 2, or the headphone output.

Turn up the INPUT 1 gain until a little pink shows through the white LED level indicator, while sending audio to the INPUT.

### A Blank Slate

The initial step in creating any scene is to clear the current state.

- *In EDIT mode, navigate to the SCENES page, press SW2 twice to 'CLEAR'.*

This will remove all current operators and unload the current MODULE. Now you can load the delay line MODULE 'lines':

- *Navigate to the MODULES page, select aleph-lines.ldr and LOAD with SW0 twice.*

You might hear a short burst of noise, and then the aleph will display ‘finished loading’ and you’re ready to build a new scene with [aleph:modules:lines].

Every MODULE has a multitude of potential uses and as such you can build many different scenes with the same MODULE. This tutorial will show a number of different, simple use cases for lines that you can expand upon yourself.

### Making a Connection

Navigate to the INPUTS page and scroll upward to see all the MODULE PARAMs. All PARAMS are listed in lower case, while all bees OPERATORS are in UPPER case. You can change these PARAMS directly via the INPUT page, or through a control network from PLAY mode.

Let's start by using ENCoder0 to control the volume of our audio input to the left main output (output 1). To do so, we need to send the ENC’s value to the appropriate PARAM in lines.

- *Navigate to OUTPUTS page.*
- *Select 000.ENC/VAL. (it may already be selected)*
- *Using ENC3, scroll upward to find the PARAM 039.adc0_dac0.*
- *Press CONN, or ‘connect’ (SW2) twice.*

Now you’ve made your first connection in a very simple network! All connections in bees are made by connecting from OUTPUTs, and sending those values to the INPUTs or to PARAMETERS of a MODULE. The OUTPUTs page is where you make all connections in a bees network, by first selecting the desired source with ENC0, then setting the desired destination with ENC3. Finally, to confirm a connection you need press SW2 twice which executes the connection.

Try out your new connection:

- *Press MODE to enter PLAY mode.*
- *Press SW0 and observe the decibel volume changes on the screen.*

There is a problem with this network though- ENC0 is capable of such fine changes that it takes a few dozen turns to get the volume up to 0dB (full volume). To fix this, we can change the behaviour of ENC0 to send much larger increments as it turns, which will feel more responsive:

- *Enter EDIT mode.*
- *Navigate to the INPUTS page with ENC2.*
- *Scroll to 000.ENC/STEP.*
- *Set the value to about 200.*

Now in PLAY mode, turning ENC0 will sweep the volume of input 1 to output 1, from minimum (-inf dB) to maximum (0dB).

All PARAMs have a scaling method to convert from bees signed 16bit numbers (-32768 to 32767), into more user friendly values like decibels (volume), milliseconds (time), or hertz (frequency).

*See: [Parameter Scaling](../param-scaling) for more detail.*

### Adding an Operator to the Network

Now that ENC0 is acting as a volume control for the audio, it will only control the volume of output 1. This is because all ins and outs are processed separately so you can run 4 totally independent mixes if you desire. For our purposes though, let’s say we want input 1 to be echoed to both outputs 1 & 2 and have the volume control affect them both.

To do so we’ll use a SPLIT (aka. 'Y') operator which lets us send the same value to more than one destination. We’ll split the ENC0 signal, and control two separate MODULE PARAMs.

To make an OPERATOR:

- *Navigate to the OPERATORS page.*
- *Turn ENC3 to scroll through the list of available OPs (they appear in the top-left of screen).*
- *Select +SPLIT.*
- *Press SW2 twice to create the OP.*

You should now see 012.Y appear at the bottom of your OP list which means it has been successfully created. 'Y' is a short name for 'SPLIT'. Now we can include it in our network:

- *Navigate to OUTPUTS.*
- *Change the routing of 000.ENC/VAL to 012.Y/X (using ENC3) and connect (SW2 - twice).*
- *Scroll down the list to find 012.Y with ENC0.*
- *Route 012.Y/A to 039.adc0_dac0.*
- *Route 012.Y/B to 040.adc0_dac1.*

Now in PLAY mode, you should have ENC0 controlling the volume from input 1 to OUTPUTs 1 and 2.

### Saving your Scene

After building this basic SCENE, you can save it to the SD card with a filename of your choice. On the SCENES page you need to provide the name of your SCENE and then STORE it on the card:

- *Navigate to the SCENES page.*
- *Scroll through available characters with ENC3.*
- *Choose which character in the name with ENC1.*
- *Enter the name ‘m2s’ (for mono to stereo).*
- *Press SW0 twice to ‘STORE’.*

Bees will say it’s writing the scene, then tell you it has finished. Now your scene is saved onto the SD card.

### Summary

**To make a connection**

- *Use the OUTPUTS page to make all connections*
- *Select source with ENC0.*
- *Choose destination with ENC3.*
- *Execute a connection by pressing SW2 twice.*

**To make an operator**

- *Use the OPERATORS page to make an OP.*
- *Select your desired OP with ENC3.*
- *Create the OP by pressing SW2 twice.*

### Further Explorations

To practice making connections in the network try this example:

*Use ENC1 to control the sensitivity of ENC0:*

- *(INPUTS) set 001.ENC/MIN to 1.*
- *Set 001.ENC/MAX to 500.*
- *(OUTPUTS) attach 001.ENC/VAL to 000.ENC/STEP.*

Try changing ENC1 then turning ENC0 to hear how you can move from incredibly fine steps of change, to large and quick motions

### Next Steps

[Tutorial 0: Getting Started with Bees](../tutorial-0)

Tutorial 1: Making a Network

[Tutorial 2: A Simple Synthesizer &rarr;](../tutorial-2)
