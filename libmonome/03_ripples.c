#line 311 "grid_tutorial.org"
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
