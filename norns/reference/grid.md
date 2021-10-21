---
layout: default
nav_exclude: true
permalink: /norns/reference/grid
---

## grid

### control

| Syntax                    | Description                                                                                                                        |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| my_grid = grid.connect(n) | Assign this connected grid to a script, defaults to port 1 unless n is specified                                                   |
| my_grid:led(x, y, val)    | Set state of single LED (x is horizontal, y is vertical, 1-indexed) of this connected grid, accepts val 0 (off) - 15 (full bright) |
| my_grid:all(val)          | Set state of all LEDs of this connected grid, expects val 0 (off) - 15 (full bright)                                               |
| my_grid:refresh()         | Update any dirty LEDs on this connected arc                                                                                        |
| my_grid:intensity(i)      | Set LED intensity                                                                                                                  |
| grid.add()                | User script callback when any grid is connected (do not use `my_grid` or custom variable, must be `grid`)                          |
| grid.remove()             | User script callback when any grid is disconnected (do not use `my_grid` or custom variable, must be `grid`)                       |

### query

| Syntax                | Description                                                                              |
| --------------------- | ---------------------------------------------------------------------------------------- |
| my_grid.name          | Returns name of this grid : string                                                       |
| my_grid.device        | If there's a physical grid present at the connected port, this will not be `nil` : table |
| my_grid.device.id     | Returns this grid's id : number                                                          |
| my_grid.device.cols   | Returns this grid's column count : number                                                |
| my_grid.device.rows   | Returns this grid's row count : number                                                   |
| my_grid.device.port   | Returns this grid's port : number                                                        |
| my_grid.device.name   | Returns this grid's name : string                                                        |
| my_grid.device.serial | Returns this grid's serial : string                                                      |

### example

This example is a bit long, but it demonstrates how an entire performance script can be defined in less than 150 lines of code.

We recommend testing it out + interacting with the mechanics before reading:

- run the script + connect a grid -- you'll see a step sequencer set up as 8 unique lanes, each with their own unique pitch

- mash some grid pads to add notes

- use E2 on norns to change the column count (try 5)

- press K2 on norns to randomize each lane's playback

- LEDs too bright? use E3 to turn down the intensity

