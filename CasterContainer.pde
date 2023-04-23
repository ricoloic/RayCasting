int SHADOW_DIST = 25;
int SHADOW_AMOUNT = 13;

class CasterContainer {
  Caster caster;
  ArrayList<Caster> shadows;
  CasterContainer(PVector initialPosition) {
    this.caster = new Caster(initialPosition, 150, #ffffff, 1);
    this.shadows = new ArrayList<Caster>();
    for (int i = 0; i < SHADOW_AMOUNT; i++)
      this.shadows.add(new Caster(new PVector(initialPosition.x, initialPosition.y)));
  }

  void castRays(ArrayList<LineBoundary> lines) {
    this.caster.castRays(lines);
  }

  void castBackground(ArrayList<LineBoundary> lines) {
    this.caster.castBackground(lines);
    this.shadows.forEach((shadowCaster) ->
      shadowCaster.castBackground(lines, color(this.caster.rayBackGroundCollor, 50)));


    this.caster.castPoint();
    this.shadows.forEach((shadowCaster) ->
      shadowCaster.castPoint());

  }
  
  void setPosition(float x, float y) {
    this.caster.setPosition(x, y);
    for (int i = 0; i < this.shadows.size(); i++) {
      float a = map(i, 0, this.shadows.size(), 0, TWO_PI);
      this.shadows.get(i).setPosition(x + (sin(a) * SHADOW_DIST), y + (cos(a) * SHADOW_DIST));
    }
  }
}
