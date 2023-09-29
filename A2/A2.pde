import processing.sound.*;

ArrayList<InstBox> instBoxes = new ArrayList<InstBox>();
ArrayList<SlotBox> slotBoxes = new ArrayList<SlotBox>();
ArrayList<Button> buttons = new ArrayList<Button>();
GridBox[][] grid = new GridBox[4][8];

//people counter data
boolean[][] data = new boolean[4][8];

//sound files
SoundFile[] instSound60_A = new SoundFile[4];
SoundFile[] instSound60_B = new SoundFile[4];
SoundFile[] instSound90_A = new SoundFile[4];
SoundFile[] instSound90_B = new SoundFile[4];
SoundFile[] instSound120_A = new SoundFile[4];
SoundFile[] instSound120_B = new SoundFile[4];

float bpm;
String bpmString = "60";

float frameCounter = 0;

boolean playing = true;

float boxSize = 80;

float instBoxX;
float instBoxY;

float slotBoxX;
float slotBoxY;

float boxGap = boxSize + 10;

float instBoxOffsetX;
float slotBoxOffsetX;
float slotBoxOffsetY;

float gridX;
float gridY;
float gridOffsetY;
float gridOffsetX;

int barNum = 0;

float barX;
float barY;
float barOffsetX;

float playButtonX;
float playButtonY;
float playButtonOffsetX;
String[] playButtonFunc = {"PAUSE", "STOP"};

float tempoButtonX;
float tempoButtonY;
float tempoButtonOffsetX;
String[] tempoButtonFunc = {"60", "90", "120"};

float trackButtonX;
float trackButtonY;
float trackButtonOffsetX;
String[] trackButtonFunc = {"ONE", "TWO"};

int heldBoxIndex = -1;

color slotColor = color(0);
color instColor = color(255);
color gridColor = color(200);
color gridColorData = color(100);
color barColor = color(225);
color barColorNum = color(125);
color buttonColor = color(240);
color buttonPressedColor = color(200);

void setup(){
  frameRate(60);
  background(255);
  size(1080, 720);
 
  rectMode(CENTER);
  instBoxX = width * 0.2;
  instBoxY = height * 0.9;
  
  slotBoxX = width * 0.15;
  slotBoxY = height * 0.2;

  gridX = slotBoxX + boxGap;
  gridY = slotBoxY;
  
  barX = slotBoxX + boxGap;
  barY = slotBoxY + boxGap * 4;
  
  playButtonX = slotBoxX;
  playButtonY = height * 0.75;
  
  tempoButtonX = slotBoxX + boxGap * 3;
  tempoButtonY = playButtonY;
  
  trackButtonX = slotBoxX + boxGap * 7;
  trackButtonY = playButtonY;
  
  /*
  instSound60_A[0] = (new SoundFile(this, ""));
  instSound60_A[1] = (new SoundFile(this, ""));
  instSound60_A[2] = (new SoundFile(this, ""));
  instSound60_A[3] = (new SoundFile(this, ""));
  
  instSound60_B[0] = (new SoundFile(this, ""));
  instSound60_B[1] = (new SoundFile(this, ""));
  instSound60_B[2] = (new SoundFile(this, ""));
  instSound60_B[3] = (new SoundFile(this, ""));
  
  instSound90_A[0] = (new SoundFile(this, ""));
  instSound90_A[1] = (new SoundFile(this, ""));
  instSound90_A[2] = (new SoundFile(this, ""));
  instSound90_A[3] = (new SoundFile(this, ""));
  
  instSound90_B[0] = (new SoundFile(this, ""));
  instSound90_B[1] = (new SoundFile(this, ""));
  instSound90_B[2] = (new SoundFile(this, ""));
  instSound90_B[3] = (new SoundFile(this, ""));
  
  instSound120_A[0] = (new SoundFile(this, ""));
  instSound120_A[1] = (new SoundFile(this, ""));
  instSound120_A[2] = (new SoundFile(this, ""));
  instSound120_A[3] = (new SoundFile(this, ""));
  
  instSound120_B[0] = (new SoundFile(this, ""));
  instSound120_B[1] = (new SoundFile(this, ""));
  instSound120_B[2] = (new SoundFile(this, ""));
  instSound120_B[3] = (new SoundFile(this, "")); 
  
  bpm = instSound60_A[0].duration() * 60;
  */
  
  /*
  
  fill data here:
  
  */
  
  
  //create slotBoxes
  for(int i = 0; i < 4; i++){
    slotBoxes.add(new SlotBox(slotBoxX, slotBoxY + slotBoxOffsetY, boxSize));
    slotBoxOffsetY += boxGap;
  }
  
  //create instBoxes
  for(int i = 0; i < 4; i++){
    instBoxes.add(new InstBox(instBoxX + instBoxOffsetX, instBoxY, boxSize, instSound60_A[i]));
    instBoxOffsetX += boxGap;
  }
  
  //create gridBoxes
  for(int a = 0; a < 4; a++){
    for(int b = 0; b < 8; b++){
      grid[a][b] = new GridBox(gridX + gridOffsetX, gridY + gridOffsetY, boxSize);
      grid[a][b].addData(data[a][b]);
      gridOffsetX += boxGap;
    }
    gridOffsetX = 0;
    gridOffsetY += boxGap;
  }
  
  //create play buttons
  for(int i = 0; i < 2; i++){
    buttons.add(new Button(playButtonX + playButtonOffsetX, playButtonY, boxSize, playButtonFunc[i]));
    playButtonOffsetX += boxGap;
  }
  
  //create tempo buttons
  for(int i = 0; i < 3; i++){
    buttons.add(new Button(tempoButtonX + tempoButtonOffsetX, tempoButtonY, boxSize, tempoButtonFunc[i]));
    tempoButtonOffsetX += boxGap;
  }
  
  //create track buttons
  for(int i = 0; i < 2; i++){
    buttons.add(new Button(trackButtonX + trackButtonOffsetX, trackButtonY, boxSize, trackButtonFunc[i]));
    trackButtonX += boxGap;
  }
}

