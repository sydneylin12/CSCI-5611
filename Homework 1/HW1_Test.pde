//CSCI 5611 HW 1 Vector Library
// Instructions:
//   Create 2 new classes Vec2 and Vec3 to support the various vector
//   operations shown in the stub implmentations included. Your code will
//   be graded  based on a set of test similar to the ones in this file.

void RunVec2Tests() {
  println("==========\nVec2 Tests\n==========");
  
  // Vec2 Constructors:
  Vec2 a = new Vec2(12,7);
  Vec2 b = new Vec2(7,-12);
  Vec2 c = new Vec2(0.5,0.7);
  
  // Vec2 toString printing:
  println("toString tests\n**************");
  println("a =", a.toString(),"expected: (12.0, 7.0)");
  println("b =", b.toString(),"expected: (7.0, -12.0)");
  println("c =", c.toString(),"expected: (0.5, 0.7)");
  println();
  
  // Vec2 length:
  println("length tests\n***********");
  println("length(a) =",a.length(),"expected: 13.892444");
  println("length(b) =",b.length(),"expected: 13.892444");
  println("length(c) =",c.length(),"expected: 0.86023253");
  println();
  
  // Vec2 lengthSqr:
  println("lengthSqr tests\n***********");
  println("lengthSqr(a) =",a.lengthSqr(),"expected: 193.0");
  println("lengthSqr(b) =",b.lengthSqr(),"expected: 193.0");
  println("lengthSqr(c) =",c.lengthSqr(),"expected: 0.74");
  println();
  
  // Vec2 plus:
  println("plus tests\n**********");
  println("a.plus(b) =",a.plus(b),"expected: (19.0, -5.0)");
  println("a.plus(c) =",a.plus(c),"expected: (12.5, 7.7)");
  println();
  
  // Vec2 add:
  Vec2 a_tmp = new Vec2(a.x,a.y);
  Vec2 b_tmp = new Vec2(b.x,b.y);
  println("add tests\n*********");
  a_tmp.add(b);
  println("a.add(b) =", a_tmp,"expected: (19.0, -5.0)");
  b_tmp.add(c);
  println("b.add(c) =", b_tmp,"expected: (7.5, -11.3)");
  println();
  
    // Vec2 minus:
  println("minus tests\n***********");
  println("a.minus(b) =",a.minus(b),"expected: (5.0, 19.0)");
  println("a.minus(c) =",a.minus(c),"expected: (11.5, 6.3)");
  println();
  
  // Vec2 subtract:
  a_tmp = new Vec2(a.x,a.y);
  b_tmp = new Vec2(b.x,b.y);
  println("subtract tests\n**************");
  a_tmp.subtract(b);
  println("a.subtract(b) =", a_tmp,"expected: (5.0, 19.0)");
  b_tmp.subtract(c);
  println("b.subtract(c) =", b_tmp,"expected: (6.5, -12.7)");
  println();
  
  // Vec2 times:
  println("times tests\n***********");
  println("a.times(5) =",a.times(5),"expected: (60.0, 35.0)");
  println("b.times(0.25) =",b.times(0.25),"expected: (1.75, -3.0)");
  println();
  
  // Vec2 mul:
  a_tmp = new Vec2(a.x,a.y);
  b_tmp = new Vec2(b.x,b.y);
  println("mul tests\n*********");
  a_tmp.mul(5);
  println("a.mul(5) =",a_tmp,"expected: (60.0, 35.0)");
  b_tmp.mul(0.25);
  println("b.mul(0.25) =",b_tmp,"expected: (1.75, -3.0)");
  println();
  
  // Vec2 normalize:
  a_tmp = new Vec2(a.x,a.y);
  b_tmp = new Vec2(b.x,b.y);
  println("normalize tests\n***************");
  a_tmp.normalize();
  println("a.normalize() =",a_tmp,"expected: (0.86377895, 0.503871)");
  b_tmp.normalize();
  println("b.normalize() =",b_tmp,"expected: (0.503871, -0.86377895)");
  println();
  
  // Vec2 normalized:
  println("normalized tests\n****************");
  println("a.normalized() =",a.normalized(),"expected: (0.86377895, 0.503871)");
  println("b.normalized() =",b.normalized(),"expected: (0.503871, -0.86377895)");
  println();
  
  // Vec2 clampToLength:
  a_tmp = new Vec2(a.x,a.y);
  b_tmp = new Vec2(b.x,b.y);
  println("clampToLength tests\n*********");
  a_tmp.clampToLength(5);
  println("a.clampToLength(5) =", a_tmp,"expected: (4.318895, 2.5193553)");
  b_tmp.clampToLength(20);
  println("b.clampToLength(20) =", b_tmp,"expected: (7.0, -12.0)");
  println();
  
  // Vec2 setToLength:
  a_tmp = new Vec2(a.x,a.y);
  b_tmp = new Vec2(b.x,b.y);
  println("setToLength tests\n*********");
  a_tmp.setToLength(5);
  println("a.setToLength(2) =", a_tmp,"expected: (4.318895, 2.5193553)");
  b_tmp.setToLength(20);
  println("b.setToLength(20) =", b_tmp,"expected: (10.077421, -17.27558)");
  println();
  
  // Vec2 distanceTo:
  println("distanceTo tests\n****************");
  println("a.distanceTo(b) =",a.distanceTo(b),"expected: 19.646883");
  println("a.distanc geTo(c) =",a.distanceTo(c),"expected: 13.11259");
  println();
  
  // Vec2 interpolate:
  println("interpolate tests\n*****************");
  println("interpolate(a,b,0.5) = ",interpolate(a,b,0.5),"expected: (9.5, -2.5)");
  println("interpolate(a,c,0.2) = ",interpolate(a,c,0.5),"expected: (6.25, 3.85)");
  println();
  
  // Vec2 dot product:
  println("dot product tests\n*****************");
  println("dot(a,b) =", dot(a,b),"expected: 0.0");
  println("dot(a,c) =", dot(a,c),"expected: 10.9");
  println();
  
  // Vec2 projAB:
  println("projAB tests\n************");
  println("projAB(a,b.normalized()) =",projAB(a,b.normalized()),"expected: (0.0, 0.0)");
  println("projAB(a,c.normalized()) =",projAB(a,c.normalized()),"expected: (7.364865, 10.31081)");
  println();
}

