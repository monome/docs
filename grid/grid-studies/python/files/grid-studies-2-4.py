#! /usr/bin/env python3

import asyncio
import monome

class GridStudies(monome.GridApp):
    def __init__(self):
        super().__init__()

    def on_grid_ready(self):
        self.step = [[0 for col in range(self.grid.width)] for row in range(6)]
        self.play_position = 0
        self.next_position = 0
        self.cutting = False

        asyncio.async(self.play())

    async def play(self):
        while True:
            if self.cutting:
                self.play_position = self.next_position
            elif self.play_position == self.grid.width - 1:
                self.play_position = 0
            else:
                self.play_position += 1

            # TRIGGER SOMETHING
            for y in range(6):
                if self.step[y][self.play_position] == 1:
                    self.trigger(y)

            self.cutting = False
            self.draw()

            await asyncio.sleep(0.1)

    def trigger(self, i):
        print("triggered", i)

    def draw(self):
        buffer = monome.GridBuffer(self.grid.width, self.grid.height)

        # display steps
        for x in range(self.grid.width):
            # highlight the play position
            if x == self.play_position:
                highlight = 4
            else:
                highlight = 0

            for y in range(6):
                buffer.led_level_set(x, y, self.step[y][x] * 11 + highlight)

        # draw trigger bar and on-states
        for x in range(self.grid.width):
            buffer.led_level_set(x, 6, 4)

        for y in range(6):
            if self.step[y][self.play_position] == 1:
                buffer.led_level_set(self.play_position, 6, 15)

        # draw play position
        buffer.led_level_set(self.play_position, 7, 15)

        # update grid
        buffer.render(self.grid)

    def on_grid_key(self, x, y, s):
        # toggle steps
        if s == 1 and y < 6:
            self.step[y][x] ^= 1
            self.draw()
        # cut
        elif y == 7:
            # cut
            if s == 1:
                self.cutting = True
                self.next_position = x
                self.key_last = x

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
