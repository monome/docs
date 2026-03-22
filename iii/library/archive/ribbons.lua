
notes = {
{0, 2, 3, 5, 7, 8, 11, 12},
{0, 2, 3, 5, 7, 9, 11, 12},
{0, 2, 3, 5, 7, 9, 10, 12},
{0, 1, 3, 5, 7, 8, 10, 12},
{0, 2, 4, 6, 7, 9, 11, 12},
{0, 2, 4, 5, 7, 9, 10, 12},
{0, 1, 3, 5, 6, 8, 10, 12}}

function note(z)
	return notes[scale][(z+6)%7+1] + math.floor((z-1)/7)*12
end

function er(k, n)
   w = w or 0
   local r = {}
   if k<1 then return r end
   local b = n
   for i=1,n do
      if b >= n then
         b = b - n
         local j = i
         while (j > n) do j = j - n end
         while (j < 1) do j = j + n end
         table.insert(r,j)
      end
      b = b + k
   end
   return r
end

scale = 1
dir = 1
alt = false
tempo = 150
pol = true
midi_root = 48

divs = {0.25,0.5,1,2,3,4,6,8}
divi = 6
div = divs[divi]

ribbon = {{},{},{}}
now = {{},{},{}}
for i=1,3 do
	ribbon[i].offset = 0
	ribbon[i].steps = 3 
	ribbon[i].span = 14
	ribbon[i].range = 16
	ribbon[i].notes = {}
	now[i].pos = 1
	now[i].on = false
	now[i].note = 0
end

function regen(x)
	local n = er(ribbon[x].steps,ribbon[x].span)
	ribbon[x].notes = {}
	for i = 1,ribbon[x].steps do
		local z = ((n[i]+ribbon[x].range-1) % ribbon[x].range + 1) + ribbon[x].offset
		ribbon[x].notes[i] = note(z)
	end
	--pt(ribbon[x].notes)
end

function init()
	for i=1,4 do arc_res(i,16) end
	regen(1)
	m = metro.new(tick,60000/(tempo*div))
	--m = metro.new(tick,80)
	r = metro.new(re,25)
end

function re()
	if dirty then
		dirty = false
		redraw()
	end
end

function set_tempo()
	div = divs[divi]
	--print(60000/(tempo*div))
	metro_set(m,math.floor(60000/(tempo*div)))
end

function arc(n,d)
	if not alt then
		if n==1 then
			ribbon[1].offset = clamp(ribbon[1].offset + d, 0, 16)
		elseif n==2 then
			ribbon[1].steps = clamp(ribbon[1].steps + d, 2, ribbon[1].span)
		elseif n==3 then
			ribbon[1].range = clamp(ribbon[1].range + d, 1, 48)
		elseif n==4 then
			tempo = clamp(tempo + d, 60, 320)
			set_tempo()
		end
	else
		if n==1 then
			scale = clamp(scale+d,1,7)
		elseif n==2 then
			ribbon[1].span = clamp(ribbon[1].span + d, 2, 48)
			ribbon[1].steps = clamp(ribbon[1].steps, 2, ribbon[1].span)
		elseif n==3 then
			if d>0 then dir = 1 else dir = -1 end
		elseif n==4 then
			midi_root = clamp(midi_root + d, 20,72)
			regen(1)
		end
	end
	regen(1)
	dirty = true
end


function arc_key(z)
	if z == 1 then
		km = metro.new(key_timer,500,1)
		alt = true
		dirty = true
	elseif km then
		print("keyshort")
		metro.stop(km)
		alt = false
	else
		alt = false
	end
end

function key_timer()
	--print("keylong!")
	metro.stop(km)
	km = nil
end

function redraw()
	for n=1,4 do
		arc_led_all(n,0)
	end

	if not alt then
		for i=1,ribbon[1].steps do
			arc_led(1,(ribbon[1].notes[i]+40)%64+1,3)
		end
		arc_led(1,(now[1].note-midi_root+40)%64+1,15)	

		for i=1,ribbon[1].steps do arc_led_rel(2,(i+40)%64+1,5) end
		for i=1,ribbon[1].span do arc_led_rel(2,(i+40)%64+1,1) end
		arc_led_rel(2,(now[1].pos+40)%64+1,15)

		if ribbon[1].range <= ribbon[1].span then
			for i=1,ribbon[1].span do arc_led(3,(i+40)%64+1,i>ribbon[1].range and 1 or 5) end
		else
			for i=1,ribbon[1].span do arc_led(3,(i+40)%64+1,5) end
			arc_led(3,(ribbon[1].range+40)%64+1,1)
		end

		point(4,tempo*3+480)

	else
		for i=1,ribbon[1].steps do arc_led(1,(ribbon[1].notes[i]+40)%64+1,1) end
		arc_led(1,(now[1].note-midi_root+40)%64+1,5)	
		for i=1,7 do arc_led(1,i+28,3) end
		arc_led(1,scale+28,15)
		for i=1,ribbon[1].steps do arc_led(2,(i+40)%64+1,5) end
		for i=1,ribbon[1].span do arc_led_rel(2,(i+40)%64+1,3) end

		arc_led_rel(2,(now[1].pos+40)%64+1,15)
		if ribbon[1].range <= ribbon[1].span then
			for i=1,ribbon[1].span do arc_led(3,(i+40)%64+1,i>ribbon[1].range and 1 or 5) end
		else
			for i=1,ribbon[1].span do arc_led(3,(i+40)%64+1,5) end
			arc_led(3,(ribbon[1].range+40)%64+1,1)
		end
		arc_led(3,35,1)
		arc_led(3,31,1)
		arc_led(3,dir==1 and 35 or 31, 9)

		arc_led(4,(midi_root + 18) % 64 + 1, 15)
	end
	arc_refresh()
end

function tick()
	if pol then
		now[1].pos = now[1].pos + dir
		if now[1].pos > ribbon[1].steps then now[1].pos = 1
		elseif now[1].pos == 0 then now[1].pos = ribbon[1].steps end
		now[1].note = midi_root + ribbon[1].notes[now[1].pos]
		now[1].on= true
		midi_note_on(now[1].note)
	else
		now[1].on= false
		midi_note_off(now[1].note)
	end
	pol = not pol
	dirty = true
end

function point(n,y)
	x = math.floor(y)
	local c = x >> 4
	arc_led(n,c%64+1,15)
	arc_led(n,(c+1)%64+1,x%16)
	arc_led(n,(c+63)%64+1,15-(x%16))
end

init()
