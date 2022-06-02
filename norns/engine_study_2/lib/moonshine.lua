-- this file easily adds Moonshine parameters to a host script
-- save it as 'moonshine.lua' under 'code > engine_study > lib'

local Moonshine = {}
local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

-- helper function to round and format parameter value text:
function round_form(param,quant,form)
  return(util.round(param,quant)..form)
end

-- first, we'll collect all of our commands into a table of norns-friendly ranges.
-- since all the voices share the same parameter names,
--   we can just iterate on this table and cleanly build 16 parameters across 9 voices.
local specs = {
  {type = "separator", name = "synthesis"},
  {id = 'amp', name = 'level', type = 'control', min = 0, max = 2, warp = 'lin', default = 1, formatter = function(param) return (round_form(param:get()*100,1,"%")) end},
  {id = 'sub_div', name = 'sub division', type = 'number', min = 1, max = 10, default = 1},
  {id = 'noise_amp', name = 'noise level', type = 'control', min = 0, max = 2, warp = 'lin', default = 0, formatter = function(param) return (round_form(param:get()*100,1,"%")) end},
  {id = 'cutoff', name = 'filter cutoff', type = 'control', min = 20, max = 24000, warp = 'exp', default = 1200, formatter = function(param) return (round_form(param:get(),0.01," hz")) end},
  {id = 'cutoff_env', name = 'filter envelope', type = 'number', min = 0, max = 1, default = 1, formatter = function(param) return (param:get() == 1 and "on" or "off") end},
  {id = 'resonance', name = 'filter q', type = 'control', min = 0, max = 4, warp = 'lin', default = 2, formatter = function(param) return (round_form(util.linlin(0,4,0,100,param:get()),1,"%")) end},
  {id = 'attack', name = 'attack', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'release', name = 'release', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.3, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'pan', name = 'pan', type = 'control', min = -1, max = 1, warp = 'lin', default = 0, formatter = Formatters.bipolar_as_pan_widget},
  {type = "separator", name = "slews"},
  {id = 'freq_slew', name = 'frequency slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'amp_slew', name = 'level slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'noise_slew', name = 'noise level slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.05, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
  {id = 'pan_slew', name = 'pan slew', type = 'control', min = 0.001, max = 10, warp = 'exp', default = 0.5, formatter = function(param) return (round_form(param:get(),0.01," s")) end},
}

-- initialize parameters:
function Moonshine.add_params()
  params:add_separator("Moonshine")
  local voices = {"all",1,2,3,4,5,6,7,8} -- match the engine's expected arguments for commands
  for i = 1,#voices do -- for each voice...
    params:add_group("voice ["..voices[i].."]",#specs) -- add a PARAMS group, eg. 'voice [all]'
    for j = 1,#specs do -- for each of the lines in the 'specs' table above, do this:
      local p = specs[j] -- (creates an alias for the line's contents)
      if p.type == 'control' then -- if the 'type' in the current 'specs' line is 'control', do this:
        params:add_control( -- add a control using:
          voices[i].."_"..p.id, -- the 'id' in the line
          p.name, -- the name in the line
          ControlSpec.new(p.min, p.max, p.warp, 0, p.default), -- the controlspec values in the line ('min', 'max', 'warp', and 'default')
          p.formatter -- the formatter in the line
        )
      elseif p.type == 'number' then -- otherwise, if the 'type' is 'number', do this:
        params:add_number(
          voices[i].."_"..p.id,
          p.name,
          p.min,
          p.max,
          p.default,
          p.formatter
        )
      elseif p.type == "option" then -- otherwise, if the 'type' is 'option', do this:
        params:add_option(
          voices[i].."_"..p.id,
          p.name,
          p.options,
          p.default
        )
      elseif p.type == 'separator' then -- otherwise, if the 'type' is 'separator', do this:
        params:add_separator(p.name)
      end
      
      -- if the parameter type isn't a separator, then we want to assign it an action to control the engine:
      if p.type ~= 'separator' then
        params:set_action(voices[i].."_"..p.id, function(x)
          -- use the line's 'id' as the engine command, eg. engine.amp or engine.cutoff_env,
          --  and send the voice and the value:
          engine[p.id](voices[i],x) -- 
          if voices[i] == "all" then -- it's nice to echo 'all' changes back to the parameters themselves
            -- since 'all' voice corresponds to the first entry in 'voices' table,
            --   we iterate the other parameter groups as 2 through 9:
            for other_voices = 2,9 do
              -- send value changes silently, since 'all' changes all values on SuperCollider's side:
              params:set(voices[other_voices].."_"..p.id, x, true)
            end
          end
        end)
      end
      
    end
  end
  -- activate the parameters' current values:
  params:bang()
end

 -- we return these engine-specific Lua functions back to the host script:
return Moonshine