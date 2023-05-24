inlets = 1;
outlets = 1;

var key_count = 0;
var last_press;
var play_position;

var redraw_grid = 0;

var i1, i2;

var states = new Array(96);
var trig = new Array(6);

var leds = new Array(128);
var buffer = new Array(64);


// initialize by clearing toggle states
function init() {
	for(i1=0;i1<96;i1++)
		states[i1] = 0;
}

// key decoding
function key(x, y, z) {
	// toggle for key-down on rows 0-5
	if(y < 6 && z == 1) {
		states[x + y*16] ^= 1;
		
		redraw();
	}
	// jump and set loop for row 7
	else if(y == 7) {
		// track key count
		if(z == 0) key_count--;
		else if(z == 1) key_count++;
		
		if(key_count == 1) {
			last_press = x;
			outlet(0,"counter","set",x);
		}
		else if(key_count == 2) {
			outlet(0,"counter","setmin", last_press);
			outlet(0,"counter","max", x);
		}			
	}
}


// LED redraw function
function redraw() {
	// display toggles
	for(i1=0;i1<96;i1++)
		leds[i1] = states[i1] * 15;
	
	// clear play row, make trigger row dim
	for(i1=0;i1<16;i1++) {
		leds[i1+96] = 5;
		leds[i1+112] = 0;
	}
	
	// display play position
	leds[112 + play_position] = 15;

	// display triggers
	for(i1=0;i1<6;i1++)
		if(trig[i1])
			leds[96+i1] = 15;
	
	// output OSC for first quadrant
	for(i1=0;i1<8;i1++)
		for(i2=0;i2<8;i2++)
			buffer[i1*8+i2] = leds[i1*16+i2];
	outlet(0,"osc","/monome/grid/led/level/map",0,0,buffer);

	// output OSC for second quadrant
	for(i1=0;i1<8;i1++)
		for(i2=0;i2<8;i2++)
			buffer[i1*8+i2] = leds[i1*16+i2+8];
	outlet(0,"osc","/monome/grid/led/level/map",8,0,buffer);
}


// received new play position
function play(i) {
	// store the play position for display
	play_position = i;
	
	// check the states, send triggers
	for(i1=0;i1<6;i1++) {
		// store a list of triggers for display
		trig[i1] = states[play_position + i1*16];
		if(trig[i1])
			outlet(0,"trig",i1);
	}
	
	// redraw
	redraw();
}


// delayed clock for clearing trig display
function delay() {
	// clear the triggers and redraw
	for(i1=0;i1<6;i1++)
		trig[i1] = 0;
	redraw();
}