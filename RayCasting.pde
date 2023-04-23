BoxBoundary canvasBoundary;
ArrayList<Boundary> boundaries;
ButtonContainer buttonContainer1;
ButtonContainer buttonContainer2;
CasterContainer caster;
Config config;

void setup() {
  // Define the canvas width and height
  //size(1900, 1000);
  fullScreen();
  noiseDetail(2, 0.7);

  ArrayList<Button> buttons = new ArrayList<Button>();
  buttons.add(new Button("Edit Boundaries", true, () -> { config.editing = !config.editing; }));
  buttons.add(new Button("Automatic Movement", true, () -> { config.autoMove = !config.autoMove; }));
  buttons.add(new Button("Snap Node On Edit", true, () -> { config.snapNodes = !config.snapNodes; }));
  buttons.add(new Button("Show Rays", true, () -> { config.casting = !config.casting; }));
  buttons.add(new Button("Show Cast Background", true, () -> { config.background = !config.background; }));
  buttonContainer1 = new ButtonContainer(buttons, 30, 30);

  ArrayList<Button> addButtons = new ArrayList<Button>();
  addButtons.add(new Button("+2 Boundary", false, () -> { boundaries.add(new Boundary(2)); }));
  addButtons.add(new Button("+3", false, () -> { boundaries.add(new Boundary(3)); }));
  addButtons.add(new Button("+4", false, () -> { boundaries.add(new Boundary(4)); }));
  addButtons.add(new Button("+5", false, () -> { boundaries.add(new Boundary(5)); }));
  buttonContainer2 = new ButtonContainer(addButtons, 30, 30 + 55);

  config = new Config(width / 2, height / 2);
  caster = new CasterContainer(config.centerPosition);
  canvasBoundary = new BoxBoundary(new Point(0, 0), new Point(width, 0), new Point(width, height), new Point(0, height), 255, 0);
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(6));
  for (String font : PFont.list())
    println(font);
  PFont myFont = createFont("Monospaced", 32);
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

  canvasBoundary.getLines().forEach((line) ->
    tempArray.add(line));
  boundaries.forEach((boundary) ->
    boundary.lines.forEach((line) ->
      tempArray.add(line)));
  buttonContainer1.buttons.forEach((boundary) ->
    boundary.lines.forEach((line) ->
      tempArray.add(line)));
  buttonContainer2.buttons.forEach((boundary) ->
    boundary.lines.forEach((line) ->
      tempArray.add(line)));

  if (!config.clicking) {
    if (config.background) caster.castBackground(tempArray);
    if (config.casting) caster.castRays(tempArray);
  }

  buttonContainer1.show();
  buttonContainer2.show();
  boundaries.forEach((b) ->
    b.show(config.editing));
}

void mouseReleased() {
  config.clicking = false;
  for (Boundary b : boundaries) {
    for (Point pt : b.points) {
      if (pt.getMoving()) {
        pt.setMoving(false);
      }
    }
  }
}

void mousePressed() {
  config.clicking = true;
  for (int i = boundaries.size(); i > 0; i--) {
    for (int j = boundaries.get(i - 1).points.size(); j > 0; j--) {
      if (boundaries.get(i - 1).points.get(j - 1).hovering()) {
        boundaries.get(i - 1).points.get(j - 1).setMoving(true);
        if (!config.snapNodes) return;
      }
    }
  }

  PVector mouse = new PVector(mouseX, mouseY);
  for (Button button : buttonContainer1.buttons)
    if (button.collides(mouse)) button.onClick();

  for (Button button : buttonContainer2.buttons)
    if (button.collides(mouse)) button.onClick();
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
