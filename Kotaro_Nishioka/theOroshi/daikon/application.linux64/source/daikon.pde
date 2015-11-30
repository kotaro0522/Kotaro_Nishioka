//加速度センサデータ受け取りサンプル
import processing.serial.*;
//library for music
import ddf.minim.*;
 
// Serialクラスのインスタンス
Serial myPort;
// about music
Minim minim;
AudioPlayer bgm,oroshi_l,oroshi_h;
// about image
PImage background,daikon,daikon_,end;
int frame = 0;
int count = 0;
int x,y;

// シリアルポートから取得したデータ
int inX, inY, inZ;
int inX_, inY_, inZ_;
double dis;

//初期化ルーチン
void setup()
{
    println(Serial.list()); //リストの表示
    //arduino
    //String portName = Serial.list()[5]; //必要に応じて番号を変更
    // ポートとスピードを設定して、Serialクラスを初期化、
    //arduino
    //myPort = new Serial(this, portName, 9600);
    //キャンバスの指定
    colorMode(HSB,256,256,256);
    size(640,480);
    frameRate(20);
    //parts of musicplayer
    minim = new Minim(this);
    bgm = minim.loadFile("bgm.mp3");
    oroshi_l = minim.loadFile("oroshi_l.mp3");
    oroshi_h = minim.loadFile("oroshi_h.mp3");
    //parts of image
    background = loadImage("background.png");
    image(background, 0, 0);
    daikon = loadImage("daikon.png");
    //image(daikon,180, -130);
    daikon_ = loadImage("daikon_.png");
    daikon.mask(daikon_);
    image(daikon,180, 90);
    end = loadImage("end.png");
    y = 531;
}

//描画ルーチン
void draw()
{
  if(y>10){
    // シリアルから取得した値を背景色に設定
    //background(inX,inY,inZ);
    
    //count frame
    frame++;
    
    //arduino
    //dis = sqrt(sq(inX - inX_)+sq(inY - inY_)+sq(inZ - inZ_));
    
    //mouse
    dis = sqrt(sq(mouseX - inX_)+sq(mouseY - inY_));
    
    println("dis:" + dis);
    
    //283*531
    //for(int j=0;j<531;j++){
    //  for(int i=0;i<283;i++){
    //    daikon_.set(i, j, color(255,255,0));
    //    x++;
    //  }
    //  println("asdfghjkldfgh");
    //  y--;
    //}
    daikon.mask(daikon_);
    
    if(dis<=3){
      bgm.pause();
    }
    if(dis<=4){
      oroshi_l.pause();
      oroshi_h.pause();
    }
    else if(dis>4 && dis<20){
      bgm.play();
      oroshi_h.pause();
      oroshi_l.play();
      movepic(daikon,180,370-y);
      for(int i=0;i<283;i++){
        daikon_.set(i, y, color(255,255,0));
      }
      y--;
      
    }
    else if(dis>=20 && dis<50){
      bgm.play();
      oroshi_l.play();
      movepic(daikon,180,370-y);
      for(int i=0;i<283;i++){
        daikon_.set(i, y, color(255,255,0));
      }
      y--;
    }
    else if(dis>=50 && dis<100){
      bgm.play();
      oroshi_h.play();
      movepic(daikon,180,370-y);
      for(int i=0;i<283;i++){
        daikon_.set(i, y, color(255,255,0));
      }
      y--;
    }
    else if(dis>=100){
      bgm.play();
      oroshi_l.pause();
      oroshi_h.play();
      movepic(daikon,180,370-y);
      for(int i=0;i<283;i++){
        daikon_.set(i, y, color(255,255,0));
      }
      y--;
    }
    if(bgm.position()>133280){
      bgm.rewind();
    }
    if(oroshi_l.position()>8100){
      oroshi_l.rewind();
    }
    if(oroshi_h.position()>4500){
      oroshi_h.rewind();
    }
//    arduino
//    inX_ = inX;
//    inY_ = inY;
//    inZ_ = inZ;
      
      //mouse
      inX_ = mouseX;
      inY_ = mouseY;
  }
  else{
    bgm.pause();
    bgm.rewind();
    oroshi_l.pause();
    oroshi_l.rewind();
    oroshi_h.pause();
    oroshi_h.rewind();
  
    image(end,0,0);
  
    if((keyPressed == true) && (key == ENTER)){
      y = 531;
      daikon_ = loadImage("daikon_.png");
      daikon.mask(daikon_);
      image(daikon,180, 90);
    }
  }  
}

//シリアル津信用のルーチン 
void serialEvent(Serial p){
    if(myPort.available() > 2){//データが3個以上到達しているとき
      
      //シリアルポートからデータを読み込み
      inX = myPort.read();
      inY = myPort.read();
      inZ = myPort.read();
      
      //読み込みが終了したことをArduinoに通知
      myPort.write(255);
      
      //読み込んだデータの表示
      print("X :" + inX);
      print(" Y :" + inY);
      println(" Z :" + inZ);
    }
}

void movepic(PImage img,int x,int y){
    if(count%4==0){
      image(background, 0, 0);
      image(img, x + 50,y);
    }
    if(count%4==1){
      image(background, 0, 0);
      image(img, x,y);
    }
    if(count%4==2){
      image(background, 0, 0);
      image(img, x - 50,y);
    }
    if(count%4==3){
      image(background, 0, 0);
      image(img, x,y);
    }
  
    count++;
}
