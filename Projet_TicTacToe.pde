/* MOUFFOK Tayeb Abderraouf |  MIV  |  Groupe 2  |  rafainiestaretro@gmail.com  */

/* ##################################   GLOBAL VARIABLES   ###################################### */

final int NB_CASE = 3;       // Number of cases
  
int[][] grid = new int[NB_CASE][NB_CASE];     // contains moves played  * 0 -> void  *  1 -> player1  *  2 -> player2

/* Grid will look like this :      {{0,0,0},        
                                    {0,0,0}, 
                                    {0,0,0}};     */
                                                
                
boolean over = false;  // True when game is over, False else
boolean started = false;     // True when the game started,  False else
boolean menu;    // True when Menu open, else False
boolean turn_choice_view;   // True when Turn Choice window is open, else False
boolean ai_mode; // True when AI_Mode enabled, else False
                
boolean player1_choice;   // True when Player1 chooses to play with X,   False if Player1 chooses to play with O
boolean starting_turn = true;    // Player1 begins first when True,    Player2/AI begins when False,    switched after each game 
boolean turn;   // turn = true -> Player 1 turn    ---      turn = false -> Player 2 turn

boolean show_help = false;      //  True when Help activated,  False else
boolean show_scores = true;   // Displays scores and turn when True, doesnt when False   --  Press 's' during a game to change it
boolean ai_turn = false;      // True when AI turn to play, else False

int p1wins, draws, p2wins;   // variables that will contains scores
int AI_DELAY=500;  // AI delay to play its turn - in milliseconds 

HashMap<Integer, Integer> rewards = new HashMap<Integer, Integer>();    // will contain the rewards for the minimax function

void setup(){
  size(512, 512);
  
  // set the rewards
  rewards.put(2, 10);     // reward = 10 when AI wins
  rewards.put(1, -10);    // reward = -10 when Player wins
  rewards.put(0, 0);      // reward = 0 when Tie
  
  //open_turn_choice();
  open_menu();
}


void draw(){
    if(ai_turn){
        delay(AI_DELAY);
        AI_Turn();
        ai_turn = false;
    }
}

/* ##################################   DRAWING FUNCTIONS   ###################################### */

