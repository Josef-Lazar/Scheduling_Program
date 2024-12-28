/**
 * Josef Lazat
 * 4/24/2022
 * Computer Science Moderation Project
 * Scheduling Program
 * Collaboration Statement: I worked alone on this project.
 * Instructions:
   You can edit the people in this program by making changes to the names.txt file in the data folder.
   The names.txt file should be in the following example format:
   
John
21510 22300
40800 41045
     
Alice
10800 12359
51200 52359
31600 62359

  When a line is considered a valid name (a string with at least 1 non-space character, that doesn't contain any numbers) a new person is added
  Wehn a line is considered a valid time frame (a sting containing a number followed by a space, followed by a larger number),
  that time frame is added to the availability of the person whose name is most closely above this line
  the first number is when the person becomes available, and the second is when the person is no longer available
  The first digit represents a day: 1 = Monday, 2 = Tuesday, ..., 7 = Sunday.
  The second and third digits represent the hour of the day.
  It is crusial to include a 0 in times that are earlier than 10, so 05 = 5am, but 5 alone will mess up the program
  Military time is used, so 03 = 3pm and 15 = 3pm.
  The fourth and fifth digits represent the minute within the hour.
  So 51445 = Friday, 2:45pm.
  Strings that are not valid names or time frames are ignored.
  We can see in out example names.txt file that Jonh will be available on Tuesday from 3:10pm to 11:00pm, and on Thursday from 8:00am to 10:45am.
 */

String[] lines;
ArrayList<Person> people;
boolean mr;
int r, g, b;
Button findTimes;
ArrayList<Person> selectedPeople;
IntList selectedPeopleTimeOverlaps;
ArrayList<PVector> selectedPeopleTimeFrames;
DropDown days;
DropDown hh;
DropDown m1;
DropDown m2;
DropDown amPm;
ArrayList<DropDown> dropDowns;



