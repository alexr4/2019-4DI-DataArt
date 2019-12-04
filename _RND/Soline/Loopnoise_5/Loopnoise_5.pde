import java.util.*;
import com.hamoid.*;
JSONArray datas;
HashMap<String, Integer> arbres;
ArrayList<String> especes;
int actual = 0;
float sens = 1.;



float noiseMax = 0.1;
float phase = 0;
float baseRadius = 0;

boolean export = true;
int tempsMax = 15 * 1000;
VideoExport videoExport;

public void settings() {
  size(1060, 1060, P2D);
  smooth(8);
}

void setup() {

 // size(1000, 3000, P2D);
  //smooth(8);
  //background(0);
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 100, 100);

  datas = loadJSONArray("arbresremarquablesparis.json");

  ArrayList<String> libelles = new ArrayList<String>();
  especes = new ArrayList<String>();
  for (int i = 0; i < datas.size(); i ++) {
    JSONObject jso = datas.getJSONObject(i);
    JSONObject fields = jso.getJSONObject("fields");
    String libellefr = fields.getString("libellefrancais");
    libelles.add(libellefr);
    //on enregistre le nom de l'espece dans une liste afin de la retrouver plus tard via un index
    if (!especes.contains(libellefr)) {
      especes.add(libellefr);
    }
  }

  arbres = getNumberOfRepetition(libelles);
  printArray(arbres);
  println(arbres.size()); 

  /*if (!especes.contains(libelles)) {
   especes.add("libellefrancais");
   }*/
   videoExport = new VideoExport(this, "SolineLoopedNoise5.mp4");
  videoExport.setFrameRate(60); 
  if (export) {
    videoExport.startMovie();
  }
}


void draw() {
  fill(0, 0, 100, 30);
  noStroke();
  rect(0, 0, width, height);

  //background(0);
  translate(width/2, height/2);
  stroke(255, 50);
  noFill();

  int[] minmax =  getMinMaxValues(arbres);
  float noiseMax = 4.5;
  randomSeed(1920);
  for (int i = 0; i<arbres.size(); i++) {
    String libelle = especes.get(i);
    int numberOfTrees = arbres.get(libelle);

    float thickness = map(numberOfTrees, minmax[0], minmax[1], 1, 10);
    /* 
     float hue =  map(numberOfTrees, minmax[0], minmax[1], 250, 0);
     72.6°, 72.4, 82.4
     */
    float hue =  map(numberOfTrees, minmax[0], minmax[1], 0, 0);
    float sat =  map(numberOfTrees, minmax[0], minmax[1], 0, 100);
    float brigh =  map(numberOfTrees, minmax[0], minmax[1], 0, 50 );
    //float noiseMax = mouseX/(float)width;
    float PHI = i * 0.1;//random(TWO_PI);//i * 0.1;
    float radInc = 5 * i;

    stroke(hue, sat, brigh, 50);
    strokeWeight(thickness);  
    beginShape();
    for (float a = 0; a < TWO_PI; a+=0.1) {

      float xoff = map(cos(a+phase+PHI), -1, 1, 0, noiseMax);
      //float xoff = map(cos(a), -1, 1, 0, noiseMax);
      float yoff = map(sin(a+PHI), -1, 1, 0, noiseMax);
      float zoff =millis() * .0005;
      float r = map(noise(xoff, yoff, zoff), 0, 1, 100, 200) + radInc - baseRadius;
      float x = r * cos(a);
      float y = r * sin(a);
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  phase += 0.01;
  baseRadius = sin(millis() * 0.001) * 100;
  
  if (export) {
    if (millis() <= tempsMax) {
      videoExport.saveFrame();
    } else {
      videoExport.endMovie();
      exit();
    }
  }
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
