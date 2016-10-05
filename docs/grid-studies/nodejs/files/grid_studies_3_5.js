var grid = require('monome-grid')();
var easymidi = require('easymidi');

var output = new easymidi.Output('grid out', true);
var input = new easymidi.Input('grid in', true);

var dirty = true;
var step = create2DArray(6, 16);
var play_position = 0;
var loop_start = 0;
var loop_end = 15;
var cutting = false;
var next_position = 0;
var keys_held = 0;
var key_last = 0;
var ticks = 0;

input.on('clock', function () {
  ticks++;
  if(ticks % 12 != 0)
    return;

  if(cutting)
    play_position = next_position;
  else if(play_position == 15)
    play_position = 0;
  else if(play_position == loop_end)
    play_position = loop_start;
  else
    play_position++;

  // TRIGGER SOMETHING
  var last_play_position = play_position - 1;
  if(last_play_position == -1)
    last_play_position = 15;
  for(var y=0;y<6;y++) {
    if(step[y][last_play_position] == 1)
      trigger('noteoff', y);
    if(step[y][play_position] == 1)
      trigger('noteon', y);
  }

  cutting = false;
  dirty = true;
});

input.on('start', function () {
  for(var y=0;y<6;y++)
    if(step[y][play_position] == 1)
      trigger('noteon', y);
});

input.on('position', function (data) {
  if(data.value != 0)
    return;
  ticks = 0;
  play_position = 0;
  if(loop_start)
    play_position = loop_start;
  dirty = true;
});

// refresh leds with a pattern
function refresh() {
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

    // draw play position
    led[7][play_position] = 15;

    // update grid
    grid.refresh(led);
    dirty = false;
  }
}

setInterval(refresh, 1000 / 60);

function trigger(type, i) {
  output.send(type, {
    note: 36 + i,
    velocity: 127,
    channel: 0
  });
}

// set up key handler
grid.key(function (x, y, s) {
  if(s == 1 && y < 6) {
    step[y][x] ^= 1;
    dirty = true;
  }
  // cut and loop
  else if(y == 7) {
    // track number of keys held
    keys_held = keys_held + (s*2) - 1;

    // cut
    if(s == 1 && keys_held == 1) {
      cutting = true;
      next_position = x;
      key_last = x;
    }
    // set loop points
    else if(s == 1 && keys_held == 2) {
      loop_start = key_last;
      loop_end = x;
    }
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

process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);

function cleanup() {
  output.close();
  input.close();
  process.exit();
}
