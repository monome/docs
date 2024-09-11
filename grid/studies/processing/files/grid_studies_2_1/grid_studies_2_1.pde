import org.monome.Monome;
import oscP5.*;

Monome m;
  
public void setup() {
  m = new Monome(this);
}

public void key(int x, int y, int s) {
  System.out.println("key received: " + x + ", " + y + ", " + s);
}
