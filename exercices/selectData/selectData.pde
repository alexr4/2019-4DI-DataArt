import java.util.*;

JSONArray datas;
HashMap<String, Integer> arbres;
ArrayList<String> especes;
int actual = 0;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);

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
    //println(libellefr);
  }

  arbres = getNumberOfRepetition(libelles);
  printArray(arbres);
  printArray(getMinMaxValues(arbres));
}

void draw() {
  background(0, 0, 50);

  //on récupère le nom de l'espèce à l'index actuel
  String name = especes.get(actual);
  //on récupère le nombre d'arbre
  int nombreArbres = arbres.get(name);
  textSize(20);
  textAlign(CENTER);
  text(name+" : "+nombreArbres, width/2, height/2);
}

void keyPressed() {
  if(key == '+'){
    //on passe à l'index suivant
    actual ++;
    actual = actual % arbres.size();
  }else if(key == '-'){
    //on passe à l'index précédent
    actual --;
    actual = (actual < 0) ? arbres.size() - 1 : actual;
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
