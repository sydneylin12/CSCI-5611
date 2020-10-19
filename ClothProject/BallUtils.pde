
float radius = 30.0;

// Ball controls
public void moveBall(char dir) {
  float speed = 0.5;
  if(dir == 'w') ballPos.z-=speed;
  else if(dir == 'a') ballPos.x-=speed;
  else if(dir == 's') ballPos.z+=speed;
  else if(dir == 'd') ballPos.x+=speed;
}

// Draws a ball by translating and pushing onto the matrix stack
public void drawSphere() {
  pushMatrix();
  fill(255,0,0);
  stroke(255, 0, 0);
  noStroke(); // So the ball doesn't have triangles everywhere
  translate(ballPos.x, ballPos.y, ballPos.z);
  sphere(radius);
  popMatrix();
}
