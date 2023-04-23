class Boundary {
  int pointAmount = 2;
  int thickness = 2;
  color collor = #FF6000;
  int offset = 0;

  ArrayList<Point> points;
  ArrayList<LineBoundary> lines;

  Boundary() {
    this.points = new ArrayList<Point>();
    this.lines = new ArrayList<LineBoundary>();

    int smallest = min(width, height);
    float radius = smallest / 3;
    int centerX = width / 2;
    int centerY = height / 2;
    for (int i = 0; i < this.pointAmount; i++) {
      float m = map(i, 0, this.pointAmount, 0, TWO_PI);
      float x = cos(m) * radius + centerX - offset;
      float y = sin(m) * radius + centerY - offset;
      points.add(new Point(x, y));
    }

    for (int i = 0; i < this.pointAmount; i++) {
      Point pt1 = this.points.get(i);
      Point pt2 = this.points.get((i - 1) % this.pointAmount);
      lines.add(new LineBoundary(pt1, pt2, this.collor, this.thickness));
    }
  }


  Boundary(int pointAmount) {
    this.pointAmount = pointAmount;
    this.points = new ArrayList<Point>();
    this.lines = new ArrayList<LineBoundary>();

    int smallest = min(width, height);
    float radius = smallest / 3;
    int centerX = width / 2;
    int centerY = height / 2;
    for (int i = 0; i < this.pointAmount; i++) {
      float m = map(i, 0, this.pointAmount, 0, TWO_PI);
      float x = cos(m) * radius + centerX - offset;
      float y = sin(m) * radius + centerY - offset;
      points.add(new Point(x, y));
    }

    for (int i = 0; i < this.pointAmount; i++) {
      Point pt1 = this.points.get(i);
      Point pt2 = this.points.get((i + 1) % this.pointAmount);
      lines.add(new LineBoundary(pt1, pt2, this.collor, this.thickness));
    }
  }

  Boundary(ArrayList<Point> points) {
    this.points = new ArrayList<Point>();
    this.lines = new ArrayList<LineBoundary>();
    this.pointAmount = points.size();

    points.forEach((pt) -> this.points.add(new Point(pt.x, pt.y)));

    for (int i = 0; i < this.pointAmount; i++) {
      Point pt1 = this.points.get(i);
      Point pt2 = this.points.get((i + 1) % this.pointAmount);
      lines.add(new LineBoundary(pt1, pt2, this.collor, this.thickness));
    }
  }

  Boundary(PVector position, Float w, Float h) {
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(new Point(position.x, position.y));
    points.add(new Point(position.x + w, position.y));
    points.add(new Point(position.x + w, position.y + h));
    points.add(new Point(position.x, position.y + h));
    this.points = new ArrayList<Point>();
    this.lines = new ArrayList<LineBoundary>();
    this.pointAmount = points.size();

    points.forEach((pt) -> this.points.add(new Point(pt.x, pt.y)));

    for (int i = 0; i < this.pointAmount; i++) {
      Point pt1 = this.points.get(i);
      Point pt2 = this.points.get((i + 1) % this.pointAmount);
      lines.add(new LineBoundary(pt1, pt2, this.collor, this.thickness));
    }
  }

  void show(Boolean editing) {
    fill(this.collor, 200);
    beginShape();
    this.points.forEach((point) -> vertex(point.x, point.y));
    endShape(CLOSE);
    this.lines.forEach((line) -> line.show(255, editing, this.thickness));
  }

  void show() {
    fill(this.collor, 200);
    beginShape();
    this.points.forEach((point) -> vertex(point.x, point.y));
    endShape(CLOSE);
    this.lines.forEach((line) -> line.show(255, false, this.thickness));
  }
}
