class LorentzAttractor {
  float x= 0.01;
  float y = 0;
  float z = 0;
  float a = 10;
  float b = 28;
  float c = 8.0/3.0;
  ArrayList<PVector>points = new ArrayList<PVector>();
  int maxNumberOfPoint;

  LorentzAttractor(float x, float y, float z, int maxNumberOfPoint) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.maxNumberOfPoint = maxNumberOfPoint;
  }

  void update() {
    float dt=0.01;
    float dx = (a*(y-x))*dt;
    float dy = (x*(b-z)-y)*dt;
    float dz = (x*y-c*z)*dt;
    x=x+dx;
    y=y+dy;
    z=z+dz;
    points.add(new PVector(x, y, z));
    
    if(points.size() > maxNumberOfPoint) points.remove(0);
  }

  void show() {
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y, v.z);
    }
    endShape();
  }
}
