c = {{},{},{},{}}

modetext = {"normal","min","max","shape","friction","midi cc","midi ch"}

-- shape 1: cos (top = max, bottom = min)
-- shape 2: ramp (north = 0, CW increases)
function init()
	print("\n0000 cycles\n")
	local r = pset_read(1)
	if not r or r.script ~= "cycles" then 
		print("fresh pset")
		c[1] = {cc=10,ch=1,min=0,max=127,shape=1,f=0} 
		c[2] = {cc=11,ch=1,min=0,max=127,shape=1,f=0} 
		c[3] = {cc=12,ch=1,min=0,max=127,shape=1,f=0} 
		c[4] = {cc=13,ch=1,min=0,max=127,shape=1,f=0} 
		c.script = "cycles"
		pset_write(1,c)
	else
		c = r
	end
	for i=1,4 do arc_res(i,8) end
	m = metro.new(tick,33)
end

pos = {0,0,0,0}
phase = {0,0,0,0}
speed = {0,0,0,0}
friction = 0.9
f = 1
out = {0,0,0,0}
mode = 1

function arc(n,d)
	if mode==1 then
		speed[n] = clamp(speed[n] + d,-64,64)
	elseif mode==2 then
		c[n].min = clamp(c[n].min + d,0,127)
	elseif mode==3 then
		c[n].max = clamp(c[n].max + d,0,127)
	elseif mode==4 then
		c[n].shape = clamp(c[n].shape + d,1,2)
	elseif mode==5 then
		c[n].f = clamp(c[n].f + d,0,15)
	elseif mode==6 then
		c[n].cc = clamp(c[n].cc + d,0,127)
	elseif mode==7 then
		c[n].ch = clamp(c[n].ch - d,1,16)
	end
end

function arc_key(z)
	if z == 1 then
		km = metro.new(key_timer,500,1)
	elseif km then
		--print("keyshort")
		metro.stop(km)
		mode = mode + 1
		if mode==8 then mode=2 end
		ps("mode: %s",modetext[mode])
	else
		--print("friction off")
		f = 1
	end
end

function key_timer()
	--print("keylong!")
	metro.stop(km)
	km = nil
	if mode ~= 1 then
		mode = 1 
		pset_write(1,c)
	end
	f = friction
end

function redraw()
	for n=1,4 do
		arc_led_all(n,0)
	end

	if mode==1 then
		for n=1,4 do
			point(n,pos[n])
		end
	elseif mode==2 then
		for n=1,4 do
			arc_led(n,36,mode == 2 and 10 or 2)
			arc_led(n,30,mode == 3 and 10 or 2)
			point2(n,c[n].min * 8)
		end
	elseif mode==3 then
		for n=1,4 do
			arc_led(n,36,mode == 2 and 10 or 2)
			arc_led(n,30,mode == 3 and 10 or 2)
			point2(n,c[n].max * 8)
		end
	elseif mode==4 then
		for n=1,4 do
			if c[n].shape == 1 then
				arc_led(n,33,15)
				arc_led(n,32,10)
				arc_led(n,34,10)
				arc_led(n,31,5)
				arc_led(n,35,5)
				arc_led(n,30,1)
				arc_led(n,36,1)
			else
				for i=1,7 do arc_led(n,29+i,i*2-1) end
			end
		end
	elseif mode==5 then
		for n=1,4 do
			for i=1,16 do
				arc_led(n,(56+i)%64+1,1)
				arc_led(n,(57+c[n].f)%64+1,15)
			end
		end
	elseif mode==6 then
		for n=1,4 do
			local z = c[n].cc
			local a = math.floor(z / 100)
			local b = math.floor((z%100)/10)
			local c = math.floor(z%10)
			--ps("%d = %d %d %d",z,a,b,c)
			arc_led(n,63,a==1 and 10 or 1)
			for i=1,9 do
				arc_led(n,51+i,b==i and 10 or 1)
				arc_led(n,40+i,c==i and 10 or 1)
			end
		end
	elseif mode==7 then
		for n=1,4 do
			for i=1,16 do
				arc_led(n,24-i,c[n].ch==i and 10 or 1)
			end
		end
	end
	arc_refresh()
end


-- draw point 1-1024
function point(n,y)
	x = math.floor(y)
	local c = x >> 4
	arc_led(n,c%64+1,15)
	arc_led(n,(c+1)%64+1,x%16)
	arc_led(n,(c+63)%64+1,15-(x%16))
end

function point2(n,x)
	local xx = math.floor(linlin(0,1023,1,768,x)) + 128 + 512
	local c = xx >> 4
	arc_led_rel(n,c%64+1,15-(xx%16))
	arc_led_rel(n,(c+1)%64+1,(xx%16))
end

function tick()
	for n=1,4 do
		pos[n] = pos[n] + speed[n]
		speed[n] = speed[n] * (f - (c[n].f/50))
		if c[n].shape == 1 then phase[n] = math.cos((pos[n]%1024)/1024*math.pi*2)
		else phase[n] = (pos[n]%1024)/1024*2-1 end
		local now = math.floor(linlin(-1,1,c[n].min,c[n].max,phase[n]))
		if now ~= out[n] then
			out[n] = now
			midi_cc(c[n].cc,now,c[n].ch)
		end
	end
	redraw()
end


init()