void draw() {
  if(playing){
    frameCounter++;
  } else {
    for(SlotBox slot : slotBoxes){
      if(slot.box != null){
        slot.box.soundFile.stop();
      }
    }
  }
  
  background(255);
  noStroke();
  
  //draw gridBoxes
  for(int a = 0; a < 4; a++){
    for(int b = 0; b < 8; b++){
      GridBox box = grid[a][b];
      if(box.hasData){
        fill(gridColorData);
      } else {
        fill(gridColor);
      }
      rect(box.x, box.y, box.size, box.size);
    }
  }
  
  //draw bar indicator
  for(int i = 0; i < 8; i++){
    if (barNum == i){
      fill(barColorNum);
    } else {
      fill(barColor);
    }
    rect(barX + barOffsetX, barY - boxSize * 0.4, boxSize, boxSize * 0.25);
    barOffsetX += boxGap;
  }
  barOffsetX = 0;
  
  //draw slotBoxes
  fill(slotColor);
  for (SlotBox box : slotBoxes) {
    rect(box.x, box.y, box.size, box.size);
  }
  
  //draw buttons
  stroke(0);
  fill(buttonColor);
  for(Button button : buttons){
    if(!button.function.equals("PAUSE") && button.pressed){
      button.pressedCooldown();
    }
    if(button.pressed){
      fill(buttonPressedColor);
    } else {
      fill(buttonColor);
    }
    rect(button.x, button.y, button.size, button.size);
  }
  
  //draw instBoxes
  fill(instColor);
  for (InstBox box : instBoxes) {
    if(box.moving){
      box.x = mouseX;
      box.y = mouseY;
    }
    rect(box.x, box.y, box.size, box.size);
  }
  
  
  if (frameCounter >= bpm) {
    barNum++;
    frameCounter = 0;
    if(barNum >= 8) {
      barNum = 0;
    }
    for(int i = 0; i < 4; i++){
      if(grid[i][barNum].hasData){
        if(slotBoxes.get(i).box != null){
          slotBoxes.get(i).box.soundFile.play();
        }
      }
    }
  }  
}

