import java.util.*;  
class Boid {
  public Vec2 pos;
  public Vec2 vel;
  public Vec2 acc;
  public float radius;
  public float maxforce;
  public float speed;
  public float distance;
  
  // Constructor with coordinates for position
  public Boid(float x, float y){
    // Initialize P, V, A
    acc = new Vec2(0, 0);
    vel = new Vec2(0, 0);
    pos = new Vec2(x, y);
    
    // Initialize all universal variables
    radius = 2;
    speed = 2;
    maxforce = 0.05;
    distance = 50;
  }

  // Handle movement of all boids in the list
  public void move(LinkedList<Boid> boids, LinkedList<Vec2> obstacles, PImage img, boolean toggle){    
    // Draw bird image here
    image(img, pos.x, pos.y, 10, 10);
        
    // Handle the 3 forces before drawing the circles
    flock(boids, obstacles, toggle);  
    
    // Call update (called each frame) after handling the boid motion
    update();
    
    // Update the particle position if they hit the walls
    checkWalls();
  }

  // Handle the 3 forces on each boid and add each force to a boid's accel. 
  public void flock(LinkedList<Boid> boids, LinkedList<Vec2> obstacles, boolean toggle){ 
    acc.add(separate(boids));
    acc.add(avoid(obstacles, toggle));
    acc.add(align(boids));
    acc.add(cohesion(boids));
  }

  // Called every frame
  public void update(){
    
    // Add acceleration to velocity
    vel.add(acc);
    
    // Update position afterward
    pos.add(vel);
    vel.clampToLength(2);
    
    // Reset accel
    acc = new Vec2(0, 0);
  }

  // Find a vector that points toward another
  public Vec2 find(Vec2 target){
    // Find vector between other position and current position
    Vec2 diff = target.minus(pos);
    diff.normalize();
    diff.mul(speed);
    
    // Subtract our velocity to get needed direction vector
    Vec2 res = diff.minus(vel);
    res.clampToLength(maxforce);
    return res;
  }

  // Handle collisions with the edge of the canvas
  public void checkWalls(){
    if(pos.x < -radius){
      pos.x = width+radius;
    }
    if(pos.x > width+radius){
      pos.x = -radius;
    }
    if(pos.y < -radius){
      pos.y = height+radius;
    }
    if(pos.y > height+radius){
      pos.y = -radius;
    }
  }
  
  // To clean up syntax - find if a boid is close enough to another
  public boolean inRange(float d){
    return d > 0 && d < distance; 
  }
  
  // Modified to work with obstacles
  // Straight up just modify the constant to account for radius
  public boolean inRangeObstacle(float d){
    return d > 0 && d < distance + 25; 
  }

  // Property 1 - seperation of boids
  // Rule: steer away from other voids, don't want collisions
  // How: sum up all the positions of neighbor boids and divide by N
  Vec2 separate (LinkedList<Boid> boids){    
    Vec2 res = new Vec2(0, 0);
    int avg = 0;
    for(Boid b : boids){
      // Skip over the curent void
      if(this == b) continue; 
      
      // Check if the distance to the other boid is valid
      // This is similar for the rest of the functions
      else if(inRange(pos.distanceTo(b.pos))){
        Vec2 dist = this.pos.minus(b.pos);
        // Without normalize they start bunching up in the corner
        dist.normalize();
        dist.div(pos.distanceTo(b.pos));
        res.add(dist);
        avg++;
      }
    }
  
    // Div by 0 handled already 
    res.div(avg);
    if(res.length() != 0){
      res.normalize();
      res.mul(speed);
      res.subtract(vel);
      res.clampToLength(0.05); 
    }
    return res;
  }
  
  // Property 1.5 - seperation of boids from OBSTACLES
  Vec2 avoid(LinkedList<Vec2> obstacles, boolean toggle){
    Vec2 res = new Vec2(0, 0);
    int avg = 0;
    for(Vec2 v : obstacles){
      // If the boid is close enough
      if(inRangeObstacle(pos.distanceTo(v))){
        Vec2 dist = this.pos.minus(v);
        dist.normalize();
        dist.div(pos.distanceTo(v));
        res.add(dist);
        avg++;
      }
    }
    
    // If the boid is close enough
    if(inRangeObstacle(pos.distanceTo(new Vec2(mouseX, mouseY))) && toggle){
      Vec2 dist = this.pos.minus(new Vec2(mouseX, mouseY));
      dist.normalize();
      dist.div(pos.distanceTo(new Vec2(mouseX, mouseY)));
      res.add(dist);
      avg++;
    }
  
    // Div by 0 handled already 
    res.div(avg);
    
    // We want a more aggressive force that avoids obstacles
    if(res.length() != 0){
      res.normalize();
      res.mul(speed);
      res.subtract(vel);
      res.clampToLength(0.1); 
    }
    return res;
  }
  
  // Boid property 2 - alignment
  // Rule: steer boids toward the majority of the flock/crowd
  // How : calculate the average velocity and set it across the flock
  Vec2 align(LinkedList<Boid> boids){
    Vec2 res = new Vec2(0, 0);
    int avg = 0;
    for (Boid b : boids){
      
      // Again don't count the current object
      if(this == b) continue;
      else if(inRange(pos.distanceTo(b.pos))){
        res.add(b.vel);
        avg++;
      }
    }
    
    res.div(avg);
    res.normalize();
    Vec2 steer = res.minus(vel);
    steer.clampToLength(0.05);
    return steer;
  }

  // Property 3 - cohesion
  // Rule 3 - Boids try to keep up with the flock they are in
  // How: average out the position
  Vec2 cohesion(LinkedList<Boid> boids){
    Vec2 res = new Vec2(0, 0);
    int avg = 0;
    for (Boid b : boids){
      if(this == b) continue;
      else if(inRange(pos.distanceTo(b.pos))){
        res.add(b.pos);
        avg++;
      }
    }
    // Divide by 0 is handled in vec2
    res.div(avg);
    
    // Find the vector that will point to the crowd
    return find(res); 
  }
}
