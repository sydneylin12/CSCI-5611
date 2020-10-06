//Vector Library [2D]
//CSCI 5611 Vector 3 from HW1

public class Vec3 {
  public float x, y, z;
  
  public Vec3(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  public Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString(){
    StringBuilder sb = new StringBuilder();
    sb.append("(");
    sb.append(x);
    sb.append(", ");
    sb.append(y);
    sb.append(", ");
    sb.append(z);
    sb.append(")");
    return sb.toString();
  }
  
  public float length(){
    return (float) Math.sqrt(x * x + y * y + z * z);
  }
  
  public float lengthSqr(){
    return x * x + y * y + z * z;
  }
  
  public Vec3 plus(Vec3 rhs){
    return new Vec3(x+rhs.x,y+rhs.y,z+rhs.z);
  }
  
  public void add(Vec3 rhs){
    // ...
    x+=rhs.x;
    y+=rhs.y;
    z+=rhs.z;
  }
  
  public Vec3 minus(Vec3 rhs){
    return new Vec3(x-rhs.x,y-rhs.y,z-rhs.z);
  }
  
  public void subtract(Vec3 rhs){
    // ...
    x-=rhs.x;
    y-=rhs.y;
    z-=rhs.z;
  }
  
  public Vec3 times(float rhs){
    return new Vec3(x*rhs,y*rhs,z*rhs);
  }
  
  public void mul(float rhs){
    // ...
    x*=rhs;
    y*=rhs;
    z*=rhs;
  }
  
  public void div(float rhs){
    if(rhs == 0) return;
    x/=rhs;
    y/=rhs;
    z/=rhs;
  }
  
  public void normalize(){
    // ...
    float len = length();
    if(len == 0) return;
    x /= len;
    y /= len;
    z /= len;
  }
  
  public Vec3 normalized(){
    float len = length();
    if(len == 0) return null;
    return new Vec3(x/len, y/len, z/len);
  }
  
  //If the vector is longer than maxL, shrink it to be maxL otherwise do nothing
  public void clampToLength(float maxL){
    // ...
    if(length() > maxL){
      float temp = length();
      x = x / temp * maxL;
      y = y / temp * maxL;
      z = z / temp * maxL;
    }
  }
  
  //Grow or shrink the vector have a length of maxL
  public void setToLength(float newL){
    // ...
    float temp = length();
    x = x / temp * newL;
    y = y / temp * newL;
    z = z / temp * newL;
  }
  
  public float distanceTo(Vec3 rhs){
    return this.minus(rhs).length();
  }
}

public Vec3 interpolate(Vec3 a, Vec3 b, float t){
  return a.plus(b.minus(a).times(t));
}

public float dot(Vec3 a, Vec3 b){
  return a.x*b.x+a.y*b.y+a.z*b.z;
}

public Vec3 cross(Vec3 a, Vec3 b){
  return new Vec3(a.x*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x);
}

public Vec3 projAB(Vec3 a, Vec3 b){
  float first = dot(a, b)/b.length();
  Vec3 second = b.normalized();
  return second.times(first);
}
