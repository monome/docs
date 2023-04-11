inlets = 1;
outlets = 1;

var key_count = 0;
var last_press;
var play_position;

var redraw_grid = 0;

var i1, i2;

var cols = 16;
var rows = 8;
var quads = 2;

var sequencer_rows = (cols * rows) - (2*cols);

var states = new Array(sequencer_rows);
var trig = new Array(rows-2);
var leds = new Array(cols * rows);
var buffer = new Array(64);

// initialize by clearing toggle states
function init() {
	for(i1=0;i1<sequencer_rows;i1++)
		states[i1] = 0;
}

function set_size(cols, rows) {
	cols = cols;
	rows = rows;
	states = new Array((cols * rows) - (2*cols));
	trig = new Array(rows-2);
	leds = new Array(cols * rows);
	if(rows > 8){
		quads = 4;
	}
}

// key decoding
function key(x, y, z) {
	// toggle for key-down on rows 0-5
	if(y < rows-2 && z == 1) {
		states[x + y*16] ^= 1;
		
		redraw();
	}
	// jump and set loop for row 7
	else if(y == rows-1) {
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
	for(i1=0;i1<sequencer_rows;i1++)
		leds[i1] = states[i1] * 15;
	
	// clear play row, make trigger row dim
	for(i1=0;i1<16;i1++) {
		leds[i1+sequencer_rows] = 5;
		leds[i1+sequencer_rows+16] = 0;
	}
	
	// display play position
	leds[sequencer_rows + 16 + play_position] = 15;

	// display triggers
	for(i1=0;i1<6;i1++)
		if(trig[i1])
			leds[sequencer_rows+i1] = 15;
	
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