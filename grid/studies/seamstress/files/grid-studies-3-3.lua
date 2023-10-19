-- grid studies: seamstress
-- grid-study-3-3.lua

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
  circle_queue = {}
  screen_dirty = true
  screen_redraw = metro.init(
    redraw, -- function to execute
    1 / 30, -- how often (here, 30 fps)
    -1 -- how many times (here, forever)
  )
  screen_redraw:start() -- start the timer
  -- // NEW

  play_position = 0
  playhead = clock.run(play)
  grid_dirty = true
  grid_redraw = metro.init(draw_grid, 1 / 60, -1)
  grid_redraw:start()
end

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  sequencer_rows = rows - 1
  grid_connected = true
end

function grid.remove(dev)
  grid_connected = false
end

function play()
  while true do
    -- perform actions
    play_position = util.wrap(play_position + 1, 1, cols)
    -- NEW //
    for y = 1, rows do
      if step[y][play_position] == 1 then
        trigger(y)
      end
    end
    screen_dirty = true
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end

-- NEW //
function trigger(i)
  table.insert(circle_queue, {
    x = math.random(256),
    y = math.random(128),
    r = math.random(40, 190),
    g = math.random(255),
    b = math.random(128, 255),
    outer_radius = i * 10,
    inner_radius = i * 5,
  })
end

function redraw()
  if screen_dirty then
    screen.clear()
    for k, v in pairs(circle_queue) do
      screen.move(v.x, v.y)
      screen.color(v.r, v.g, v.b)
      screen.circle(v.outer_radius)
      screen.circle_fill(v.inner_radius)
    end
    circle_queue = {}
    screen_dirty = false
    screen.refresh()
  end
end
-- // NEW

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
    -- queue grid LEDs
    -- display steps:
    for x = 1, cols do
      local highlight
      if x == play_position then
        highlight = 4
      else
        highlight = 0
      end

      -- NEW //
      -- jump row
      local jump_row = sequencer_rows + 1
      g:led(x, jump_row, 4)

      -- sequencer rows:
      for y = 1, sequencer_rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end

      -- // NEW
    end

    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
