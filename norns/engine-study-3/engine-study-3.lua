-- *transit authority*
-- SuperCollider engine study 3
-- monome.org

engine.name = "FXBusDemo"
local formatters = require("formatters")

-- NEW: add LFO for additional movement:
local lfo = require("lib/lfo")

-- NEW: add sequins to sequence hz values
local _s = require("sequins")
local hz_vals = _s({ 300, 400, 400 / 3, 100, 300 / 2, 300 / 1.5 })
local random_offset = { 0.5, 1.5, 2, 3, 1, 0.75 }

-- NEW: add screen redraw variables
local bright = 1
local rad = 2
local screen_dirty = true
local hz = 330

function clock.tempo_change_handler(x)
	engine.set_delay_time(clock.get_beat_sec() / 2)
end

function init()
	-- NEW: invoke our brightness poll //
	brightness = poll.set("brightness_poll")
	brightness.callback = function(val)
		bright = util.round(util.linlin(20, 20000, 1, 15, val))
		screen_dirty = true
	end
	brightness.time = 1 / 60
	brightness:start()
	-- // brightness poll

	-- NEW: invoke our amp poll //
	amp = poll.set("amp_poll")
	amp.callback = function(val)
		rad = util.round(util.linlin(0, 1, 2, 120, val))
		screen_dirty = true
	end
	amp.time = 1 / 30
	amp:start()
	-- // amp poll

	-- NEW: redraw at 60fps //
	redraw_timer = metro.init(function()
		if screen_dirty then
			redraw()
			screen_dirty = false
		end
	end, 1 / 60, -1)
	redraw_timer:start()
	-- // redraw

	-- NEW: synth controls //
	params:add({
		type = "separator",
		id = "synth_separator",
		name = "synth",
	})

	params:add({
		type = "control",
		id = "fchz",
		name = "filter hz",
		controlspec = controlspec.FREQ,
		action = function(x)
			if fchzLFO.enabled == 0 then
				engine.set_synth("fchz", x)
			end
      fchz_raw = params:get_raw("fchz")
		end,
	})
	-- // synth controls

	local cs_amp = controlspec.new(0, 2, "lin", 0.001, 1, nil, 1 / 200)
	local cs_fc1 = controlspec.new(20, 20000, "exp", 0, 600, "Hz")
	local cs_fc2 = controlspec.new(20, 20000, "exp", 0, 1800, "Hz")
	local cs_pan = controlspec.new(-1, 1, "lin", 0.001, 0, nil, 1 / 200)

	local frm_percent = function(param)
		return ((param:get() * 100) .. "%")
	end

	params:add({
		type = "separator",
		id = "levels_separator",
		name = "levels",
	})

	params:add({
		type = "control",
		id = "dry_level",
		name = "dry level",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_level("dry", x)
		end,
	})

	params:add({
		type = "control",
		id = "delay_level",
		name = "delay level",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_level("delay_send", x)
		end,
	})

	params:add({
		type = "control",
		id = "reverb_level",
		name = "reverb level",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_level("reverb_send", x)
		end,
	})

	params:add({
		type = "separator",
		id = "pan_separator",
		name = "panning",
	})

	params:add({
		type = "control",
		id = "dry_pan",
		name = "dry",
		controlspec = cs_pan,
		formatter = formatters.bipolar_as_pan_widget,
		action = function(x)
			engine.set_pan("dry", x)
		end,
	})

	params:add({
		type = "control",
		id = "delay_pan",
		name = "delay",
		controlspec = cs_pan,
		formatter = formatters.bipolar_as_pan_widget,
		action = function(x)
			engine.set_pan("delay_send", x)
		end,
	})

	params:add({
		type = "control",
		id = "reverb_pan",
		name = "reverb",
		controlspec = cs_pan,
		formatter = formatters.bipolar_as_pan_widget,
		action = function(x)
			engine.set_pan("reverb_send", x)
		end,
	})

	params:add({
		type = "separator",
		id = "main_eq_separator",
		name = "main EQ",
	})

	params:add({
		type = "control",
		id = "eq_lo",
		name = "lo",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_main("ampLo", x)
		end,
	})

	params:add({
		type = "control",
		id = "eq_mid",
		name = "mid",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_main("ampMid", x)
		end,
	})

	params:add({
		type = "control",
		id = "eq_hi",
		name = "hi",
		controlspec = cs_amp,
		formatter = frm_percent,
		action = function(x)
			engine.set_main("ampHi", x)
		end,
	})

	params:add({
		type = "control",
		id = "fc1",
		name = "lo freq",
		controlspec = cs_fc1,
		action = function(x)
			engine.set_main("fc1", x)
		end,
	})

	params:add({
		type = "control",
		id = "fc2",
		name = "hi freq",
		controlspec = cs_fc2,
		action = function(x)
			engine.set_main("fc2", x)
		end,
	})

	-- NEW: add 'fchz' LFO
  fchz_spec = params:lookup_param("fchz").controlspec
	fchzLFO = lfo:add({
		shape = "sine", -- shape
		min = -1, -- min
		max = 1, -- max
		depth = 0.6, -- depth (0 to 1)
		mode = "clocked", -- mode
		period = 1 / 3, -- period (in 'clocked' mode, represents 4/4 bars)
		baseline = "center",
		action = function()
			engine.set_synth(
        "fchz",
        calculate_bipolar_lfo_movement(fchzLFO, "fchz")
      )
		end,
	})
	fchzLFO:add_params("myLFO", "lfo")
	params:hide("lfo_min_myLFO")
	params:hide("lfo_max_myLFO")
	_menu.rebuild_params()

	startup_actions = clock.run(function()
		clock.sleep(0.1)
		params:set("delay_level", 1)
		params:set("reverb_level", 0)
		params:set("fchz", 1500)
		params:bang()
		-- NEW: sequins clock
		sequence = clock.run(function()
			while true do
				engine.set_synth("hz", hz_vals() * random_offset[math.random(#random_offset)])
				clock.sync(1 / 4)
			end
		end)
		fchzLFO:start() -- start our LFO, complements ':stop()'
	end)
end

function calculate_bipolar_lfo_movement(lfoID, paramID)
	if lfoID:get("depth") > 0 then
		return fchz_spec:map(lfoID:get("scaled") / 2 + fchz_raw)
	else
		return fchz_spec:map(fchz_raw)
	end
end

-- NEW: draw to screen //
function redraw()
	screen.clear()
	screen.level(bright)
	screen.circle(64, 32, rad)
	screen.fill()
	screen.update()
end
-- // draw to screen
