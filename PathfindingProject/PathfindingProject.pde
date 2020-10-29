// CSCI 5611 project 3
// Sid Lin - linx1052
// Noah Park - park1623

/* USAGE:
-On start-up your PRM will be tested on a random scene and the results printed
-Left clicking will set a red goal, right clicking the blue start
-The arrow keys will move the circular obstacle with the heavy outline
-Pressing 'r' will randomize the obstacles and re-run the tests 

ADDED FEATURES:
-Press 'e' to edit and override the mouse controls. Left or right mouse click will place a white circle and re-compute path.
-Press 'tab' to move the agent from start to finish.
*/

/*
TODO LIST:
Simple agent navigation: 50 - DONE
3d rendinering: 10 - idk
Improved agent rendering: 10 - i dunno use some textures or whatever
Orientation smoothing: 10 - ALMOST DONE
Planning rotation: 10 - idk
User scenario editing: 10: - DONE 
Realtime user interaction: 10 - idk
Multiple agents: 10 - idk
Crowd: 20 - idk
Website: 10
*/

import java.util.*;

// NODE & OBSTACLE VARIABLES
int numObstacles = 50;
int numNodes  = 100;
static int maxNumObstacles = 1000;
static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];
Vec2 circlePos[] = new Vec2[maxNumObstacles]; //Circle positions
float circleRad[] = new float[maxNumObstacles];  //Circle radii

// START/END/PATHING VARIABLES
Vec2 startPos = new Vec2(100,500);
Vec2 goalPos = new Vec2(500,200);
Vec2 currPos = new Vec2(0, 0);
ArrayList<Integer> curPath; // Holds the shortest path
LinkedList<Vec2> pathOfVectors; // "Queue" of node positions for the path

// BOOLEAN FLAGS
boolean pathFound = true;
boolean traveling = false;
boolean reachedGoal = false;
boolean editing = false;

// VARIOUS VARIABLES
int numCollisions;
float pathLength;
int strokeWidth = 2;

// IMAGE STUFF
PImage tree;
PImage grass;

/**
* Setup the screen size.
*/
void setup(){
  size(1024,768);
  tree = loadImage("tree.png");
  grass = loadImage("grass.jpg");
  testPRM();
}

/**
* Draw func to actaully put objects on screen.
*/
void draw(){
  strokeWeight(1);
  //background(200); //Grey background
  image(grass, 0, 0, width, height);
  stroke(0,0,0);
  fill(255,255,255);
  
  //Draw the circle obstacles
  for (int i = 0; i < numObstacles; i++){
    Vec2 c = circlePos[i];
    float r = circleRad[i];
    //circle(c.x,c.y,r*2);
    image(tree, c.x-r, c.y-r, r*2, r*2);
  }
  
  // Draw user controllable circle
  fill(125);
  circle(circlePos[0].x,circlePos[0].y,circleRad[0]*2);
  
  // Draw PRM Nodes
  fill(0, 255, 0);
  for (int i = 0; i < numNodes; i++){
    circle(nodePos[i].x,nodePos[i].y,5);
  }
  
  /* Connect all nodes in the roadmap - cleaning this up for now
  stroke(100,100,100);
  strokeWeight(1);
  for (int i = 0; i < numNodes; i++){
    for (int j : neighbors[i]) line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
  } */
  
  // Draw Start and Goal nodes
  fill(0, 0, 255);
  circle(startPos.x,startPos.y,20);
  fill(255, 0, 0);
  circle(goalPos.x,goalPos.y,20);
  
  // Invalid path
  if(curPath.size() > 0 && curPath.get(0) == -1){
    pathFound = false;
    return; //No path found
  }
  
  // Draw the actual planned path
  stroke(20,255,40);
  strokeWeight(2);
  if (curPath.size() == 0){
    line(startPos.x,startPos.y,goalPos.x,goalPos.y);
    return;
  }
  line(startPos.x,startPos.y,nodePos[curPath.get(0)].x,nodePos[curPath.get(0)].y);
  for (int i = 0; i < curPath.size()-1; i++){
    int curNode = curPath.get(i);
    int nextNode = curPath.get(i+1);
    line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
  }
  line(goalPos.x,goalPos.y,nodePos[curPath.get(curPath.size()-1)].x,nodePos[curPath.get(curPath.size()-1)].y);
  
  // Reset the stroke
  stroke(0,0,0);

  // DRAW NODE GOING TO GOAL HERE
  if(traveling){
    // If we are at the end of the path
    if(pathOfVectors.isEmpty()){
      traveling = false;
      return;
    }
    currPos = travel(currPos, pathOfVectors.peek(), nodePos, curPath);
    if(currPos.equals(pathOfVectors.peek())) currPos = pathOfVectors.poll();
  }
}

boolean shiftDown = false;
void keyPressed(){
  if (key == 'r'){
    testPRM();
    return;
  }
  
  if(keyCode == SHIFT){
    shiftDown = true;
  }
  
  if(key == TAB){ // Enable the traveling
    if(!pathFound) return;
    System.out.println("Starting path!"); 
    // Set current position to equal start position
    currPos = new Vec2(startPos.x, startPos.y);
    traveling = true;
    // Duplicate the list to use with pathfinding
    pathOfVectors = new LinkedList<Vec2>();
    pathOfVectors.add(startPos);
    for(int i : curPath) pathOfVectors.add(nodePos[i]);
    pathOfVectors.add(goalPos);
    System.out.println(pathOfVectors.toString()); // Should be of size path.length + 2
    return;
  }
  
  // Toggle edit mode
  if(key == 'e'){
    editing = !editing;
    System.out.println("EDITING: " + editing);
    return;
  }
  
  // Moves the circle on the screen
  float speed = 10;
  if (shiftDown) speed = 30;
  if (keyCode == RIGHT){
    circlePos[0].x += speed;
  }
  if (keyCode == LEFT){
    circlePos[0].x -= speed;
  }
  if (keyCode == UP){
    circlePos[0].y -= speed;
  }
  if (keyCode == DOWN){
    circlePos[0].y += speed;
  }
  computePath();
}

/**
* Helper to compute path after a circle is drawn or added
*/
void computePath(){
  connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);
  curPath = planPath(startPos, goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  if(curPath.size() > 0 && curPath.get(0) == -1){
    pathFound = false;
    return; //No path found
  }
  else pathFound = true; 
}

// Turns off the "extra speed"
void keyReleased(){
  if (keyCode == SHIFT){
    shiftDown = false;
  }
}

void mousePressed(){
  traveling = false;
  currPos = null;
  
  if(editing){
    addCircle();
    return; 
  }
  
  // If not editing
  if (mouseButton == RIGHT){
    startPos = new Vec2(mouseX, mouseY);
  }
  else{
    goalPos = new Vec2(mouseX, mouseY);
  }
  curPath = planPath(startPos, goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  if(curPath.size() > 0 && curPath.get(0) == -1){
    pathFound = false;
    return; //No path found
  }
  else pathFound = true;
}

/**
* Adds a circle to the map
*/
void addCircle(){
   if(numObstacles >= maxNumObstacles){
     System.out.println("Maximum number of obstacled reached: " + maxNumObstacles);
     return;
   }
   fill(255);
   int idx = numObstacles++;
   float rad = (10+40*pow(random(1),3));
   circlePos[idx] = new Vec2(mouseX, mouseY);
   circleRad[idx] = rad;
   circle(circlePos[idx].x,circlePos[idx].y,rad*2);
   computePath();
}
