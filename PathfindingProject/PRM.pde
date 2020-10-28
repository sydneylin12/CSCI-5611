import java.util.*;
//You will only be turning in this file
//Your solution will be graded based on it's runtime (smaller is better), 
//the optimality of the path you return (shorter is better), and the
//number of collisions along the path (it should be 0 in all cases).

// NOTE: b/c dijkstras calculates shortest path for ALL paths, the runtime isn't that great

//You must provide a function with the following prototype:
// ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes);
// Where: 
//    -startPos and goalPos are 2D start and goal positions
//    -centers and radii are arrays specifying the center and radius
//    -numObstacles specifies the number of obstacles
//    -nodePos is an array specifying the 2D position of roadmap nodes
//    -numNodes specifies the number of obstacles
// The function should return an ArrayList of node IDs (indexes into the nodePos array).
// This should provide a collision-free chain of direct paths from the start position
// to the position of each node, and finally to the goal position.
// If there is no collision-free path between the start and goal, return an ArrayList with
// the 0'th element of "-1".

// Your code can safely make the following assumptions:
//   - The function connectNeighbors() will always be called before planPath()
//   - The variable maxNumNodes has been defined as a large static int, and it will
//     always be bigger than the numNodes variable passed into planPath()
//   - None of the positions in the nodePos array will ever be inside an obstacle
//   - The start and the goal position will never be inside an obstacle

// There are many useful functions in CollisionLibrary.pde and Vec2.pde
// which you can draw on in your implementation. Please add any additional 
// functionality you need to this file (PRM.pde) for compatabilty reasons.

// Here we provide a simple PRM implementation to get you started.
// Be warned, this version has several important limitations.
// For example, it uses BFS which will not provide the shortest path.
// Also, it (wrongly) assumes the nodes closest to the start and goal
// are the best nodes to start/end on your path on. Be sure to fix 
// these and other issues as you work on this assignment. This file is
// intended to illustrate the basic set-up for the assignmtent, don't assume 
// this example funcationality is correct and end up copying it's mistakes!).



//Here, we represent our graph structure as a neighbor list
//You can use any graph representation you like
ArrayList<Integer>[] neighbors = new ArrayList[maxNumNodes];  //A list of neighbors can can be reached from a given node

//Set which nodes are connected to which neighbors (graph edges) based on PRM rules
void connectNeighbors(Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[i], dir, distBetween);
      if (!circleListCheck.hit){
        neighbors[i].add(j);
      }
    }
  }
}

//This is probably a bad idea and you shouldn't use it...
int closestNode(Vec2 point, Vec2[] nodePos, int numNodes){
  int closestID = -1;
  float minDist = 999999;
  for (int i = 0; i < numNodes; i++){
    float dist = nodePos[i].distanceTo(point);
    if (dist < minDist){
      closestID = i;
      minDist = dist;
    }
  }
  return closestID;
}

// TODO: this entire function
ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  ArrayList<Integer> path = new ArrayList();
  int startID = closestNode(startPos, nodePos, numNodes);
  int goalID = closestNode(goalPos, nodePos, numNodes);  
  ArrayList<Integer> a = aStar(nodePos, numNodes, centers, radii, startID, goalID);
  ArrayList<Integer> b = path = dijkstra(nodePos, numNodes, centers, radii, startID, goalID);
  
  System.out.println("A-star Path: " + a.toString());
  System.out.println("Dijkstra Path: " + b.toString());
  
  return a;
}

/**
* Dijkstra's algorithm implementation
* @param nodePos, position of all nodes in Vector 2D form
* @param numNodes, the number of vertices/nodes in the graph
* @param startID, source node
* @param goalID, end node
*/
ArrayList<Integer> dijkstra(Vec2[] nodePos, int numNodes, Vec2[] centers, float[] radii, int startID, int goalID){
  // Shortest distance of all nodes
  int[] distance = new int[numNodes];
  // Is node visited?
  boolean[] spt = new boolean[numNodes];
  // Parent of shortest edge btwn nodes
  int[] predecessor = new int[numNodes];
  
  // Initialize the distance to all MAX
  Arrays.fill(distance, Integer.MAX_VALUE);
  
  // Starting here, start has no parent
  distance[startID] = 0;
  predecessor[startID] = -1;
  
  // Iterate through all vertices
  for(int i = 0; i < numNodes - 1; i++){
    // Get shortest/min vertex, u, also distance[start] = 0 initially
    int u = getMinDistance(distance, spt);
    
    boolean firstCheck = pointInCircleList(centers, radii, 100, nodePos[startID]);
    boolean lastCheck = pointInCircleList(centers, radii, 100, nodePos[goalID]);
    
    if(u == -1 || firstCheck || lastCheck){ // Edge case
      ArrayList<Integer> invalid = new ArrayList();
      invalid.add(-1);
      return invalid;
    }

    spt[u] = true; // Mark as visited
    
    // Get adjacency list of vertex u
    ArrayList<Integer> adj = neighbors[u];

    // Go through each adj to u, and update the adjacent distances if applicable
    for(int v : adj){
      int d = (int) nodePos[u].distanceTo(nodePos[v]);
      // If not visited, and current distance + edge distance is less than what we have already
      Vec2 dir = nodePos[v].minus(nodePos[u]).normalized();
      hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[i], dir, d);
      
      if(!spt[v] && distance[u] + d < distance[v] && !circleListCheck.hit){
        // Update distance AND parent
        distance[v] = distance[u] + d;
        predecessor[v] = u;
      }
    }
  }
  return buildPath(startID, goalID, distance, predecessor);
}

/**
* Helper func to find vertex with shortest distance value given distance array and shortest path tree set
* @param distance, array of distance values
* @param spt, the shortest path set of the graph
* @return index of minimum distance value
*/
int getMinDistance(int[] distance, boolean[] spt){
  int min = Integer.MAX_VALUE;
  int mindex = -1;
  for(int i = 0; i < distance.length; i++){
    if(!spt[i] && distance[i] < min){
      min = distance[i];
      mindex = i;
    }
  }
  return mindex;
}

/**
* Returns ArrayList of the shortest path
* @param startID, starting node
* @param endID, ending node
* @param predecessor, the array of parent nodes
* @return ArrayList containing full path
*/
ArrayList<Integer> buildPath(int startID, int goalID, int[] distance, int[] predecessor){
  ArrayList<Integer> res = new ArrayList();
  if(goalID != startID){
    String path = printPath(new StringBuilder(), goalID, predecessor);
    // Trim off excess whitespace (char 0), then split it into an array, then turn it into an arraylist
    String[] arr = path.substring(1).split(" ");
    for(String s : arr) res.add(Integer.parseInt(s));
  }
  res.add(0, startID);
  System.out.println("START: " + startID + " GOAL: " + goalID + " path: " + res.toString());
  return res;
}

/**
* Returns String representing path with a recursive helper
* @param sb, the StringBuilder containing the path
* @param u, current node
* @param predecessor, the array of parent nodes
* @return recursively built string of the path
*/
String printPath(StringBuilder sb, int u, int[] predecessor){
  if(u == -1 || predecessor[u] == -1) return "";
  printPath(sb, predecessor[u], predecessor);
  sb.append(" ");
  sb.append(u);
  return sb.toString();
}
