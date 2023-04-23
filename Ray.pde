class Ray {
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
