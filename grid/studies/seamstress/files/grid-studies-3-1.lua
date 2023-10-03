-- grid studies: seamstress
-- grid-study-3-1.lua

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

	-- NEW //
	sequencer_rows = rows - 2

	step = {}
	for r = 1, rows do
		step[r] = {}
		for c = 1, cols do
			step[r][c] = 0
		end
	end
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

function grid.add(dev)
  cols = dev.cols
  rows = dev.rows
  -- NEW //
  sequencer_rows = rows - 2
  -- // NEW
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
  -- NEW //
  if z == 1 and y <= sequencer_rows then
    -- when step value is 0, set it to 1 ; when step value is 1, set it to 0
    step[y][x] = math.abs(step[y][x] - 1)
  end
  -- // NEW
  grid_dirty = true
end

function draw_grid()
  if grid_dirty then
    g:all(0) -- clear grid LEDs
    -- queue grid LEDs:
    -- NEW //
    for x = 1, cols do
      for y = 1, rows do
        g:led(x, y, step[y][x] * 11)
      end
    end
    -- // NEW
    g:refresh() -- draw grid LEDs
    grid_dirty = false -- reset flag
  end
end