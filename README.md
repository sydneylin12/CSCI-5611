# CSCI 5611 - Sid Lin
This is my repository for CSCI 5611 - Fall 2020.

Website link can be found [here](https://sydneylin12.github.io/CSCI-5611/)

# Project 1 - Boids
## Overview
I have implemented a simple 2d boid simulation in processing, per the assignment requirements. 
Each boid is represented as a ant icon because it was the first thing I could think of.
The ants will move around in "swarms" and avoid the big red circles (obstacles).
Obstacles are drawn as large red circles with a black outline.

## Features
* Separation
  * Required - boids will separate a small distance from each other, as if they needed "personal space"
* Alignment
  * Reqired - boids will generally face/move in the same direction as the surrounding crowd.
* Cohesion
  * Required - boids will attempt to move in a "flock"
* Additional Behavoirs
  * My boids will avoid obstacles placed on the scene
  * Use key 'o' to place a boid at (mouseX, mouseY)
  * Use 'c' to remove all obstacles
* Benchmarking
  * Additional - console output to determine framerate
  * Use key 't' to toggle benchmarking, default is true (on)
  * NOTE: n = 1000 yields around 24 FPS on a NVIDIA GTX 1060 w/ i7 4790k
* Improved Boid Rendering
  * Additional - used ant logos instead of simple shapes for each boid
  * Got boids to rotate correctly using ArcTan with velocity vector
* User Interaction
  * Click the canvas to place a boid
  * Type 't' to toggle "mouse repel"
  * Type 'o' to spawn obstacle
  * Type 'd' to toggle debug FPS output to console
  * Type 'c' to clear
  
## Code
The general approach to this project was averaging out certain vectors in an O(n^2) loop between each boid. There was a distance helper function to
determine if a boid was close enough to the other. Then, a count is summed up and the resulting vector is averaged by the amount of valid boids. 
Finally, I make some modifications to the resulting acceleration vector to make sure the boids are moving slow enough.
<pre><code>
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
    res.normalize();
    res.setToLength(0.05);
    return res;
    return res;
  }
</pre></code>

This block of code is used for rotating the image. It was probably the other significant part about the project, other than the boid implementation.

<pre><code>
float theta = (float) Math.atan2(b.vel.y, b.vel.x);
pushMatrix();
translate(b.pos.x, b.pos.y);
rotate(theta + radians(45));
image(img, 0, 0, 10, 10);
popMatrix();
</pre></code>
  
## Tech used
Vanilla processing + java.utils LinkedList<> ADT. One image from google images was used (the ant). 

## Difficulties
A lot of the vector tweaking was "guess-and-checking" rather than doing it to a formula. I had to normalize, clamp, and set a ton of variables. 
There are also tons of arbitrary weights in the code, such as the 1.2 for separation. Getting the rotation to work was also frustrating because I
kept using position instead of velocity to get a boid's direction. I had previous experience with processing from 4611 so there was little to no learning
curve for this editor.

## Videos
I can't embed a video in here, so [here](https://www.youtube.com/watch?v=u0CUPmYFpRw&feature=youtu.be&ab_channel=SidLin) is a link to a YT unlisted video instead.
NOTE: I made a few minor changes after recording, so the final result may vary SLIGHTLY.
  




