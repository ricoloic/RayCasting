Float BUTTON_HEIGHT = 55.0;
color DEFAULT_BUTTON_BACKGROUND_COLLOR = #FF6000;

//Create an interface to handle click event for the callback method
interface ClickHandler {
    //create abstract method, i.e., clickEventHandler() that will act as callback
    void handleClick();
}

class Button {
  int pointAmount = 2;
  int thickness = 2;
  color collor = 255;
  String content = "";
  
  Boolean active;
  float w;
  float h;

  ArrayList<Point> points;
  ArrayList<LineBoundary> lines;

  private ClickHandler clickHandler;
  Boolean withActiveCollor;

  Button(String content, Boolean withActiveCollor, ClickHandler clickHandler) {
    this.withActiveCollor = withActiveCollor;
    this.active = false;
    this.clickHandler = clickHandler;
    PVector position = new PVector(0, 0);
    this.content = content;
    this.w = (float) (content.length() * 19.5 + 30);
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(new Point(position.x, position.y));
    points.add(new Point(position.x + this.w, position.y));
    points.add(new Point(position.x + this.w, position.y + BUTTON_HEIGHT));
    points.add(new Point(position.x, position.y + BUTTON_HEIGHT));
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

  Button(String content, PVector position, Boolean withActiveCollor, ClickHandler clickHandler) {
    this.withActiveCollor = withActiveCollor;
    this.active = false;
    this.clickHandler = clickHandler;
    this.content = content;
    this.w = (float) (content.length() * 19.5 + 30);
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(new Point(position.x, position.y));
    points.add(new Point(position.x + this.w, position.y));
    points.add(new Point(position.x + this.w, position.y + BUTTON_HEIGHT));
    points.add(new Point(position.x, position.y + BUTTON_HEIGHT));
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
  
  Button show() {
    this.lines.forEach((line) ->
      line.show(this.collor, false, this.thickness));

    if (this.withActiveCollor && this.active) {
      fill(color(DEFAULT_BUTTON_BACKGROUND_COLLOR, 200));
      rect(this.points.get(0).x, this.points.get(1).y, this.w, BUTTON_HEIGHT);
    }

    fill(#FFFFFF);
    text(content, this.points.get(0).x + 15, this.points.get(0).y + 40);

    return this;
  }


  Boolean collides(PVector origin) {
    Point topLeft = this.points.get(0);
    Point topRight = this.points.get(1);
    Point bottomRight = this.points.get(2);

    Boolean containX = origin.x >= topLeft.x && origin.x <= topRight.x;
    Boolean containY = origin.y >= topLeft.y && origin.y <= bottomRight.y;
    Boolean contained = containX && containY;
    
    if (contained) this.thickness = 4;
    else this.thickness = 2;
    
    return containX && containY;
  }

  float getMaxX() {
    return this.points.get(1).x;
  }
  
  void move(float x, float y) {
    this.points.get(0).set(x, y);
    this.points.get(1).set(x + this.w, y);
    this.points.get(2).set(x + this.w, y + BUTTON_HEIGHT);
    this.points.get(3).set(x, y + BUTTON_HEIGHT);
  }

  void onClick() {
    this.active = !this.active;
    if (clickHandler != null) {
      clickHandler.handleClick();
    }
  };
}
