class SingleEllipse {
  float r  = 2;
  float xposOfSingleEllipse;
  float yposOfSingleEllipse;
  float gravity = random(20);
  float accelerateOfGravity = 0.1;

  SingleEllipse (float tempXposOfSingleEllipse, float tempYposOfSingleEllipse) {
    xposOfSingleEllipse = tempXposOfSingleEllipse;
    yposOfSingleEllipse = tempYposOfSingleEllipse;
  }
  
  void showUpAndMove () {
    noStroke();
      fill(255,200);
    ellipse(xposOfSingleEllipse, yposOfSingleEllipse,r,r);
    yposOfSingleEllipse = yposOfSingleEllipse + gravity;
    gravity = gravity + accelerateOfGravity;
    
  }
}

