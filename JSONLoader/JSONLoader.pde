import java.util.*;
import java.util.Date;
import java.text.SimpleDateFormat;


JSONArray dataset;

HashMap<String, Integer> species;
HashMap<String, Integer> years;


void setup() {
  size(1280, 720, P2D);
  smooth(8);

  ArrayList speciesList = new ArrayList<String>();
  ArrayList dateList = new ArrayList<String>();

  String datasetPath = sketchPath("../Assets/Datas/arbresremarquablesparis.json");
  dataset = loadJSONArray(datasetPath);

  println("dataset has been loaded with "+dataset.size()+" datas");
  for (int i=0; i<dataset.size(); i++) {
    JSONObject jso = dataset.getJSONObject(i);
    JSONObject fields = jso.getJSONObject("fields");

    String date = fields.getString("dateplantation");
    String year = getDate(date)[0];

    speciesList.add(fields.getString("libellefrancais"));
    dateList.add(year);
  }

  species = getNumberOfRepetition(speciesList);
  years = getNumberOfRepetition(dateList);
  printArray(years);

  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(0, 0, 10);

  float margin = 20.0;
  float textHeight = 100;
  float rectWidth = width - margin * 2.0;
  float rectHeight = height - margin * 2.0;
  int numberOfSpecies = species.size();
  float marginBar = 10;
  float barWidth = rectWidth / numberOfSpecies - marginBar;
  float barMaxHeight = rectHeight - textHeight;

  int i=0;
  int[] minmax = getMinMax(species);
  //printArray(minmax);

  noStroke();
  for (Map.Entry entry : species.entrySet()) {
    String specie = (String) entry.getKey();
    int count = (int) entry.getValue();

    float x = barWidth * i + margin + marginBar * i;
    float bary = height - margin - textHeight;
    float texty = height - margin;
    float barheight = map(count, minmax[0], minmax[1], minmax[0], barMaxHeight);
    float hue = map(count, minmax[0], minmax[1], 180, 0);

    fill(hue, 100, 100);
    rect(x, bary, barWidth, -barheight);

    fill(0, 0, 100);
    pushMatrix();
    translate(x, texty);
    rotate(-HALF_PI);
    textSize(9);
    textAlign(RIGHT, TOP);
    text(specie, -10, 0, textHeight, 40);
    popMatrix();
    i++;
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
