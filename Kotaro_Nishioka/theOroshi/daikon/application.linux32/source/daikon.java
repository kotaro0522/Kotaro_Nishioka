import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class daikon extends PApplet {

//\u52a0\u901f\u5ea6\u30bb\u30f3\u30b5\u30c7\u30fc\u30bf\u53d7\u3051\u53d6\u308a\u30b5\u30f3\u30d7\u30eb

//library for music

 
// Serial\u30af\u30e9\u30b9\u306e\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9
Serial myPort;
// about music
Minim minim;
AudioPlayer bgm,oroshi_l,oroshi_h;
// about image
PImage background,daikon,daikon_,end;
int frame = 0;
int count = 0;
int x,y;

// \u30b7\u30ea\u30a2\u30eb\u30dd\u30fc\u30c8\u304b\u3089\u53d6\u5f97\u3057\u305f\u30c7\u30fc\u30bf
int inX, inY, inZ;
int inX_, inY_, inZ_;
double dis;

//\u521d\u671f\u5316\u30eb\u30fc\u30c1\u30f3
public void setup()
{
    println(Serial.list()); //\u30ea\u30b9\u30c8\u306e\u8868\u793a
    //arduino
    //String portName = Serial.list()[5]; //\u5fc5\u8981\u306b\u5fdc\u3058\u3066\u756a\u53f7\u3092\u5909\u66f4
    // \u30dd\u30fc\u30c8\u3068\u30b9\u30d4\u30fc\u30c9\u3092\u8a2d\u5b9a\u3057\u3066\u3001Serial\u30af\u30e9\u30b9\u3092\u521d\u671f\u5316\u3001
    //arduino
    //myPort = new Serial(this, portName, 9600);
    //\u30ad\u30e3\u30f3\u30d0\u30b9\u306e\u6307\u5b9a
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

//\u63cf\u753b\u30eb\u30fc\u30c1\u30f3
public void draw()
{
  if(y>10){
    // \u30b7\u30ea\u30a2\u30eb\u304b\u3089\u53d6\u5f97\u3057\u305f\u5024\u3092\u80cc\u666f\u8272\u306b\u8a2d\u5b9a
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

//\u30b7\u30ea\u30a2\u30eb\u6d25\u4fe1\u7528\u306e\u30eb\u30fc\u30c1\u30f3 
public void serialEvent(Serial p){
    if(myPort.available() > 2){//\u30c7\u30fc\u30bf\u304c3\u500b\u4ee5\u4e0a\u5230\u9054\u3057\u3066\u3044\u308b\u3068\u304d
      
      //\u30b7\u30ea\u30a2\u30eb\u30dd\u30fc\u30c8\u304b\u3089\u30c7\u30fc\u30bf\u3092\u8aad\u307f\u8fbc\u307f
      inX = myPort.read();
      inY = myPort.read();
      inZ = myPort.read();
      
      //\u8aad\u307f\u8fbc\u307f\u304c\u7d42\u4e86\u3057\u305f\u3053\u3068\u3092Arduino\u306b\u901a\u77e5
      myPort.write(255);
      
      //\u8aad\u307f\u8fbc\u3093\u3060\u30c7\u30fc\u30bf\u306e\u8868\u793a
      print("X :" + inX);
      print(" Y :" + inY);
      println(" Z :" + inZ);
    }
}

public void movepic(PImage img,int x,int y){
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "daikon" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
