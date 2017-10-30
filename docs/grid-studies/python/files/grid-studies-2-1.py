#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.App):
    def __init__(self):
        super().__init__('/monome')

    def on_grid_ready(self):
        self.step = [[0 for col in range(self.grid.width)] for row in range(6)]

        asyncio.async(self.play())

    async def play(self):
        while True:
            self.draw()

            await asyncio.sleep(0.1)

    def draw(self):
        buffer = monome.GridBuffer(self.grid.width, self.grid.height)

        # display steps
        for x in range(self.grid.width):
            for y in range(6):
                buffer.led_level_set(x, y, self.step[y][x] * 11)

        # update grid
        buffer.render(self.grid)

    def on_grid_key(self, x, y, s):
        # toggle steps
        if s == 1 and y < 6:
            self.step[y][x] ^= 1
            self.draw()

if __name__ == '__main__':
    grid_studies = GridStudies()

    loop = asyncio.get_event_loop()
    asyncio.async(monome.SerialOsc.create(loop=loop, autoconnect_app=grid_studies))
    loop.run_forever()
