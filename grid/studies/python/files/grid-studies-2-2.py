#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.GridApp):
    def __init__(self):
        super().__init__()
        self.width = 0
        self.height = 0
        self.step = [[0 for col in range(16)] for row in range(16)]
        self.play_position = -1
        self.play_task = asyncio.ensure_future(self.play())

    # when grid is plugged in via USB:
    def on_grid_ready(self):
        self.width = self.grid.width
        self.height = self.grid.height
        self.sequencer_rows = self.height-2
        self.connected = True
        self.draw()

    # when grid is physically disconnected:
    def on_grid_disconnect(self,*args):
        self.connected = False

    async def play(self):
        while True:
            await asyncio.sleep(0.1)

            if self.play_position == self.width - 1:
                self.play_position = 0
            else:
                self.play_position += 1

            if self.connected:
                self.draw()

    def draw(self):
        buffer = monome.GridBuffer(self.width, self.height)

        # display steps
        for x in range(self.width):
            # highlight the play position
            if x == self.play_position:
                highlight = 4
            else:
                highlight = 0

            for y in range(self.sequencer_rows):
                buffer.led_level_set(x, y, self.step[y][x] * 11 + highlight)

        # update grid
        buffer.render(self.grid)

    def on_grid_key(self, x, y, s):
        # toggle steps
        if s == 1 and y < self.sequencer_rows:
            self.step[y][x] ^= 1
            self.draw()

async def main():
    loop = asyncio.get_running_loop()
    grid_studies = GridStudies()

    def serialosc_device_added(id, type, port):
        print('connecting to {} ({})'.format(id, type))
        asyncio.ensure_future(grid_studies.grid.connect('127.0.0.1', port))

    serialosc = monome.SerialOsc()
    serialosc.device_added_event.add_handler(serialosc_device_added)

    await serialosc.connect()
    await loop.create_future()

if __name__ == '__main__':
    asyncio.run(main())
