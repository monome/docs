inlets = 3; // second inlet: LED messages, third inlet: metro
outlets = 12;

var in_port;
var prefix;

var autoconnect = 0;
var connected = 0;

var serials = [];
var devices = [];
var ports = [];
var cols = [];
var rows = [];

var quad_dirty = new Array(0,0,0,0);
var led_quads = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
				];

function clamp(n,minimum,maximum) {
	return Math.min(Math.max(n, minimum), maximum)
}

function adjust(n) {
	return Math.floor(n/8);
}

function insert_all(state) {
	state = clamp(state,0,1);
	for(i = 0; i < 64; i++) {
		led_quads[0][i] = state*15;
		led_quads[1][i] = state*15;
		led_quads[2][i] = state*15;
		led_quads[3][i] = state*15;
	}
	for (i = 0; i < 4; i++) {
		quad_dirty[i] = 1;
	}
}

function insert_set(x,y,level) {
	if(level == 1) {
		led_level(x,y,15);
	}
	else {
		led_level(x,y,0);
	}
}

function insert_row(x_offset,y,n1,n2) {
	n1 = clamp(n1,0,255);
	decoded = n1.toString(2).split('').reverse();
	x_adjust = adjust(x_offset);
	y_adjust = y;
	quad_adjust = 0;
	
	if(x_adjust < 2) {	
		if(y >= 8) {
			y_adjust = y-8;
			quad_adjust = 2;
		}
		
		for(i = 0; i < 8; i++){
			if(decoded[i] == null){
				decoded[i] = 0
			}
		}

		iter = 8*y_adjust;
		qID = x_adjust + quad_adjust;

		for(i = iter; i < iter + decoded.length; i++){
			led_quads[qID][i] = decoded[i - iter] * 15;
			quad_dirty[qID] = 1;
		}

		if(n2 != null){
			decoded = n2.toString(2).split('').reverse();
			for(i = 0; i < 8; i++){
				if(decoded[i] == null){
					decoded[i] = 0
				}
			}
			for(i = iter; i < iter + decoded.length; i++){
				led_quads[qID + 1][i] = decoded[i - iter] * 15;
				quad_dirty[qID + 1] = 1;
			}
		}
	}
}

function insert_col(x,y_offset,n1,n2) {
	n1 = clamp(n1,0,255);
	decoded = n1.toString(2).split('').reverse();
	y_adjust = adjust(y_offset);
	offset = false;
	
	if (y_adjust != 0){
		offset = true;
	}
		
	for(i = 0; i < 8; i++){
		if(decoded[i] == null){
			decoded[i] = 0
		}
	}
	for(i = 0; i < decoded.length; i++){
		if(x < 8){
			if (offset == false){
				led_quads[0][(i*8)+x] = decoded[i] * 15;
			}else{
				led_quads[2][(i*8)+x] = decoded[i] * 15;
			}
			
		}else{
			if (offset == false){
				led_quads[1][(i*8)+(x-8)] = decoded[i] * 15;
			}else{
				led_quads[3][(i*8)+(x-8)] = decoded[i] * 15;
			}
		}
	}
	
	if(offset == false){
		quad_dirty[0] = 1;
		quad_dirty[1] = 1;
	}else{
		quad_dirty[2] = 1;
		quad_dirty[4] = 1;
	}
	
	if(n2 != null){
		n2 = clamp(n2,0,255);
		decoded = n2.toString(2).split('').reverse();
		for(i = 0; i < 8; i++){
			if(decoded[i] == null){
				decoded[i] = 0
			}
		}
		for(i = 0; i < decoded.length; i++){
			if(x < 8){
				if (offset == false){
					led_quads[2][(i*8)+x] = decoded[i] * 15;
					quad_dirty[2] = 1;
				}
			}else{
				if (offset == false){
					led_quads[3][(i*8)+(x-8)] = decoded[i] * 15;
					quad_dirty[3] = 1;
				}
			}
		}
	}
}

function row_level() {
	if(arguments.length > 2){
		x_offset = arguments[0];
		x_adjust = adjust(x_offset);
		y = arguments[1];
		y_adjust = y;
		quad_adjust = 0;
		
		if(arguments.length == 10 || arguments.length == 18){
			if(y >= 8) {
				y_adjust = y-8;
				quad_adjust = 2;
			}

			yID = 8*y_adjust;
			qID = x_adjust + quad_adjust;

			for(i = 2; i < arguments.length; i++){
				if(i < 10){
					led_quads[qID][i-2 + yID] = arguments[i];
					quad_dirty[qID] = 1;
				} else {
					led_quads[qID + 1][i-10 + yID] = arguments[i];
					quad_dirty[qID + 1] = 1;
				}	
			}		
		}		
	}
}

