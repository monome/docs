#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.GridApp):
    def __init__(self):
        super().__init__()

    def on_grid_key(self, x, y, s):
        print("key:", x, y, s)
        self.grid.led_level_set(x, y, s*15)

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    grid_studies = GridStudies()

    def serialosc_device_added(id, type, port):
        print('connecting to {} ({})'.format(id, type))
        asyncio.ensure_future(grid_studies.grid.connect('127.0.0.1', port))

    serialosc = monome.SerialOsc()
    serialosc.device_added_event.add_handler(serialosc_device_added)

    loop.run_until_complete(serialosc.connect())
    loop.run_forever()
