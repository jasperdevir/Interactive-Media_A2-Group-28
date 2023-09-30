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

//image files
PImage Img_Slot1_A;
PImage Img_Slot2_A;
PImage Img_Slot3_A;
PImage Img_Slot4_A;
PImage MusicImage;

PImage PlayImage;
PImage PauseImage;
PImage Image60;
PImage Image90;
PImage Image120;
PImage TrackAImage;
PImage TrackBImage;

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

color slotColor = color(246, 234, 254);
color instColor = color(190, 163, 211);
color gridColor = color(211, 216, 255);
color gridColorData = color(143, 154, 250);
color barColor = color(255, 223, 223);
color barColorNum = color(240, 141, 141);
color buttonColor = color(135, 190, 137);
color buttonPressedColor = color(240, 240, 240);

// Background Gradient

color activeColour;
float lerpAmount = 0;
//change the speed at which the colour changes
float lerpSpeed = 0.01;

Table rawData;
ArrayList<Float> g_data = new ArrayList<Float>();
float minData;
float maxData;

int dataIndex = 0;
//change the amount of frames it takes for a new data point
float colourCounterInit = 120;
float colourCounter = 0;

color skyBlueColour = color(123, 116, 209);
color darkBlueColour = color(215, 162, 133);

color targetColour;
color startColour;

void setup() {
  frameRate(60);
  background(254, 254, 254);
  size(1080, 720);

  rectMode(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);

  instBoxX = width * 0.15;
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

  // Image Files

  PlayImage = loadImage("assets/play.png");
  PauseImage = loadImage("assets/pause.png");

  Image60 = loadImage("assets/60.png");
  Image90 = loadImage("assets/90.png");
  Image120 = loadImage("assets/120.png");

  TrackAImage = loadImage("assets/A.png");
  TrackBImage = loadImage("assets/B.png");

  Img_Slot1_A = loadImage("assets/kick.png");
  Img_Slot2_A = loadImage("assets/snare.png");
  Img_Slot3_A = loadImage("assets/keys.png");
  Img_Slot4_A = loadImage("assets/guitar.png");
  MusicImage = loadImage("assets/music.png");


  // 60 BPM Files

  instSound60_A[0] = (new SoundFile(this, "TrackA/kick_1.wav"));
  instSound60_A[1] = (new SoundFile(this, "TrackA/snare_1.wav"));
  instSound60_A[2] = (new SoundFile(this, "TrackA/synth_1.wav"));
  instSound60_A[3] = (new SoundFile(this, "TrackA/chirp_1.wav"));

  instSound60_B[0] = (new SoundFile(this, "TrackB/drumloop.wav"));
  instSound60_B[1] = (new SoundFile(this, "TrackB/bassloop.wav"));
  instSound60_B[2] = (new SoundFile(this, "TrackB/keysloop.wav"));
  instSound60_B[3] = (new SoundFile(this, "TrackB/vocalloop.wav"));

  // 90 BPM Files

  instSound90_A[0] = (new SoundFile(this, "TrackA/kick_1_90bpm.wav"));
  instSound90_A[1] = (new SoundFile(this, "TrackA/snare_1_90bpm.wav"));
  instSound90_A[2] = (new SoundFile(this, "TrackA/synth_1_90bpm.wav"));
  instSound90_A[3] = (new SoundFile(this, "TrackA/chirp_1_90bpm.wav"));

  instSound90_B[0] = (new SoundFile(this, "TrackB/drumloop.wav"));
  instSound90_B[1] = (new SoundFile(this, "TrackB/bassloop.wav"));
  instSound90_B[2] = (new SoundFile(this, "TrackB/keysloop.wav"));
  instSound90_B[3] = (new SoundFile(this, "TrackB/vocalloop.wav"));

  // 120 BPM Files

  instSound120_A[0] = (new SoundFile(this, "TrackA/kick_1_120bpm.wav"));
  instSound120_A[1] = (new SoundFile(this, "TrackA/snare_1_120bpm.wav"));
  instSound120_A[2] = (new SoundFile(this, "TrackA/synth_1_120bpm.wav"));
  instSound120_A[3] = (new SoundFile(this, "TrackA/chirp_1_120bpm.wav"));

  instSound120_B[0] = (new SoundFile(this, "TrackB/drumloop.wav"));
  instSound120_B[1] = (new SoundFile(this, "TrackB/drumloop.wav"));
  instSound120_B[2] = (new SoundFile(this, "TrackB/drumloop.wav"));
  instSound120_B[3] = (new SoundFile(this, "TrackB/drumloop.wav"));

  // Initialise BPM

  bpm = instSound60_A[0].duration() * 60;



  // fill data here:

  for (int x = 0; x < 8; x++) {
    data[0][x] = true;
    data[1][x] = true;
    data[2][x] = true;
    data[3][x] = true;
  }

  //create slotBoxes
  for (int i = 0; i < 4; i++) {
    slotBoxes.add(new SlotBox(slotBoxX, slotBoxY + slotBoxOffsetY, boxSize));
    slotBoxOffsetY += boxGap;
  }

  //create instBoxes
  for (int i = 0; i < 4; i++) {
    instBoxes.add(new InstBox(instBoxX + instBoxOffsetX, instBoxY, boxSize, instSound60_A[i]));
    instBoxOffsetX += boxGap;
  }

  //create gridBoxes
  for (int a = 0; a < 4; a++) {
    for (int b = 0; b < 8; b++) {
      grid[a][b] = new GridBox(gridX + gridOffsetX, gridY + gridOffsetY, boxSize);
      grid[a][b].addData(data[a][b]);
      gridOffsetX += boxGap;
    }
    gridOffsetX = 0;
    gridOffsetY += boxGap;
  }

  //create play buttons
  for (int i = 0; i < 2; i++) {
    buttons.add(new Button(playButtonX + playButtonOffsetX, playButtonY, boxSize, playButtonFunc[i]));
    playButtonOffsetX += boxGap;
  }

  //create tempo buttons
  for (int i = 0; i < 3; i++) {
    buttons.add(new Button(tempoButtonX + tempoButtonOffsetX, tempoButtonY, boxSize, tempoButtonFunc[i]));
    tempoButtonOffsetX += boxGap;
  }

  //create track buttons
  for (int i = 0; i < 2; i++) {
    buttons.add(new Button(trackButtonX + trackButtonOffsetX, trackButtonY, boxSize, trackButtonFunc[i]));
    trackButtonX += boxGap;
  }

  // gradient data

  rawData = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2023-09-02T14%3A53%3A24&rToDate=2023-09-04T14%3A53%3A24&rFamily=wasp&rSensor=ES_B_01_411_7E39&rSubSensor=TCA", "csv");
  for (int i = 0; i < rawData.getRowCount(); i++) {
    g_data.add(rawData.getFloat(i, 1));
  }

  minData = findMin(g_data);
  maxData = findMax(g_data);
}

