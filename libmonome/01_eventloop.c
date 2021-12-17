#line 120 "grid_tutorial.org"
#include <stdlib.h>
#include <monome.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

unsigned int grid[16][16];

static volatile int is_running = 1;

void handle_press(const monome_event_t *e, void *data) {
    unsigned int x, y;

    x = e->grid.x;
    y = e->grid.y;

    /* toggle the button */
    grid[x][y] = !grid[x][y];
    monome_led_set(e->monome, x, y, grid[x][y]);
}

static void please_close(int sig)
{
    is_running = 0;
}

int main(int argc, char *argv[]) {
    monome_t *monome;
    int x, y;

    if (argc < 2) {
        printf("Usage %s device_path\n", argv[0]);
        return 1;
    }

    signal(SIGINT, please_close);

    for(x = 0; x < 16; x++)
        for(y = 0; y < 16; y++) grid[x][y] = 0;

    if( !(monome = monome_open(argv[1], "8000")) )
        return -1;

    monome_led_all(monome, 0);

    monome_register_handler(monome, MONOME_BUTTON_DOWN, handle_press, NULL);

    while(is_running) {
        while(monome_event_handle_next(monome));
        usleep(800);
    }

    printf("Closing!\n");
    monome_led_all(monome, 0);
    monome_close(monome);
    return 0;
}
