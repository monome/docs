var grid = require('monome-grid')();

// initialize 2-dimensional led array
var led = [];
for (var y=0;y<8;y++) {
  led[y] = [];
  for (var x=0;x<16;x++)
    led[y][x] = 0;
}

var dirty = true;

// refresh leds with a pattern
function refresh() {
  if(dirty) {
    grid.refresh(led);
    dirty = false;
  }
}

// call refresh() function 60 times per second
setInterval(refresh, 1000 / 60);

// set up key handler
grid.key(function (x, y, s) {
  led[y][x] = s * 15;
  dirty = true;
});
