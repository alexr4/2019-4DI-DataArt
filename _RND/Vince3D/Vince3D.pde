Tree tree;
float min_dist = 10;
float max_dist = 100;
float boxWidth;
float len = 5;

void setup() {
  size(1000, 1000, P3D);
  smooth(8);
  boxWidth = width/4;
  tree = new Tree();
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(225, 100, 60);
  translate(width/2, height/2, mouseX);
  rotateY(millis() * 0.0001);
  //strokeWeight(4);
  noStroke();
  
  lights();
  //directionalLight(220, 50, 50, 0.5, 0.25, -1.0);
  //directionalLight(51, 15, 99, -0.5, -0.25, -1.0);
  //directionalLight(51, 15, 50, 0, -0.5, 1.0);

  tree.show();
  tree.grow();
}

class Tree {
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();
  Tree() {
    for (int i = 0; i < 100; i++) {
      leaves.add(new Leaf());
    }
    Branch root = new Branch(new PVector(0, 0, 0), new PVector(0, -1, 0));
    branches.add(root);
    Branch current = new Branch(root);
    while (!closeEnough(current)) {
      Branch trunk = new Branch(current);
      branches.add(trunk);
      current = trunk;
    }
  }
  boolean closeEnough(Branch b) {
    for (Leaf l : leaves) {
      float d = PVector.dist(b.pos, l.pos);
      if (d < max_dist) {
        return true;
      }
    }
    return false;
  }
  void grow() {
    for (Leaf l : leaves) {
      Branch closest = null;
      PVector closestDir = null;
      float record = -1;
      for (Branch b : branches) {
        PVector dir = PVector.sub(l.pos, b.pos);
        float d = dir.mag();
        if (d < min_dist) {
          l.reached();
          closest = null;
          break;
        } else if (d > max_dist) {
        } else if (closest == null || d < record) {
          closest = b;
          closestDir = dir;
          record = d;
        }
      }
      if (closest != null) {
        closestDir.normalize();
        closest.dir.add(closestDir);
        closest.count++;
      }
    }
    for (int i = leaves.size()-1; i >= 0; i--) {
      if (leaves.get(i).reached) {
        leaves.remove(i);
      }
    }
    for (int i = branches.size()-1; i >= 0; i--) {
      Branch b = branches.get(i);
      if (b.count > 0) {
        b.dir.div(b.count);
        b.dir.normalize();
        Branch newB = new Branch(b);
        branches.add(newB);
        b.reset();
      }
    }
  }
  void show() {
    /*for (Leaf l : leaves) {
     l.show();
     }*/
    for (Branch b : branches) {
      if (b.parent != null) {
        float distToOrigin = PVector.dist(b.pos, new PVector(0, 0, 0));
        distToOrigin /= boxWidth;

        fill(360 - distToOrigin * 200, 100, 100);
        //line(b.pos.x, b.pos.y, b.pos.z, b.parent.pos.x, b.parent.pos.y, b.parent.pos.z);

        noStroke();
        pushMatrix();
        translate(b.pos.x, b.pos.y, b.pos.z);
        rotate(b.eta, b.axis.x, b.axis.y, b.axis.z); 
        translate(0, -b.radius*.5, 0);
        box(b.radius * b.radiusInc, b.radius, b.radius * b.radiusInc);
        popMatrix();
      }
    }
  }
}
class Branch {
  Branch parent;
  PVector pos;
  PVector dir;
  int count = 0;
  PVector saveDir;

  PVector axis;
  float eta;
  float radius;
  float radiusInc;

  Branch(PVector v, PVector d) {
    parent = null;
    pos = v.copy();
    dir = d.copy();
    saveDir = dir.copy();
  }
  
  Branch(Branch p) {
    parent = p;
    pos = parent.next();
    dir = parent.dir.copy();
    saveDir = dir.copy();
    compute3DPosition();
  }
  
  void reset() {
    count = 0;
    dir = saveDir.copy();
  }
  PVector next() {
    PVector v = PVector.mult(dir, len);
    PVector next = PVector.add(pos, v);
    return next;
  }

  void compute3DPosition() {
    if (parent != null) {
      float distToOrigin = PVector.dist(pos, new PVector(0, 0, 0));
      distToOrigin /= boxWidth;

      PVector v0tov1 = PVector.sub(pos, parent.pos);
      PVector n = v0tov1.normalize();

      //compute angle between two vectors
      PVector v0 = new PVector(0, 1, 0);
      PVector v1 = v0tov1.copy().normalize();

      float v0Dotv1 = PVector.dot(v0, v1);
      eta = acos(v0Dotv1);
      axis = v0.cross(v1);
      
      radius = PVector.dist(pos, parent.pos);
      radiusInc = map(distToOrigin, 0, 1, 0.5, 0.05);
    }
  }
}
class Leaf {
  PVector pos;
  boolean reached = false;
  Leaf() {
    pos = PVector.random3D();
    pos.mult(random(boxWidth));
    //pos = new PVector(random(10, width-10), random(10, height-40));
  }
  void reached() {
    reached = true;
  }
  void show() {
    stroke(255);
    noFill();
    //strokeWeight(2);
    point(pos.x, pos.y, pos.z);
  }
}
