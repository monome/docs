var grid = require('monome-grid')();

var dirty = true;
var step = create2DArray(6, 16);
var timer = 0;
var play_position = 0;
var STEP_TIME = 10;

// refresh leds with a pattern
function refresh() {
  if(timer == STEP_TIME) {
    if(play_position == 15)
      play_position = 0;
    else
      play_position++;

    // TRIGGER SOMETHING
    for(var y=0;y<6;y++)
      if(step[y][play_position] == 1)
        trigger(y);

    timer = 0;
    dirty = true;
  }
  else timer++;

  if(dirty) {
    var led = create2DArray(8, 16);
    var highlight = 0;

    // display steps
    for (var x=0;x<16;x++) {
      // highlight the play position
      if(x == play_position)
        highlight = 4;
      else
        highlight = 0;

      for (var y=0;y<6;y++)
        led[y][x] = step[y][x] * 11 + highlight;
    }

    // draw trigger bar and on-states
    for(var x=0;x<16;x++)
      led[6][x] = 4;
    for(var y=0;y<6;y++)
      if(step[y][play_position] == 1)
        led[6][y] = 15;

    // update grid
    grid.refresh(led);
    dirty = false;
  }
}

// call refresh() function 60 times per second
setInterval(refresh, 1000 / 60);

function trigger(i) {
  console.log('trigger at ' + i);
}

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
