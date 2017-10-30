#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.App):
    def __init__(self):
        super().__init__('/monome')

    def on_grid_key(self, x, y, s):
        print("key:", x, y, s)
        self.grid.led_level_set(x, y, s*15)

if __name__ == '__main__':
    grid_studies = GridStudies()

    loop = asyncio.get_event_loop()
    asyncio.async(monome.SerialOsc.create(loop=loop, autoconnect_app=grid_studies))
    loop.run_forever()
