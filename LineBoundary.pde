class LineBoundary {
  private Point pt1;
  private Point pt2;
  private int thickness;
  private int collor;

  LineBoundary(Point pt1, Point pt2, color collor, int thickness) {
    this.pt1 = pt1;
    this.pt2 = pt2;
    this.collor = collor;
    this.thickness = thickness;
  }
  
  LineBoundary(Point pt1, Point pt2) {
    this.pt1 = pt1;
    this.pt2 = pt2;
    this.collor = 255;
    this.thickness = 2;
  }

  void show(Boolean editing) {
    strokeWeight(this.thickness);
    stroke(this.collor);
    line(this.pt1.x, this.pt1.y, this.pt2.x, this.pt2.y);

    if (editing) {
      this.pt1.show();
      this.pt2.show();
    }
  }

  void show(color collor, Boolean editing, int thickness) {
    strokeWeight(thickness);
    stroke(collor);
    line(this.pt1.x, this.pt1.y, this.pt2.x, this.pt2.y);
    strokeWeight(this.thickness);
    stroke(this.collor);
    if (editing) {
      this.pt1.show();
      this.pt2.show();
    }
  }

  ArrayList<LineBoundary> getLines() {
    ArrayList<LineBoundary> lines = new ArrayList<LineBoundary>();
    lines.add(this);
    return lines;
  }

  ArrayList<Point> getPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(this.pt1);
    points.add(this.pt2);
    return points;
  }
}