```lua
-- // grid reference example \\
-- 8 playheads move across grid
-- press a key to add a step
-- 
-- K2: randomize the
--     playback rate
-- E2: clamp the column count
-- E3: change LED intensity

g = grid.connect() -- if no argument is provided, defaults to port 1

engine.name = 'PolyPerc'

MU = require 'musicutil'

function init()

  engine.release(0.2)
  engine.cutoff(1200)

  grid_connected = g.device~= nil and true or false -- ternary operator, eg. http://lua-users.org/wiki/TernaryOperator
  columns = grid_connected and g.device.cols or 16 -- keep track of device columns
  rows = grid_connected and g.device.rows or 8 -- keep track of device rows
  led_intensity = 15 -- scales LED intensity

  notes = {60,61,51,65,48,68,70,77} -- some notes to play

  playheads = {} -- table for playheads
  for i = 1,rows do -- for each row...
    playheads[i] = {} -- create a playhead!
    playheads[i].pos = 1 -- track the position
    playheads[i].rate = 1 -- start rate at 1 beat per step
    playheads[i].data = {} -- for 1's and 0's
    for j = 1,columns do
      playheads[i].data[j] = 0 -- start with 0's in every step
    end
    playheads[i].clock = clock.run(
      function()
        while true do
          clock.sync(playheads[i].rate) -- sync to playhead rate
          playheads[i].pos = util.wrap(playheads[i].pos+1,1,columns) -- advance playhead position
          if playheads[i].data[playheads[i].pos] == 1 then -- if data at this position equals 1...
            engine.hz(MU.note_num_to_freq(notes[i])) -- play note!
          end
          grid_dirty = true -- redraw grid!
        end
      end
      )
  end

  -- common redraw function:
  redraw_clock = clock.run(
    function()
      while true do
        clock.sleep(1/15)
        if screen_dirty then
          redraw()
        end
        if grid_dirty then
          grid_redraw()
        end
      end
    end
  )
  grid_dirty = true -- use flags to keep track of whether hardware needs to be redrawn
  screen_dirty = true
end

function grid_redraw()
  if grid_connected then -- only redraw if there's a grid connected
    g:all(0) -- turn all the LEDs off
    for x = 1,columns do -- for each column...
      for y = 1,rows do -- for each row...

        -- g:led(x,y,playheads[y].data[x] == 1 and (playheads[y].pos == x and 15 or 12) or (playheads[y].pos == x and 8 or 0))
        -- ^^ this one line summarizes the next 12 lines!!! wild!!

        if playheads[y].pos == x then -- if the playhead crosses...
          if playheads[y].data[x] == 1 then -- an active step...
            g:led(x,y,15) -- full-bright
          else -- if step is non-active
            g:led(x,y,8) -- semi-bright
          end
        else -- if not current playhead step...
          if playheads[y].data[x] == 1 then-- an active step...
            g:led(x,y,12) -- near-full
          else -- not an active step
            g:led(x,y,2) -- low
          end
        end
      end
    end
    g:intensity(led_intensity) -- change intensity
    g:refresh() -- refresh the LEDs
  end
  grid_dirty = false -- reset the flag because changes have been committed
end

function g.key(x,y,z)
  if z == 1 then -- if we press any grid key
    playheads[y].data[x] = playheads[y].data[x] == 0 and 1 or 0 -- ternary operator again! if data is 0, flip to 1 + vice versa
    grid_dirty = true -- enable flag to redraw grid, because data has changed
  end
end

function enc(n,d)
  if n == 3 then -- if encoder 3, then...
    led_intensity = util.clamp(led_intensity + d,0,15) -- change LED intensity (within 0 to 15 range)
  elseif n == 2 then -- if encoder 2 then
    columns = util.clamp(columns+d,1,16) -- change our column count (within 1 and 16)
  end
  grid_dirty = true -- enable flag to redraw grid, because data has changed
  screen_dirty = true -- enable flag to redraw screen, because data has changed
end

function key(n,z)
  if n == 2 and z == 1 then -- if key 2 is pressed down then...
    for i = 1,#playheads do -- for each playhead (we don't know how many, because it's based on the connected grid)
      playheads[i].rate = math.random(i*2) / math.random(i*3) -- randomize the playback rate for each
    end
    engine.pw(math.random(90)/100) -- change the pulse width
  elseif n == 3 and z == 1 then -- if key 3 is pressed down then...
    for i = 1,#playheads do -- for each playhead (we don't know how many, because it's based on the connected grid)
      playheads[i].pos = 1 -- reset to step 1
    end
  end
  grid_dirty = true -- enable flag to redraw grid, because data has changed
end

function redraw()
  screen.clear() -- clear screen
  screen.move(0,10)
  screen.text("K2: RANDOMIZE RATES")
  screen.move(0,20)
  screen.text("K3: RESET TO STEP 1")
  screen.move(128,54)
  screen.text_right("E2: # OF COLUMNS ("..columns..")")
  screen.move(128,64)
  screen.text_right("E3: INTENSITY ("..led_intensity..")")
  screen.update()
  screen_dirty = false
end

function grid.add(new_grid) -- must be grid.add, not g.add (this is a function of the grid class)
  print(new_grid.name.." says 'hello!'")
   -- each grid added can be queried for device information:
  print("new grid found at port: "..new_grid.port)
  g = grid.connect(new_grid.port) -- connect script to the new grid
  grid_connected = true -- a grid has been connected!
  grid_dirty = true -- enable flag to redraw grid, because data has changed
end

function grid.remove(g) -- must be grid.remove, not g.remove (this is a function of the grid class)
  print(g.name.." says 'goodbye!'")
end
```

### description

Connects a script to a monome [grid](https://monome.org/docs/grid), adding a matrix of re-definable buttons and LEDs to control and display components of your script.
