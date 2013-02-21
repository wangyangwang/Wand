class Particle {
  float r = 0.9;
  PVector pos, speed;
  ArrayList tail;
  float splash = 50;
  float margin = 0.3;
  int taillength = 30;

  Particle(float tempx, float tempy, float tempz) {
    float startx = tempx + random(-splash, splash);
    float starty = tempy + random(-splash, splash);
    float startz = tempz + random(-splash, splash);
    startx = constrain(startx, 0, width);
    starty = constrain(starty, 0, height);
    startz = constrain(startz, 0, 200);
    float xspeed = random(-5, 5);
    float yspeed = random(-5, 5);
    float zspeed = random(-5, 5);

    pos = new PVector(startx, starty, startz);
    speed = new PVector(xspeed, yspeed, zspeed);
    tail = new ArrayList();
  }

  void run() {
    pos.add(speed);
    tail.add(new PVector(pos.x, pos.y, pos.z));
     if(tail.size() > taillength) {
      tail.remove(0);
    }
    float damping = random(-0.5, -0.6);

  }



  void update() {
    for (int i = 0; i < tail.size(); i++) {
      PVector tempv = (PVector)tail.get(i);
      noStroke();
      fill(255,map(i,0,tail.size(),0,255));

      pushMatrix();
      translate(tempv.x,tempv.y, tempv.z);
      noStroke();
     sphere(r);
   
  
      popMatrix();
    }
  }
}

