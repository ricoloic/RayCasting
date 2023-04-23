class ButtonContainer {
  int x;
  int y;
  int spacing;
  ArrayList<Button> buttons;

  ButtonContainer(ArrayList<Button> buttons,int x, int y, int spacing) {
    this.x = x;
    this.y =  y;
    this.spacing = spacing;
    this.buttons = new ArrayList<Button>();
    for (int i = 0; i < buttons.size(); i++) {
      Button button = buttons.get(i);
      float buttonX = (i == 0 ? x : buttons.get(i - 1).getMaxX());
      button.move(buttonX, y);
      this.buttons.add(button);
    }
  }

  ButtonContainer(int x, int y, int spacing) {
    this.x = x;
    this.y =  y;
    this.spacing = spacing; 
    this.buttons = new ArrayList<Button>();
  }
  
  void add(Button button) {
    int size = buttons.size();
    float buttonX = (size == 0 ? x : buttons.get(size - 1).getMaxX());
    button.move(buttonX, y);
    this.buttons.add(button);
  }

  void show(int colliderX, int colliderY) {
    this.buttons.forEach((button) -> button.show());
  }

  void click() {
    for (Button button : this.buttons)
      button.onClick();
  }
}
