ArrayList<LSTree> lstlist;
int numberOfTrees = 12;

void setup() {
  size(720, 1080);

  lstlist = new ArrayList<LSTree>();

  for (int i=0; i<numberOfTrees; i++) {
    int randomIteration = round(random(1, 5));

    lstlist.add(new LSTree(randomIteration));
  }
}


void draw() {
  background(0);

  for (int i=0; i<numberOfTrees; i++) {
    
    LSTree lst = lstlist.get(i);
    lst.turtle(i * 100, height/2);
  }
}