void RunVec3Tests() {
  println("==========\nVec3 Tests\n==========");
  
  // Vec3 Constructors:
  Vec3 a = new Vec3(12,7,6);
  Vec3 b = new Vec3(7,-12,-6);
  Vec3 c = new Vec3(0.5,0.7,0.4);
  
  // Vec3 toString printing:
  println("toString tests\n**************");
  println("a =", a.toString(),"expected: (12.0, 7.0, 6.0)");
  println("b =", b.toString(),"expected: (7.0, -12.0, -6.0)");
  println("c =", c.toString(),"expected: (0.5, 0.7, 0.4)");
  println();
  
  // Vec3 length:
  println("length tests\n***********");
  println("length(a) =",a.length(),"expected: 15.132746");
  println("length(b) =",b.length(),"expected: 15.132746");
  println("length(c) =",c.length(),"expected: 0.9486833");
  println();
  
  // Vec3 lengthSqr:
  println("lengthSqr tests\n***********");
  println("lengthSqr(a) =",a.lengthSqr(),"expected: 229.0");
  println("lengthSqr(b) =",b.lengthSqr(),"expected: 229.0");
  println("lengthSqr(c) =",c.lengthSqr(),"expected: 0.90000004");
  println();
  
  // Vec3 plus:
  println("plus tests\n**********");
  println("a.plus(b) =",a.plus(b),"expected: (19.0, -5.0, 0.0)");
  println("a.plus(c) =",a.plus(c),"expected: (12.5, 7.7, 6.4)");
  println();
  
  // Vec3 add:
  Vec3 a_tmp = new Vec3(a.x,a.y, a.z);
  Vec3 b_tmp = new Vec3(b.x,b.y, b.z);
  println("add tests\n*********");
  a_tmp.add(b);
  println("a.add(b) =", a_tmp,"expected: (19.0, -5.0, 0.0)");
  b_tmp.add(c);
  println("b.add(c) =", b_tmp,"expected: (7.5, -11.3, -5.6)");
  println();
  
  // Vec3 minus:
  println("minus tests\n***********");
  println("a.minus(b) =",a.minus(b),"expected: (5.0, 19.0, 12.0)");
  println("a.minus(c) =",a.minus(c),"expected: (11.5, 6.3, 5.6)");
  println();
  
  // Vec3 subtract:
  a_tmp = new Vec3(a.x,a.y, a.z);
  b_tmp = new Vec3(b.x,b.y, b.z);
  println("subtract tests\n**************");
  a_tmp.subtract(b);
  println("a.subtract(b) =", a_tmp,"expected: (5.0, 19.0, 12.0)");
  b_tmp.subtract(c);
  println("b.subtract(c) =", b_tmp,"expected: (6.5, -12.7, -6.4)");
  println();
  
  // Vec3 times:
  println("times tests\n***********");
  println("a.times(5) =",a.times(5),"expected: (60.0, 35.0, 30.0)");
  println("b.times(0.25) =",b.times(0.25),"expected: (1.75, -3.0, -1.5)");
  println();
  
  // Vec3 mul:
  a_tmp = new Vec3(a.x,a.y, a.z);
  b_tmp = new Vec3(b.x,b.y, b.z);
  println("mul tests\n*********");
  a_tmp.mul(5);
  println("a.mul(5) =",a_tmp,"expected: (60.0, 35.0, 30.0)");
  b_tmp.mul(0.25);
  println("b.mul(0.25) =",b_tmp,"expected: (1.75, -3.0, -1.5)");
  println();
  
  // Vec3 normalize:
  a_tmp = new Vec3(a.x,a.y, a.z);
  b_tmp = new Vec3(b.x,b.y, b.z);
  println("normalize tests\n***************");
  a_tmp.normalize();
  println("a.normalize() =",a_tmp,"expected: (0.79298234, 0.46257302, 0.39649117)");
  b_tmp.normalize();
  println("b.normalize() =",b_tmp,"expected: (0.46257302, -0.79298234, -0.39649117)");
  println();
  
  // Vec3 normalized:
  println("normalized tests\n****************");
  println("a.normalized() =",a.normalized(),"expected: (0.79298234, 0.46257302, 0.39649117)");
  println("b.normalized() =",b.normalized(),"expected: (0.46257302, -0.79298234, -0.39649117)");
  println();
  
  
  // Vec3 clampToLength:
  a_tmp = new Vec3(a.x,a.y,a.z);
  b_tmp = new Vec3(b.x,b.y,b.z);
  println("clampToLength tests\n*********");
  a_tmp.clampToLength(5);
  println("a.clampToLength(2) =", a_tmp,"expected: (3.964912, 2.3128653, 1.982456) ");
  b_tmp.clampToLength(20);
  println("b.clampToLength(10) =", b_tmp,"expected: (7.0, -12.0, -6.0)");
  println();
  
  // Vec3 setToLength:
  a_tmp = new Vec3(a.x,a.y,a.z);
  b_tmp = new Vec3(b.x,b.y,b.z);
  println("setToLength tests\n*********");
  a_tmp.setToLength(5);
  println("a.setToLength(2) =", a_tmp,"expected: (3.964912, 2.3128653, 1.982456) ");
  b_tmp.setToLength(20);
  println("b.setToLength(20) =", b_tmp,"expected: (9.251461, -15.859648, -7.929824) ");
  println();
  
  // Vec3 distanceTo:
  println("distanceTo tests\n****************");
  println("a.distanceTo(b) =",a.distanceTo(b),"expected: 23.021729");
  println("a.distanceTo(c) =",a.distanceTo(c),"expected: 14.258331");
  println();
  
  // Vec3 interpolate:
  println("interpolate tests\n*****************");
  println("interpolate(a,b,0.5) = ",interpolate(a,b,0.5),"expected: (9.5, -2.5, 0.0)");
  println("interpolate(a,c,0.2) = ",interpolate(a,c,0.5),"expected: (6.25, 3.85, 3.2)");
  println();
  
  // Vec3 dot product:
  println("dot product tests\n*****************");
  println("dot(a,b) =", dot(a,b),"expected: -36.0");
  println("dot(a,c) =", dot(a,c),"expected: 13.299999");
  println();
  
  // Vec3 cross product:
  println("cross product tests\n*******************");
  println("cross(a,b) =",cross(a,b),"expected: (30.0, 114.0, -193.0)");
  println("cross(a,c) =",cross(a,c),"expected: (-1.3999999, -1.8000002, 4.8999996)");
  println();
  
  // Vec3 projAB:
  println("projAB tests\n************");
  println("projAB(a,b) =",projAB(a,b.normalized()),"expected: (-1.1004369, 1.8864634, 0.9432317)");
  println("projAB(a,c) =",projAB(a,c.normalized()),"expected: (7.388889, 10.344443, 5.9111114)");
  println();
}

void setup(){
  // Test code for homework 1.
  
  // Vec2 Tests:
  RunVec2Tests();
  
  // Vec3 Tests:
  RunVec3Tests();
}
