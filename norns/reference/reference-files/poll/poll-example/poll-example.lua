-- polling example:
-- 
-- draws two circles
--   to represent
--   incoming audio amplitude
-- 
-- see PARAMS for
--   individual channel control

-- https://monome.org/docs/norns/reference/poll

engine.name = 'ExamplePoll'
local pre_init_monitor_level;
local radii = {0,0} -- we'll redraw our circles with outgoing audio levels for each channel

local function amp_handler(which,val)
  radii[which] = util.linlin(0,1,0,70,val)
  screen_dirty = true
end

function init()

  -- assign our polls
  ampL = poll.set('outputAmpL')
  ampL.callback = function(val) amp_handler(1, val) end -- what to do with the value returned by SuperCollider
  ampL.time = 1/60 -- how often to refresh (norns redraws at 60fps)
  ampL:start() -- start the poll!
  
  ampR = poll.set('outputAmpR')
  ampR.callback = function(val) amp_handler(2, val) end
  ampR.time = 1/60 -- how often to refresh (norns redraws at 60fps)
  ampR:start() -- start the poll!
  
  screen_redraw = clock.run(
    function()
      while true do
        clock.sleep(1/15)
        if screen_dirty then
          redraw()
          screen_dirty = false
        end
      end
    end
  )
  
  pre_init_monitor_level = params:get('monitor_level')
  params:set('monitor_level',-inf)
  
  local function strip_trailing_zeroes(s)
    return string.format('%.2f', s):gsub("%.?0+$", "")
  end
  
  params:add_separator('header', 'engine controls')
  
  -- each side has an amp value:
  local sides = {'L', 'R'}
  for i = 1,2 do
    params:add_control(
      'eng_amp'..sides[i], -- ID
      'amp '..sides[i], -- display name
      controlspec.new(
        0, -- min
        2, -- max
        'lin', -- warp
        0.001, -- output quantization
        1, -- default value
        '', -- string for units
        0.005 -- adjustment quantization
      ),
      -- params UI formatter:
      function(param)
        return strip_trailing_zeroes(param:get()*100)..'%'
      end
    )
    
    params:set_action('eng_amp'..sides[i],
      function(x)
        engine.amp(sides[i],x)
      end
    )
  end
  
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.circle(30,32,radii[1])
  screen.stroke()
  screen.circle(98,32,radii[2])
  screen.stroke()
  screen.update()
end

function cleanup()
  params:set('monitor_level', pre_init_monitor_level) -- restore 'monitor' level
end