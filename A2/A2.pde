import processing.sound.*;

ArrayList<InstBox> instBoxes = new ArrayList<InstBox>();
ArrayList<SlotBox> slotBoxes = new ArrayList<SlotBox>();
ArrayList<Button> buttons = new ArrayList<Button>();
GridBox[][] grid = new GridBox[4][8];

boolean[][] testData = new boolean[4][8];

SoundFile[] instSound60_A = new SoundFile[4];

float bpm = instSound60_A[0].duration() * 60;

//int barBeats = 4;

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
  

  testData[3][0] = true;
  testData[3][1] = true;
  testData[3][2] = true;
  testData[3][3] = true;
  testData[3][4] = true;
  testData[3][5] = true;
  testData[3][6] = true;
  testData[3][7] = true;
  
  testData[2][0] = true;
  testData[2][1] = true;
  testData[2][2] = true;
  testData[2][3] = true;
  testData[2][4] = true;
  testData[2][5] = true;
  testData[2][6] = true;
  testData[2][7] = true;
 
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
  
  instSound60_A[0] = (new SoundFile(this, "drums.mp3"));
  instSound60_A[1] = (new SoundFile(this, "bass.mp3"));
  instSound60_A[2] = (new SoundFile(this, "arp.mp3"));
  instSound60_A[3] = (new SoundFile(this, "sine.wav"));
  
  for(int i = 0; i < 4; i++){
    slotBoxes.add(new SlotBox(slotBoxX, slotBoxY + slotBoxOffsetY, boxSize));
    slotBoxOffsetY += boxGap;
  }
  
  for(int i = 0; i < 4; i++){
    instBoxes.add(new InstBox(instBoxX + instBoxOffsetX, instBoxY, boxSize, instSound60_A[i]));
    instBoxOffsetX += boxGap;
  }
  for(int a = 0; a < 4; a++){
    for(int b = 0; b < 8; b++){
      grid[a][b] = new GridBox(gridX + gridOffsetX, gridY + gridOffsetY, boxSize);
      grid[a][b].addData(testData[a][b]);
      gridOffsetX += boxGap;
    }
    gridOffsetX = 0;
    gridOffsetY += boxGap;
  }
  
  for(int i = 0; i < 2; i++){
    buttons.add(new Button(playButtonX + playButtonOffsetX, playButtonY, boxSize, playButtonFunc[i]));
    playButtonOffsetX += boxGap;
  }
  
  for(int i = 0; i < 3; i++){
    buttons.add(new Button(tempoButtonX + tempoButtonOffsetX, tempoButtonY, boxSize, tempoButtonFunc[i]));
    tempoButtonOffsetX += boxGap;
  }
  
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
  
  fill(slotColor);
  for (SlotBox box : slotBoxes) {
    rect(box.x, box.y, box.size, box.size);
  }
  
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
  for (int i = 0; i < instBoxes.size(); i++) {
    InstBox box = instBoxes.get(i);
    if ((mouseX >= box.x - boxSize / 2 && mouseX <= box.x + boxSize / 2) && (mouseY >= box.y - boxSize / 2 && mouseY <= box.y + boxSize / 2)) {
      heldBoxIndex = i;
      box.moving = true;
    }
  }
  
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
      } else if(button.function.equals("90")){
        button.pressed = true;
      } else if(button.function.equals("120")){
        button.pressed = true;
      } else if(button.function.equals("ONE")){
        button.pressed = true;
        println("TRACK1");
      }else if(button.function.equals("TWO")){
        button.pressed = true;
        println("TRACK2");
      } else {
        println("##Button function error");
      }
    }
  }
}

void mouseReleased() {
  if(heldBoxIndex != -1){
    InstBox heldBox = instBoxes.get(heldBoxIndex);
    heldBoxIndex = -1;
    for (SlotBox slotBox : slotBoxes) {
      if ((mouseX >= slotBox.x - boxSize / 2 && mouseX <= slotBox.x + boxSize / 2) && (mouseY >= slotBox.y - boxSize / 2 && mouseY <= slotBox.y + boxSize / 2)) {
        if(slotBox.box != null){
          slotBox.replace(heldBox);
        } else {
          slotBox.fill(heldBox);
        }
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
}
