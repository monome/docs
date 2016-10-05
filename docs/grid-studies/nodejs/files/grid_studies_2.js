var grid = require('monome-grid')();

// initialize 2-dimensional led array
var led = [];
for (var y=0;y<8;y++) {
  led[y] = [];
  for (var x=0;x<16;x++)
    led[y][x] = 0;
}

// refresh leds with a pattern
function refresh() {
  led[0][0] = 15;
  led[2][0] = 5;
  led[0][2] = 5;
  grid.refresh(led);
}

// call refresh() function 60 times per second
setInterval(refresh, 1000 / 60);

// set up key handler
grid.key(function (x, y, s) {
  console.log('key received: ' + x + ', ' + y + ', ' + s);
});
