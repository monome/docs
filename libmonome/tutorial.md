---
layout: default
title: libmonome tutorial
nav_exclude: true
---

# libmonome tutorial

Controlling the Grid with libmonome and C

Introduction
============

This guide aims to show how someone can use libmonome to control the
grid from C.

Why do this? The big advantage that libmonome provides is that it
doesn\'t require serialosc or OSC at all. The OSC communications layer,
usually built on top of the UDP networking protocol, introduces a
non-trivial amount of overhead. Using libmonome to directly control the
grid will will make the grid consistently more responsive, and also much
easier to debug.

The assumption here is that readers are already familiar with the C
programming language and building programs from the commandline. The
presented code has been tested to work on both Linux and OSX.

Writing a program using the Grid can boiled down to three things: A.
handling button presses (down and up), B. controlling the LED lights (on
and off), and C. making other things happen while managing the grid
(making sound, video, etc). This guide/tutorial will address (A) and (B)
directly, while paving the way for (C).

Hello Grid
==========

To begin, here\'s very simple \"hello grid\" program:

```
// {#00_hello.c .c tangle="00_hello.c"}
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
```

The monome interface manages state in a struct called `monome_t`.

`monome_open` opens the monome device. Automatically will use OSC or
serial directly based on filename. (This is important!)

`monome_led_all` will efficiently toggle all LEDs to be in and on or off
state. It\'s being used to turn everything off (far more useful than
turning everything on).

`monome_register_handler` will register a callback to the event loop. In
this case, it\'s the `MONOME_BUTTON_DOWN` callback, which is the
function created called `handle_press`. This will get called every time
a button is pushed.

`monome_event_loop` begins the event loop and starts listening to
events.

`monome_close` will cleanly close the monome listener. However, in this
current setup, it will never get here. More on that later.

`monome_led_set` is used to light a single led at a particular XY
coordinate.

Breaking out the event loop
===========================

A more practical version of the previous example is shown below. Here, a
signal interrupt is added so that it is possible to break out of the
loop and cleanly exit with \`monome~close~\`. \`monome~eventloop~\` is
replaced with a small while loop, with a small delay added so as to not
eat up CPU cycles.

The new monome function here is used, `monome_event_handle_next`, which
is what `monome_event_loop` was calling to process events.

Not only is this approach allow for a more graceful exit, but it also a
more practical way to use it in larger pieces of software.

```
// {#01_eventloop.c .c tangle="01_eventloop.c"}
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
```

More Efficient Drawing
======================

As monome applications get more complex, independently setting LEDs with
\`monome~ledset~\` becomes noticeably slow. A more efficient route would
involve setting LEDs one row at a time `monome_led_row` (8 calls on a
regular Grid) or one quad at a time using `monome_led_map` (2 calls on a
regular Grid).

This toggle LED example will be reworked to use quads with
`monome_led_map`, as it is the most efficient way to draw a bunch of
LEDs.

```
// {#02_more_efficient.c .c tangle="02_more_efficient.c"}
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
```

A more interesting example
==========================

Using `monome_led_map` to redraw the entire screen every time a single
LED button is toggled feels a bit overkill. This drawing approach really
shines when many parts of the grid need to be redrawn, quickly.

So, our simple toggle app will be modified a bit to add some flair:
every time a part of the grid is toggled, it will produce a virtual
ripple.

To accomplish this, LEDs on the grid will be treated more like pixels on
a very low resolution framebuffer. State will be maintained for the
toggled states and ripple animations separately, and then drawn on the
Grid at the last minute.

In addition, a few other structs and abstractions have been made. In
particular, all program data that was once global data has now been
consolidated into one struct created inside of the `main` function using
`malloc`. This is a better practice. Not only does it make programs
easier to manage this way, but removing global variables also eases off
dependency on stack memory allocation, which is finite and can be very
small on some systems.

```
// {#03_ripples.c .c tangle="03_ripples.c"}
#include <stdlib.h>
#include <monome.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/time.h>

struct canvas {
    uint8_t quadL[8];
    uint8_t quadR[8];
};

static volatile int is_running = 1;

struct ripple {
    int cx;
    int cy;
    int size;
    int count;
    struct ripple *next;
};

#define MAXRIPPLES 8

struct ripple_stack {
    struct ripple stack[MAXRIPPLES];
    struct ripple *head, *tail;
    int size;
};

struct app_data {
    struct ripple_stack rstack;
    monome_t *m;
    struct canvas c;
    int please_draw;
    int please_update;

};

void set_led(struct canvas *c, int x, int y, int s)
{
    uint8_t *q;

    if (x >= 8) {
        q = c->quadR;
        x -= 8;
    } else {
        q = c->quadL;
    }

    if (s) {
        q[y] |= 1 << x;
    } else {
        q[y] &= ~(1 << x);
    }
}

void clear_screen(struct canvas *c)
{
    int i;
    for (i = 0; i < 8; i++) {
        c->quadL[i] = 0;
        c->quadR[i] = 0;
    }
}

void ripple_stack_init(struct ripple_stack *rs)
{
    int i;
    struct ripple *rip, *last;

    last = NULL;
    for (i = 0; i < MAXRIPPLES; i++) {
        rip = &rs->stack[i];
        rip->cx = 0;
        rip->cy = 0;
        rip->size = 0;
        rip->count = 1;

        if (last != NULL) last->next = rip;
        last = rip;
    }

    last->next = &rs->stack[0];

    rs->size = 0;
    rs->head = NULL;
    rs->tail = NULL;
}