void mousePressed() {
  //instBox drag and drop
  for (int i = 0; i < instBoxes.size(); i++) {
    InstBox box = instBoxes.get(i);
    if ((mouseX >= box.x - boxSize / 2 && mouseX <= box.x + boxSize / 2) && (mouseY >= box.y - boxSize / 2 && mouseY <= box.y + boxSize / 2)) {
      heldBoxIndex = i;
      box.moving = true;
    }
  }
  
  //button interaction
  for(Button button : buttons){
    if ((mouseX >= button.x - boxSize / 2 && mouseX <= button.x + boxSize / 2) && (mouseY >= button.y - boxSize / 2 && mouseY <= button.y + boxSize / 2)) {
      if(button.function.equals("PAUSE") && !button.pressed){
        button.pressed = true;
        playing = false;
      } else if(button.function.equals("PAUSE")){
        button.pressed = false;
        playing = true;
      } else if(button.function.equals("STOP")){
        button.pressed = true;
        playing = false;
        frameCounter = 0;
        barNum = 0;
        buttons.get(0).pressed = true;
      } else if(button.function.equals("60")){
        button.pressed = true;
        bpmString = "60";
        bpm = instSound60_A[0].duration() * 60;
      } else if(button.function.equals("90")){
        button.pressed = true;
        bpmString = "90";
        bpm = instSound90_A[0].duration() * 60;
      } else if(button.function.equals("120")){
        button.pressed = true;
        bpmString = "120";
        bpm = instSound120_A[0].duration() * 60;
      } else if(button.function.equals("ONE")){
        button.pressed = true;
        for(int i = 0; i < instBoxes.size(); i++){
          if(bpmString.equals("60")){
            instBoxes.get(i).soundFile = instSound60_A[i];
          } else if (bpmString.equals("90")) {
            instBoxes.get(i).soundFile = instSound90_A[i];
          } else if (bpmString.equals("120")) {
            instBoxes.get(i).soundFile = instSound120_A[i];
          } else {
            println("##Track button error");
          }
        }    
      } else if(button.function.equals("TWO")){
        button.pressed = true;
        for(int i = 0; i < instBoxes.size(); i++){
          if(bpmString == "60"){
            instBoxes.get(i).soundFile = instSound60_B[i];
          } else if (bpmString == "90") {
            instBoxes.get(i).soundFile = instSound90_B[i];
          } else if (bpmString == "120") {
            instBoxes.get(i).soundFile = instSound120_B[i];
          } else {
            println("##Track button error");
          }
        }
      } else {
        println("##Button function error");
      }
    }
  }
}

void mouseReleased() {
  //instBoxes drag and drop
  if(heldBoxIndex != -1){
    InstBox heldBox = instBoxes.get(heldBoxIndex);
    heldBoxIndex = -1;
    SlotBox orgBox = null;
    
    for (SlotBox slotBox : slotBoxes) {
      if(slotBox.box == heldBox){
        orgBox = slotBox;
      }
    }
    
    for (SlotBox slotBox : slotBoxes) {
      if ((mouseX >= slotBox.x - boxSize / 2 && mouseX <= slotBox.x + boxSize / 2) && (mouseY >= slotBox.y - boxSize / 2 && mouseY <= slotBox.y + boxSize / 2)) {
        if(slotBox.box != null){
          if(orgBox != null){
            slotBox.swap(heldBox, orgBox);
          } else {
            slotBox.replace(heldBox);
          }
        } else {
          slotBox.fill(heldBox);
        }
        return;
      } 
    }
    for (SlotBox slotBox : slotBoxes) {
      if(slotBox.box == heldBox){
        slotBox.removeBox();
        return;
      }
    }
    heldBox.returnBox();
  }
}

class Box {
  
  float x;
  float y;
  float size;
  
  Box(float x, float y, float size){
    this.x = x;
    this.y = y;
    this.size = size;
  }
}

class Button extends Box {

  String function;
  boolean pressed;
  float pressedCooldown;
  float currentCooldown;
  
  Button(float x, float y, float size, String function){
    super(x,y,size);
    this.function = function;
    pressedCooldown = 10;
  }
  
  void pressedCooldown(){
    currentCooldown++;
    if (currentCooldown >= pressedCooldown){
      currentCooldown = 0;
      pressed = false;
    }
  }
}

class GridBox extends Box {
  
  boolean hasData;
  
  GridBox(float x, float y, float size){
    super(x,y,size);
  }
  
  void addData(boolean hasData){
    this.hasData = hasData;
  }
}

class InstBox extends Box {
  
  float xBase;
  float yBase;
  boolean moving;
  SoundFile soundFile;
  
  InstBox(float x, float y, float size, SoundFile soundFile){
    super(x,y,size);
    this.soundFile = soundFile;
    xBase = x;
    yBase = y;
    moving = false;
  }
  
  void returnBox(){
    x = xBase;
    y = yBase;
    moving = false;
  }
}

class SlotBox extends Box {
  
  InstBox box;
  
  SlotBox(float x, float y, float size){
    super(x,y,size);
  }
  
  void fill(InstBox box){
    this.box = box;
    box.x = x;
    box.y = y;
    box.moving = false;
  }
  
  void replace(InstBox newBox){
    box.returnBox();
    fill(newBox);
  }
  
  void removeBox(){
    box.returnBox();
    box = null;
  }
  
  void swap(InstBox newBox, SlotBox otherBox){
    otherBox.fill(this.box);
    this.fill(newBox);
  } 
}
