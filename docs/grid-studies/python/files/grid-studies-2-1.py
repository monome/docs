#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.Monome):
    def __init__(self):
        super().__init__('/monome')

    def ready(self):
        self.step = [[0 for col in range(self.width)] for row in range(6)]

        asyncio.async(self.play())

    @asyncio.coroutine
    def play(self):
        while True:
            self.draw()

            yield from asyncio.sleep(0.1)

    def draw(self):
        buffer = monome.LedBuffer(self.width, self.height)

        # display steps
        for x in range(self.width):
            for y in range(6):
                buffer.led_level_set(x, y, self.step[y][x] * 11)

        # update grid
        buffer.render(self)

    def grid_key(self, x, y, s):
        # toggle steps
        if s == 1 and y < 6:
            self.step[y][x] ^= 1
            self.draw()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    asyncio.async(monome.create_serialosc_connection(GridStudies))
    loop.run_forever()