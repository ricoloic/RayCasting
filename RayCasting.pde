BoxBoundary canvasBoundary;
ArrayList<Boundary> boundaries;
ButtonContainer buttonContainer;
Caster caster;
Config config;

  //PVector centerPosition;
  //Boolean editing = false;
  //Boolean autoMove = false;
  //Boolean snapNodes = false;
  //Boolean casting = true;
  //Boolean moving = false;
  //Boolean background = true;
  //Float xoff = (float) 0;
  //Float yoff = (float) 11111;

void setup() {
  // Define the canvas width and height
  size(1900, 1000);
  fullScreen();
  noiseDetail(2, 0.7);

  ArrayList<Button> buttons = new ArrayList<Button>();

  buttons.add(new Button("Edit Boundaries", true, () -> { config.editing = !config.editing; }));
  buttons.add(new Button("Automatic Movement", true, () -> { config.autoMove = !config.autoMove; }));
  buttons.add(new Button("Snap Node On Edit", true, () -> { config.snapNodes = !config.snapNodes; }));
  buttons.add(new Button("Show Casting", true, () -> { config.casting = !config.casting; }));
  buttons.add(new Button("+2 Boundary", false, () -> { boundaries.add(new Boundary(2)); }));
  buttons.add(new Button("+3", false, () -> { boundaries.add(new Boundary(3)); }));
  buttons.add(new Button("+4", false, () -> { boundaries.add(new Boundary(4)); }));
  buttons.add(new Button("+5", false, () -> { boundaries.add(new Boundary(5)); }));

  buttonContainer = new ButtonContainer(buttons, 30, 30, 50);
  config = new Config(width / 2, height / 2);
  caster = new Caster(config.centerPosition);
  canvasBoundary = new BoxBoundary(
    new Point(0, 0),
    new Point(width, 0),
    new Point(width, height),
    new Point(0, height),
    255,
    0
    );
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(6));
  for (String font : PFont.list())
    println(font);
  PFont myFont = createFont("Monospaced.plain", 32);
  textFont(myFont);
}

void draw() {
  background(50);

  if (config.autoMove) {
    caster.setPosition(noise(config.xoff) * width, noise(config.yoff) * height);
    config.xoff += 0.01;
    config.yoff += 0.01;
  } else {
    caster.setPosition(mouseX, mouseY);
  }

  ArrayList<LineBoundary> tempArray = new ArrayList<LineBoundary>();

  canvasBoundary.getLines().forEach((line) -> tempArray.add(line));

  boundaries.forEach((boundary) ->
    boundary.lines.forEach((line) ->
    tempArray.add(line)));

  buttonContainer.buttons.forEach((boundary) ->
    boundary.lines.forEach((line) ->
      tempArray.add(line)));

  canvasBoundary.show(false);
  Boolean collides = false;


  if (!config.moving) {
    if (config.background) caster.castBackground(tempArray);
    if (config.casting && !collides) caster.castRays(tempArray);
  }

  buttonContainer.show(mouseX, mouseX);
  boundaries.forEach((b) -> b.show(config.editing));
}

void mouseReleased() {
  config.moving = false;
  for (Boundary b : boundaries) {
    for (Point pt : b.points) {
      if (pt.getMoving()) {
        pt.setMoving(false);
      }
    }
  }
}

void mousePressed() {
  config.moving = true;
  for (int i = boundaries.size(); i > 0; i--) {
    for (int j = boundaries.get(i - 1).points.size(); j > 0; j--) {
      if (boundaries.get(i - 1).points.get(j - 1).hovering()) {
        boundaries.get(i - 1).points.get(j - 1).setMoving(true);
        if (!config.snapNodes) return;
      }
    }
  }

  for (Button button : buttonContainer.buttons)
    if (button.collides(new PVector(mouseX, mouseY))) button.onClick();
}

void keyPressed() {
  if (keyCode == 69) {
    config.editing = !config.editing;
  } else if (keyCode == 65) {
    boundaries.add(new Boundary(3));
  } else if (keyCode == 83) {
    config.snapNodes = !config.snapNodes;
  } else if (keyCode == 77) {
    config.autoMove = !config.autoMove;
  } else if (keyCode == 67) {
    config.casting = !config.casting;
  } else if (keyCode == 66) {
    config.background = !config.background;
  }
}
