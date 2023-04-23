class Point extends PVector {
  
  private Boolean moving;
  
  Point(float x, float y) {
    super(x, y);
    this.moving = false;
  }

  void show() {
    if (this.hovering()) fill(100, 20, 20);
    else fill(200, 40, 40);

    strokeWeight(1);
    ellipse(this.x, this.y, 30, 30);

    if (this.moving) {
      this.set(mouseX, mouseY);
    }
  }

  Boolean hovering() {
    PVector dist1 = new PVector(this.x, this.y);
    PVector dist2 = new PVector(mouseX, mouseY);
    return dist(dist1, dist2) < 15;
  }
  
  Boolean getMoving() {
    return this.moving;
  }

  void setMoving(Boolean moving) {
    this.moving = moving;
  }
}
