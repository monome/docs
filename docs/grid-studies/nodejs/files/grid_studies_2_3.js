const monomeGrid = require('monome-grid');

async function run() {
  let grid = await monomeGrid(); // optionally pass in grid identifier


  // initialize 2-dimensional led array
  let led = [];
  for (let y=0;y<8;y++) {
    led[y] = [];
    for (let x=0;x<16;x++)
      led[y][x] = 0;
  }

  let dirty = true;

  // refresh leds with a pattern
  let refresh = function() {
    if(dirty) {
      grid.refresh(led);
      dirty = false;
    }
  }

  // call refresh() function 60 times per second
  setInterval(refresh, 1000 / 60);

  // set up key handler
  grid.key((x, y, s) => {
    led[y][x] = s * 15;
    dirty = true;
  });
}

run();
