---
layout: default
nav_exclude: true
permalink: /aleph/tutorial-5/
---

# Aleph Tutorial 5

## Presets, Presets, Presets (Part 1)

Presets are an incredibly powerful aspect of the bees system, allowing the storage and recall of values as well as alternate routings between operators. The result of this is a greatly streamlined method to drastically alter a running patch at the push of a button, or receipt of a given message.

We’ll start with some simple uses of the preset system but will show how within a scene there can be multiple layers of preset control that need not conflict unless desired. While it might seem complicated at first, you’re likely to have a ‘eureka!’ moment about half way through this tutorial, at which point it might make sense to re-read the first section.

It’s important to keep in mind that triggering preset recall is executed via a simple network command. Not only does this mean it’s possible to change presets with messages from external devices, but also that the bees can itself trigger presets. We’ll explore this briefly here but there is a huge range of possibilities as a result that you’ll have to explore further on your own.

### Connections

This tutorial will simply use the aleph-waves module so make sure you’re running the most up-to-date bees bundle. Attach your headphones or speakers to outputs 1 & 2.

- *Load a fresh scene by pressing CLEAR (SW2) on the SCENES page.*
- *Load aleph-waves in the MODULES page with SW0.*

### Presets as Defaults

The first and most basic use of the preset system is simply to remember the values of inputs and parameters in a scene. While a scene saves the current state of all values when being saved, there will be times when you want faster access to the default values of a patch.

Let’s start by saving the default hz0 parameter value (330Hz) to preset 0.

- *Navigate to INPUTS page.*
- *Select 090.hz0.*
- *Press STORE (SW0) twice.*

You’ve just created your first preset! now the value of hz0 is stored in preset 0 in your scene. You might have noticed when pressing SW0 the first time a number appears on the top line of the screen – this is the name of the preset you’re about to write to. Now let’s try and recall the value we just wrote.

- *Set 090.hz0 to a new number (say 700Hz).*
- *Hold SW3 and turn ENC1. (Aleph ENC reference)*
- *Select preset 000 and release SW3.*

You should now hear the tone return to your preset value of 330Hz. Using this method of holding SW3 and turning ENC1 it’s possible to navigate to any given preset and preview the effect of parameter changes on the screen. As you turn ENC1 you’ll notice a tiny dot to the far right of the parameter, demonstrating that it’s value will be recalled when selecting that preset. Let’s save a new value for hz0 into preset 1:

- *Set 090.hz0 to 283Hz.*
- *Select preset 1 (hold SW3, turn ENC1).*
- *Press STORE (SW0) twice.*

Now you can test out your two presets by selecting them sequentially and watching the screen update the value, showing you what output you’ll receive when releasing SW3.

### Include and Exclude

While the above method shows a way to explicitly store values into a preset it might make more sense at times to use the INC (include), and EXC (exclude) functions on the INPUTS page. Any value you set to INC will display the dot to the right of the display showing that it’s value will be recalled in a preset. Let’s set a number of parameters to be included in preset 0.

- *Select preset 0 (SW3 & ENC1).*
- *Set hz1, tune0, and tune1 to INC with SW1.*
- *Set these params to new values.*
- *Navigate to the PRESETS page.*
- *Select ‘000_’ with ENC1, and double press STORE (SW0).*

Now if you return to the INPUTS page and change these values, then recall preset 0, you’ll hear your saved tones again. Now you’ll probably say “but this is slower than just storing values directly”, and you’d be entirely correct! the STORE command on the INPUTS page is essentially like pressing INC and then pressing STORE on the PRESETS page, so we recommend that approach.

The EXC function is perhaps a bit more useful as it allows you to stop recalling a parameter that’s been added to a preset. Let’s remove these 3 new parameters from our preset:

- *Navigate to INPUTS.*
- *Select tune1, double-press EXC (SW1).*
- *As above for tune0 & hz1.*

Let’s clean up these values before moving on:

- *Set tune0 & tune1 to 1.*
- *Set hz1 to 220Hz.*

### Adding Names and Descriptions

Before moving on to more exciting patching, let’s quickly note that presets can be given descriptive names to aid in their navigation. At present there are 32 available preset slots, though this number is likely to increase with future bees updates. Let’s set some names for the presets to make the next few tasks easier to navigate:

- *Navigate to PRESETS page.*
- *Select ‘000_’ and name it ‘A00_’.*
- *As above: ‘001_’ to ‘A01_’.*
- *As above: ’002_’ to ‘B02_’.*
- *As above: ’003_’ to ‘B03_’.*
- *As above: ’004_’ to ‘C04_’.*
- *As above: ’005_’ to ‘C05_’.*

The idea here is that we will create two independent groups of presets, one called ‘A’ and the other ‘B’. Of course you can give your presets much more descriptive names but the above is a quick way to delineate functional groups.

*Note: you don’t need to press ‘STORE’ to save the preset name, and if you do it will duplicate the current PRESET’s values into the selected preset slot.*

