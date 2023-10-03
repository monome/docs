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

  sequencer_rows = rows - 2

  step = {}
  for r = 1, rows do
    step[r] = {}
    for c = 1, cols do
      step[r][c] = 0
    end
  end

  play_position = 0
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
  sequencer_rows = rows - 2
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
    for y = 1,rows do
      if step[y][play_position] == 1 then
        trigger(y)
      end
    end
    -- // NEW
    clock.sync(1 / 4)
    grid_dirty = true
  end
end

-- NEW //
function trigger(i)
  screen.clear()
  screen.move(math.random(256), math.random(128))
  screen.color(math.random(255), math.random(255), 255)
  screen.circle(i * 10)
  screen.circle_fill(i * 5)
  screen.refresh()
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
      -- trigger bar
      local trig_bar = sequencer_rows + 1
      g:led(x, trig_bar, 4)
      -- // NEW

      for y = 1, sequencer_rows do
        g:led(x, y, step[y][x] * 11 + highlight)
      end
    end

    -- NEW //
    for y = 1, sequencer_rows do
      local trig_bar = sequencer_rows+1
      if step[y][play_position] == 1 then
        g:led(play_position, trig_bar, 15)
      end
    end
    -- // NEW
    
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end
