import java.util.*;
import java.util.Date;
import java.text.SimpleDateFormat;


JSONArray dataset;

TreeMap<String, TreeList> treePerArrdt;
HashMap<String, Float> hueList;
int numberOfArrdt;
int maxNumberOftrees = 0;

void setup() {
  size(1280, 720, P2D);
  smooth(8);

  //String datasetPath = sketchPath("../Assets/Datas/arbresremarquablesparis.json");
  String datasetPath = sketchPath("../Assets/Datas/les-arbres.json");
  dataset = loadJSONArray(datasetPath);
  println(dataset.size());

  treePerArrdt = new TreeMap<String, TreeList>();
  hueList = new HashMap<String, Float>();
  HashMap<String, Integer> tmp = new HashMap<String, Integer>();
  HashMap<String, Integer> tmpspecies = new HashMap<String, Integer>();
  for (int i=0; i<dataset.size(); i++) {
    JSONObject jso = dataset.getJSONObject(i);
    JSONObject fields = jso.getJSONObject("fields");
    //println(fields);

    String arrdt = fields.getString("arrondissement");
    TreeData tree = new TreeData(i, fields);
    tmp.put(arrdt, 1);
    tmpspecies.put(fields.getString("libellefrancais"), 1);

    if (treePerArrdt.get(arrdt) != null) {
      //add tree
      treePerArrdt.get(arrdt).addTree(tree);
    } else {
      //create tree List
      TreeList trees = new TreeList();
      trees.addTree(tree);
      treePerArrdt.put(arrdt, trees);
    }
  }

  int i = 0;
  println(tmpspecies.size());
  for (Map.Entry entry : tmpspecies.entrySet()) {
    String specie = (String) entry.getKey();
    float hue = round(map(i, 0, tmpspecies.size(), 0, 200));
    hueList.put(specie, hue);
    println(specie, hue);
    i++;
  }
  numberOfArrdt = tmp.size();

  //print for debug
  /*
  for (Map.Entry entry : treePerArrdt.entrySet()) {
   String arrdt = (String) entry.getKey();
   TreeList tl = (TreeList) entry.getValue();
   //println(arrdt, tl.treesList.size());
   for (Map.Entry trees : tl.treesList.entrySet()) {
   String species = (String) trees.getKey();
   ArrayList<TreeData> datas = (ArrayList<TreeData>) trees.getValue();
   //println("\t", species, datas.size());
   }
   }*/

  ArrayList<Integer> numbersOfTreesPerSpecies = new ArrayList<Integer>();
  for (Map.Entry entry : treePerArrdt.entrySet()) {
    TreeList tl = (TreeList) entry.getValue();
    for (Map.Entry trees : tl.treesList.entrySet()) {
      ArrayList<TreeData> datas = (ArrayList<TreeData>) trees.getValue();
      numbersOfTreesPerSpecies.add(datas.size());
    }
  }
  maxNumberOftrees = Collections.max(numbersOfTreesPerSpecies);
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(0, 0, 10);

  float margin = 20.0;
  float textHeight = 50;
  float rectWidth = width - margin * 2.0;
  float rectHeight = height - margin * 2.0;
  // int years = treePerYears.size();
  float marginBar = 10;
  float barWidth = rectWidth / numberOfArrdt - marginBar;

  int i=0;
  //printArray(minmax);

  noStroke();
  for (Map.Entry entry : treePerArrdt.entrySet()) {
    String year = (String) entry.getKey();
    TreeList tl = (TreeList) entry.getValue();

    float x = barWidth * i + margin + marginBar * i;
    float oy = height - margin;
    float y = oy - textHeight;

    int numberOfTrees = 0;
    for (Map.Entry trees : tl.treesList.entrySet()) {
      String species = (String) trees.getKey();
      ArrayList<TreeData> datas = (ArrayList<TreeData>) trees.getValue();
      float h = map(datas.size(), 1, maxNumberOftrees, 2, 40);

      numberOfTrees += datas.size();
      float hue = hueList.get(species);
      fill(hue, 100, 100);
      rect(x, y, barWidth, -h);
      y -= h + 1;
      //println("\t", species, datas.size());
    }

    fill(0, 0, 100);
    text(numberOfTrees, x, y - 20);


    //float bary = height - margin - textHeight;
    //float texty = height - margin;
    //float barheight = map(count, minmax[0], minmax[1], minmax[0], barMaxHeight);
    //float hue = map(count, minmax[0], minmax[1], 180, 0);

    //fill(hue, 100, 100);

    pushMatrix();
    translate(x, oy);
    rotate(-HALF_PI);
    textSize(9);
    textAlign(LEFT, TOP);
    text(year, -10, 0, textHeight, 40);
    popMatrix();
    i++;
  }

  color mouseColor = get(mouseX, mouseY);
  int hue = (int)hue(mouseColor);
  String specie = getKeyByValue(hueList, (float)hue);
  //println(specie, hue);
  if (specie != null) {
    float mx = mouseX + 20;
    float my = mouseY;
    pushStyle();
    fill(0);
    rect(mx, my, 100, 40);
    fill(0, 0, 100);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(specie, mx, my, 100, 40);
    popStyle();
  }
}

HashMap<String, Integer> getNumberOfRepetition(ArrayList<String> field) {
  HashMap<String, Integer> countedList = new HashMap<String, Integer>(); //create a hashmap where the key is the specie and the value is the number of repetition

  for (String name : field) {
    if (countedList.get(name) != null) {
      int value = countedList.get(name);
      countedList.put(name, value+1);
    } else {
      countedList.put(name, 1);
    }
  }

  return countedList;
}

int[] getMinMax(HashMap<String, Integer> hm) {
  ArrayList<Integer> counts = new ArrayList<Integer>(hm.values());
  int min = Collections.min(counts);
  int max = Collections.max(counts);

  return new int[]{min, max};
}

String[] getDate(String dateInput) {
  String[] dates = new String[3];
  try {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    // SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date d = sdf.parse(dateInput);
    //String formattedTime = output.format(d);
    Calendar myCal = new GregorianCalendar();
    myCal.setTime(d);

    dates[0] = Integer.toString(myCal.get(Calendar.YEAR));
    dates[1] = Integer.toString(myCal.get(Calendar.MONTH) + 1);
    dates[2] = Integer.toString(myCal.get(Calendar.DAY_OF_MONTH));
  }
  catch(Exception e) {
  }
  return dates;
}

public static String getKeyByValue(Map<String, Float> map, Float value) {
  for (Map.Entry entry : map.entrySet()) {
    if (Objects.equals(value, entry.getValue())) {
      return (String) entry.getKey();
    }
  }
  return null;
}
