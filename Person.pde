class Person {
  
  String name;
  IntList availableTimes;
  Button button;
  
  Person(String name_) {
    
    name = name_;
    availableTimes = new IntList();
    button = new Button(name, 0, 0);
    
  }
  
  
  void displayButton(int x, int y) {
    
    button.setX(x);
    button.setY(y);
    button.display();
    
  }
  
  
  
  void addTime(int time) {
    
    availableTimes.append(time);
    
  }
  

  
  IntList getAvailableTimes() {
    return availableTimes;
  }
  
  boolean getButtonClicked() {
    return button.getClicked();
  }
  
  
  
}
