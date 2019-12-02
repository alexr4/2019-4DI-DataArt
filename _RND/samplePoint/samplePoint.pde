int i=0;
float x, y;
float radius = 10;

void setup(){
  size(500, 500, P2D);
  smooth(8);
  x = width/2;
  y = height/2;
  background(240);
  
}

void draw(){
  stroke(0);
  fill(200);
  if(i < 10000){
    float rndTheta = random(TWO_PI);
    float nx = cos(rndTheta) * radius + x;
    float ny = sin(rndTheta) * radius + y;
    
    ellipse(nx, ny, radius, radius);
    x = nx;
    y = ny;
    if(x > width || x < 0 || y > height || y < 0){
      x = width/2;
      y = height/2;
    }
    i++;
  }
}
