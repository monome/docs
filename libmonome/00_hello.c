#line 30 "grid_tutorial.org"
#include <stdlib.h>
#include <monome.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

unsigned int grid[16][16];

void handle_press(const monome_event_t *e, void *data) {
    unsigned int x, y;

    x = e->grid.x;
    y = e->grid.y;

    /* toggle the button */
    grid[x][y] = !grid[x][y];
    monome_led_set(e->monome, x, y, grid[x][y]);
}

int main(int argc, char *argv[]) {
    monome_t *monome;

    if (argc < 2) {
        printf("Usage %s device_path\n", argv[0]);
        return 1;
    }

    int x, y;

    for(x = 0; x < 16; x++)
        for(y = 0; y < 16; y++) grid[x][y] = 0;

    if( !(monome = monome_open(argv[1], "8000")) )
        return -1;

    monome_led_all(monome, 0);

    monome_register_handler(monome, MONOME_BUTTON_DOWN, handle_press, NULL);

    monome_event_loop(monome);

    monome_close(monome);
    return 0;
}
