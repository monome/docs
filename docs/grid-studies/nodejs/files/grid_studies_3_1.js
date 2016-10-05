var grid = require('monome-grid')();

var dirty = true;
var step = create2DArray(6, 16);

// refresh leds with a pattern
function refresh() {
  if(dirty) {
    var led = create2DArray(8, 16);

    // display steps
    for (var x=0;x<16;x++)
      for (var y=0;y<6;y++)
        led[y][x] = step[y][x] * 15;

    // update grid
    grid.refresh(led);
    dirty = false;
  }
}

// call refresh() function 60 times per second
setInterval(refresh, 1000 / 60);

// set up key handler
grid.key(function (x, y, s) {
  if(s == 1 && y < 6) {
    step[y][x] ^= 1;
    dirty = true;
  }
});

function create2DArray(sizeY, sizeX) {
  var arr = [];
  for (var y=0;y<sizeY;y++) {
    arr[y] = [];
    for (var x=0;x<sizeX;x++)
      arr[y][x] = 0;
  }
  return arr;
}
