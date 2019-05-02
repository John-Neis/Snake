class Segment {
  
  color skin;
  
  int posY;
  int posX;
  
  int spdY;
  int spdX;
  
  int wide;
  int high;
  
  Segment(int x, int y, color c) {
    posX = x;
    posY = y;
    spdY = 0;
    spdX = 0;
    wide = 10;
    high = 10;
    skin = c;
  }
  
  void dispSeg() {
    fill(skin);
    rect(posX, posY, wide, high);
  }
  
}
