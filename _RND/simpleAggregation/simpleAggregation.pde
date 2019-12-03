import java.util.*;

JSONArray datas;
HashMap<String, Integer> arbres;
int actual = 0;
float seed = 1000;

void setup() {
  size(1000, 1000, P3D);
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
  //printArray(arbres);
  //printArray(getMinMaxValues(arbres));
  //println(arbres.size(), sqrt(arbres.size()));
}

void draw() {
  background(0, 0, 20);

  float margin = 40;
  int colsrows = ceil(sqrt(arbres.size()));
  float cellSize = (height - margin * 2) / colsrows;
  int[] minmax = getMinMaxValues(arbres);
  ArrayList<String> names = new ArrayList<String>(arbres.keySet());
  
  float maxTime = 8000.0;
  float modTime = millis() % maxTime;
  float normTime = modTime / maxTime;
  float easing = sin(normTime * TWO_PI);
  float pingpongtime = 1.0 - abs(normTime * 2.0 -1.0);
  float pingpongeased = 1;//1.0 - abs(easing);

  //get the actual name 

  float radius = 100;

  pushMatrix();
  translate(width*0.5, height * 0.5);
  rotateY(frameCount * 0.001);

  //lights();
  directionalLight(220, 50, 50, 0.5, 0.25, -1.0);
  directionalLight(51, 15, 99, -0.5, -0.25, -1.0);
  directionalLight(51, 15, 50, 0, -0.5, 1.0);

  noStroke();
  strokeWeight(10);
  fill(0, 0, 90);
  for (int j=0; j<arbres.size(); j++) {
    String name = names.get(j);
    int count = arbres.get(name);
    float x =0;
    float y =0;
    float z =0;
    float hue = map(j, 0, arbres.size() -1, 0, 300);
    
    int counter = round(pingpongeased * count);
    
    for (int i=0; i<counter; i++) {
      randomSeed(int(seed)*i*j);
      float theta = random(PI);
      float phi = random(TWO_PI);
      float nx = x + sin(phi) * cos(theta) * radius;
      float ny = y + sin(phi) * sin(theta) * radius;
      float nz = z + cos(phi) * radius;

      //stroke(0, 0, 100);
      //line(x, y, z, nx, ny, nz);

      //pushMatrix();
      //translate(nx, ny, nz);
      //sphere(radius*.5);
      //popMatrix();


      PVector v0tov1 = PVector.sub(new PVector(nx, ny, nz), new PVector(x, y, z));
      PVector n = v0tov1.normalize();

      //compute angle between two vectors
      PVector v0 = new PVector(0, 1, 0);
      PVector v1 = v0tov1.copy().normalize();

      float v0Dotv1 = PVector.dot(v0, v1);
      float eta = acos(v0Dotv1);
      PVector axis = v0.cross(v1);
      //println(degrees(phi), axis);

      fill(hue, 100, 100);
      noStroke();
      pushMatrix();
      translate(x, y, z);
      rotate(eta, axis.x, axis.y, axis.z); 
      translate(0, radius*.5, 0);
      box(radius * 0.1, radius, radius * 0.1);
      popMatrix();

      x = nx;
      y = ny;
      z = nz;

      if (i == counter-1) {
        pushMatrix();
        translate(x, y, z);
        fill(0, 0, 100);
        text(name, 20, 20);
        popMatrix();
      }
    }
  }
  popMatrix();
}

void keyPressed() {
  actual ++;
  actual = actual % arbres.size();
  seed = random(frameCount);
}

HashMap<String, Integer> getNumberOfRepetition(ArrayList<String> list) {
  HashMap<String, Integer> values = new HashMap<String, Integer>();

  for (int i=0; i<list.size(); i++) {
    String value = list.get(i);
    if (values.get(value) != null) {
      int count = values.get(value);
      values.put(value, count+1);
    } else {
      values.put(value, 1);
    }
  }

  return values;
}

int[] getMinMaxValues(HashMap<String, Integer> hashmap) {
  ArrayList<Integer> counts = new ArrayList<Integer>(hashmap.values());
  int min = Collections.min(counts);
  int max = Collections.max(counts);

  return new int[]{min, max};
}
