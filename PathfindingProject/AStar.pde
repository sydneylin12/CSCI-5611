/**
* A-star algorithm 
*/
import java.util.*;

// Distance/heuristic/total values
float[] f;
float[] g;
float[] h;

/**
* The A* informed search algorithm
* @param nodePos the position of nodes array
* @param numNodes total number of nodes
* @param centers the array of obstacle centers
* @param radii the array of obstacle radii
* @param startID id/index of start node
* @param goalID id/index of end node
* @param startPos the starting (blue circle) position
* @param goalPos the ending (red circle) position
*/
ArrayList<Integer> aStar(Vec2[] nodePos, int numNodes, Vec2[] centers, float[] radii, int startID, int goalID, Vec2 startPos, Vec2 goalPos){
  ArrayList<Integer> res = new ArrayList<Integer>();
  Vec2 goal = nodePos[goalID];
  int[] parent = new int[numNodes];
  boolean[] visited = new boolean[numNodes];
    
  // No path b/c of an intersection of start or end node
  boolean startIsBad = pointInCircleList(centers, radii, numObstacles, startPos); 
  boolean endIsBad = pointInCircleList(centers, radii, numObstacles, goalPos); 
  if(startIsBad || endIsBad){
    System.out.println("Start or end node position was invalid.");
    res.add(-1);
    return res;
  }
    
  // Arrays for the values
  g = new float[maxNumNodes];
  h = new float[maxNumNodes];
  f = new float[maxNumNodes];
  
  Arrays.fill(parent, -1);
  Arrays.fill(g, Integer.MAX_VALUE);
  Arrays.fill(f, Integer.MAX_VALUE);
  
  // Fill up our arrays
  for(int i = 0; i < numNodes; i++){
    h[i] = nodePos[i].distanceTo(goal);
  } 
  
  // Create the "fringe"
  PriorityQueue<Integer> pq = new PriorityQueue<Integer>(new Comparator<Integer>(){
    public int compare(Integer a, Integer b){
      return (int)(f[a] - f[b]); 
    }
  });
  
  // Initial starting point
  visited[startID] = true;
  g[startID] = 0;
  f[startID] = g[startID] + h[startID]; // Pretty much adding 0 here
  pq.offer(startID);
    
  // Keep searching until there are no options left
  while(!pq.isEmpty()){
    int node = pq.poll();
    if(node == goalID) break;
    
    // Go through each adjacent node
    for(int adj : neighbors[node]){
      Vec2 dir = nodePos[adj].minus(nodePos[node]).normalized();
      float d = nodePos[node].distanceTo(nodePos[adj]);
      float tempG = g[node] + d;
      
      // Check the collisions
      hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[node], dir, d);
      // Update lowest g-score
      if(tempG < g[adj] && !circleListCheck.hit){
        visited[adj] = true; // Add to closed list
        parent[adj] = node; 
        g[adj] = tempG;
        f[adj] = g[adj] + h[adj];
        // Add to PQ if not already there
        if(!pq.contains(adj)) pq.offer(adj);
      }
    }
  }
  
  // No path - taken from starter code
  if(pq.isEmpty()){
    System.out.println("No path was found from A-star.");
    res.add(0,-1);
    return res;
  }
  
  // Construct path here in revesre
  int prev = parent[goalID];
  while(prev >= 0){
    res.add(0, prev);
    prev = parent[prev];
  }
  return res;
}


/**
* Makes a purple triangle travel from start to goal pos
* Also adjusts the orientation of the triangle
*/
float dt = 0.1;
Vec2 travel(Vec2 startPos, Vec2 goalPos, Vec2[] nodePos, ArrayList<Integer> path){
  fill(255,0,255);
  Vec2 curr = startPos;
  Vec2 dir = goalPos.minus(curr);
  curr = curr.plus(dir.times(dt));
  float theta = (float) Math.atan2(dir.y, dir.x);
  pushMatrix();
  translate(curr.x, curr.y);
  // Rotate the triangle in a certain way
  rotate(theta + radians(270));
  triangle(-5, 0, 0, 20, 5, 0);
  popMatrix();  
  return curr;
}
