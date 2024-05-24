int DAY_LEN;
int CITY_COUNT;
String[] TextFile;
City[] cities;
int TOP_VISIBLE = 12;
float[] maxes;



float X_MIN = 100;
float X_MAX = 1600;
float Y_MIN = 300;
float Y_MAX = 1000;
float X_W = X_MAX-X_MIN;
float Y_H = Y_MAX-Y_MIN;
float X_SCALE = -1;

int frames = 0;
float currentDay = 0; 
float FRAMES_PER_DAY = 5;
float BAR_HEIGHT;
float BAR_PROPORTION = 0.9;


void setup(){
  TextFile = loadStrings("Tempatures.csv");
  String[] parts = TextFile[0].split("\t");
  CITY_COUNT = parts.length-1;
  DAY_LEN = TextFile.length-1;
  
  maxes = new float[DAY_LEN];
  for(int d = 0; d < DAY_LEN; d++){
    maxes[d] = 0;
  }
  
  cities = new City[CITY_COUNT];
  for (int i = 0; i < CITY_COUNT; i++){
    cities[i] = new City(parts[i+1]);
  }
  
  for(int d = 0; d < DAY_LEN; d++){
    String[] DataParts = TextFile[d+1].split("\t");
    for(int c = 0; c < CITY_COUNT; c++){
      float val = Float.parseFloat(DataParts[c+1]);
      cities[c].data[d] = val;
      if (val > maxes[d]){
        maxes[d] = val;
      }
    }
  }
  getRankings();
  BAR_HEIGHT = (rankToY(1)-rankToY(0))*BAR_PROPORTION;
  size(1920,1080);
}
float stepIndex(float[] a, float index){
  return a[(int)index];
}
float linIndex(float[] a, float index){
  int indexInt = (int)index;
  float indexRem = index%1.0;
  float beforeVal = a[indexInt];
  float afterVal = a[indexInt+1];
  return lerp(beforeVal,afterVal,indexRem);
}
float WAIndex(float[] a, float index, float WINDOW_WIDTH){
  int startIndex = max(0,ceil(index-WINDOW_WIDTH));
  int endIndex = min(DAY_LEN-1,floor(index+WINDOW_WIDTH));
  float counter = 0;
  float summer = 0;
  
  for(int d = startIndex; d <= endIndex; d++){
    float val = a[d];
    float weight = 0.5+0.5*cos((d-index)/WINDOW_WIDTH*PI);
    counter += weight;
    summer += val*weight;
  }
  float finalResult = summer/counter;
  return finalResult;
}


float getXScale(float d){
  return WAIndex(maxes,d,14)*1.2;
}
float valueToX(float val){
  return X_MIN+X_W*val/X_SCALE;
}
float rankToY(float rank){
  float y = Y_MIN+rank*(Y_H/TOP_VISIBLE);
  return y;
}

void draw(){
  currentDay = frames/FRAMES_PER_DAY;
  X_SCALE = getXScale(currentDay);
  drawBackground();
  drawBars();

  
  frames++;
}



void drawBackground(){
  background(0);
  
}
void drawBars(){
  for(int c = 0; c < CITY_COUNT; c++){
    float val = linIndex(cities[c].data,currentDay);
    float x = valueToX(val);
    float rank = WAIndex(cities[c].data,currentDay, 5);
    float y = rankToY(rank);
    fill(cities[c].z);
    rect(X_MIN,y,x-X_MIN,BAR_HEIGHT);
  }
}

void getRankings(){
  for(int d = 0; d < DAY_LEN; d++){
      boolean[] taken = new boolean[CITY_COUNT];
      for(int c = 0; c < CITY_COUNT; c++){
        taken[c] = false;
      }
      for(int spot = 0; spot < TOP_VISIBLE; spot++){
        int holder = -1;
        float record = -1;
        for(int c = 0; c < CITY_COUNT; c++){
          if(!taken[c]){
            float val = cities[c].data[d];
            if(val > record){
              record = val;
              holder = c;
              
            }
          }
        }
      cities[holder].ranks[d] = spot;
      taken[holder] = true;
      println(cities[holder].name);
      }
    }
}
