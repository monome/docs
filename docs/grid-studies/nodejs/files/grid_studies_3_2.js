const monomeGrid = require('monome-grid');

let dirty = true;
let step = create2DArray(6, 16);
let timer = 0;
let play_position = 0;
const STEP_TIME = 10;

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
      if(play_position == 15)
        play_position = 0;
      else
        play_position++;

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

      // update grid
      grid.refresh(led);
      dirty = false;
    }
  }

  // call refresh() function 60 times per second
  setInterval(refresh, 1000 / 60);

  // set up key handler
  grid.key((x, y, s) =>  {
    if(s == 1 && y < 6) {
      step[y][x] ^= 1;
      dirty = true;
    }
  });
}

run();
