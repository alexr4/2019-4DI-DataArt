import java.util.*;


JSONArray dataset;

HashMap<String, Integer> species;

void setup(){
    size(1280, 720, P2D);
    smooth(8);

    ArrayList speciesList = new ArrayList<String>();

    String datasetPath = sketchPath("../Assets/Datas/arbresremarquablesparis.json");
    dataset = loadJSONArray(datasetPath);

    println("dataset has been loaded with "+dataset.size()+" datas");
    for(int i=0; i<dataset.size(); i++){
        JSONObject jso = dataset.getJSONObject(i);
        JSONObject fields = jso.getJSONObject("fields");

        speciesList.add(fields.getString("espece"));
    }

    species = getNumberOfRepetition(speciesList);

    colorMode(HSB, 360, 100, 100);
}

void draw(){
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

HashMap<String, Integer> getNumberOfRepetition(ArrayList<String> field){
    HashMap<String, Integer> countedList = new HashMap<String, Integer>(); //create a hashmap where the key is the specie and the value is the number of repetition

    for(String name : field){
        if(countedList.get(name) != null){
            int value = countedList.get(name);
            countedList.put(name, value+1);
        }else{
            countedList.put(name, 1);
        }
    }

    return countedList;
}

int[] getMinMax(HashMap<String, Integer> hm){
    ArrayList<Integer> counts = new ArrayList<Integer>(hm.values());
    int min = Collections.min(counts);
    int max = Collections.max(counts);

    return new int[]{min, max};
}