function col_level() {
	if(arguments.length > 2){
		x = arguments[0];
		y_offset = arguments[1];
		x_adjust = adjust(x);
		y_adjust = adjust(y_offset);
		
		if(arguments.length == 10 || arguments.length == 18){
			
			if(y_adjust == 0){
				for(i = 2; i < arguments.length; i++){
					if(i < 10){
						led_quads[x_adjust][((8*(i-2)) + x) - (8*x_adjust)] = arguments[i];
						quad_dirty[x_adjust] = 1;
					} else {
						led_quads[x_adjust+2][(8*(i-10)) + x - (8*x_adjust)] = arguments[i];
						quad_dirty[x_adjust+2] = 1;
					}	
				}
			}else{
				for(i = 2; i < arguments.length; i++){
					if(i < 10){
						led_quads[x_adjust+2][((8*(i-2)) + x) - (8*x_adjust)] = arguments[i];
						quad_dirty[x_adjust+2] = 1;
					}
				}
			}												
		}		
	}
}

function led_level(x,y,level) {
	if(x < 8 && y < 8) {
		offset = 8*y;
		led_quads[0][offset+x] = level;
		quad_dirty[0] = 1;
	}
	else if(x > 7 && x < 16 && y < 8){
		offset = 8*y;
		led_quads[1][offset+(x-8)] = level;
		quad_dirty[1] = 1;
	}
	else if(x < 8 && y > 7 && y < 16){
		offset = 8*(y-8);
		led_quads[2][offset+x] = level;
		quad_dirty[2] = 1;
	}
	else if(x > 7 && x < 16 && y > 7 && y < 16){
		offset = 8*(y-8);
		led_quads[3][offset+(x-8)] = level;
		quad_dirty[3] = 1;
	}
}

function all_level(level) {
	for (i = 0; i < 4; i++) {
		for(j = 0; j < 64; j++) {
			led_quads[i][j] = level;
		}
		quad_dirty[i] = 1;
	}
}

function redraw() {
	for(i=0;i<4;i++) {
		if(quad_dirty[i] != 0){
			outlet(i+6,led_quads[i]);
			quad_dirty[i] = 0;
		}
	}
}

// init args: #0 (port) #1 (prefix) #2 (non-zero disables autoconnect)
function init() {
	in_port = arguments[0] + 12288;
	
	prefix = arguments[1];

	if(prefix == 0 || prefix == "#1")
		prefix = "/monome";
		
	if(arguments[2] == 0)
		autoconnect = 1;
	
	outlet(0, "port", in_port);
	rescan();
}

function rescan() {
	outlet(1, "/serialosc/list", "localhost", in_port);
	outlet(1, "/serialosc/notify", "localhost", in_port);
	outlet(3, "clear");
	outlet(3, "append", "none");
	outlet(3, "textcolor", 1.0, 1.0, 1.0, 0.3);
	
	ports = [];
	devices = [];
	serials = [];
	rows = [];
	cols = [];
	
	for (i=0; i<4 ; i++) {
		quad_dirty[i] = 1
	}
}


function osc() {
	if(arguments[0] == "/serialosc/device") {
		outlet(3, "append", arguments[1], arguments[2]);
		ports.push(arguments[3]);
		devices.push(arguments[2]);
		serials.push(arguments[1]);
		
		if(autoconnect == 1) {
			outlet(3, 1);
		}
		
		if(connected) {
			var i;
			for(i = 0; i < serials.length; i++) {
				if(serials[i] == connected)
					outlet(3,i+1);
			}
		}
			
	}
	else if(arguments[0] == "/serialosc/remove" || arguments[0] == "/serialosc/add") {
		rescan();
	}
	
	else if(arguments[0] == "/sys/port" && arguments[1] != in_port) {
		outlet(3, "set", 0);
		outlet(3, "textcolor", 1.0, 1.0, 1.0, 0.3);
		connected = 0;
	}
	
	else if(arguments[0] == "/sys/size") {
		cols.push(arguments[1]);
		rows.push(arguments[2]);
		outlet(10, arguments[1]);
		outlet(11, arguments[2]);
	}
	
}


function menu(i) {
	if(i != 0) {
		outlet(3, "textcolor", 1.0, 1.0, 1.0, 1.0);
		outlet(2, "port", ports[i-1]);
		outlet(2, "/sys/port", in_port);
		outlet(2, "/sys/prefix", prefix);
		
		outlet(4, serials[i-1]);
		outlet(5, devices[i-1]);
		outlet(10, cols[i-1]);
		outlet(11, rows[i-1]);
		
		autoconnect = 0;
		connected = serials[i-1];
	}
	else {
		post(ports);
		post(serials);
		if(connected)
			outlet(2, "/sys/port", 0);
	}
	
}

function serial() {
	var i;
	for(i = 0; i < serials.length; i++) {
		if(serials[i] == arguments[0])
			outlet(3,i+1);
	}
}