### Recalling Presets in Play Mode

Now that you know how to add values into the current preset we can talk about how to use presets in a useful way for performance. We’ll begin by mapping SW0 to PRESET/READ:

- *Connect 004.SW/VAL to 011.PRESET/READ.*
- *Set 004.SW/TOG to 1.*

![](../images/t5-sw-pre.jpg)

Enter play mode and press SW0 to bounce between the two pitch values. You can add some slew to 002.hz0Slew if you’d like. This should make it clear that all presets are doing is recalling a set of numbers, just as if they’d been sent to it by another operator.

In addition to simply setting parameters directly, it’s just as easy to change operator inputs. We’ll use SW1 to give ENC0 a coarse and fine control. First we create the control network

- *Make an ADD operator.*
- *Connect ADD/SUM to PRESET/READ.*
- *Set ADD/B to 2.*
- *Connect SW1(005.SW/VAL) to ADD/A.*

![](../images/t5-sw-add-pre.jpg)

Now attach ENC0 to a module parameter, say pm01:

- *Connect ENC0 to 082.pm01.*

And finally we need to store our fine and coarse settings as preset entries:

- *Navigate to INPUTS page.*
- *Recall preset B02 (SW3 & ENC1).*
- *Set ENC0/STEP to 10.*
- *Press STORE twice to add to the preset.*
- *Recall preset B03.*
- *Set ENC0/STEP to 200.*
- *Press STORE twice to add to the preset.*

![](../images/t5-fine.jpg)

Enter play mode and turn ENC0 to see the phase modulation 0→1 gradually start to increase. If you now hold SW1 you’ll see ‘B03’ printed to the screen and ENC0 will now sweep the value much more quickly. All the while you can press SW0 to change between the two pitches without confusing the coarse fine control at all. If you’re really keen, you can change the names of presets B02 and B03 to ‘fine’ and ‘coarse’ respectively, via the PRESETS page.

### Destination Routing

Another powerful use of the preset system is in dynamically changing the routing of the operator network. I don’t even think we quite understand the power of this system yet, but i’ll demonstrate a simple use case to get your imagination running. Using SW2 we’ll change the routing of ENC0 from ‘phase modulation 0→1’ to ‘phase modulation 1→0’:

- *Create an ADD operator.*
- *Set ADD/B to 4.*
- *Set SW2/TOG (006.SW/TOG) to 1.*
- *Connect SW2 (006.SW/VAL) to ADD/A.*
- *Connect ADD/SUM to PRESET/READ.*

The above creates the routing network from SW2 through to the preset system. It will trigger the loading of preset 4 or 5 in a toggling fashion. Now we set and store the destination routings:

- *Navigate to OUTPUTS page.*
- *Recall preset C04 (SW3 & ENC1).*
- *Locate 000.ENC/VAL &rarr; 082.pm01 and STORE.*
- *Recall preset C05 (SW3 & ENC1).*
- *Connect 000.ENC/VAL to 081.pm10.*
- *STORE the routing in the preset.*

![](../images/t5-route.jpg)

Now in play mode you’ll be able to change the routing of ENC0 to two separate destinations, all while changing the fine/coarse effect of the knob, and changing the pitch of two oscillators.

### Summary

This is the end of the first part of the presets tutorial. As it seems a nice place to let you imagine and explore the system on your own. The second part of the presets tutorial will show some working examples, tips and tricks, as well as some more experimental self-modifying networks. For now, here’s a quick ‘cheat sheet’ of things covered in this tutorial:

#### Recalling a Preset Directly:

- *From INPUTS or OUTPUTS page.*
- *Hold SW3.*
- *Turn ENC1 to scroll through preset names.*
- *Release SW3 to recall the selected preset.*

#### Storing a Value / Destination in a Preset:

- *Recall the preset you wish to save to (SW3 & ENC1).*
- *Set the desired value / destination.*
- *Press STORE (SW0) twice to save.*

#### Remove a Value from a Preset (ie. Stop it being recalled):

- *Locate your value or destination.*
- *A dot to the right indicates it is currently stored.*
- *Press EXC (SW1) twice to remove.*
- *The dot will disappear.*

### Going Further

- *Add hz1 manipulation to presets A00 and A01.*
- *Use SW3 to toggle presets 006 and 007.*
- *Set presets 006&007 to route ENC1 to wave0 and wave1.*
- *Add coarse fine control for ENC1 into presets B02 and B03.*

### Next Steps

[Tutorial 0: Getting Started with Bees](../tutorial-0)

[Tutorial 1: Making a Network](../tutorial-1)

[Tutorial 2: A Simple Synthesizer](../tutorial-2)

[Tutorial 3: Connecting a Controller](../tutorial-3)

[Tutorial 4: Sequencing & Modulation](../tutorial-4)

Tutorial 5: Presets, Presets, Presets!

[Tutorial 6: More Presets &rarr;](../tutorial-6)
