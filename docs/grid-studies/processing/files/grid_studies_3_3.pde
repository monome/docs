import org.monome.Monome;
import oscP5.*;

Monome m;
boolean dirty;

int[][] step;
int timer;
int play_position;
int STEP_TIME = 10;

public void setup() {
  m = new Monome(this);
  
  dirty = true;
  
  step = new int[6][16];
  
  size(360,140);
  background(51);
  stroke(255,204);
}
  
public void draw() {
  fill(51, 60);
  rect(0,0,width,height);
  
  if(timer == STEP_TIME) {
    if(play_position == 15)
      play_position = 0;
    else 
      play_position++;
    
    // TRIGGER SOMETHING
    for(int y=0;y<6;y++)
      if(step[y][play_position] == 1)
        trigger(y);
    
    timer = 0;
    dirty = true;
  }
  else timer++;
  
  if(dirty) {
    int[][] led = new int[8][16];
    int highlight;
    
    // display steps
    for(int x=0;x<16;x++) {
      // highlight the play position
      if(x == play_position)
        highlight = 4;
      else 
        highlight = 0;
        
      for(int y=0;y<6;y++)
        led[y][x] = step[y][x] * 11 + highlight;
    }
    
    // draw trigger bar and on-states
    for(int x=0;x<16;x++)
      led[6][x] = 4;    
    for(int y=0;y<6;y++)
      if(step[y][play_position] == 1)
        led[6][y] = 15;
        
    
    // update grid
    m.refresh(led);
    dirty = false;
  }
}

public void key(int x, int y, int s) {
  // toggle steps
  if(s == 1 && y < 6) {
    step[y][x] ^= 1;
    
    dirty = true; 
  }
}

public void trigger(int i) {
  line(20,20+i*20,width-20,20+i*20);
}
