boolean[][] currentMap;
boolean[][] nextMap;
float chanceToStartAlive = 0.45f;
int numberOfSteps = 6;
int birthLimit = 4;
int deathLimit = 3;
int rectWidth = 10, rectHeight = 10;
int transformationStep = 0;

public boolean[][] initialiseMap(boolean[][] map)
{
    for(int x = 0; x < width / rectWidth; x++)
    {
        for(int y = 0; y < height / rectHeight; y++)
        {
            if(random(1.0) < chanceToStartAlive)
            {
                map[x][y] = true;
            }
        }
    }
    return map;
}

public int countAliveNeighbours(boolean[][] map, int x, int y){
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
            
            else if(map[nx][ny])
            {
                count = count + 1;
            }
        }
    }
    return count;
}



public boolean[][] generateMap(boolean[][] map)
{
    map = initialiseMap(map);
    for(int i = 1; i <= numberOfSteps; i++)
    {
        map = doSimulationStep(map);
    }
    return map;
}


public boolean[][] doSimulationStep(boolean[][] oldMap){
    boolean[][] newMap = new boolean[width / rectWidth][height / rectHeight];

    for(int x = 0; x < width / rectWidth; x++)
    {
        for(int y = 0; y < height / rectHeight; y++)
        {
            int nbs = countAliveNeighbours(oldMap, x, y);
            if(oldMap[x][y])
            {
                if(nbs < deathLimit)
                {
                    newMap[x][y] = false;
                }
                else
                {
                    newMap[x][y] = true;
                }
            }
            else
            {
                if(nbs > birthLimit)
                {
                    newMap[x][y] = true;
                }
                else
                {
                    newMap[x][y] = false;
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
  frameRate(240);
  currentMap = generateMap(new boolean[width / rectWidth][height / rectHeight]);
  nextMap = generateMap(new boolean[width / rectWidth][height / rectHeight]);
}

public void transformMap (int i)
{
  int x = i / (height / rectWidth);
  int y = i % (height / rectWidth);
  currentMap[x][y] = nextMap[x][y];
}
  
public void draw() 
{
    background(51,85,120);

    fill(68,51,51);
    for (int x = 0; x < width / rectWidth; x++)
    {
      for (int y = 0; y < height / rectHeight; y++)
      {
        if (currentMap[x][y] == true)
        {
          rect(x * rectWidth,y * rectHeight,rectWidth,rectHeight);
        }
      }
    }
    if (transformationStep < (width / rectWidth) * (height / rectWidth))
    {
      for (int i = 1; i <= 20; i++)
      {
        if (transformationStep >= (width / rectWidth) * (height / rectWidth))
        {
          break; 
        }
        transformMap(transformationStep);
        transformationStep++;
      }  
    }
    else
    {
      nextMap = generateMap(new boolean[width / rectWidth][height / rectHeight]);
      transformationStep = 0;
    }
    fill(255);
    textSize(16);
    text("FPS : " + frameRate,24,36);
}
