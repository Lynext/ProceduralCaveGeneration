int[][] currentMap;
int[][] nextMap;
boolean transformActive = false;
int numberOfSteps = 0;
int birthLimit = 4;
int deathLimit = 3;
int cellWidth = 10, cellHeight = 10;
int transformationStep = 0;
int gen = 0;
float startUp = 0;

float chanceToStartAlive = 0.45f;
public int[][] initialiseMap(int[][] map)
{
    for(int x = 0; x < width / cellWidth; x++)
    {
        for(int y = 0; y < height / cellHeight; y++)
        {
            if(random(1.0) < chanceToStartAlive)
            {
                map[x][y] = 1;
            }
        }
    }
    return map;
}

public int countAliveNeighbours(int[][] map, int x, int y){
    int count = 0;
    for(int i = -1; i < 2; i++)
    {
        for(int j = -1; j < 2; j++)
        {
            int nx = x + i;
            int ny = y + j;

            if(i == 0 && j == 0)
            {
               continue;
            }
            
            if(nx < 0 || ny < 0 || nx >= map.length || ny >= map[0].length)
            {
                count = count + 1;
            }
            
            else if(map[nx][ny] >= 1)
            {
                count = count + 1;
            }
        }
    }
    return count;
}



public int[][] generateMap(int[][] map)
{
    map = initialiseMap(map);
    for(int i = 1; i <= numberOfSteps; i++)
    {
        map = doSimulationStep(map);
    }
    return map;
}

public void setMap (int[][] toSet, int[][] oldMap)
{
  for(int x = 0; x < width / cellWidth; x++)
    {
        for(int y = 0; y < height / cellHeight; y++)
        {
           if (oldMap[x][y] >= 1)
             toSet[x][y] = 1;
           else
             toSet[x][y] = 0;
        }
    }
}


public int[][] doSimulationStep(int[][] oldMap)
{
    int[][] newMap = new int[width / cellWidth][height / cellHeight];

    for(int x = 0; x < width / cellWidth; x++)
    {
        for(int y = 0; y < height / cellHeight; y++)
        {
            int anc = countAliveNeighbours(oldMap, x, y);
            if(oldMap[x][y] >= 1)
            {
                if(anc < deathLimit)
                {
                    newMap[x][y] = -2;
                }
                else
                {
                    newMap[x][y] = 1;
                }
            }
            else
            {
                if(anc > birthLimit)
                {
                    newMap[x][y] = 2;
                }
                else
                {
                    newMap[x][y] = 0;
                }
            }
        }
    }
    return newMap;
}


public void setup() 
{
  size(1280, 720, P2D);
  noStroke();
  frameRate(60);
  currentMap = generateMap(new int[width / cellWidth][height / cellHeight]);
  nextMap = doSimulationStep(currentMap);
}

public void transformMap (int i)
{
  int x = i / (height / cellWidth);
  int y = i % (height / cellWidth);
  currentMap[x][y] = nextMap[x][y];
}
  
public void draw() 
{
    startUp += 1f / frameRate;
    if (startUp >= 3)
      transformActive = true;
  
    background(51,85,120);

    for (int x = 0; x < width / cellWidth; x++)
    {
      for (int y = 0; y < height / cellHeight; y++)
      {
        if (currentMap[x][y] == 1)
        {
          fill(68,51,51);
          stroke(68,51,51);
          rect(x * cellWidth,y * cellHeight,cellWidth,cellHeight);
        }
        else if (currentMap[x][y] == 2)
        {
          fill(68 + 100,51 + 100,51 + 100);
          stroke(68 + 100,51 + 100,51 + 100);
          rect(x * cellWidth,y * cellHeight,cellWidth,cellHeight);
        }
        else if (currentMap[x][y] == -2)
        {
          //fill(51 - 30,85 - 30,120 - 30);
          //stroke(51 - 30,85 - 30,120 - 30);
          fill(50,0,0);
          stroke(50,0,0);
          rect(x * cellWidth,y * cellHeight,cellWidth,cellHeight);
        }
      }
    }
    if (transformActive)
    {
      for (int i = 1; i <= 32; i++)
      {
        if (transformationStep < (width / cellWidth) * (height / cellHeight))
        {
          transformMap(transformationStep);
          transformationStep++;
        }
        else
        {
         gen++;
         setMap(currentMap,nextMap);
         transformationStep = 0;
         nextMap = doSimulationStep(currentMap);
        }
      }
  }
    fill(255);
    textSize(16);
    text("FPS : " + frameRate,24,36);
    text("Gen : " + gen,24,72);
}
