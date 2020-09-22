import java.util.*;
class Flock {
  
  // Only 1 class variale - just the list of boids
  public LinkedList<Boid> boids;
  public LinkedList<Vec2> obstacles;
  public boolean toggle;
  
  public Flock(){
    boids = new LinkedList<Boid>();
    obstacles = new LinkedList<Vec2>();
  }
   
  // Move each boid indidually
  public void move(PImage img){
    for (Boid b : boids) {
      b.move(boids, obstacles, img, toggle);
    }
  }

  // Just put it in the list
  public void add(Boid b){
    boids.add(b);
  }
  
  public void addObstacle(float x, float y){
    obstacles.add(new Vec2(x, y));
  }
  
  public void drawObstacles(){
    for(Vec2 pos : obstacles){
      circle(pos.x, pos.y, 50); 
    }
  }
}
