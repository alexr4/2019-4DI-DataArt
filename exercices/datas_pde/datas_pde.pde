import java.util.*;

JSONArray datas;
HashMap<String, Integer> arbres;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);

  datas = loadJSONArray("arbresremarquablesparis.json");
  
  ArrayList<String> libelles = new ArrayList<String>();
  for (int i = 0; i < datas.size(); i ++) {
    JSONObject jso = datas.getJSONObject(i);
    JSONObject fields = jso.getJSONObject("fields");
    String libellefr = fields.getString("libellefrancais");
    libelles.add(libellefr);
    //println(libellefr);
  }
  
  arbres = getNumberOfRepetition(libelles);
  printArray(arbres);
  printArray(getMinMaxValues(arbres));
  //println(arbres.size(), sqrt(arbres.size()));
}

void draw() {
  background(0, 0, 50);
  
  float margin = 40;
  int colsrows = ceil(sqrt(arbres.size()));
  float cellSize = (height - margin * 2) / colsrows;
  int[] minmax = getMinMaxValues(arbres);
  ArrayList<String> names = new ArrayList<String>(arbres.keySet());
  
  //rectMode(CENTER);
  textAlign(CENTER);
  noStroke();
  for(int r=0; r<colsrows; r++){
    for(int c=0; c<colsrows; c++){
      float x = c * cellSize + margin + cellSize * 0.5;
      float y = r * cellSize + margin + cellSize * 0.5;
      int index = c + r * colsrows;
      String name = names.get(index);
      int count = arbres.get(name);
      
      float growth = map(count, minmax[0], minmax[1], 10, cellSize - 20);
      float hue = map(count, minmax[0], minmax[1], 220, 0);
      
      fill(hue, 100, 100);
      ellipse(x, y, growth, growth);
      
      fill(0, 0, 0);
      text(name, x, y + cellSize*0.5);
      //rect(x, y, cellSize, cellSize);
    }
  }
}

HashMap<String, Integer> getNumberOfRepetition(ArrayList<String> list){
  HashMap<String, Integer> values = new HashMap<String, Integer>();
  
  for(int i=0; i<list.size(); i++){
    String value = list.get(i);
    if(values.get(value) != null){
      int count = values.get(value);
      values.put(value, count+1);
    }else{
      values.put(value, 1);
    }
  }
  
  return values;
}

int[] getMinMaxValues(HashMap<String, Integer> hashmap){
  ArrayList<Integer> counts = new ArrayList<Integer>(hashmap.values());
  int min = Collections.min(counts);
  int max = Collections.max(counts);
  
  return new int[]{min, max};
}
