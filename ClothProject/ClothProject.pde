// Processing 3d Camera Library

/*
Installation:
Go to Sketch -> Import Library -> Add Library -> *Search for PeasyCam and install*
The sketch will NOT work without doing this!!

Controls:
Scroll wheel: move in/out
Mouse drag: rotate/pan camera
WASD: move ball
Checklist:
Multiple ropes: YES
Cloth simulation: YES 
Air drag: YES
3D camera and rendering: YES
User interaction: YES
Realistic speed: YES
Ripping/tearing: NO
Water: NO
Art contest: Yes
Project video: YES
*/
import peasy.*;

PeasyCam cam;

// Start the ball back a bit before the cloth
Vec3 ballPos = new Vec3(50, 40, 50);

int n = 20;
float dt = 0.0000001;
float heightOffset = -50;
float restingLength = 5;
PImage texture;
      

float k = 100000; 
float kv = 10000;

ArrayList<ArrayList<Spring>> springs = new ArrayList<ArrayList<Spring>>();

public void setup(){
  size(1200, 800, P3D);
  
  // Initialize the framework camera with min/max zoom distance
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(75);
  cam.setMaximumDistance(300);
  
  // Initialize springs here
  for(int i = 0; i < n; i++){
    ArrayList<Spring> temp = new ArrayList<Spring>();
    for(int j = 0; j < n; j++) temp.add(new Spring(restingLength*i, heightOffset, restingLength*j));
    springs.add(temp);
  }
  
  for(int i = 0; i < n; i++) springs.get(0).get(i).pinned = true;
}

public void draw(){
  lights();
  background(0);
  drawSphere();
  lines();
  for(int i = 0; i < springs.size(); i++) moveCloth();
  if(keyPressed) moveBall(key);
}

public void lines(){
  for(int i = 1; i < n; i++){
    ArrayList<Spring> temp = springs.get(i);
    for(int j = 1; j < n; j++){
      Vec3 current = temp.get(j).pos;
      Vec3 left = temp.get(j-1).pos;
      Vec3 up = springs.get(i-1).get(j).pos;
      line(current.x, current.y, current.z, left.x, left.y, left.z);
      line(current.x, current.y, current.z, up.x, up.y, up.z);
    }
  }
  
  // Draw last line for i
  for(int i = 0; i < n-1; i++){
    Vec3 current = springs.get(i).get(0).pos;
    Vec3 next = springs.get(i+1).get(0).pos;
    line(current.x, current.y, current.z, next.x, next.y, next.z);
  }
  
  // Last line for j
  for(int j = 0; j < n-1; j++){
    Vec3 current = springs.get(0).get(j).pos;
    Vec3 next = springs.get(0).get(j+1).pos;
    line(current.x, current.y, current.z, next.x, next.y, next.z);
  }
}

// Iterate through the spring array and have springs apply forces to their neighbors
public void moveCloth(){
  textureCloth();
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      Spring current = springs.get(i).get(j);
      //Build the cloth
      if(i == 0 && j == 0){
        current.applySpringForce(null, null, null);
      }
      else if(i > 0 && j == 0){
        Spring above = springs.get(i-1).get(j);
        current.applySpringForce(null, above, null);
      }
      else if(i == 0 && j >= 0){
        Spring left = springs.get(i).get(j-1);
        current.applySpringForce(left, null, null);
      }
      else{
        Spring above = springs.get(i-1).get(j);
        Spring left = springs.get(i).get(j-1);
        Spring corner = springs.get(i-1).get(j-1);
        current.applySpringForce(left, above, null);
        current.applyDragForce(left, above, corner, dt);
      }
      
      // Handle collisions
      current.handleBallCollisions();
    }// End nested for
  }
}// End moveCloth

public void textureCloth(){
    for(int i = 0; i < n-1; i++){
      for(int j = 0; j < n-1; j++){
        pushMatrix();
        beginShape();
        fill(0, 0, 255);
        noStroke();
        vertex(springs.get(i).get(j).pos.x, springs.get(i).get(j).pos.y, springs.get(i).get(j).pos.z, (float)i/n, (float)j/n);
        vertex(springs.get(i+1).get(j).pos.x, springs.get(i+1).get(j).pos.y, springs.get(i+1).get(j).pos.z, (float)(i+1)/n, (float)j/n);
        vertex(springs.get(i).get(j+1).pos.x, springs.get(i).get(j+1).pos.y, springs.get(i).get(j+1).pos.z, (float)i/n, (float)(j+1)/n);
        endShape();
        beginShape();
        texture(texture);
        textureMode(NORMAL);
        fill(0, 255, 0);
        noStroke();
        vertex(springs.get(i+1).get(j+1).pos.x, springs.get(i+1).get(j+1).pos.y, springs.get(i+1).get(j+1).pos.z, (float)(i+1)/n, (float)(j+1)/n);
        vertex(springs.get(i+1).get(j).pos.x, springs.get(i+1).get(j).pos.y, springs.get(i+1).get(j).pos.z, (float)(i+1)/n, (float)j/n);
        vertex(springs.get(i).get(j+1).pos.x, springs.get(i).get(j+1).pos.y, springs.get(i).get(j+1).pos.z, (float)i/n, (float)(j+1)/n);
        endShape();
        popMatrix();
      }
    }
}
