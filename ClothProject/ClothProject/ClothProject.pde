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
Multiple ropes: YES 50 
Cloth simulation: YES 20
Air drag: NO
3D camera: YES 20
User interaction: Partially (camera can move but ball does not interact w/ cloth) (5/10)?
Realistic speed: NO
Ripping/tearing: NO
Water: NO
*/
import peasy.*;

PeasyCam cam;

// Start the ball back a bit before the cloth
Vec3 ballPos = new Vec3(0, 0, 10);

int n = 50;
float dt = 0.0000001;
float heightOffset = -25;
float restingLength = 1;
      
float k = 80000; 
float kv = 4000;

ArrayList<ArrayList<Spring>> springs = new ArrayList<ArrayList<Spring>>();

public void setup(){
  size(1200, 800, P3D);
  
  // Initialize the framework camera with min/max zoom distance
  cam = new PeasyCam(this, 125);
  cam.setMinimumDistance(75);
  cam.setMaximumDistance(150);
  
  // Everything white
  fill(255);
  stroke(255);
  
  // Initialize springs here
  for(int i = 0; i < n; i++){
    // All springs will be of length 1 apart (RESTING)
    ArrayList<Spring> temp = new ArrayList<Spring>();
    for(int j = 0; j < n; j++) temp.add(new Spring(i, heightOffset, j));
    springs.add(temp);
  }
  
  for(int i = 0; i < n; i++) springs.get(0).get(i).pinned = true;
  
  // If pinning all 4 corners, 1 doesnt get pinned properly
  //springs.get(0).get(0).pinned = true;
  //springs.get(0).get(n-1).pinned = true;
  //springs.get(n-1).get(0).pinned = true;
  //springs.get(n-1).get(n-1).pinned = true;
}

public void draw(){
  lights();
  background(0);
  
  drawSphere();
  lines();
  for(int i = 0; i < springs.size(); i++){
    moveCloth();
  }
  if(keyPressed) moveBall(key);
}

public void lines(){
  // Set white again
  fill(255);
  stroke(255);
  
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
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      Spring current = springs.get(i).get(j);
      if(i == 0 && j == 0){
        current.applyForce(null, null, null);
      }
      else if(i > 0 && j == 0){
        Spring above = springs.get(i-1).get(j);
        current.applyForce(null, above, null);
      }
      else if(i == 0 && j > 0){
        Spring left = springs.get(i).get(j-1);
        current.applyForce(left, null, null);
      }
      else{
        Spring above = springs.get(i-1).get(j);
        Spring left = springs.get(i).get(j-1);
        // This does not work yet
        Spring corner = springs.get(i-1).get(j-1);
        current.applyForce(left, above, null);
      }
    } // End nested for
  }
}
