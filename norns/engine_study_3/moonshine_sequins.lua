engine.name = 'Moonshine'

moonshine_setup = include 'lib/moonshine'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'
-- see https://monome.org/docs/norns/reference/lib/sequins for more info

function init()
  moonshine_setup.add_params()
  mults = {
    s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} }, -- create a sequins of hz multiples for voice 1
    s{0.25, 1.25, s{2/3, 3.5, 1/3} }, -- create a sequins of hz multiples for voice 2
    s{2, 1.25, s{3.5, 1.5, 2.25, 0.5} } -- create a sequins of hz multiples for voice 3
  }
  playing = false
  base_hz = 200
  sequence = {}
  sequence[1] = clock.run(
    function()
      while true do
        clock.sync(1/4)
        if playing then
          for i = 1,2 do
            engine.trig(i, base_hz * mults[i]() * math.random(2))
          end
        end
      end
    end
  )
  
  sequence[2] = clock.run(
    function()
      while true do
        clock.sync(3)
        if playing then
          engine.trig(3, base_hz * mults[3]())
          clock.sync(1)
          engine.freq(3, base_hz * mults[3]())
        end
      end
    end
  )
  
  -- some default parameters:
  for i = 1,2 do
    params:set(i.."_amp",0.65)
    params:set(i.."_attack",0)
    params:set(i.."_release",0.3)
    params:set(i.."_pan",i == 1 and -1 or 1)
    params:set(i.."_cutoff",2300)
  end
  params:set("3_amp",0.55)
  params:set("3_cutoff",16000)
  params:set("3_attack",clock.get_beat_sec()*2.5)
  params:set("3_release",clock.get_beat_sec()*0.75)
  params:set("3_freq_slew",clock.get_beat_sec()/2)
  params:set("3_pan_slew", clock.get_beat_sec()*2)
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    for i = 1,3 do
      mults[i]:reset() -- resets sequins index to 1
    end
    if not playing then
        engine.free_all_notes()
      end
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text(playing and "K3: turn off" or "K3: turn on")
  screen.update()
end