import processing.net.*;
Client my_client;

boolean shot = false;
boolean win = false;
int win2 = 0;
boolean lose = false;

boolean start = true;

PImage title;
PImage best;
PImage worst;

PImage rabbit;
PImage carrot;
PImage spaceship;
PImage beam;

int cx, cy;
int sx, sy;
int x,y;
int bx_c[];
int by_c[];
int bx_s[];
int by_s[];
int count_c;
int count_s;

String serverAdder = "127.0.0.1";
int port = 20000;

//void shooting(int x,int y);

void setup(){
  my_client = new Client(this, serverAdder,port);
  title = loadImage( "title.png" );
  best = loadImage( "youwin.png" );
  worst = loadImage( "youlose.png" );
  rabbit = loadImage("rabbit_.png");
  carrot = loadImage("carrot_.png");
  spaceship = loadImage("spaceship_.png");
  beam = loadImage("beam_.png");
  cx = 0;
  cy = 760;
  sx = 0;
  sy = 0;
  bx_c = new int[100];
  by_c = new int[100];
  bx_s = new int[100];
  by_s = new int[100];
  x = 0;
  y = 0;
  count_c = 0;
  count_s = 0;
  size(1024,840);
  colorMode(RGB, 100);
  noStroke();
}

void draw(){
  
  background(0);
  
 
  if(shot){
    for(int i = 0;i<count_c;i++){
      //fill(50,50,0);
      //rect(bx_c[i],by_c[i],20,50);
      image(beam,bx_c[i],by_c[i],20,50);
      by_c[i]-=8;
      
      if(by_c[i]<80  && by_c[i] > 0 && bx_c[i] < sx + 80 && bx_c[i] > sx + 20 && !lose){
        win = true;
        win2 = 1;
      }
    }
  }
    
  
  //fill(100,0,0);
  //rect(cx,cy,80,80);
  //fill(0,0,100);
  //rect(sx,sy,80,80);
  image(spaceship,cx,cy,80,80);
  image(rabbit,sx,sy,80,80);
  
  
  if(count_s > 0){
    for(int i = 0;i<count_s;i++){
      //fill(50,50,0);
      //rect(bx_s[i],by_s[i],20,50);
      image(carrot,bx_s[i],by_s[i],20,50);
      
      by_s[i]+=8;
    }
  }
  
  
  
  
  
  cx = mouseX - 40;
  
  String msg = cx +  " " + count_c + " " + x + " " + y + " " + win2 +"\n";
  print("client: " + msg);
  
  my_client.write(msg);
  
  if(start){
    image(title, 0, 0);
  }
  else if(win){
    image(best, 0, 0);
  }
   if(lose){
    image(worst, 0, 0);
    println("looooooooose\n");
  }
}

void clientEvent(Client c){
  String msg = c.readStringUntil('\n');
  if(msg != null){
    String[] data = splitTokens(msg);
    
    sx = int(data[0]);
    if(count_s >= 0 && count_s != int(data[1])){
      bx_s[count_s] = int(data[2]);
      by_s[count_s] = int(data[3]);
    }
    count_s = int(data[1]);
    if(int(data[4]) == 1){
      lose = true;
    }
  }
}

void mouseClicked(){
  count_c += 1;
  shot = true;
  bx_c[count_c - 1] = mouseX - 10;
  by_c[count_c - 1] = 760;
  x = mouseX - 10;
  y = 80;
}

void keyPressed(){
  if(key == ENTER){
    start = false;
  }
}


  

