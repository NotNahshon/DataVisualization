class City{
  String name;
  float[] data = new float[DAY_LEN];
  int[] ranks = new int[DAY_LEN];
  color z;
  public City(String n){
    name = n;
    for(int i = 0; i < DAY_LEN; i++){
      data[i] = 0;
      ranks[i] = TOP_VISIBLE+1;
    }
    z = color(random(50,200),random(50,200),random(50,200));
  }

}