void draw() {
  if (playing) {
    frameCounter++;
  } else {
    for (SlotBox slot : slotBoxes) {
      if (slot.box != null) {
        slot.box.soundFile.stop();
      }
    }
  }

  // draw gradient background
  float mappedValue = map(g_data.get(dataIndex), minData, maxData, 0, 1);
  targetColour = lerpColor(skyBlueColour, darkBlueColour, mappedValue);

  activeColour = lerpColor(startColour, targetColour, lerpAmount);

  if (lerpAmount + lerpSpeed < 1) {
    lerpAmount += lerpSpeed;
  }

  if (colourCounter <= 0) {

    colourCounter = colourCounterInit;
    lerpAmount = 0;
    startColour = targetColour;

    if (dataIndex + 1 >= g_data.size()) {
      dataIndex = 0;
    } else {
      dataIndex += 1;
    }
  }

  background(activeColour);
  colourCounter -= 1;

  // draw machine base
  fill(254, 254, 254);
  strokeWeight(6);
  stroke(230, 230, 230);
  rect(width*0.49, height*0.59, 900, 739, 30);
  noStroke();


  //draw gridBoxes
  for (int a = 0; a < 4; a++) {
    for (int b = 0; b < 8; b++) {
      GridBox box = grid[a][b];
      if (box.hasData) {
        fill(gridColorData);
      } else {
        fill(gridColor);
      }
      rect(box.x, box.y, box.size, box.size);
    }
  }

  //draw bar indicator
  for (int i = 0; i < 8; i++) {
    if (barNum == i) {
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
    rect(box.x, box.y, box.size, box.size, 20);
  }

  //draw buttons
  noStroke();
  stroke(0);
  fill(buttonColor);
  for (Button button : buttons) {
    if (!button.function.equals("PAUSE") && button.pressed) {
      button.pressedCooldown();
    }
    if (button.pressed) {
      noStroke();
      fill(buttonPressedColor);
    } else {
      if (button.function.equals("PAUSE") || button.function.equals("STOP")) {
        noStroke();
        fill(135, 190, 137);
      } else if (button.function.equals("60") || button.function.equals("90") || button.function.equals("120")) {
        strokeWeight(5);
        stroke(240, 141, 141);
        fill(255);
      } else {
        noStroke();
        fill(135, 190, 186);
      }
    }
    ellipse(button.x, button.y, button.size, button.size);
  }

  //draw instBoxes
  fill(instColor);
  for (InstBox box : instBoxes) {
    if (box.moving) {
      box.x = mouseX;
      box.y = mouseY;
    }
    rect(box.x, box.y, box.size, box.size, 20);
    image(MusicImage, box.x, box.y);
  }

  //draw bar
  if (frameCounter >= bpm) {
    barNum++;
    frameCounter = 0;
    if (barNum >= 8) {
      barNum = 0;
    }
    for (int i = 0; i < 4; i++) {
      if (grid[i][barNum].hasData) {
        if (slotBoxes.get(i).box != null) {
          slotBoxes.get(i).box.soundFile.play();
        }
      }
    }
  }
  
  // draw button icons
  image(PlayImage, 165, 540);
  image(PauseImage, 252, 540);

  image(Image60, 432, 540);
  image(Image90, 522, 540);
  image(Image120, 612, 540);

  image(TrackAImage, 792, 540);
  image(TrackBImage, 882, 540);
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
  for (Button button : buttons) {
    if ((mouseX >= button.x - boxSize / 2 && mouseX <= button.x + boxSize / 2) && (mouseY >= button.y - boxSize / 2 && mouseY <= button.y + boxSize / 2)) {
      if (button.function.equals("PAUSE") && !button.pressed) {
        button.pressed = true;
        playing = false;
      } else if (button.function.equals("PAUSE")) {
        button.pressed = false;
        playing = true;
      } else if (button.function.equals("STOP")) {
        button.pressed = true;
        playing = false;
        frameCounter = 0;
        barNum = 0;
        buttons.get(0).pressed = true;
      } else if (button.function.equals("60")) {
        button.pressed = true;
        bpmString = "60";
        musicUpdate(bpmString, "A");
      } else if (button.function.equals("90")) {
        button.pressed = true;
        bpmString = "90";
        musicUpdate(bpmString, "A");
      } else if (button.function.equals("120")) {
        button.pressed = true;
        bpmString = "120";
        musicUpdate(bpmString, "A");
      } else if (button.function.equals("ONE")) {
        button.pressed = true;
        musicUpdate(bpmString, "A");
      } else if (button.function.equals("TWO")) {
        button.pressed = true;
        musicUpdate(bpmString, "B");
      } else {
        println("##Button function error");
      }
    }
  }
}

void musicUpdate(String currBPM, String currTrack) {
  if (currBPM == "60" && currTrack == "A") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound60_A[i];
    }
    bpm = instSound60_A[0].duration() * 60;
  } else if (currBPM == "60" && currTrack == "B") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound60_B[i];
    }
    bpm = instSound60_B[0].duration() * 60;
  }

  if (currBPM == "90" && currTrack == "A") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound90_A[i];
    }
    bpm = instSound90_A[0].duration() * 60;
  } else if (currBPM == "90" && currTrack == "B") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound90_B[i];
    }
    bpm = instSound90_B[0].duration() * 60;
  }

  if (currBPM == "120" && currTrack == "A") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound120_A[i];
    }
    bpm = instSound120_A[0].duration() * 60;
  } else if (currBPM == "120" && currTrack == "B") {
    for (int i = 0; i < instBoxes.size(); i++) {
      instBoxes.get(i).soundFile = instSound120_B[i];
    }
    bpm = instSound120_B[0].duration() * 60;
  }
}

