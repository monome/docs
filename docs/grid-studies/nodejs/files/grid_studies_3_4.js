const monomeGrid = require('monome-grid');

let dirty = true;
let step = create2DArray(6, 16);
let timer = 0;
let play_position = 0;
let loop_start = 0;
let loop_end = 15;
const STEP_TIME = 10;
let cutting = false;
let next_position = 0;
let keys_held = 0;
let key_last = 0;

function create2DArray(sizeY, sizeX) {
  let arr = [];
  for (let y=0;y<sizeY;y++) {
    arr[y] = [];
    for (let x=0;x<sizeX;x++)
      arr[y][x] = 0;
  }
  return arr;
}

async function run() {
  let grid = await monomeGrid(); // optionally pass in grid identifier

  // refresh leds with a pattern
  let refresh = function() {
    if(timer == STEP_TIME) {
      if(cutting)
        play_position = next_position;
      else if(play_position == 15)
        play_position = 0;
      else if(play_position == loop_end)
        play_position = loop_start;
      else
        play_position++;

      // TRIGGER SOMETHING
      for(let y=0;y<6;y++) {
        if(step[y][play_position] == 1) {
          trigger(y);
        }
      }

      cutting = false;
      timer = 0;
      dirty = true;
    }
    else timer++;

    if(dirty) {
      let led = create2DArray(8, 16);
      let highlight = 0;

      // display steps
      for (let x=0;x<16;x++) {
        // highlight the play position
        if(x == play_position)
          highlight = 4;
        else
          highlight = 0;

        for (let y=0;y<6;y++)
          led[y][x] = step[y][x] * 11 + highlight;
      }

      // draw trigger bar and on-states
      for(let x=0;x<16;x++) {
        led[6][x] = 4;
      }

      for(let y=0;y<6;y++) {
        if(step[y][play_position] == 1) {
          led[6][y] = 15;
        }
      }

      // draw play position
      led[7][play_position] = 15;

      // update grid
      grid.refresh(led);
      dirty = false;
    }
  }

  // call refresh() function 60 times per second
  setInterval(refresh, 1000 / 60);

  let trigger = function(i) {
    console.log(`trigger at ${i}`);
  }

  // set up key handler
  grid.key((x, y, s) => {
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
}

run();
