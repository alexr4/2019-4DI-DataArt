import peasy.*;

PeasyCam cam;

ArrayList<LorentzAttractor> lalist;

void setup() {
  size(800, 600, P3D);
  colorMode(HSB, 360, 100, 100);
  cam=new PeasyCam(this, 500);
  smooth(8);

  lalist = new ArrayList<LorentzAttractor>();
  float boxsize = 25;
  int numberOfTrees = 49;
  for (int i=0; i<numberOfTrees; i++) {
    PVector rnd = PVector.random3D();
    rnd.mult(boxsize);
    int numberOfPointPerLigne = (int) random(100, 200);
    lalist.add(new LorentzAttractor(rnd.x, rnd.y, rnd.z, numberOfPointPerLigne));
  }
}
void draw() {
  background(0);

  translate(0, 0);
  //translate(width/2,height/2);
  scale(2.5);
  stroke(255);
  noFill();
  
  for (int i=0; i<lalist.size(); i++) {
    float hue = map(i, 0, lalist.size(), 0, 360);
    LorentzAttractor lo = lalist.get(i);
    
    lo.update();
    stroke(hue, 100, 100);
    lo.show();
  }

  //println(x,y,z);
}
