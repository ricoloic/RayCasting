BoxBoundary canvasBoundary;
ArrayList<Boundary> boundaries;
ButtonContainer buttonContainer1;
ButtonContainer buttonContainer2;
CasterContainer caster;
Config config;

void saveBoundariesToFile() {
  JSONArray list = new JSONArray();
  
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary b = boundaries.get(i);
    JSONArray pointList = new JSONArray();
    for (int j = 0; j < b.points.size(); j++) {
      Point p = b.points.get(j);
      JSONArray pt = new JSONArray();
      pt.setFloat(0, (float) p.x);
      pt.setFloat(1, (float) p.y);
      pointList.setJSONArray(j, pt);
    }
    list.setJSONArray(i, pointList);
  }

  saveJSONArray(list, "data/boundaries.json");
}

ArrayList<Boundary> createInitialLayout() {
  JSONArray jsonBoundaries = loadJSONArray("boundaries.json");
  ArrayList<Boundary> boundaryList = new ArrayList<Boundary>();
  
  for (int i = 0; i < jsonBoundaries.size(); i++) {
    JSONArray jsonPoints = jsonBoundaries.getJSONArray(i);
    ArrayList<Point> boundaryPoints = new ArrayList<Point>();
    for (int j = 0; j < jsonPoints.size(); j++) {
      JSONArray jsonPoint = jsonPoints.getJSONArray(j);
      boundaryPoints.add(new Point(jsonPoint.getFloat(0), jsonPoint.getFloat(1)));
    }
    boundaryList.add(new Boundary(boundaryPoints));
  }

  return boundaryList;
}

void setup() {
  // Define the canvas width and height
  //size(1900, 1000);
  fullScreen();
  noiseDetail(2, 0.7);

  ArrayList<Button> buttons = new ArrayList<Button>();
  buttons.add(new Button("Edit Boundaries", () -> { config.editing = !config.editing; }));
  buttons.add(new Button("Automatic Movement", () -> { config.autoMove = !config.autoMove; }));
  buttons.add(new Button("Snap Node On Edit", () -> { config.snapNodes = !config.snapNodes; }));
  buttons.add(new Button("Show Rays", () -> { config.casting = !config.casting; }));
  buttons.add(new Button("Show Cast Background", () -> { config.background = !config.background; }));
  buttonContainer1 = new ButtonContainer(buttons, 30, 30);

  ArrayList<Button> addButtons = new ArrayList<Button>();
  addButtons.add(new Button("Clear Boundaries", () -> { boundaries = new ArrayList<Boundary>(); }));
  addButtons.add(new Button("+2 Boundary", () -> { boundaries.add(new Boundary(2)); }));
  addButtons.add(new Button("+3", () -> { boundaries.add(new Boundary(3)); }));
  addButtons.add(new Button("+4", () -> { boundaries.add(new Boundary(4)); }));
  addButtons.add(new Button("+5", () -> { boundaries.add(new Boundary(5)); }));
  buttonContainer2 = new ButtonContainer(addButtons, 30, 30 + 55);

  config = new Config(width / 2, height / 2);
  caster = new CasterContainer(config.centerPosition, #33a1fd);
  canvasBoundary = new BoxBoundary(new Point(0, 0), new Point(width, 0), new Point(width, height), new Point(0, height), 255, 0);
  boundaries = createInitialLayout();
  for (String font : PFont.list())
    println(font);
  PFont myFont = createFont("Monospaced", 32);
  textFont(myFont);
}

void draw() {
  background(#f4d06f);

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
  } else if (keyCode == 70) {
    saveBoundariesToFile();
  }
}
