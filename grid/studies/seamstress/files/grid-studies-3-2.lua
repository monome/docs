-- grid studies: seamstress
-- grid-study-3-2.lua

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

  sequencer_rows = rows - 1

  step = {}
  for r = 1, rows do
    step[r] = {}
    for c = 1, cols do
      step[r][c] = 0
    end
  end

  -- NEW //
  play_position = 0
  -- // NEW
  playhead = clock.run(play)
  grid_dirty = true
  grid_redraw = metro.init(
    draw_grid, -- function to execute
    1 / 60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  grid_redraw:start() -- start the timer
end

function redraw()
  screen.clear()
  screen.move(10, 10)
  screen.color(255, 255, 255, 255) -- RGBA, A is optional
  screen.text("grid connected: " .. tostring(grid_connected))
  screen.refresh()
end

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  sequencer_rows = rows - 1
  grid_connected = true
  redraw()
end

function grid.remove(dev)
  grid_connected = false
  redraw()
end

function play()
  while true do
    -- perform actions
    -- NEW //
    play_position = util.wrap(play_position + 1, 1, cols)
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end

function g.key(x, y, z)
  if z == 1 and y <= sequencer_rows then
    -- when step value is 0, set it to 1 ; when step value is 1, set it to 0
    step[y][x] = math.abs(step[y][x] - 1)
  end
  grid_dirty = true
end

function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs:
    for x = 1, cols do
      -- NEW //
      local highlight
      if x == play_position then
        highlight = 4
      else
        highlight = 0
      end
      for y = 1, rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end
      -- // NEW
    end
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
