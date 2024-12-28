class DropDown {
  
  StringList options;
  Button optionButton;
  ArrayList<Button> optionsButtons;
  int selected;
  boolean openClosed;
  int x;
  int y;
  int w;
  int h;
  
  DropDown(StringList options_, int x_, int y_) {
    
    options = options_.copy();
    optionsButtons = new ArrayList<Button>();
    selected = 0;
    openClosed = false;
    x = x_;
    y = y_;
    w = 100;
    h = 21;
    
    for (int i = 0; i < options.size(); i++) {
      optionButton = new Button(options.get(i), x, y + i * 21);
      optionButton.setRGB(255, 255, 255);
      optionsButtons.add(optionButton);
    }
    
  }
  
  
  
  void display() {
    
    if (openClosed) {
      displayOpen();
    } else {
      displayClosed();
    }
    
  }
  
  void displayOpen() {
    
    int mouseInOption = -1;
    for (int i = 0; i < optionsButtons.size(); i++) {
      optionsButtons.get(i).setY(y + i * 21);
      optionsButtons.get(i).display();
      if (optionsButtons.get(i).mouseInButton()) {
        mouseInOption = i;
      }
      if (optionsButtons.get(i).getClicked()) {
        openClosed = false;
        selected = i;
        optionsButtons.get(i).setY(y);
        optionsButtons.get(i).setClicked(false);
      }
    }
    if (mouseInOption != -1) {
      optionsButtons.get(mouseInOption).display();
    }
    
  }
  
  void displayClosed() {
    optionsButtons.get(selected).display();
    if (optionsButtons.get(selected).getClicked()) {
      openClosed = true;
      optionsButtons.get(selected).setClicked(false);
    }
  }
  
  
  boolean mouseInDropDown() {
    if (openClosed && mouseIn(x, y, w, h * optionsButtons.size())) {
      return true;
    } else if (!openClosed && mouseIn(x, y, w, h)) {
      return true;
    } else {
      return false;
    }
  }
  
  
  
  void setX(int x_) {
    x = x_;
    for (int i = 0; i < optionsButtons.size(); i++) {
      optionsButtons.get(i).setX(x);
    }
  }
  
  void setY(int y_) {
    y = y_;
    for (int i = 0; i < optionsButtons.size(); i++) {
      optionsButtons.get(i).setY(y);
    }
  }
  
  void setW(int w_) {
    w = w_;
    for (int i = 0; i < optionsButtons.size(); i++) {
      optionsButtons.get(i).setW(w);
    }
  }
  
  void setH(int h_) {
    h = h_;
    for (int i = 0; i < optionsButtons.size(); i++) {
      optionsButtons.get(i).setH(h);
    }
  }
  
  void setOpenClosed(boolean openClosed_) {
    openClosed = openClosed_;
  }
  
  boolean getOpenClosed() {
    return openClosed;
  }
  
  int getSelected() {
    return selected;
  }
  
  String getChoice() {
    return optionsButtons.get(selected).getSign();
  }
  
  Button getSelectedButton() {
    return optionsButtons.get(selected);
  }
  
  
  
}
