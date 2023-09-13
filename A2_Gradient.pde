color activeColour;
float lerpAmount = 0;
//change the speed at which the colour changes
float lerpSpeed = 0.01;

Table rawData;
ArrayList<Float> data = new ArrayList<Float>();
float minData;
float maxData;

int dataIndex = 0;
//change the amount of frames it takes for a new data point
float colourCounterInit = 120;
float colourCounter = 0;

color skyBlueColour = color(0, 191, 255);
color darkBlueColour = color(0, 0, 139);

color targetColour;
color startColour;

void setup(){
  size(400,400);
  frameRate(60);
  
  rawData = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2023-09-02T14%3A53%3A24&rToDate=2023-09-04T14%3A53%3A24&rFamily=wasp&rSensor=ES_B_01_411_7E39&rSubSensor=TCA", "csv");
  for(int i = 0; i < rawData.getRowCount(); i++){
    data.add(rawData.getFloat(i, 1));
  }
  
  minData = findMin(data);
  maxData = findMax(data);
  
}
void draw(){
  
  float mappedValue = map(data.get(dataIndex), minData, maxData, 0, 1);
  targetColour = lerpColor(skyBlueColour, darkBlueColour, mappedValue);
  
  activeColour = lerpColor(startColour, targetColour, lerpAmount);
  
  if(lerpAmount + lerpSpeed < 1){
    lerpAmount += lerpSpeed;
  }
  
  if(colourCounter <= 0){
 
    colourCounter = colourCounterInit;
    lerpAmount = 0;
    startColour = targetColour;
    
    if(dataIndex + 1 >= data.size()){
      dataIndex = 0;
    } else {
      dataIndex += 1;
    }
  }
  
  background(activeColour);
  
  colourCounter -= 1;
}

float findMin (ArrayList<Float> list){
  float min = list.get(0);
  for(int i = 1; i < list.size(); i++){
    if(list.get(i) < min){
      min = list.get(i);
    }
  }
  return min;
}

float findMax (ArrayList<Float> list){
  float max = list.get(0);
  for(int i = 1; i < list.size(); i++){
    if(list.get(i) > max){
      max = list.get(i);
    }
  }
  return max;
}
