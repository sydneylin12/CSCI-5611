// Processing 3d Camera Library
import peasy.*;

PeasyCam cam;

Vec3 ballPos = new Vec3(0, 0, 0);

void setup() {
  size(1200, 800, P3D);
  
  // Initialize the framework camera with min/max zoom distance
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(150);
  
  // Everything white
  fill(255);
  stroke(255);
  strokeWeight(1);
}

void draw() {
  lights();
  background(0);
  drawSphere();
  if(keyPressed) moveSphere(key);
}
