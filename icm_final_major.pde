import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import processing.video.*;
import processing.opengl.*;
import SimpleOpenNI.*;


SimpleOpenNI context;
Minim minim;
AudioPlayer song;
FFT fft;
BeatDetect beat;
BeatListener bl;



float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
float        rotY = radians(0);
boolean      handsTrackFlag = false;

PVector      handVec = new PVector();
ArrayList    handVecList = new ArrayList();
int          handVecListSize = 30;
String       lastGesture = "";


ArrayList<BigCircle> singleBigCircle;
int number = 1; //get the first value of buffer, that's the volumn we will use
float a = 0.01;
Movie movie; 
PShader blur;
ArrayList plist = new ArrayList(); //particle
ArrayList xpos ; //arraylist of x postion, for the tail of main object
ArrayList ypos ;  //arraylist of y postion, for the tail of main object
int MAX = 5; //the max quantity of paricle per time
int num=20; // the tai's length  of each particle
ArrayList pSize; //length of main object's tail
int Cmax=18; //quantity of main object's tail
float kickSize, snareSize, hatSize;
color elemental[] = new color [5];
//rotate angle
float rv;
PShader nebula;

//-------------------------------lines-----------------
int maxL = 10;
float gap = 150;
float lineSpeed;
float x = 1.1;
float x1 = 0;
float x2 = 3000;

float deeper;

float lCir  = 255;
float lcirA = 1;
float sCir  = 0;
float scirA = 1;
float beatAlp;
float rotateAngle = 1;
float movingRectZ = -10000;
float movingRectSpeed = 50;
float movieAlpha = 0;
//--------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------



