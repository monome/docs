-- grid studies: seamstress
-- grid-study-2-1.lua

g = grid.connect(1) -- '1' is technically optional.
-- without an argument, seamstress will always connect to the first-registered grid.

function init()
  if g then
    cols = g.cols
    rows = g.rows
    grid_connected = true
  else
    cols = 16
    rows = 8
    grid_connected = false
  end

  playhead = clock.run(play)
  grid_dirty = true
  grid_redraw = metro.init(
    draw_grid, -- function to execute
    1 / 60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  grid_redraw:start() -- start the timer
end

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  grid_connected = true
end

function grid.remove(dev)
  grid_connected = false
end

function play()
  while true do
    -- perform actions
    clock.sync(1 / 4)
    grid_dirty = true
  end
end

function g.key(x, y, z)
  -- define grid keypress action
  grid_dirty = true
end

function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
