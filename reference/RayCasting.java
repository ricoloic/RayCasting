import java.util.*;

import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;
import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

/** RayCasting */
public class RayCasting {
BoxBoundary canvasBoundary;
ArrayList<Boundary> boundaries;
PVector centerPosition;
Caster caster;
Boolean editing = false;
Boolean autoMove = false;
Boolean snap = false;
Float xoff = (float) 0;
Float yoff = (float) 11111;

BoxBoundary getSidesBoundaries(int thickness) {
  float w = width - 1;
  float h = height - 1;
  return new BoxBoundary(
    new Point(1, 1),
    new Point(w, 1),
    new Point(w, h),
    new Point(1, h),
    255,
    thickness
  );
}

BoxBoundary getSidesBoundaries() {
  float w = width - 1;
  float h = height - 1;
  return new BoxBoundary(
    new Point(1, 1),
    new Point(w, 1),
    new Point(w, h),
    new Point(1, h),
    255,
    0
  );
}

void setup() {
  // Define the canvas width and height
  //size(1000, 1000);
  fullScreen();
  noiseDetail(2, 0.7);
  centerPosition = new PVector(width / 2, height / 2);
  caster = new Caster(centerPosition);
  canvasBoundary = getSidesBoundaries();
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(5));
}

void draw() {
  background(30);
  
  if (autoMove) {
      caster.setPosition(noise(xoff) * width, noise(yoff) * height);
      xoff += 0.01;
      yoff += 0.01;
    } else {
      caster.setPosition(mouseX, mouseY);
    }

    if (!editing) {
      ArrayList<LineBoundary> tempArray = new ArrayList<LineBoundary>();
      canvasBoundary.getLines().forEach((line) -> tempArray.add(line));
      boundaries.forEach((boundary) -> {
        boundary.lines.forEach((line) -> tempArray.add(line));
      });
      caster.cast(tempArray);
    }

    canvasBoundary.show(false);
    boundaries.forEach((b) -> b.show(editing));
}

void mouseReleased() {
    for (Boundary b : boundaries) {
    for (Point pt : b.points) {
      if (pt.getMoving()) {
        pt.setMoving(false);
      }
    }
  }
}

void mousePressed() {
  for (int i = boundaries.size(); i > 0; i--) {
    for (int j = boundaries.get(i - 1).points.size(); j > 0; j--) {
      if (boundaries.get(i - 1).points.get(j - 1).hovering()) {
        boundaries.get(i - 1).points.get(j - 1).setMoving(true);
        if (!snap) return;
      }
    }
  }
}

