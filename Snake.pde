Segment t[];
  
Segment pellet = new Segment(10 * (int)random(1, 49), 10 * (int)random(8, 49), color(255));
  
int tailIND, speedBUFX, speedBUFY;


void drawTitle() {
  stroke(255);
  fill(255);
  line(40, 20, 60, 20); /* S */ line(80, 20, 80, 60); // N
  line(40, 20, 40, 40);         line(80, 20, 100, 60);
  line(40, 40, 60, 40);         line(100, 20, 100, 60);
  line(60, 40, 60, 60);
  line(60, 60, 40, 60);
  
  line(120, 20, 120, 60); /* A */ line(160, 20, 160, 60); // K
  line(120, 20, 140, 20);         line(160, 40, 180, 20);
  line(140, 20, 140, 60);         line(160, 40, 180, 60);
  line(120, 40, 140, 40);
  
  line(200, 20, 200, 60); /* E */
  line(200, 20, 220, 20);
  line(200, 40, 220, 40);
  line(200, 60, 220, 60);
  
  line(0, 70, 500, 70);
}

void setup() {
  t = new Segment[255];
  t[0] = new Segment(250, 250, color(255));
  
  // You start the game as just a snake head
  for(int i = 1; i < 255; i++) {
    t[i] = null;
  }
  
  // Tail index makes it easy to track the butt of the snake
  tailIND = 0;
  speedBUFX = 0;
  speedBUFY = 0;
  
  // Processing gobbledygook
  size(500, 500);
  background(0);
}

void draw() {
  // Makes it run at a reasonable speed. This is an arcade after all
  frameRate(60);
  background(0);
  drawTitle();
  text("Score: " + tailIND, 400, 40);
  
  for(int i = 0; i < 255; i++) {
    if(t[i] != null)
      t[i].dispSeg(); // Draw the snake
    else break;
  }
  
  pellet.dispSeg(); // Draw the pellet
  fill(0);
  rect(pellet.posX + 3, pellet.posY + 3, pellet.wide - 6, pellet.high - 6);
  
  // This transitions each segment forward,
  // following the preceding segment. Snakey-like.
  if(t[0].spdX != 0 || t[0].spdY != 0) {
    for(int i = tailIND; i > 0; i--) {
      //if(t[i - 1].posX % 10 == 0 && t[i - 1].posY % 10 == 0) {
        t[i].posX = t[i - 1].posX;
        t[i].posY = t[i - 1].posY;
      //}
    }
  }
  t[0].posX += t[0].spdX; // Technically the only bit of the snake that 
  t[0].posY += t[0].spdY; // moves is the head. Everything else will follow.
  // This whole sequence goes from tail to head. Hence, the necessity of 
  // tailIND.
  
  // This is where we check if the snake has eaten a pellet
  if((t[0].posX == pellet.posX) && (t[0].posY == pellet.posY)) {
    
    pellet.posX = 10 * (int)random(1, 49);
    pellet.posY = 10 * (int)random(8, 49);
    
    // There's a chance the pellet will be on the snake.
    // Pellet on snake = sloppy looking. This makes it less likely.
    for(int i = tailIND; i >= 0; i--) {
      if(pellet.posX == t[i].posX && pellet.posY == t[i].posY) {
        pellet.posX = 10 * (int)random(1, 49);
        pellet.posY = 10 * (int)random(8, 49);
      }
    }
    // We also need to extend the snake's tail
    tailIND++;
    t[tailIND] = new Segment(t[tailIND - 1].posX, t[tailIND - 1].posY, color(255));
  }
    
  // This whole thing is basically just in case the snake eats itself  
  for(int i = tailIND; i > 0; i--) {
    if(t[0].posX == t[i].posX && t[0].posY == t[i].posY && tailIND > 1) {
      
      t[0].spdX = 0;
      t[0].spdY = 0;
      t[0].posX = 250;
      t[0].posY = 250;
      for(int j = tailIND; j > 0; j--) {
        t[j] = null;
      }
      tailIND = 0;
      break;

    }
  }
  
  // This is if the snake eats the top or bottom wall
  if(t[0].posY < 70 || t[0].posY > 490) {
    t[0].spdY = 0;
    t[0].posY = 250;
    t[0].posX = 250;
    for(int j = tailIND; j > 0; j--) {
        t[j] = null;
    }
    tailIND = 0;  
  }
  
  // This is if the snake eats the left or right wall
  if(t[0].posX < 0 || t[0].posX > 490) {
    t[0].spdX = 0;
    t[0].posX = 250;
    t[0].posY = 250;
    for(int j = tailIND; j > 0; j--) {
        t[j] = null;
    }
    tailIND = 0;
  }
  
  // This is pretty hard to trigger. Basically this is if you win.
  if(tailIND == 254) {
    for(int j = tailIND; j > 0; j--) {
        t[j] = null;
    }
    tailIND = 0;
    t[0].spdX = 0;
    t[0].spdY = 0;
    t[0].posX = 250;
    t[0].posY = 250;
  }
  
  if(t[0].posX % 10 == 0 && t[0].posY % 10 == 0) {
    t[0].spdX = speedBUFX;
    //speedBUFX = 0;
  }
    
  if(t[0].posY % 10 == 0 && t[0].posX % 10 == 0) {
    t[0].spdY = speedBUFY;
    //speedBUFY = 0;
  }
}

// Change the snakes direction, but you can't double back on yourself.
void keyPressed() {
  if(key == CODED) {
    if(keyCode == UP) {
      if(t[0].spdY == 1) {
        return;
      }
      speedBUFY = -1;
      speedBUFX = 0;
      return;
        
    } else if(keyCode == DOWN) { 
      if(t[0].spdY == -1) {
        return;
      }
      speedBUFY = 1;
      speedBUFX = 0;
      return;
        
    } else if(keyCode == LEFT) { 
      if(t[0].spdX == 1) {
        return;
      }
      speedBUFX = -1;
      speedBUFY = 0;
      return;
        
    } else if(keyCode == RIGHT) {
      if(t[0].spdX == -1) {
        return;
      }
      speedBUFX = 1;
      speedBUFY = 0;
      return;
    }
  }
}
