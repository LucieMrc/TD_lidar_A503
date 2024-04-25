

import oscP5.*;
import netP5.*;

OscP5 oscP5;


// "SOL" ou "MUR" ou "SOL_MUR"
String MODE = "SOL";
int nObjects;
float smoothing = 0.1;

ArrayList <Trackable> activeObjects;



void setup() {
  fullScreen();
 //size(400, 400);
  //frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);


  if (MODE == "SOL") {
    nObjects = 20;
    activeObjects = new ArrayList<Trackable>(nObjects);
    for (int i =  0; i< nObjects; i++) {
      activeObjects.add(new Trackable());
    }
  } else if (MODE == "MUR") {
    nObjects = 10;
    activeObjects = new ArrayList<Trackable>(nObjects);
    for (int i =  0; i< nObjects; i++) {
      activeObjects.add(new Trackable());
    }
  } else if (MODE == "SOL_MUR") {
    nObjects = 30;
    activeObjects = new ArrayList<Trackable>(nObjects);
    for (int i =  0; i< nObjects; i++) {
      activeObjects.add(new Trackable());
    }
  }
  println(activeObjects.size());
}

void draw() {
  background(0);

  for (int i = 0; i < activeObjects.size(); i++) {
    Trackable o = (Trackable) activeObjects.get(i);
    if (o.id !=0){
      o.update();
      o.draw();
    }
  }
}




void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  String s;

  for (int i = 0; i< activeObjects.size(); i++) {
    Trackable o = (Trackable) activeObjects.get(i);

    s = (String)"/" + MODE + "/blobs/blob" + nf(i) +"/u";
    if (theOscMessage.checkAddrPattern(s)==true) {
      o.u = theOscMessage.get(0).floatValue();
    }
    
    s = (String)"/" + MODE + "/blobs/blob" + nf(i) +"/v";
    if (theOscMessage.checkAddrPattern(s)==true) {
      o.v = theOscMessage.get(0).floatValue();
    }
    
    s = (String)"/" + MODE + "/blobs/blob" + nf(i) +"/tx";
    if (theOscMessage.checkAddrPattern(s)==true) {
      o.tx = theOscMessage.get(0).floatValue();
    }
    
    s = (String)"/" + MODE + "/blobs/blob" + nf(i) +"/ty";
    if (theOscMessage.checkAddrPattern(s)==true) {
      o.ty = theOscMessage.get(0).floatValue();
    }
    
    s = (String)"/" + MODE + "/blobs/blob" + nf(i) +"/id";
    if (theOscMessage.checkAddrPattern(s)==true) {
      o.id = theOscMessage.get(0).floatValue();
    }
  }
  //println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}

class Trackable {

  float u;
  float v;
  float tx;
  float ty;
  
  float targetX;
  float targetY;
  
  float id;

  Trackable() {
    this.id = 0;
    this.u = 0;
    this.v = 0;
    this.tx = 0;
    this.ty = 0;
  }

  Trackable(float id, float u, float v, float tx, float ty) {
    this.id = id;
    this.u = u;
    this.v = v;
    this.tx = tx;
    this.ty = ty;
  }
  
  void update(){
     targetX = lerp(this.targetX, this.u, smoothing); 
     targetY = lerp(this.targetY, this.v, smoothing); 
  }

  void draw() {
    pushMatrix();
    textAlign(CENTER, CENTER);
   
    float screenX = map(this.targetX, 0, 1, 0, width);
    float screenY = map(this.targetY, 0, 1, height, 0);
    ellipse(screenX, screenY, 10, 10);
    textSize(24);
    text(this.id, screenX, screenY- 20);
    popMatrix();
  }
}