void open_menu(){
  /* Function that draws the Menu to let the player choose if he wants to play against another player or against AI */
  started = false;
  menu = true;
  ai_mode = false;
  p1wins = 0; p2wins = 0; draws = 0;
  
    // text part  
    int textSize = 40;
    textAlign(CENTER, CENTER);
    
        // big title part
        textSize(textSize);
        PFont font = loadFont("Dubai-Bold-60.vlw");
        textFont(font, 60);
        fill(#A7F3FF);
        background(12, 13, 59);
        text("TIC-TAC-TOE", width/2, height/8);
        
        // subtitles part
        textSize(textSize/1.5);
        font = loadFont("SegoeUI-30.vlw");
        textFont(font, 25);
        fill(#FFD6E8);
        text("Press 'A' to play against AI", width/2, height/1.2-textSize);
        fill(#E0FFD6);
        text("Press 'P' to play against a player", width/2, height/1.2);
        
        
     // shape part
      int spacing = 60;
      strokeWeight(5);
      stroke(#C4FDFF, 150);
      line(width/3, height/2.5, 2*width/3, height/2.5);
      line(width/3, height/2.5+spacing, 2*width/3, height/2.5+spacing);
      line(4*width/9, height/3.5, 4*width/9, height/3.5+3*spacing);
      line(4*width/9+spacing, height/3.5, 4*width/9+spacing, height/3.5+3*spacing);    
}


void open_turn_choice(){
  /* Function that draws the windows to let the player choose if he wants to starts to play with X or O */
  
  fill(0, 240);
  noStroke();
  rect(0,0,width,height);
  
  // big title part
        textSize(40);
        PFont font = loadFont("Dubai-Bold-60.vlw");
        textFont(font, 60);
        fill(#A7F3FF);
        //background(12, 13, 59);
        text("TIC-TAC-TOE", width/2, height/8);
  
  //fill(#156F6E, 150);
  strokeWeight(5);
  stroke(255, 100);
  noFill();
  rect(width/9,height/3,7*width/9,height/2.5+40, 30);
  turn_choice_view = true;

  // text part
    int textSize = 40;
    textAlign(CENTER, CENTER);
    
        // big title part
        textSize(textSize);
        font = loadFont("SegoeUI-BoldItalic-60.vlw");
        textFont(font, 45);
        fill(#FFE374);
        //background(12, 13, 59);
        text("Player 1", width/2, height/3+45);
        stroke(#FFE374,200);
        strokeWeight(3);
        line(width/2-textWidth("Player 1")/2, height/3+45+textSize/2, width/2+textWidth("Player 1")/2-5, height/3+45+textSize/2);
        
        // subtitles part
        textSize(textSize/1.5);
        font = loadFont("SegoeUI-27.vlw");
        textFont(font, 27);
        fill(#FFC1C2, 220);
        text("Press 'x' to play with X", width/2, height/2+45);
        fill(#C1FFFE, 220);
        text("Press 'o' to play with O", width/2, height/2+1.2*textSize+45);

}


void draw_grid(){
  /*  draws NB_CASE*NB_CASE grid  */
  int x = 0;
  int y = 0;
  
  fill(12, 13, 59);    // background color | dark blue
  stroke(255);         // lines color
  strokeWeight(5);     // lines width
  
  while(y<height){
    while(x<width){
      rect(x, y, width/NB_CASE, height/NB_CASE);
      x += width/NB_CASE;
    }
    x = 0;
    y += height/NB_CASE;
  }
}


void updateGrid(){
    /* Update the drawing following grid's state */
   
    draw_grid();

  
    int box_width = width/NB_CASE;
    int box_height = height/NB_CASE;
    
    int padding = 40;
    fill(12, 13, 59);
    
    if(player1_choice){
      for(int i=0; i<NB_CASE; i++){
          for(int j=0; j<NB_CASE; j++){
              if(grid[i][j] == 1){
                  // draw a cross
                  stroke(#FFC1C2);        // cross color
                  strokeWeight(5);           // cross width
                  line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
                  line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
                  
              }
              else{
                  if(grid[i][j] == 2){
                      // draw a circle
                      stroke(#C1FFFE);     // circle color
                      strokeWeight(5);      // circle width
                      circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
                  }
              }
          }
      }
    }
    else{
      for(int i=0; i<NB_CASE; i++){
          for(int j=0; j<NB_CASE; j++){
              if(grid[i][j] == 2){
                  // draw a cross
                  stroke(#FFC1C2);        // cross color
                  strokeWeight(5);           // cross width
                  line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
                  line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
                  
              }
              else{
                  if(grid[i][j] == 1){
                      // draw a circle
                      stroke(#C1FFFE);     // circle color
                      strokeWeight(5);      // circle width
                      circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
                  }
              }
          }
      }
    }
    
    
    
    // show Help is show_help is True
    if(ai_mode){
      if(show_help&&started&&(turn==player1_choice)){   // AI Mode
          showHelp();
      }
    }
    else{                              // 2 Players Mode
      if(show_help&&started){      
          showHelp();
      }
    }
    
    
    
    if(show_scores){
      
      // prints scores
      textAlign(CENTER, CENTER);
      PFont font = loadFont("SegoeUI-BoldItalic-15.vlw");
      textFont(font, 15);
      fill(255, 100);
      if(!player1_choice)
          fill(#C1FFFE, 100);    // blue color
        else
          fill(#FFC1C2, 100);    // pink color
      text("P1 wins : "+str(p1wins), box_width/2, height*0.96);
      fill(#FFEEAF, 100);
      text("Draws : "+str(draws), box_width+box_width/2, height*0.96);
      if(player1_choice)
          fill(#C1FFFE, 100);    // blue color
        else
          fill(#FFC1C2, 100);    // pink color
      if(ai_mode){
        text("AI wins : "+str(p2wins), 2*box_width+box_width/2, height*0.96);
        }
      else
        text("P2 wins : "+str(p2wins), 2*box_width+box_width/2, height*0.96);
        
      // prints actual turn
      if(turn==player1_choice){
        if(player1_choice)
          fill(#FFC1C2, 180);     // pink color
        else
          fill(#C1FFFE, 180);     // blue color
        text("Turn : P1", 2*box_width+box_width/2, height*0.04);
      }
      else{
         if(!player1_choice)
           fill(#FFC1C2, 180);     // pink color
         else
           fill(#C1FFFE, 180);     // blue color
           
         if(ai_mode)
           text("Turn : AI", 2*box_width+box_width/2, height*0.04);
         else
           text("Turn : P2", 2*box_width+box_width/2, height*0.04);   
      }
      
        
      font = loadFont("SegoeUI-30.vlw");
      textFont(font, 25);
    }
    
}


void showHelp(){
  /* Function that helps the player by displaying the best move possible  ---  Executed when show_help is True */
  
  if(check_winner()==-1){
        int[] bestPlayerMove = new int[2];
        if(turn==!(player1_choice)&&!(ai_mode))
            bestPlayerMove = getBestMove(2);
        else
            bestPlayerMove = getBestMove(1);
        int i = bestPlayerMove[0];
        int j = bestPlayerMove[1];
        
        int box_width = width/NB_CASE;
        int box_height = height/NB_CASE;
        
        int padding = 60;
        
        if(turn){
          // draw a cross
          stroke(255, 60);        // cross color
          strokeWeight(5);           // cross width
          line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
          line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
        }
        else{
          // draw a circle
          stroke(255,60);     // circle color
          fill(12, 13, 59);
          strokeWeight(5);      // circle width
          circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
        }
  }
}


/* ##################################   PROCESSING FUNCTIONS   ###################################### */


void initialize_grid(){
  /* Function that initialize the grid with zeros */
  for(int i=0; i<NB_CASE; i++){
      for(int j=0; j<NB_CASE; j++){
          grid[i][j] = 0;
      }
  }
}


void start_2players_mode(){
    /* Function that starts 2 players mode  ---   Executed when Player press 'P' in the menu */

    started = true; 
    turn = starting_turn;
    starting_turn = !starting_turn;     // change next game starter
    initialize_grid();
    updateGrid();
    if(show_help)
          showHelp();
}


void start_ai_mode(){
  /* Function that starts AI mode  ---  Executed when Player press 'A' in the menu after he chooses X or O*/
  
    started = true;
    turn = starting_turn;
    starting_turn = !starting_turn;
    initialize_grid();
    updateGrid();
    if(turn == !player1_choice){
      AI_Turn();
    }
    
    if(show_help)
      showHelp();
}


boolean equals3(int a, int b, int c){
  /* Function that returns True if (a = b = c)  else returns False */
    if((a == b) && (b == c))
        return true;
    else
        return false;
}



int check_winner(){
  /* Function that checks if there is a winner 
  returns
      (-1) : if game not over yet
      0 : if draw
      1 : if player 1 won
      2 : if player 2 won
  */

     // vertical
  for (int i = 0; i < 3; i++) {
    if (equals3(grid[i][0], grid[i][1], grid[i][2]) && (grid[i][0] != 0)) {
      return grid[i][0];
    }
  }
  
     // horizontal
  for (int i = 0; i < 3; i++) {
    if (equals3(grid[0][i], grid[1][i], grid[2][i]) && (grid[0][i] != 0)) {
      return grid[0][i];
    }
  }
  
    // diagonal
  if(equals3(grid[0][0], grid[1][1], grid[2][2]) && (grid[0][0] != 0))
      return grid[0][0];
  if(equals3(grid[2][0], grid[1][1], grid[0][2]) && (grid[2][0] != 0))
      return grid[2][0];
      
      
  // check if it's a draw
      for(int i=0; i<NB_CASE; i++){
        for(int j=0; j<NB_CASE; j++){
           if(grid[i][j]==0) return -1;    // game not over yet
        }
      }
      
  return 0;   // it is a draw
  
}


boolean check_if_over(){
    /* Checks if the game is over and prints the result 
    returns : 
          True if game over
          False if game not over yet
    */
    
    int winner = check_winner();
    
    if(winner == -1)   // if game not over yet
      return false;
    
    // drawing settings  
    int text_size = 50;
    fill(0, 200);
    strokeWeight(2);
    stroke(0);
    rect(0, 0, width, height);
    textSize(text_size);
    textAlign(CENTER, CENTER);
    
    // printing result
    if(winner == 1){
      // Player 1 won
        if(player1_choice)
          fill(#FFC1C2);    // pink color 
        else
          fill(#C1FFFE);    // blue color
        text("Player 1 won !", width/2, height/2);
        p1wins++;
    }
    else{
      if(winner == 2){
      // Player 2 won
        if(player1_choice)
          fill(#C1FFFE);    // blue color
        else
          fill(#FFC1C2);    // pink color 
        if(ai_mode)
          text("AI won !", width/2, height/2);
        else
          text("Player 2 won !", width/2, height/2);
        p2wins++;
      }
      else{
        if(winner == 0){
        fill(255);
        text("Tie !", width/2, height/2);
        draws++;
        }
        else
            print("Error");
      }
    }
    fill(255, 180);
    textSize(text_size/2.5);
    text("Press space bar to play again", width/2, height/2+text_size);
    textSize(text_size/3);
    fill(#C1FFCB, 150);
    text("Press 'm' to go to the menu", width/2, height - text_size/2);
    return true;
}


void mouseClicked() {
  /* Executed each time a click is made */
  
  // Find which box was clicked
  if((!over)&&(started)&&(!ai_turn)){
    int box_width = width/NB_CASE;
    int box_height = height/NB_CASE;
    
    int x = mouseX / box_width;
    int y = mouseY / box_height;
    
    boxClicked(x, y);
  }
}

void boxClicked(int x, int y){
   /* Executed each time a grid's box is clicked */
  
  // check if the box clicked is empty
  if(grid[x][y] == 0){
      if(turn==player1_choice)
          // player 1 turn
          grid[x][y] = 1;
      else
          // player 2 turn     ---    only in 2 players mode
          grid[x][y] = 2;
      
      turn = !turn;  // change turn
      show_help = false;
      updateGrid();
      over = check_if_over();
      
      
      
      if((ai_mode)&&(!over)){   // make an AI move if AI mode enabled 
        ai_turn=true;
      }
  }
}

void keyPressed(){
    /* Function executed when a keyboard key is pressed */
    
    if(menu){      // Menu open
 
        if((key=='p')||(key=='P')){  // 'P' pressed
            // launch 2 players mode
            ai_mode = false;
            print("2 Players mode\n");
            menu = false;
            open_turn_choice();
        }
        
        else{
          if((key=='a')||(key=='A')){  // 'A' pressed
            // launch AI mode
            print("AI mode\n");
            ai_mode=true;
            menu = false;
            open_turn_choice();
          }
        }
    }
    
    if(turn_choice_view){
      // Turn Choice window open
        if((key=='x')||(key=='X')){
          // Player 1 choosed to play with X
          player1_choice = true;
          starting_turn = player1_choice;
          turn_choice_view = false;
          if(ai_mode)
              start_ai_mode();
          else
              start_2players_mode();
        
        }
        else{
          if((key=='o')||(key=='O')){
            // Player 1 choosed to play with X
            player1_choice = false;
            starting_turn = player1_choice;
            turn_choice_view = false;
            if(ai_mode)
                start_ai_mode();
            else
                start_2players_mode();          
          }
          else{
            if((key=='m')||(key=='M')){
              // Go back to menu
              turn_choice_view = false;
              open_menu();
            }
          }
        }
    }
    
    if(started&&!(over)){
        if((key=='s')||(key=='S')){
            show_scores = !show_scores;
            updateGrid();
        }
        if((key=='h')||(key=='H')){
            show_help = true;
            if(ai_mode)
              showHelp();
            updateGrid();
        }
    }
  
  
    if(over){    // Game over
        if(key==' '){
          // the player pressed space to play again
          over = false;
          if(ai_mode)
              start_ai_mode();
          else
              start_2players_mode();
        }
        
        if((key=='m')||(key=='M')){
          // the player pressed 'm' to get back to the menu
            over = false;
            open_menu();
        }
          
    }
}




/* ######################################     AI    PART    ############################################# */

void AI_Turn(){
  /* Function executed when it is AI turn to play */
        makeBestMove();             // call the function to search and make the best move
        turn = !turn;               // change turn
        updateGrid();              // update the drawing
        over = check_if_over();     // check if game is over
}

void makeBestMove(){
  int[] bestMove = new int[2];
  bestMove = getBestMove(2);
  grid[bestMove[0]][bestMove[1]] = 2;      // make the best move
}

int[] getBestMove(int maximizer) {
  /* Function that searches and make the best move possible using minmax */
  // AI to make its turn
  int bestReward = (int) Double.NEGATIVE_INFINITY;      // initialize bestReward to -infinity

  int[] bestMove = new int[2];   // will contain the best move
  
  // iterate through all boxes
  for(int i = 0; i<NB_CASE; i++){
    for (int j = 0; j<NB_CASE; j++){

      // check if the box is empty
      if (grid[i][j] == 0) {
        grid[i][j] = maximizer;                    // made this move to test it
        int reward = minimax(false, maximizer);        // get the reward of the made move
        grid[i][j] = 0;                    // undo the move
        if (reward > bestReward) {           // store the max reward in bestReward and its position in bestMove
          bestReward = reward;
          bestMove[0] = i;
          bestMove[1] = j;
        }
      }
     }
  }
  return bestMove;
}


int minimax(boolean isMaximizing, int maximizer) {
  /* Function which executes minimax algorithm 
    Parameter : 
          * isMaximazing :   True when maximazing    ---    False when minimizing
          * maximizer :    1  when Player 1 is maximzing & AI is minimizing     ----    2 when AI is maximizing & Player 1 is minimizing
    Return :
          Max reward when maximzing    ---    Min reward when minimizing
  */

  // check if game over
  int winner = check_winner();   
  if (winner != -1) {      // if game over
    if(maximizer == 2)
      return rewards.get(winner);      // returns the reward of game result
    else
      return -rewards.get(winner); 
  }
  
  int minimizer;
  if(maximizer == 2)
      minimizer=1;
  else
      minimizer=2;
  

  if (isMaximizing) {
    // process Maximizing    ---    AI turn
    
    int maxReward = (int) Double.NEGATIVE_INFINITY;    // initialize maxReward to -infinity
    
    // iterate through all boxes
    for (int i = 0; i < NB_CASE; i++) {
      for (int j = 0; j < NB_CASE; j++) {
        if (grid[i][j] == 0) {       // check if the box is empty
          grid[i][j] = maximizer;            // maximizer move
          int reward = minimax(false, maximizer);    // get reward of last move
          grid[i][j] = 0;            // undo move
          maxReward = max(reward, maxReward);      // update maxReward
        }
      }
    }
    return maxReward;
  } 
  
  else {
    // process Minimazing   ---    Player turn
    
    int minReward = (int) Double.POSITIVE_INFINITY;      // initialize minReward to +infinity
    
    // iterate through all boxes
    for (int i = 0; i < NB_CASE; i++) {
      for (int j = 0; j < NB_CASE; j++) {
        
        if (grid[i][j] == 0) {     // check if the box is empty
          grid[i][j] = minimizer;          // minimizer move
          int reward = minimax(true, maximizer);    // get reward of last move
          grid[i][j] = 0;          // undo move
          minReward = min(reward, minReward);     // update minReward
        }
      }
    }
    return minReward;
  }
}
