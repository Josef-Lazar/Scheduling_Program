class Button {
  
  String sign;
  int x;
  int y;
  int w;
  int h;
  boolean clicked;
  int r,g,b;
  
  Button (String sign_, int x_, int y_) {
    
    sign = sign_;
    x = x_;
    y = y_;
    w = 100;
    h = 21;
    clicked = false;
    r = 200;
    g = 200;
    b = 255;
    
  }
  
  
  
  void display() {
    
    if (mr && mouseIn(x, y, w, h)) {
      mr = false;
      clicked = !clicked;
    }
    if (mouseIn(x, y, w, h)) {
      strokeWeight(2);
    } else if (clicked) {
      strokeWeight(1.4);
    } else {
      strokeWeight(1);
    }
    if (mousePressed && mouseIn(x, y, w, h)) {
      fill(r - 100, g - 100, b - 100);
    } else if (clicked) {
      fill(r - 50, g - 50, b - 50);
    } else {
      fill(r, g, b);
    }
    rect(x, y, w, h);
    fill(0);
    textSize(15);
    text(sign, x + 4, y + 16);
    
  }
  
  boolean mouseInButton() {
    if (mouseIn(x, y, w, h)) {
      return true;
    } else {
      return false;
    }
  }
  
  
  
  String getSign() {
    return sign;
  }
  
  void setX(int x_) {
    x = x_;
  }
  
  void setY(int y_) {
    y = y_;
  }
  
  void setW(int w_) {
    w = w_;
  }
  
  void setH(int h_) {
    h = h_;
  }
  
  void setClicked(boolean clicked_) {
    clicked = clicked_;
  }
  
  boolean getClicked() {
    return clicked;
  }
  
  void setRGB(int r_, int g_, int b_) {
    r = r_;
    g = g_;
    b = b_;
  }
  
  
  
}
