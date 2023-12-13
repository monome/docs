-- norns engine study 3: Busses

engine.name = "FXBusDemo"
formatters = require("formatters")

function init()
  default_vals = {
    amp = {
      min = 0,
      max = 2,
      default = 1,
      quantum = 1 / 200,
      step = 0.001,
      formatter = function(param)
        return ((param:get() * 100) .. "%")
      end,
    },
    pan = {
      min = -1,
      max = 1,
      default = 0,
      quantum = 1 / 200,
      step = 0.001,
      formatter = formatters.bipolar_as_pan_widget,
    },
  }

  level_params = {
    { type = "separator", id = "levels_separator", name = "levels" },
    {
      id = "dry_level",
      name = "dry level",
      action_key = "dry",
    },
    {
      id = "delay_level",
      name = "delay level",
      action_key = "delay_send",
    },
    {
      id = "reverb_level",
      name = "reverb level",
      action_key = "reverb_send",
    },
  }

  pan_params = {
    { type = "separator", id = "pan_separator", name = "panning" },
    {
      id = "dry_pan",
      name = "dry pan",
      action_key = "dry",
    },
    {
      id = "delay_pan",
      name = "delay pan",
      action_key = "delay_send",
    },
    {
      id = "reverb_pan",
      name = "reverb pan",
      action_key = "reverb_send",
    },
  }

  eq_params = {
    { type = "separator", id = "main_separator", name = "main EQ" },
    {
      id = "ampLo",
      name = "lo",
    },
    {
      id = "ampMid",
      name = "mid",
    },
    {
      id = "ampHi",
      name = "hi",
    },
  }

  for i = 1, #level_params do
    local d = level_params[i]
    local dv = default_vals.amp
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_level(d.action_key, x)
      end)
    end
  end

  for i = 1, #pan_params do
    local d = pan_params[i]
    local dv = default_vals.pan
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_pan(d.action_key, x)
      end)
    end
  end

  for i = 1, #eq_params do
    local d = eq_params[i]
    local dv = default_vals.amp
    if d.type == "separator" then
      params:add_separator(d.id, d.name)
    else
      params:add_control(
        d.id,
        d.name,
        controlspec.new(dv.min, dv.max, "lin", dv.step, dv.default, nil, dv.quantum),
        dv.formatter
      )
      params:set_action(d.id, function(x)
        engine.set_main(d.id, x)
      end)
    end
  end

  params:set("delay_level", 0)
  params:set("reverb_level", 0)

  params:bang()
end
