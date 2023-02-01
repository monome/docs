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
        self.next_position = -1
        self.cutting = False
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

            if self.cutting:
                self.play_position = self.next_position
            elif self.play_position == self.width - 1:
                self.play_position = 0
            else:
                self.play_position += 1

            # TRIGGER SOMETHING
            for y in range(self.sequencer_rows):
                if self.step[y][self.play_position] == 1:
                    self.trigger(y)

            self.cutting = False

            if self.connected:
                self.draw()

    def trigger(self, i):
        print("triggered", i)

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

        # draw trigger bar and on-states
        for x in range(self.width):
            buffer.led_level_set(x, self.sequencer_rows, 4)

        for y in range(self.sequencer_rows):
            if self.step[y][self.play_position] == 1:
                buffer.led_level_set(self.play_position, self.sequencer_rows, 15)

        # draw play position
        buffer.led_level_set(self.play_position, self.sequencer_rows+1, 15)

        # update grid
        buffer.render(self.grid)

    def on_grid_key(self, x, y, s):
        # toggle steps
        if s == 1 and y < self.sequencer_rows:
            self.step[y][x] ^= 1
            self.draw()
        # cut
        elif y == self.height-1: # want 0-index!
            # cut
            if s == 1:
                self.cutting = True
                self.next_position = x

async def main():
    loop = asyncio.get_event_loop()
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