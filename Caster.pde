import java.util.*;

class Caster {
  PVector position;
  int radius = 10;
  int rayCollor;
  color rayBackGroundCollor;
  color rayThickness = 1;

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
    color rayBackGroundCollor,
    color rayThickness
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
    this.rayBackGroundCollor = color(#454545);
  }

  void castRays(ArrayList<LineBoundary> lines) {
    ArrayList<Ray> rays = this.makeRays(lines);
    ArrayList<PointAngle> foundIntersections = findIntersections(rays, lines);

    foundIntersections.sort(Comparator.comparing(PointAngle::getAngle));
    strokeWeight(this.rayThickness);
    stroke(this.rayCollor);
    foundIntersections.forEach((pa) -> line(this.position.x, this.position.y, pa.point.x, pa.point.y));
  }

  void castBackground(ArrayList<LineBoundary> lines, color collor) {
    ArrayList<Ray> rays = this.makeRays(lines);
    ArrayList<PointAngle> foundIntersections = findIntersections(rays, lines);

    foundIntersections.sort(Comparator.comparing(PointAngle::getAngle));
    noStroke();
    fill(collor);
    beginShape();
    foundIntersections.forEach((pa) -> vertex(pa.point.x, pa.point.y));
    endShape();
  }
  
  void castBackground(ArrayList<LineBoundary> lines) {
    ArrayList<Ray> rays = this.makeRays(lines);
    ArrayList<PointAngle> foundIntersections = findIntersections(rays, lines);

    foundIntersections.sort(Comparator.comparing(PointAngle::getAngle));
    noStroke();
    fill(this.rayBackGroundCollor);
    beginShape();
    foundIntersections.forEach((pa) -> vertex(pa.point.x, pa.point.y));
    endShape();
  }
  
  void castPoint() {
    stroke(255, 0, 0);
    strokeWeight(10);
    point(this.position.x, this.position.y);
  }

  private ArrayList<PointAngle> findIntersections(ArrayList<Ray> rays, ArrayList<LineBoundary> lines) {
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
    return foundIntersections;
  }

  private ArrayList<Ray> makeRays(ArrayList<LineBoundary> lines) {
    ArrayList<Ray> rays = new ArrayList<Ray>();

    for (int i = 0; i < lines.size(); i += 1) {
      LineBoundary line = lines.get(i);
      ArrayList<Float> angles = new ArrayList<Float>();

      Float displacement = 0.001;

      float a = PVector.sub(line.pt1, this.position).normalize().heading();
      angles.add(a);
      angles.add(a + displacement);
      angles.add(a - displacement);
      float b = PVector.sub(line.pt2, this.position).normalize().heading();
      angles.add(b);
      angles.add(b + displacement);
      angles.add(b - displacement);
      angles.forEach((angle) -> rays.add(new Ray(this.position, angle)));
    }

    return rays;
  }

  void setPosition(float x, float y) {
    this.position.set(x, y);
  }
}
