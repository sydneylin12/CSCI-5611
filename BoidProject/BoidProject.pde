// Sid Lin - linx1052 - 5345915

Flock f;
PImage img;
boolean debug;

void setup() {
  size(1024, 1024);
  f = new Flock();
  int rand = 500;
  debug = true;
  
  // Change this to improve FPS
  int num = 400;
  
  for (int i = 0; i < num; i++){
    // Spawn a boid in the middle
    float randX = random(-rand, rand);
    float randY = random(-rand, rand);
    f.add(new Boid(width/2+randX,height/2+randY));
  }
  
  // Fill in ball color
  stroke(0);
  fill(255, 0, 0);
  
  f.addObstacle(width/2, height/2);
  
  // Add the bird image 
  img = loadImage("ant.png");
}


void draw() {
  background(255);
  for(Boid b: f.boids){
    float theta = (float) Math.atan2(b.vel.y, b.vel.x);
    pushMatrix();
    translate(b.pos.x, b.pos.y);
    rotate(theta + radians(45));
    image(img, 0, 0, 10, 10);
    popMatrix();
  }
  f.move(img);
  f.drawObstacles();
  if(debug) System.out.println("Frame rate is: " + frameRate + " fps");  
}

// User interaction - add a boid on click
void mousePressed() {
  f.add(new Boid(mouseX,mouseY));
}

void keyPressed(){
  if(key == 'o'){
    f.addObstacle(mouseX, mouseY); 
  }
  if(key == 'c'){
    f.obstacles.clear(); 
  }
  if(key == 't'){
    f.toggle = !f.toggle; 
  }
  if(key == 'd'){
    debug = !debug;
  }
}
