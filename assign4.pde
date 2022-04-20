PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float [] cabbageX = new float [6];float [] cabbageY = new float [6];
float [] soldierX = new float [6];float [] soldierY = new float [6];
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");

  // Load soil images used in assign3 if you don't plan to finish requirement #6
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");

  // Load PImage[][] soils
  soils = new PImage[6][5];
  for(int i = 0; i < soils.length; i++){
    for(int j = 0; j < soils[i].length; j++){
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  // Load PImage[][] stones
  stones = new PImage[2][5];
  for(int i = 0; i < stones.length; i++){
    for(int j = 0; j < stones[i].length; j++){
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  // Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  // Initialize soilHealth
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;
    }
  }
   
   //soilHeaith[][]
   
    for(int i=0;i<8;i++){
      soilHealth[i][i]=30 ;
    }
     
    for(int b=10;b<18;b++){
      for(int a=0;a<10;a++){         
      if(floor((b+1)/2)%2==0){
      if(a-1<8&&a-1>=0){if(floor(a/2)%2==0){soilHealth[a-1][b-2]=30;}}}      
      else{if(floor(a/2)%2==0 ){if(a+1<8){soilHealth[a+1][b-2]=30;}}}
    }
    }

    for(int a=0;a<8;a++){
    for(int b=0;b<8;b++){
     if((a+b)%3==1){soilHealth[a][b+16]=30;}
     if((a+b)%3==2){soilHealth[a][b+16]=45;}
    }
    }
 
    for(int j=1;j<SOIL_ROW_COUNT;j++){
    int count = 1+int(random(2));
    int lastCol=-1, lastRow=-1;
    for(int i=0;i<count;i++){
      int col = int(random(8));
      int row =j;
      if(lastCol == col && lastRow == row){
          i--;}
          else{soilHealth[col][j]=0;}
    }  
    }
 
 
    for(int b=0;b<6;b++){
      cabbageX[b]=int(random(8))*80;
      cabbageY[b]=(int(random(4))+4*b)*80;
    }

    for(int a=0;a<6;a++){
      soldierX[a]=int(random(8))*80;
      soldierY[a]=(int(random(4))+4*a)*80;
    }
  }


void draw() {

  switch (gameState) {

    case GAME_START: 
    image(title, 0, 0);
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }

    }else{

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);

    }

    break;

    case GAME_RUN: // In-Game
    
    image(bg, 0, 0);

    
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);

      
    pushMatrix();
    translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

    

    fill(124, 204, 25);
    noStroke();
    rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);


    for(int i = 0; i < soilHealth.length; i++){
      for (int j = 0; j < soilHealth[i].length; j++) {

        int areaIndex = floor(j / 4);
  if(soilHealth[i][j]>0)image(soils[areaIndex][int((constrain(soilHealth[i][j],0,15)-1)/3)], i * SOIL_SIZE, j * SOIL_SIZE);
        if(soilHealth[i][j]>15){
        image(stones[0][int((constrain(soilHealth[i][j],0,30)-16)/3)],i * SOIL_SIZE, j * SOIL_SIZE);
      }
      
        if(soilHealth[i][j]>30){
        image(stones[1][int((soilHealth[i][j]-31)/3)],i * SOIL_SIZE, j * SOIL_SIZE);
      }
        if(soilHealth[i][j]<=0){
        image(soilEmpty,i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }
    }

    for(int i=0;i<6;i++){
      image(cabbage,cabbageX[i],cabbageY[i]);
      if(playerX<cabbageX[i]+80&&playerX+80>cabbageX[i]&&playerY+80>cabbageY[i]&&playerY<cabbageY[i]+80){
      if(playerHealth<5){
        cabbageX[i]+=640;
        playerHealth++;
      }
      }
    }

    

    PImage groundhogDisplay = groundhogIdle;

    if(playerMoveTimer == 0){
      if(playerRow<23&&soilHealth[playerCol][playerRow+1]<=0){
          playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;      
      }

      if(leftState){
        groundhogDisplay = groundhogLeft;
        if(playerCol > 0){
          if(playerRow>=0&&soilHealth[playerCol-1][playerRow]>0){
          soilHealth[playerCol-1][playerRow]--;
          }
          else{
          playerMoveDirection = LEFT;
          playerMoveTimer = playerMoveDuration;
          }
        }

      }else if(rightState){
        groundhogDisplay = groundhogRight;
        if(playerCol < SOIL_COL_COUNT - 1){
          if(playerRow>=0&&soilHealth[playerCol+1][playerRow]>0){
          soilHealth[playerCol+1][playerRow]--;
          }
          else{
          playerMoveDirection = RIGHT;
          playerMoveTimer = playerMoveDuration;
          }
        }

      }else if(downState){

        groundhogDisplay = groundhogDown;
        if(playerRow < SOIL_ROW_COUNT - 1){
          soilHealth[playerCol][playerRow+1]--;
        }
      }

    }
    
    if(playerMoveTimer > 0){

      playerMoveTimer --;
      switch(playerMoveDirection){

        case LEFT:
        groundhogDisplay = groundhogLeft;
        if(playerMoveTimer == 0){
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }
        break;

        case RIGHT:
        groundhogDisplay = groundhogRight;
        if(playerMoveTimer == 0){
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

        case DOWN:
        groundhogDisplay = groundhogDown;
        if(playerMoveTimer == 0){
          playerRow++;
          playerY = SOIL_SIZE * playerRow;
        }else{
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }

    }

    image(groundhogDisplay, playerX, playerY);
    for(int i=0;i<6;i++){
      soldierX[i]+=soldierSpeed;
      if(soldierX[i]>width){soldierX[i]=-80;
    }
      image(soldier,soldierX[i],soldierY[i]);
      
      if(playerX<soldierX[i]+soldier.width&&playerX+groundhogIdle.width>soldierX[i]&&playerY+groundhogDown.height>soldierY[i]&&playerY<soldierY[i]+soldier.height){      
      
      
      playerX = PLAYER_INIT_X;
      playerY = PLAYER_INIT_Y;
      playerCol = (int) (playerX / 80);
      playerRow = (int) (playerY / 80);
      playerMoveTimer = 0;
      playerHealth--;    
      soilHealth[4][0]=15;
      }
    }

    if(demoMode){  

      fill(255);
      textSize(26);
      textAlign(LEFT, TOP);

      for(int i = 0; i < soilHealth.length; i++){
        for(int j = 0; j < soilHealth[i].length; j++){
          text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }

    }

    popMatrix();

    // Health UI
      for(int i=0;i<playerHealth;i++){
      image(life,10+(life.width+20)*i,10);
      }
 
    if(playerHealth<=0){
    gameState=GAME_OVER;
    }
    break;

    case GAME_OVER:
    image(gameover, 0, 0);
    
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;

        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth = 2;

        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {
            soilHealth[i][j] = 15;
          }
        }
   
    for(int i=0;i<8;i++){
      soilHealth[i][i]=30 ;
    }
    
    for(int y=10;y<18;y++){
      for(int x=0;x<10;x++){         
      if(floor((y+1)/2)%2==0){
      if(x-1<8&&x-1>=0){if(floor(x/2)%2==0){soilHealth[x-1][y-2]=30;}}}      
      else{if(floor(x/2)%2==0 ){if(x+1<8){soilHealth[x+1][y-2]=30;}}}
    }
    }
    
    for(int x=0;x<8;x++){
    for(int y=0;y<8;y++){
     if((x+y)%3==1){soilHealth[x][y+16]=30;}
     if((x+y)%3==2){soilHealth[x][y+16]=45;}
    }
    }

    for(int j=1;j<SOIL_ROW_COUNT;j++){
    int count = 1+int(random(2));
    int lastCol=-1, lastRow=-1;
    for(int i=0;i<count;i++){
      int col = int(random(8));
      int row =j;
      if(lastCol == col && lastRow == row){
          i--;}
          else{soilHealth[col][j]=0;}
    }  
    }
        // Initialize soidiers and their position
        for(int j=0;j<6;j++){
          soldierX[j]=int(random(8))*SOIL_SIZE;
          soldierY[j]=(int(random(4))+4*j)*SOIL_SIZE;
        }
        // Initialize cabbages and their position
        for(int j=0;j<6;j++){
          cabbageX[j]=int(random(8))*SOIL_SIZE;
          cabbageY[j]=(int(random(4))+4*j)*SOIL_SIZE;
        }        
      }

    }else{

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

    }
    break;
    
  }
}

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = true;
      break;
      case RIGHT:
      rightState = true;
      break;
      case DOWN:
      downState = true;
      break;
    }
  }else{
    if(key=='b'){
      demoMode = !demoMode;
    }
  }
}


void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = false;
      break;
      case RIGHT:
      rightState = false;
      break;
      case DOWN:
      downState = false;
      break;
    }
  }
}