void setup() {
  
  size(1300, 500);
  r = int(random(200, 255));
  g = int(random(200, 255));
  b = int(random(200, 255));
  background(r, g, b);
  lines = loadStrings("names.txt");
  people = new ArrayList<Person>();
  
  for (int i = 0; i < lines.length && people.size() < 24; i++) {
    if (isItAName(lines[i])) { //the lines[i] string must have at least one non-space character and not contain any numbers
      people.add(new Person(lines[i]));
    } else if (isItATimeFrame(lines[i])) { //the lines[i] string must contain a number followed by a space followed by a larger nubmer
      int startTime = int(split(lines[i], " ")[0]); //the smaller number
      int endTime = int(split(lines[i], " ")[1]); //the larger number
      for (int j = startTime; j <= endTime; j++) { //adds all the number between the smaller and larger number to a list of a persons available times
        people.get(people.size() - 1).addTime(j);
      }
    }
  }
  while (people.size() > 24) { //caps the amont of people to 24 (this is done so all the buttons would fint, it could be increased if size of the window was stretched down)
    people.remove(people.size() - 1);
  }
  
  findTimes = new Button("Find Times", 50, 50 + 35 * (people.size() % 3 == 0 ? people.size()/3 : (people.size()/3 + 1)));
  findTimes.setRGB(200, 255, 200);
  selectedPeople = new ArrayList<Person>();
  selectedPeopleTimeOverlaps = new IntList();
  selectedPeopleTimeFrames = new ArrayList<PVector>();
  
  
  days = new DropDown(new StringList("chose day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), 880, 50);
  hh = new DropDown(new StringList("hh", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"), 1015, 50);
  hh.setW(25);
  m1 = new DropDown(new StringList("m", "0", "1", "2", "3", "4", "5"), 1054, 50);
  m1.setW(20);
  m2 = new DropDown(new StringList("m", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"), 1074, 50);
  m2.setW(20);
  amPm = new DropDown(new StringList("am/pm", "am", "pm"), 1100, 50);
  amPm.setW(60);
  dropDowns = new ArrayList<DropDown>();
  dropDowns.add(days);
  dropDowns.add(hh);
  dropDowns.add(m1);
  dropDowns.add(m2);
  dropDowns.add(amPm);
  
}



void draw() {
  
  background(r, g, b);
  text("select the people whom you would like to meet with", 40, 30);
  for (int i = 0; i < people.size(); i++) {
    people.get(i).displayButton(50 + 114 * (i % 3), 50 + 35 * (i/3));
  }
  
  findTimes.display();
  
  if (findTimes.getClicked()) {
    selectedPeople.clear();
    for (int j = 0; j < people.size(); j++) {
      if (people.get(j).getButtonClicked()) {
        selectedPeople.add(people.get(j));
      }
    }
    findTimes.setClicked(false);
    selectedPeopleTimeOverlaps = timeOverlaps(selectedPeople);
    selectedPeopleTimeFrames = timeFrames(selectedPeopleTimeOverlaps);
  }
  
  for (int k = 0; k < selectedPeopleTimeFrames.size(); k++) {
    text("From: " + numberToDayAndTime(str(int(selectedPeopleTimeFrames.get(k).x))) +
         ", to: " + numberToDayAndTime(str(int(selectedPeopleTimeFrames.get(k).y))), 430, 100 + 20 * k);
  }
  if (selectedPeopleTimeFrames.size() < 1) {
    text("No Overlaping times", 430, 100);
  }
  
  
  text("select the time when you would like to meet", 870, 30);
  
  if (isDropDownOpenClosed()) {
    for (int l = 0; l < dropDowns.size(); l++) {
      if (dropDowns.get(l).mouseInDropDown() && !dropDowns.get(l).getOpenClosed()) {
        closeDropDowns(dropDowns);
        dropDowns.get(l).setOpenClosed(true);
      }
    }
  }
  
  if (inputToString().length() > 5) {
    text(inputToString(), 900, 100);
} else {
    for (int m = 0; m < peopleAvailableAt(people, int(inputToString())).size(); m++){
      text(peopleAvailableAt(people, int(inputToString())).get(m).name, 900, 100 + 20 * m);
    }
  }
  
  days.display();
  text("at", 990, 67);
  hh.display();
  text(":", 1045, 67);
  m1.display();
  m2.display();
  if (m1.mouseInDropDown()) {
    m1.display();
  }
  amPm.display();
  
  
  mr = false;
  
}



//checks if the inputed string is a name - a name is a string that has at least one non-space character, and no numbers 
boolean isItAName(String s) {
  
  if (trim(s).equals("")) {
    return false;
  }
  
  if (s.length() >= 1) {
    for (int i = 0; i < s.length() - 1; i++) {
      String l = s.substring(i, i+1);
      if (isItANumber(l)) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
  
}



//checks if the inputed string is a time frame - a time frame is a string that has two numbers separated by a space, and whose first number is smaller than its second number
boolean isItATimeFrame(String s) {
  
  String[] startAndEnd = split(s, " ");
  if (startAndEnd.length == 2) {
    if (isItANumber(startAndEnd[0]) && isItANumber(startAndEnd[1])) {
      if (int(startAndEnd[0]) <= int(startAndEnd[1])) {
        return true;
      }
      println("check names file, there might be an error at: " + startAndEnd[0] + " " + startAndEnd[1]);
      return false;
    } else {
      return false;
    }
  } else {
    return false;
  }
  
}



//checks if every character in a string is a number
boolean isItANumber(String s) {
  
  if (s.length() > 0) {
    for (int i = 0; i < s.length() - 1 || i == 0; i++) {
      String l = s.substring(i, i+1);
      if (!l.equals("0") && !l.equals("1") && !l.equals("2") && !l.equals("3") && !l.equals("4") && !l.equals("5") && !l.equals("6") && !l.equals("7") && !l.equals("8") && !l.equals("9")) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
  
}



//returns an IntList containing all the times at which the inputed people are available
IntList timeOverlaps(ArrayList<Person> p) {
  
  int possibleOverlap = 9999;
  IntList overlaps = new IntList();
  
  while (possibleOverlap < 72401) {
    if (arePeopleAvailable(p, possibleOverlap)) {
      overlaps.append(possibleOverlap);
    }
    possibleOverlap++;
  }
  
  return overlaps;
  
}



//checks if the inputed person is available at the inputed time
boolean isPersonAvailable(Person p, int time) {
  
  for (int i = 0; i < p.getAvailableTimes().size(); i++) {
    if (time == p.getAvailableTimes().get(i)) {
      return true;
    }
  }
  return false;
  
}



//checks if the inputed people are available at the inputed time
boolean arePeopleAvailable(ArrayList<Person> p, int time) {
  
  for (int i = 0; i < p.size(); i++) {
    if (!isPersonAvailable(p.get(i), time)) {
      return false;
    }
  }
  return true;
  
}



//returns a list of people from the inputed list, who are available at the inputed time
ArrayList<Person> peopleAvailableAt(ArrayList<Person> p, int time) {
  
  ArrayList<Person> availablePeople = new ArrayList<Person>();
  for (int i = 0; i < p.size(); i++) {
    if (isPersonAvailable(p.get(i), time)) {
      availablePeople.add(p.get(i));
    }
  }
  return availablePeople;
  
}



//checks if the mouse cursor is within the rectoangle whose x, y, w, and h are inputed
boolean mouseIn(int x, int y, int w, int h) {
  
  if (x < mouseX && mouseX < x + w && y < mouseY && mouseY < y + h) {
    return true;
  } else {
    return false;
  }
  
}



//outputs a string containing a day, hour, minute, and am/pm, based on an inputed string of 5 numbers, where the first number is the day, the next two are the hour in military time, and the last two are the minute 
String numberToDayAndTime(String n) {
  
  String day;
  String hours;
  String minutes;
  String ampm;
  if (n.length() == 5 && isItANumber(n)) {
    switch(n.substring(0, 1)) {
      case "1": day = "Monday"; break;
      case "2": day = "Tuesday"; break;
      case "3": day = "Wednesday"; break;
      case "4": day = "Thursday"; break;
      case "5": day = "Friday"; break;
      case "6": day = "Saturday"; break;
      case "7": day = "Sunday"; break;
      default: day = "input is in wrong format"; break;
    }
    if (int(n.substring(1, 3)) > 12) {
      hours = str(int(n.substring(1, 3)) - 12);
      ampm = "pm";
    } else if (int(n.substring(1, 3)) == 12) {
      hours = "12";
      ampm = "pm";
    } else {
      hours = n.substring(1, 3);
      ampm = "am";
    }
    minutes = n.substring(3, 5);
    return day + " " + hours + ":" + minutes + ampm;
  } else {
    return "input is in wrong format";
  }
  
}



//translates a list of every time that someone is available to a list of time frame vectors, whose x is when they become available, and whose y is when they stop being available
ArrayList<PVector> timeFrames(IntList times) {
  
  ArrayList<PVector> tf = new ArrayList<PVector>();
  if (times.size() < 1) {
    return tf;
  }
  int start = times.get(0);
  int end;
  for (int i = 0; i < times.size() - 1; i++) {
    if (times.get(i) + 1 != times.get(i + 1)) {
      end = times.get(i);
      tf.add(new PVector(start, end));
      start = times.get(i + 1);
    }
  }
  end = times.get(times.size() - 1);
  tf.add(new PVector(start, end));
  return tf;
  
}



//checks if there is a drop down that is open
boolean isDropDownOpenClosed() {
  
  for (int l = 0; l < dropDowns.size(); l++) {
    if (dropDowns.get(l).getOpenClosed()) {
      return true;
    }
  }
  return false;
  
}



//closes all the inputed drop downs
void closeDropDowns(ArrayList<DropDown> dropDown) {
  
  for (int i = 0; i < dropDown.size(); i++) {
    dropDown.get(i).getSelectedButton().setY(50);
    dropDown.get(i).setOpenClosed(false);
  }
  
}



//makes a 5 digit string representing the users drop down inputs
String inputToString() {
  
  String d;
  String h;
  String m;
  if (days.getChoice().equals("chose day")) {
    return "Please select a valid day";
  } else if (hh.getChoice().equals("hh")) {
    return "Please select a valid hour";
  } else if (m1.getChoice().equals("m") || m2.getChoice().equals("m")) {
    return "Please select a valid minute";
  } else if (amPm.getChoice().equals("am/pm")) {
    return "Please select am or pm";
  } else {
    d = str(days.getSelected());
    h = str(hh.getSelected() + (amPm.getSelected() == 1 ? 0 : 12));
    h = h.length() == 1 ? "0" + h : h;
    m = str(m1.getSelected() - 1) + str(m2.getSelected() - 1);
    return d + h + m;
  }
  
}





void mouseReleased() {
  
  mr = true;
  for (int i = 0; i < dropDowns.size(); i++) {
    if (dropDowns.get(i).getOpenClosed() && !dropDowns.get(i).mouseInDropDown()) {
      dropDowns.get(i).setOpenClosed(false);
    }
  }
  
}



void keyPressed() {
  
  //for (int i = 0; i < selectedPeople.size(); i++) {
  //  println(selectedPeople.get(i).name);
  //}
  
  //IntList okay = new IntList(2, 3, 4, 5, 10, 11, 12);
  //ArrayList<PVector> test = timeFrames(okay);
  //println(test.get(0).x);
  //println(test.get(0).y);
  //println(test.get(1).x);
  //println(test.get(1).y);
  
  //println(inputToString());
  
}