void keyPressed() {
  if (keyCode == 69) {
    editing = !editing;
  } else if (keyCode == 65) {
    boundaries.add(new Boundary(3));
  } else if (keyCode == 83) {
    snap = !snap;
  }
}class Boundary {
  int pointAmount = 2;
  int thickness = 2;
  int collor = 255;

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
      float x = cos(m) * radius + centerX;
      float y = sin(m) * radius + centerY;
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
      float x = cos(m) * radius + centerX;
      float y = sin(m) * radius + centerY;
      points.add(new Point(x, y));
    }
    
    for (int i = 0; i < this.pointAmount; i++) {
      Point pt1 = this.points.get(i);
      Point pt2 = this.points.get((i + 1) % this.pointAmount);
      lines.add(new LineBoundary(pt1, pt2, this.collor, this.thickness));
    }
  }
  
  void show(Boolean editing) {
    this.lines.forEach((line) -> line.show(this.collor, editing, this.thickness));
  }
}class BoxBoundary {
  private LineBoundary lineBoundary1;
  private LineBoundary lineBoundary2;
  private LineBoundary lineBoundary3;
  private LineBoundary lineBoundary4;
  public int collor;
  public int thickness;
  
  BoxBoundary(
    Point pt1,
    Point pt2,
    Point pt3,
    Point pt4,
    int collor,
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
class Caster {
  PVector position;
  int radius = 10;
  int rayCollor;
  int rayBackGroundCollor;
  int rayThickness;
  
  class PointAngle {
    PVector point;
    float angle;

    PointAngle(PVector point, float angle) {
      this.point = point;
      this.angle = angle;
    }
    
    float getAngle() {
      return this.angle;
    }
  }

  Caster(
    PVector position,
    int rayCollor,
    int rayBackGroundCollor,
    int rayThickness
  ) {
    this.position = position;
    this.rayCollor = rayCollor;
    this.rayBackGroundCollor = rayBackGroundCollor;
    this.rayThickness = rayThickness;
  }
  
  Caster(
    PVector position
  ) {
    this.position = position;
    this.rayCollor = 150;
    this.rayBackGroundCollor = color(220, 50);
    this.rayThickness = 1;
  }

  void cast(ArrayList<LineBoundary> lines) {
    ArrayList<Ray> rays = this.makeRays(lines);
    ArrayList<PointAngle> foundIntersections = new ArrayList<PointAngle>();
    for (int i = 0; i < rays.size(); i += 1) {
      PVector closest = null;
      double min = Double.POSITIVE_INFINITY;

      for (int j = 0; j < lines.size(); j += 1) {
        PVector intersection = rays.get(i).cast(lines.get(j));

        if (intersection != null) {
          float distance = this.position.dist(intersection);
          if (distance < min) {
            min = distance;
            closest = intersection;
          }
        }
      }

      if (closest != null) {
        foundIntersections.add(new PointAngle(closest, rays.get(i).angle));
      }
    }

    noStroke();
    fill(this.rayBackGroundCollor);
    foundIntersections.sort(Comparator.comparing(PointAngle::getAngle));
    beginShape();
    foundIntersections.forEach((pa) -> vertex(pa.point.x, pa.point.y));
    endShape();

    strokeWeight(this.rayThickness);
    stroke(this.rayCollor);
    foundIntersections.forEach((pa) -> line(this.position.x, this.position.y, pa.point.x, pa.point.y));
  }

  private ArrayList<Ray> makeRays(ArrayList<LineBoundary> lines) {
    ArrayList<Ray> rays = new ArrayList<Ray>();

    for (int i = 0; i < lines.size(); i += 1) {
      LineBoundary line = lines.get(i);
      ArrayList<Float> angles = new ArrayList<Float>();
      
      float a = PVector.sub(line.pt1, this.position).normalize().heading();
      angles.add(a);
      angles.add(a + 0.001);
      angles.add(a - 0.001);

      float b = PVector.sub(line.pt2, this.position).normalize().heading();
      angles.add(b);
      angles.add(b + 0.001);
      angles.add(b - 0.001);

      angles.forEach((angle) -> rays.add(new Ray(this.position, angle)));
    }

    return rays;
  }
  
  void setPosition(float x, float y) {
    this.position.set(x, y);
  }
}
class LineBoundary {
  private Point pt1;
  private Point pt2;
  private int thickness;
  private int collor;

  LineBoundary(Point pt1, Point pt2, int collor, int thickness) {
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

  void show(int collor, Boolean editing, int thickness) {
    strokeWeight(thickness);
    stroke(collor);
    line(this.pt1.x, this.pt1.y, this.pt2.x, this.pt2.y);

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
}class Point extends PVector {
  
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
}class Ray {
  private float angle;
  private PVector origin;
  private PVector direction;

  Ray(PVector origin, float angle) {
    this.angle = angle;
    this.origin = origin;
    this.direction = PVector.fromAngle(angle);
  }
  
  PVector cast(LineBoundary line) {
    float t = this.calculateT(
      line.pt1.x,
      line.pt1.y,
      line.pt2.x,
      line.pt2.y,
      this.origin.x,
      this.origin.y,
      this.origin.x + this.direction.x,
      this.origin.y + this.direction.y
    );

    float u = this.calculateU(
      line.pt1.x,
      line.pt1.y,
      line.pt2.x,
      line.pt2.y,
      this.origin.x,
      this.origin.y,
      this.origin.x + this.direction.x,
      this.origin.y + this.direction.y
    );

    Boolean intersectBoundary = t > 0 && t < 1 && u > 0;
    
    if (intersectBoundary) {
      return this.calculateIntersection(
        line.pt1.x,
        line.pt1.y,
        line.pt2.x,
        line.pt2.y,
        t
      );
    }
    return null;
  }
  
  private PVector calculateIntersection(
    float x1,
    float y1,
    float x2,
    float y2,
    float t
  ) {
    float x = x1 + t * (x2 - x1);
    float y = y1 + t * (y2 - y1);
    return new PVector(x, y);
  }
  
  private float calculateU(
    float x1,
    float y1,
    float x2,
    float y2,
    float x3,
    float y3,
    float x4,
    float y4
  ) {
    float denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (denominator == 0) {
      return -1;
    }
    float numerator = (x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2);
    return numerator / denominator;
  }

  private float calculateT(
    float x1,
    float y1,
    float x2,
    float y2,
    float x3,
    float y3,
    float x4,
    float y4
  ) {
    float denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (denominator == 0) {
      return -1;
    }
    float numerator = (x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4);
    return numerator / denominator;
  }
} 
}