void mouseReleased() {
  //instBoxes drag and drop
  if (heldBoxIndex != -1) {
    InstBox heldBox = instBoxes.get(heldBoxIndex);
    heldBoxIndex = -1;
    SlotBox orgBox = null;

    for (SlotBox slotBox : slotBoxes) {
      if (slotBox.box == heldBox) {
        orgBox = slotBox;
      }
    }

    for (SlotBox slotBox : slotBoxes) {
      if ((mouseX >= slotBox.x - boxSize / 2 && mouseX <= slotBox.x + boxSize / 2) && (mouseY >= slotBox.y - boxSize / 2 && mouseY <= slotBox.y + boxSize / 2)) {
        if (slotBox.box != null) {
          if (orgBox != null) {
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
      if (slotBox.box == heldBox) {
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

  Box(float x, float y, float size) {
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

  Button(float x, float y, float size, String function) {
    super(x, y, size);
    this.function = function;
    pressedCooldown = 10;
  }

  void pressedCooldown() {
    currentCooldown++;
    if (currentCooldown >= pressedCooldown) {
      currentCooldown = 0;
      pressed = false;
    }
  }
}

class GridBox extends Box {

  boolean hasData;

  GridBox(float x, float y, float size) {
    super(x, y, size);
  }

  void addData(boolean hasData) {
    this.hasData = hasData;
  }
}

class InstBox extends Box {

  float xBase;
  float yBase;
  boolean moving;
  SoundFile soundFile;

  InstBox(float x, float y, float size, SoundFile soundFile) {
    super(x, y, size);
    this.soundFile = soundFile;
    xBase = x;
    yBase = y;
    moving = false;
  }

  void returnBox() {
    x = xBase;
    y = yBase;
    moving = false;
  }
}

class SlotBox extends Box {

  InstBox box;

  SlotBox(float x, float y, float size) {
    super(x, y, size);
  }

  void fill(InstBox box) {
    this.box = box;
    box.x = x;
    box.y = y;
    box.moving = false;
  }

  void replace(InstBox newBox) {
    box.returnBox();
    fill(newBox);
  }

  void removeBox() {
    box.returnBox();
    box = null;
  }

  void swap(InstBox newBox, SlotBox otherBox) {
    otherBox.fill(this.box);
    this.fill(newBox);
  }
}

float findMin (ArrayList<Float> list) {
  float min = list.get(0);
  for (int i = 1; i < list.size(); i++) {
    if (list.get(i) < min) {
      min = list.get(i);
    }
  }
  return min;
}

float findMax (ArrayList<Float> list) {
  float max = list.get(0);
  for (int i = 1; i < list.size(); i++) {
    if (list.get(i) > max) {
      max = list.get(i);
    }
  }
  return max;
}
