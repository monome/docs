const monomeGrid = require('monome-grid');

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

  let dirty = true;
  let step = create2DArray(6, 16);

  // refresh leds with a pattern
  let refresh = function() {
    if(dirty) {
      let led = create2DArray(8, 16);

      // display steps
      for (let x=0;x<16;x++)
        for (let y=0;y<6;y++)
          led[y][x] = step[y][x] * 15;

      // update grid
      grid.refresh(led);
      dirty = false;
    }
  }

  // call refresh() function 60 times per second
  setInterval(refresh, 1000 / 60);

  // set up key handler
  grid.key((x, y, s) => {
    if(s == 1 && y < 6) {
      step[y][x] ^= 1;
      dirty = true;
    }
  });
}

run();

