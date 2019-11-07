---
layout: default
nav_exclude: true
permalink: /aleph/bees/
---

# Aleph: Bees

*Quick Links*: [Operators](/docs/aleph/ops/) - [Tutorials](/docs/aleph/tutorial-0/)

<div class="vid"><iframe src="https://player.vimeo.com/video/87359988?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

## Introduction

Bees is an application designed to be a flexible routing system. It can arbitrarily map and process control rate input, manage audio modules, and store/recall scenes from an SD card.

This page provides general information about Bees, though for more hands-on usage instructions head straight to the [Tutorials](/docs/aleph/tutorial-0/).

### Nomenclature

- CONTROL: a numerical value, or “control voltage.”
- MODULE: a program which runs on the DSP processor.
- INPUT: input node in a control-processing network. (UPPERCASE)
- PARAMETER: a direct input to a MODULE, with associated metadata. (lowercase)
- OUTPUT: output node in a control-processing network. can be connected to an INPUT or PARAMETER.
- OPERATOR: a unit of processing for CONTROL signals.
- PRESET: a record of the state of all PARAMETERs and INPUTs and their OUTPUT connections.
- SCENE: a record of the composition of the entire network, including the identity and state of the current MODULE, the group of OPERATORs, and the associated PRESETs.

### Scenes

Within the bees environment the user can create SCENES that represent a configuration of the control-processing network. Each scene includes a number of OPERATORS (aka. ops) which can be dynamically configured and automated with the preset system. OPS have INPUTs which can be set directly within a network, or controlled by other OPS in a network.

### Modes

Bees has an EDIT mode and PLAY mode. The mode is toggled using the MODE SWITCH, and EDIT mode is indicated by a lit MODE LED. In EDIT mode the ENCODERs and SWITCHes are used for navigation and menu actions. In PLAY mode these values are sent to the network and processed accordingly.

The control-processing network can be directly manipulated in EDIT mode, or via CONTROL inputs in PLAY mode. Typically a scene will route the ENCODERs and SWITCHes to performance oriented functions in PLAY mode (eg. ENC0 is routed to a ‘METRO’ OP's ‘PERIOD’ INPUT to provide an ‘arp cycle time’ function in the default scene).

### Operators

OPERATORs are units of processing for CONTROL signals. An OPERATOR can have zero or more INPUTs and OUTPUTs. Bees supports multiple instances of each operator, though there is an upper limit of how many ops may exist in a single scene.

OPERATORs are what enable intelligent connections of hardware components, and where the initial focus for expandability of the Bees system lies.

For a full list of operators and their functions, see the [ops](/docs/aleph/ops/) page.

### Parameters & Scaling

In depth parameter article: [Parameter Scaling](/docs/aleph/param-scaling/)

All CONTROL values in a bees network are represented by a signed 16bit integer (-32,768 to 32,767). Each PARAM will default to a logical scale and limits: timing signals are represented in milliseconds, boolean (on/off) states are represented by 1 or 0.

It is important to note the limitations of 16bit integer math. On modern computing systems numbers are typically calculated at 32 or 64 bits of floating-point precision, so multiplying very large numbers bears a very low rounding error. In contrast, 16bit math makes rounding errors far more noticeable and requires alternative approaches to problems. Eg: The typical 60,000/x equation for converting a millisecond interval into a 'beats per minute' figure is not possible, and must be approached in an alternative manner.

When CONTROL values are sent to DSP parameters they are then mapped depending on the function to which they are attached. For instance in [waves](/docs/aleph/waves], pitch parameters are scaled with 256 values per semitone for linear control of pitch.

### Presets

A record of the state of all PARAMETERs, INPUTs, and their connections. PRESETs can be manipulated in realish time, and conditionally include/exclude specific components.

Each SCENE contains 32 PRESETs (more soon) which can store and recall all PARAM and INPUT values for the active ops. OUTPUT routings will be included in an upcoming release of bees. Using the PRESET operator it is possible to automate the storing and recall of parameters from CONTROL messages in the network.

### Saving Your Work

The SD card is used for SCENE storage and loading of the dsp MODULEs. Your current SCENE including all of its PRESETs can be saved to the SD card in the SCENEs page of bees. A filename can be entered using ENC1&3. If the filename does not appear in the list it will save a new SCENE, else it will overwrite that with the same name.

When viewing the contents of the SD card on a computer, you will find your SCENEs in the /data/bees/scenes folder. If you wish to share your SCENE simply find the named file and follow the instructions below. This is also the folder where you can upload new SCENEs downloaded from the wiki.

On powerdown, the current state of the device is saved to the SD card as “default.scn,” which will subsequently be loaded at startup. It is important that the device not lose power completely during the couple of seconds that this takes; this will result in a corrupted scene file (requiring a clean boot) and possibly a corrupted filesystem on the SD card (requiring reformatting.)

It is possible to fast-shutdown the aleph in order to discard any unsaved changes to the current scene. To do so, hold the MODE switch while pressing the POWER button to shutdown.

### Updating Bees

When a new version of bees is available you can copy the hex file to the /app folder on your SD card. Place the card in your aleph and power-up while holding the MODE switch. This will enter the bootloader.

Select the desired bees file to load and press SW2 to write the new file to flash. The upload process will take around 3 minutes. When it is complete the aleph will reboot automatically into the updated version of Bees.

It’s a good idea first to check the release notes to confirm compatibility with your saved scenes.

A more in-depth explanation of updating the Aleph is available at [Aleph- updates](/docs/aleph/updates/).

### Troubleshooting

If the aleph is frozen while attempting to load into bees, or from a scene you will need to hard reset. To do so, power down the Aleph with the POWER button, then remove the power cable if the device remains on. Replug the power cable and, while holding SW0, press the POWER button to ‘first time’ boot the Aleph. this begins with a blank scene and attempts to load *waves*.

If you encounter situations where your aleph stops responding, or does so in an unexpected manner, please report the event and surrounding actions to help@monome.org. Bees is still in development and we're constantly looking for ways to refine and improve it.

### Tutorials

[Tutorial 0: Getting Started with Bees](../tutorial-0)
[Tutorial 1: Making a Network](../tutorial-1)
[Tutorial 2: A Simple Synthesizer](../tutorial-2)
[Tutorial 3: Connecting a Controller](../tutorial-3)
[Tutorial 4: Sequencing & Modulation](../tutorial-4)
[Tutorial 5: Presets, Presets, Presets!](../tutorial-5)
[Tutorial 6: More Presets](../tutorial-6)
[Tutorial 7: Control Voltage](../tutorial-7)

Also see the contributed [video tutorials!](/docs/aleph/videos/)

### Quick Reference

- Hold down the MODE key when shutting down the aleph to bypass the automatic scene save to default.scn
- Hold down SW0 when powering up to skip default.scn and boot to a blank scene
