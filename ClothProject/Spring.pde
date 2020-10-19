
// Spring class for cloth
public class Spring {
  public Vec3 pos;
  public Vec3 vel;
  public Vec3 acc;
  public Vec3 force;
  
  // 9.8 m/s^2
  public float gravity = 9.8;
  public boolean pinned;
  
  public Spring(float x, float y, float z){
    pos =  new Vec3(x, y, z);
    vel = new Vec3();
    acc = new Vec3();
    force = new Vec3();
    pinned = false;
  }
  
  // Do all the physics here
  // @param left, the left neighbor of the spring, null if there is none
  // @param above, the spring directly above the current one, null if none
  public void applySpringForce(Spring left, Spring above, Spring corner){
    if(pinned) return;
    float v1 = 0;
    float v2 = 0;
    float fNet = 0;
    float currentLength = 0;
    Vec3 dir = new Vec3();

    // Formula : sigma(springs in vertices) * k(current length of spring - resting length of spring) = MA = FNet
    
    // Add force from left neighbor
    if(left != null){
      // Get direction from a to b
      dir = pos.minus(left.pos);
      // Then get the magnitude (current length of spring)
      currentLength = dir.length();
      dir.normalize();
      
      v1 = dot(dir, left.vel);
      v2 = dot(dir, vel);
      
      // fNet = springforce + dampForce
      fNet = -k*(restingLength - currentLength) - kv * (v1-v2);
      
      vel = vel.minus(dir.times(fNet * dt));
      left.vel.add(dir.times(fNet * dt));
    }
    else force.y = 0;

    
    // Add force from above neighbor
    if(above != null){
      dir = pos.minus(above.pos);
      currentLength = dir.length();
      dir.normalize();
      v1 = dot(dir, above.vel);
      v2 = dot(dir, vel);
      fNet = -k * (restingLength - currentLength) - kv * (v1-v2);
      vel.sub(dir.times(fNet * dt));
      above.vel.add(dir.times(fNet * dt));
    }
    else force.x = 0;
    
    // Add force from above neighbor
    if(corner != null){
      dir = pos.minus(corner.pos);
      currentLength = dir.length();
      dir.normalize();
      v1 = dot(dir, corner.vel);
      v2 = dot(dir, vel);
      fNet = -k * (restingLength - currentLength) - kv * (v1-v2);
      vel.sub(dir.times(fNet * dt));
      corner.vel.add(dir.times(fNet * dt));
    }
    else force.z = 0;
    
    acc.y = force.y + gravity;
    acc.z = force.z;
    acc.x = force.x;
    vel.y += acc.y * dt;
    vel.z += acc.z * dt;
    vel.x += acc.x * dt;
    
    pos.add(vel.times(5));
    
  }
 
  public void handleBallCollisions(){
    float ballDistance = pos.minus(ballPos).length();
    if(ballDistance < radius + 0.1){
      Vec3 n = ballPos.minus(pos).times(-1);
      n.normalize();
      Vec3 bounce = n.times(dot(vel, n));
      vel = vel.minus(bounce.times(1.5));
      pos = pos.plus(n.times(0.1 + radius - ballDistance));
    }
  }
  
   public void applyDragForce (Spring left, Spring above, Spring corner){
     float cons = - 0.0045;
     Vec3 air = new Vec3 (0, 0, 0);
     Vec3 velAvg = vel.plus(left.vel).plus(above.vel).times(1.0/3).minus(air);
     Vec3 normal = cross(left.pos.minus(pos), above.pos.minus(pos));
     Vec3 drag = normal.times(cons*dot(normal, velAvg)*velAvg.length()/normal.length());
     vel = vel.plus(drag);
     above.vel = above.vel.plus(drag);
     left.vel = left.vel.plus(drag);
     
     velAvg = corner.vel.plus(left.vel).plus(above.vel).times(1.0/3).minus(air);
     normal = cross(left.pos.minus(corner.pos), above.pos.minus(corner.pos));
     drag = normal.times(cons*dot(normal, velAvg)*velAvg.length()/normal.length());
     corner.vel = corner.vel.plus(drag);
     above.vel = above.vel.plus(drag);
     left.vel = left.vel.plus(drag);   
   }
}
