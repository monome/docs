---
layout: default
nav_exclude: true
permalink: /aleph/modules/
---

# Aleph: Modules

Modules are run on the DSP hardware of the Aleph. They handle all audio input and output, and communicate with the current Application (eg. Bees) to set their function. Modules also control CV output (though not input).

Modules can be created with many varied functions, though the main distribution includes three highly customizable modules for FM synthesis, delay/sampling, and percussion synthesis.

### Functionality & Parameters

The interface to modules is via a list of *parameters*. This list is different for each module and the associated functionality is described in the following subpages for each module.

- [waves](../waves) - Monophonic synthesizer w/ phase modulation
- [lines](../lines) - Dual delay line with modulation matrix mixer
- [dsyn](../dsyn) - Noise and filterbank “percussion” synthesizer