void setup() {


  //frameRate(120);
  size(1024, 768, P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem 
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  singleBigCircle = new ArrayList<BigCircle>();

  // enable depthMap generation 
  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // enable hands + gesture generation
  context.enableGesture();
  context.enableHands();
  // add focus gestures  / here i do have some problems on the mac, i only recognize raiseHand ? Maybe cpu performance ?
  context.addGesture("Wave");
  context.addGesture("Click");
  context.addGesture("RaiseHand");
  // set how smooth the hand capturing should be
  context.setSmoothingHands(.5);



  blur = loadShader("blur.glsl"); 
  minim = new Minim(this);  
  song = minim.loadFile("music.mp3", 1024);
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  println(song.bufferSize());
  println(song.sampleRate());
  //movie 
//  myMovie = new Movie(this, "view2.mov");
//  myMovie.loop();
  perspective();
  //arrayList initialization
  pSize = new ArrayList();
  xpos = new ArrayList();
  ypos = new ArrayList();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(10);
  kickSize = snareSize = hatSize = 0;
  bl = new BeatListener(beat, song);
  noSmooth();

}


//--------------DRAW below!!!!----------------------------------
//--------------DRAW below!!!!----------------------------------
//--------------DRAW below!!!!----------------------------------
//--------------DRAW below!!!!----------------------------------


void draw() {

   //background here!!-------------
    rectMode(CORNER);
    fill (242,198,160, 15);
    rect (-1000, -1000, 10000, 10000);
    //background here!!-------------
  

  context.update();


  // set the scene pos

  if (handsTrackFlag)  
  {

    translate(width/2, height/2, 0);
    rotateX(rotX);
    scale(1.5);

    float rotateSpeed = random(0.01, 0.1);
    // ------------------get a useful value from volume---------------------------------------------
    fft.forward(song.mix);

    float q = song.mix.get(number);//get volumn
    float radius = q*500;
    int radius2= (int)radius;
    //working on the tails of everything
    pSize.add(radius2);  
    xpos.add(handVec.x);
    ypos.add(handVec.y); 
    //constrain the length of tails
    if (pSize.size() > Cmax) {
      pSize.remove(0);
    }
    if (xpos.size() > Cmax) {
      xpos.remove(0);
      ypos.remove(0);
    }

    // ------------------main object---------------------------------------------

    for (int i=0;i<pSize.size();i++) {
      int radiuss=(Integer)pSize.get(i);
      float xpos2=(Float)xpos.get(i);
      float ypos2=(Float)ypos.get(i);
      println(xpos2);
      println(ypos2);
      noFill();
      pushMatrix();
      a=a+0.01;
      float segments = (int)abs(q*1000);
      //println(segments/10);
      float segments2 = map(segments, 20, 600, 0, 10);
      int segments3=6-(int)segments2;
      sphereDetail(segments3);
      //    println(segments3);
      stroke(242,135,5,i*(255/Cmax));
      //    strokeWeight(segments3-5);
      strokeWeight(2);
      translate(xpos2, ypos2);

      rotateX(rv*8);
      rotateY(rv*8);
      rv = rv +rotateSpeed;
      sphere(q * 300);
      popMatrix();
    }

    number = (number +1 )% song.bufferSize(); 
    //------------------------------------------------tail of particles------------------

    for (int i = 0; i < plist.size(); i++) {
      Particle p = (Particle) plist.get(i);
      //makes p a particle equivalent to ith particle in ArrayList
      p.run();
      p.update();
    }


    //-----------------------------------create particle-------------------- 
    pushMatrix();
    translate(-width/2, -height/2);
    if (abs(q*800) > 200 || mousePressed) {
      for (int i = 0; i < MAX; i ++) {
        plist.add(new Particle(handVec.x, handVec.y, handVec.z)); // fill ArrayList with particles
      }
    }

    if (plist.size() > 300) {
      plist.remove(0);
    }
    popMatrix();

    // --------------------colorful effect-------------------------------------------
   
   
   
   
    
    
    
    
    pushMatrix();
    translate(handVec.x, handVec.y);
    for (int i = 0; i < song.bufferSize() - 1; i += 5) {

      float leftLevel = pow(song.left.level()*10, 3);
      float rightLevel = pow(song.right.level()*10, 3);
      float mixLevel = pow(song.mix.level()*10, 3);

      rotateX(frameCount*0.05);
      rotateY(frameCount*-0.02);
      rotateZ(frameCount*-0.02);
      //blue ellipse
      if ( beat.isKick()) {
        noFill();
        strokeWeight(0.5);
        ellipseMode(CENTER);
        stroke(242,183,5 ,180);
        lCir = lCir+lcirA;

        

        ellipse (0, 0, 200 + kickSize, 200 + kickSize);
      }
      //Red Ellipse (Beat driven)
      if ( beat.isSnare()) {
        noFill();
        ellipseMode(CENTER);
        stroke(242,38,19, 160); 
        sCir = sCir+scirA;
       
        strokeWeight(0.5);
        ellipse (0, 0, 100 + kickSize, 100 + kickSize);
      }
    }
    popMatrix();

    //-----------------------------falling down particles-----------------------

    pushMatrix();



    if (abs(q*800) > 450 || mousePressed ) {
      singleBigCircle.add(new BigCircle(random(200), handVec.x, handVec.y));
    }
    for (int i = 0;i<singleBigCircle.size();i++) {
      singleBigCircle.get(i).showUp();
    }

    if (singleBigCircle.size() > 5) {
      singleBigCircle.remove(0);
    }

    popMatrix();


    //-------------------------
    filter(blur);
    filter(blur);
  }
}


//--------------DRAW above!!!!----------------------------------
//--------------DRAW above!!!!----------------------------------
//--------------DRAW above!!!!----------------------------------
//--------------DRAW abbbbove!!!!----------------------------------




void stop()
{    
  song.close();
  minim.stop();
  super.stop();
}  


//----------------------------------------------Kinect callback functions----------------------

void onCreateHands(int handId, PVector pos, float time)
{
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);

  handsTrackFlag = true;
  handVec = pos;

  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId, PVector pos, float time)
{
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handVec = pos;

  handVecList.add(0, pos);
  if (handVecList.size() >= handVecListSize)
  { // remove the last point 
    handVecList.remove(handVecList.size()-1);
  }
}

void onDestroyHands(int handId, float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);

  handsTrackFlag = false;
  context.addGesture(lastGesture);
}

// -----------------------------------------------------------------
// gesture events


void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);
  lastGesture = strGesture;
  context.removeGesture(strGesture); 
  context.startTrackingHands(endPosition);
}


//
//void movieEvent(Movie m) {
//  m.read () ;
//}
