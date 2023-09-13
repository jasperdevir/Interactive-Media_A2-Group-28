ArrayList<InstBox> instBoxes = new ArrayList<InstBox>();
ArrayList<SlotBox> slotBoxes = new ArrayList<SlotBox>();

float boxSize = 100;

float instBoxBaseX;
float instBoxBaseY;

float slotBoxX;
float slotBoxY;

float instBoxOffset;
float slotBoxOffset;

int heldBoxIndex;

void setup(){
  background(255);
  size(1080, 720);
  
  rectMode(CENTER);
  instBoxBaseX = width * 0.5;
  instBoxBaseY = height * 0.8;
  
  slotBoxX = width * 0.2;
  slotBoxY = height * 0.2;
  
  for(int i = 0; i < 4; i++){
    slotBoxes.add(new SlotBox(slotBoxX, slotBoxY + slotBoxOffset, boxSize));
    slotBoxOffset += boxSize + 10;
  }
  
  for(int i = 0; i < 4; i++){
    instBoxes.add(new InstBox(instBoxBaseX + instBoxOffset, instBoxBaseY, boxSize));
    instBoxOffset += boxSize + 10;
  }
  
}

void draw() {
  background(255);
  
  fill(0);
  for (SlotBox box : slotBoxes) {
    rect(box.x, box.y, box.size, box.size);
  }
  
  fill(255);
  for (InstBox box : instBoxes) {
    if(box.moving){
      box.x = mouseX;
      box.y = mouseY;
    }
    rect(box.x, box.y, box.size, box.size);
  }
  
}

void mousePressed() {
  for (int i = 0; i < instBoxes.size(); i++) {
    InstBox box = instBoxes.get(i);
    if ((mouseX >= box.x - boxSize / 2 && mouseX <= box.x + boxSize / 2) && (mouseY >= box.y - boxSize / 2 && mouseY <= box.y + boxSize / 2)) {
      heldBoxIndex = i;
      box.moving = true;
      box.xBase = box.x;
      box.yBase = box.y;
    }
  }
  println(heldBoxIndex);
}

void mouseReleased() {
  InstBox heldBox = instBoxes.get(heldBoxIndex);
  for (SlotBox slotBox : slotBoxes) {
    if ((mouseX >= slotBox.x - boxSize / 2 && mouseX <= slotBox.x + boxSize / 2) && (mouseY >= slotBox.y - boxSize / 2 && mouseY <= slotBox.y + boxSize / 2)) {
      if(slotBox.box != null){
        slotBox.replace(heldBox);
      } else {
        slotBox.fill(heldBox);
      }
    } else {
      if(slotBox.box != null){
        slotBox.removeBox();
      } else {
        heldBox.returnBox();
      }
    }
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

class InstBox extends Box {
  
  float xBase;
  float yBase;
  boolean moving;
  
  InstBox(float x, float y, float size){
    super(x,y,size);
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