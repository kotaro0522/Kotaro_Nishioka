import processing.net.*;
Server server;

boolean shot = false;
boolean win = false;
int win2 = 0;
boolean lose = false;

PImage rabbit;
PImage carrot;
PImage spaceship;
PImage beam;

int sx, sy;
int cx, cy;
int x,y;
int bx_c[];
int by_c[];
int bx_s[];
int by_s[];
int count_c;
int count_s;

int port = 20000;

void setup(){
  server = new Server(this, port);
  rabbit = loadImage("rabbit_.png");
  carrot = loadImage("carrot_.png");
  spaceship = loadImage("spaceship_.png");
  beam = loadImage("beam_.png");
  sx = 0;
  sy = 760;
  cx = 0;
  cy = 0;
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
  Client c = server.available();
  if(c != null) {
    String msg = c.readStringUntil('\n');
    if (msg != null){
      String[] data = splitTokens(msg);
      
      cx = int(data[0]);
      if(count_c >= 0 && count_c != int(data[1])){
        bx_c[count_c] = int(data[2]);
        by_c[count_c] = int(data[3]);
      }
      count_c = int(data[1]);
      if(int(data[4]) == 1){
        lose = true;
      }
      
      
    }
  }
  background(0);
  
  if(shot){
    for(int i = 0;i<count_s;i++){
      //fill(50,50,0);
      //rect(bx_s[i],by_s[i],20,50);
      image(carrot,bx_s[i],by_s[i],20,50);
      by_s[i]-=8;
      
      if(by_s[i]<80  && by_s[i] > 0 && bx_s[i] < sx + 80 && bx_s[i] > sx + 20 && !lose){
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
  
  
  if(count_c > 0){
    for(int i = 0;i<count_c;i++){
      //fill(50,50,0);
      //rect(bx_c[i],by_c[i],20,50);
      image(beam,bx_c[i],by_c[i],20,50);
      
      by_c[i]+=8;
    }
  }
    
  if(win){
    println("You win.\n");
  }
  else if(lose){
    println("You lose.\n");
  }
  
  
  sx = mouseX - 40;

  String msg = sx + " " + count_s + " " + x + " " + y  + " " + win2 + "\n";
  print("server: " + msg);

  server.write(msg);
}

void mouseClicked(){
  count_s += 1;
  shot = true;
  bx_s[count_s - 1] = mouseX - 10;
  by_s[count_s - 1] = 760;
  x = mouseX - 10;
  y = 80;
}
