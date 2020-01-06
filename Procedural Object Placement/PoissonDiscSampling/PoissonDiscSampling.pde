float radius;
PVector sampleRegionSize;
void setup() {
  size(1080, 720);
  sampleRegionSize = new PVector(width, height);

  radius = 150;
}

void draw() {
}

ArrayList GeneratePoints(float radius, PVector sampleRegionSize, int numSamplesBeforeRejection = 30) {
  float cellSize = pow(radius, 0.5);
  int x = ceil(width/cellSize);
  int y = ceil(height/cellSize);
  int[][] grid = new int[x][y];
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<PVector> spawnPoints = new ArrayList<PVector>();

  spawnPoints.add(sampleRegionSize.div(2));
  
  while(spawnPoints.size() > 0){
    int spawnIndex = int(random(spawnPoints.size()));
    PVector spawnCentre = spawnPoints.get(spawnIndex);
    boolean candidateAccepted = false;
    for (int i =0; i < numSamplesBeforeRejection; i++){
      PVector candidate = spawnCentre.add(PVector.random2D().mult(random(radius, 2*radius)));
      //to accept candidate
      if(isValid(candidate, sampleRegionSize, cellSize, radius, points, grid)){
        points.add(candidate);
        spawnPoints.add(candidate);
        grid[int(candidate.x/cellSize)][int(candidate.y/cellSize)] = points.size();
        candidateAccepted = true;
        break;
      }
      if(!candidateAccepted){
      spawnPoints.remove(spawnIndex);
        }
    }
    return points;
    
  }
  
  boolean isValid(PVector candidate, PVector sampleRegionSize, float cellSize, ArrayList<Vector> points, int[][] grid){
    if ((candidate.x >= 0) && (candidate.x < sampleRegionSize.x) && (candidate.y >= 0) && (candidate.y < sampleRegionSize.y)){
      int cellX = int(candidate.x/cellSize);
      int cellY = int(candidate.y/cellSize);
      int searchStartX = max(0,cellX-2);
      int searchEndX = min(cellX+2, grid[0].length-1);
      int searchStartY = max(0,cellY-2);
      int searchEndY = min(cellY+2, grid[1].length-1);
      
      //looping
      for(int x = searchStartX; x <= searchEndX; x++){
        for(int y = searchStartY; y <= searchEndY; y++){
          int pointIndex = grid[x][y] -1;
          if (pointIndex != -1){
            float sqrDst = (candidate.sub(points.get(pointIndex))).magSq();
            if (sqrDst < pow(radius,2)){
              return false;
            }
          }
        }
      }
    }
  }
}
