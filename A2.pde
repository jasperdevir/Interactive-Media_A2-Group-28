float rectX;
float rectY;

float rectHomeX;
float rectHomeY;

float rectSlotX;
float rectSlotY;

boolean rectDragged = false;

void setup(){
  background(255);
  size(620,380);
  
  rectMode(CENTER);
  rectHomeX = width / 2;
  rectHomeY = height * 0.8;
  
  rectSlotX = width * 0.2;
  rectSlotY = height * 0.2;
  
  rectX = rectHomeX;
  rectY = rectHomeY;
}

void draw(){
  background(255);
  if(rectDragged){
    rectX = mouseX;
    rectY = mouseY;
  }
  fill(0);
  rect(rectSlotX, rectSlotY, 50, 50);
  fill(255);
  rect(rectX, rectY, 50, 50);
  
}

void mousePressed(){
  if(mouseX >= rectX - 25 && mouseX <= rectX + 25){
    rectDragged = true;
  }
}

void mouseReleased(){
  if(mouseX >= rectSlotX - 25 && mouseX <= rectSlotX + 25){
    rectX = rectSlotX;
    rectY = rectSlotY;
  } else {
    rectX = rectHomeX;
    rectY = rectHomeY;
  }
  rectDragged = false;
}
