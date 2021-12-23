#line 192 "grid_tutorial.org"
#include <stdlib.h>
#include <monome.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdint.h>

uint16_t grid[8];
static int please_draw = 0;

static uint8_t quadL[8];
static uint8_t quadR[8];

static volatile int is_running = 1;

void handle_press(const monome_event_t *e, void *data) {
    unsigned int x, y;
    int s;
    uint8_t *q;

    x = e->grid.x;
    y = e->grid.y;

    if (x >= 8) {
        q = quadR;
        x -= 8;
    } else {
        q = quadL;
    }

    s = (q[y] & (1 << x)) ? 0 : 1;

    if (s) {
        q[y] |= 1 << x;
    } else {
        q[y] &= ~(1 << x);
    }

    please_draw = 1;
}

static void redraw(monome_t *m, uint16_t *g)
{
    if (please_draw) {
        please_draw = 0;
        monome_led_map(m, 0, 0, quadL);
        monome_led_map(m, 255, 0, quadR);
    }
}

static void please_close(int sig)
{
    is_running = 0;
}

int main(int argc, char *argv[]) {
    monome_t *monome;

    int y;

    if (argc < 2) {
        printf("Usage %s device_path\n", argv[0]);
        return 1;
    }

    signal(SIGINT, please_close);

    for (y = 0; y < 8; y++) {
        quadL[y] = 0;
        quadR[y] = 0;
    }

    if( !(monome = monome_open(argv[1], "8000")) )
        return -1;

    monome_led_all(monome, 0);

    monome_register_handler(monome, MONOME_BUTTON_DOWN, handle_press, NULL);

    while(is_running) {
        while(monome_event_handle_next(monome));
        redraw(monome, grid);
        usleep(800);
    }

    printf("Closing!\n");

    monome_led_all(monome, 0);
    monome_close(monome);
    return 0;
}
