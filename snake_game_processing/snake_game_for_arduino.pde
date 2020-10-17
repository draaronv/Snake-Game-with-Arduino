import processing.serial.*;
Serial mySerial;
int Rw[] = new int[4];
byte inBuffer[] = new byte[100];
ArrayList<Integer> x = new ArrayList<Integer>(), y = new ArrayList<Integer>();
int w=30, h=30, bs=20, dir=2, ax=12, ay=10;
int[]dx={0, 0, 1, -1}, dy={1, -1, 0, 0};
boolean gameover=false;
int nd;
void setup() 
{ 
  String myPort=Serial.list() [0];
  mySerial=new Serial(this, myPort, 115200);
  size(600, 600); 
  x.add(5); 
  y.add(5);
}

void draw()
{
  buttonRandL();
  background(255);
  for (int i=0; i<w; i++) line(i*bs, 0, i*bs, height);
  for (int i=0; i<h; i++)line(0, i*bs, width, i*bs);
  fill(0, 255, 0); 
  for (int i = 0; i < x.size(); i++) rect(x.get(i)*bs, y.get(i)*bs, bs, bs);
  if (!gameover) {  
    fill(255, 0, 0); 
    rect(ax*bs, ay*bs, bs, bs); 
    if (frameCount%5==0) {
      x.add(0, x.get(0) + dx[dir]); 
      y.add(0, y.get(0) + dy[dir]);
      if (x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h) gameover = true;
      for (int i=1; i<x.size(); i++) if (x.get(0)==x.get(i)&&y.get(0)==y.get(i)) gameover=true;
      if (x.get(0)==ax && y.get(0)==ay) { 
        ax = (int)random(0, w); 
        ay = (int)random(0, h);
      } else { 
        x.remove(x.size()-1); 
        y.remove(y.size()-1);
      }
    }
  } else {
    fill(0); 
    textSize(30); 
    textAlign(CENTER); 
    text("GAME OVER. Press space", width/2, height/2);
    if (keyPressed&&key==' ') { 
      x.clear(); 
      y.clear(); 
      x.add(5);  
      y.add(5); 
      gameover = false;
    }
  }
}

void buttonRandL()
{
  while (mySerial.available()>0) 
  {
    if (mySerial.readBytesUntil(10, inBuffer)>0) 
    {//Read to determine whether the wrap 10BYTE
      String inputString = new String(inBuffer);
      String inputStringArr[] = split(inputString, ',');//Data ',' Split
      Rw[0] = int(inputStringArr[0]);
      Rw[1] = int(inputStringArr[1]);
      Rw[2] = int(inputStringArr[2]);
      Rw[3] = int(inputStringArr[3]);
      int nd=Rw[0]==1? 0:(Rw[1]==1?1:(Rw[2]==1?2:(Rw[3]==1?3:-1)));
      if (nd!=-1&&(x.size()<=1||!(x.get(1)==x.get(0)+dx[nd]&&y.get(1)==y.get(0)+dy[nd]))) dir=nd;
    }
  }
}
