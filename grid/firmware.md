---
layout: default
nav_exclude: true
---

![](images/2022-grid-firmware.jpg)

## firmware

**Note that this is only for grids made in 2022 and early 2023. grids shipped on or after January 23, 2024 have this newest firmware. grids made before 2022 do not require a firmware update.**

This new firmware addresses some edge communication stability issues and also low-brightness inconsistencies due to the LED driver circuit used.

### instructions

1. Remove the bottom screws.
2. Locate the golden pushbutton near the USB port. Hold it down while connecting the grid to a computer.
3. A USB drive will enumerate. Download the appropriate firmware listed below and copy the file to this drive. The drive will unmount immediately upon copying the file (on macOS this may cause a benign alert).
4. Disconnect and put the screws back on (make sure to place the spacers first).

### troubleshooting

If you flash the firmware and don't see LED activity afterward, verify that the firmware file you flashed corresponds to the marking in the bottom-right of the circuit board.

### firmwares

- zero, circuit board marking `monome/grid-zero/230412` - [download zero-240123.uf2](zero-240123.uf2)
- one, circuit board marking `monome/grid-one/230412` - [download one-240123.uf2](one-240123.uf2)
- late 2022, circuit board marking `monome/grid/220914` - [download grid-240123.uf2](grid-240123.uf2)
- **all other grid editions do not require a firmware update**
