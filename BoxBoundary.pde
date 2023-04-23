class BoxBoundary {
  private LineBoundary lineBoundary1;
  private LineBoundary lineBoundary2;
  private LineBoundary lineBoundary3;
  private LineBoundary lineBoundary4;
  public color collor;
  public int thickness;
  
  BoxBoundary(
    Point pt1,
    Point pt2,
    Point pt3,
    Point pt4,
    color collor,
    int thickness
  ) {
    this.lineBoundary1 = new LineBoundary(pt1, pt2);
    this.lineBoundary2 = new LineBoundary(pt2, pt3);
    this.lineBoundary3 = new LineBoundary(pt3, pt4);
    this.lineBoundary4 = new LineBoundary(pt4, pt1);
    this.collor = collor;
    this.thickness = thickness;
  }
  
  BoxBoundary(
    Point pt1,
    Point pt2,
    Point pt3,
    Point pt4
  ) {
    this.lineBoundary1 = new LineBoundary(pt1, pt2);
    this.lineBoundary2 = new LineBoundary(pt2, pt3);
    this.lineBoundary3 = new LineBoundary(pt3, pt4);
    this.lineBoundary4 = new LineBoundary(pt4, pt1);
    this.collor = 255;
    this.thickness = 2;
  }

  void show(Boolean editing) {
    this.lineBoundary1.show(this.collor, editing, this.thickness);
    this.lineBoundary2.show(this.collor, editing, this.thickness);
    this.lineBoundary3.show(this.collor, editing, this.thickness);
    this.lineBoundary4.show(this.collor, editing, this.thickness);
  }

  ArrayList<LineBoundary> getLines() {
    ArrayList<LineBoundary> lines = new ArrayList<LineBoundary>();
    lines.add(this.lineBoundary1);
    lines.add(this.lineBoundary2);
    lines.add(this.lineBoundary3);
    lines.add(this.lineBoundary4);
    return lines;
  }
  
  
  ArrayList<Point> getPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(this.lineBoundary1.pt1);
    points.add(this.lineBoundary1.pt2);
    points.add(this.lineBoundary2.pt1);
    points.add(this.lineBoundary2.pt2);
    points.add(this.lineBoundary3.pt1);
    points.add(this.lineBoundary3.pt2);
    points.add(this.lineBoundary4.pt1);
    points.add(this.lineBoundary4.pt2);
    return points;
  }
}