void ripple_stack_add(struct ripple_stack *rs, int x, int y)
{
    struct ripple *rip;
    if (rs->size >= MAXRIPPLES) return;

    rip = NULL;

    if (rs->size == 0) {
        rip = &rs->stack[0];
        rs->head = rip;
    } else {
        rip = rs->tail->next;
    }

    rip->cx = x;
    rip->cy = y;
    rip->size = 0;
    rip->count = 3;

    rs->tail = rip;
    rs->size++;
}

void draw_rect(struct canvas *c,
               int xpos, int ypos, int w, int h)
{
    int i;

    /* top horizontal */

    if (ypos >= 0 && ypos < 8) {
        for (i = 0; i < w; i++) {
            int pos;
            pos = xpos + i;
            if (pos >= 16) break;
            set_led(c, pos, ypos, 1);
        }
    }

    /* left vertical */

    if (xpos >= 0 && xpos < 16 ) {
        for (i = 0; i < h; i++) {
            int pos;
            pos = ypos + i;
            if (pos < 8 && pos >= 0) {
                set_led(c, xpos, pos, 1);
            }
        }
    }

    /* bottom horizontal */

    ypos += h - 1;

    if (ypos >= 0 && ypos < 8) {
        for (i = 0; i < w; i++) {
            int pos;
            pos = xpos + i;
            if (pos >= 16) break;
            set_led(c, pos, ypos, 1);
        }
    }

    /* right vertical */

    xpos += w - 1;
    ypos -= h - 1;

    if (xpos >= 0 && xpos < 16) {
        for (i = 0; i < h; i++) {
            int pos;
            pos = ypos + i;
            if (pos < 8 && pos >= 0) {
                set_led(c, xpos, pos, 1);
            }
        }
    }
}

void ripple_stack_draw(struct ripple_stack *rs,
                       struct canvas *c)
{
    int r;
    struct ripple *head , *cur;
    int size;
    clear_screen(c);

    head = rs->head;
    cur = head;
    size = rs->size;

    for (r = 0; r < size; r++) {
        int x, y, w, h;
        x = cur->cx - cur->size;
        y = cur->cy - cur->size;
        w = ((cur->size + 1) * 2) - 1;
        h = w;
        draw_rect(c, x, y, w, h);
        cur = cur->next;
    }
}

void ripple_stack_update(struct ripple_stack *rs)
{
    int r;
    struct ripple *head , *cur;
    int size;

    head = rs->head;
    cur = head;
    size = rs->size;

    for (r = 0; r < size; r++) {
        cur->size++;
        if (cur->size > 8) {
            cur->count--;
            cur->size = 0;
            if (cur->count <= 0) {
                head = cur->next;
                rs->size--;
            }
        }
        cur = cur->next;
    }

    rs->head = head;
}

void handle_press(const monome_event_t *e, void *data) {
    unsigned int x, y;
    struct app_data *ad;

    ad = (struct app_data *)data;

    x = e->grid.x;
    y = e->grid.y;

    ripple_stack_add(&ad->rstack, x, y);

    ad->please_draw = 1;
}

static void redraw(struct app_data *ad)
{
    if (ad->please_draw) {
        ad->please_draw = 0;

        ripple_stack_draw(&ad->rstack, &ad->c);

        if (ad->please_update) {
            ripple_stack_update(&ad->rstack);
        }

        monome_led_map(ad->m, 0, 0, ad->c.quadL);
        monome_led_map(ad->m, 255, 0, ad->c.quadR);
    }

}

static void please_close(int sig)
{
    is_running = 0;
}

static double now_sec(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec*1e-6;
}

int main(int argc, char *argv[]) {
    monome_t *monome;
    double now, then;
    struct app_data *data;

    int y;

    if (argc < 2) {
        printf("Usage %s device_path\n", argv[0]);
        return 1;
    }

    signal(SIGINT, please_close);

    data = malloc(sizeof(struct app_data));

    for (y = 0; y < 8; y++) {
        data->c.quadL[y] = 0;
        data->c.quadR[y] = 0;
    }

    ripple_stack_init(&data->rstack);

    if (!(monome = monome_open(argv[1], "8000")))
        return -1;

    data->m = monome;
    data->please_draw = 0;
    data->please_update = 0;
    monome_led_all(monome, 0);

    monome_register_handler(monome,
                            MONOME_BUTTON_DOWN,
                            handle_press,
                            data);

    now = then = now_sec();

    while(is_running) {
        while(monome_event_handle_next(monome));
        now = now_sec();

        if ((now - then) > 0.08) {
            data->please_update = 1;
            data->please_draw = 1;
            then = now;
        }

        redraw(data);

        usleep(800);
    }

    printf("Closing!\n");

    monome_led_all(monome, 0);
    monome_close(monome);

    free(data);
    return 0;
}
```

Further Reading
===============

TODO: link to monome.h, OSC reference, etc.

## Files

- [00_hello.c](00_hello.c)
- [01_eventloop.c](01_eventloop.c)
- [02_more_efficient.c](02_more_efficient.c)
- [03_ripples.c](03_ripples.c)

## Acknowledgements

This tutorial was contributed by [pbat.ch](https://pbat.ch)

