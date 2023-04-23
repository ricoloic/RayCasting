class Config {
  PVector centerPosition;
  Boolean editing = false;
  Boolean autoMove = false;
  Boolean snapNodes = false;
  Boolean casting = false;
  Boolean clicking = false;
  Boolean background = true;
  Float xoff = (float) 0;
  Float yoff = (float) 11111;
  
  Config(float centerX, float centerY) {
    centerPosition = new PVector(centerX, centerY);
  }
}
