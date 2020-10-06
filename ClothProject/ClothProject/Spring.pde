
// Spring class for cloth
public class Spring {
  public Vec3 pos;
  public Vec3 vel;
  public Vec3 acc;
  public Vec3 force;
  
  public Spring(){
    pos =  new Vec3();
    vel = new Vec3();
    acc = new Vec3();
    force = new Vec3();
  }
  
  public Spring(float x, float y, float z){
    pos =  new Vec3(x, y, z);
    vel = new Vec3();
    acc = new Vec3();
    force = new Vec3();
  }
  
  public void fixY(){
    pos.y = 0;
  }
  
  public void goTo(Vec3 target){
    vel = target.minus(pos);
    vel.mul(10);
  }
}
