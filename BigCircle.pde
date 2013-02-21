class BigCircle {

  float R;
  float XposOfBigCircle, YposOfBigCircle;
  ArrayList<SingleEllipse> singleEllipses;

  BigCircle (float tempR, float tempXposOfBigCircle, float tempYposOfBigCircle) {

    R = tempR;
    XposOfBigCircle = tempXposOfBigCircle;
    YposOfBigCircle = tempYposOfBigCircle;
    singleEllipses = new ArrayList<SingleEllipse>();
  }




  void showUp() {
 float q = song.mix.get(number);//get volumn
    for (float i = 0 ; i < 2*PI; i=i+((2*PI)/90)) {
      float startXposOfSingleCircle=  handVec.x  + cos(i)*q*300;
      float startYposOfSingleCircle=  handVec.y +  sin(i)*q*300;

      float  finalXposOfSingleCircle = startXposOfSingleCircle + random(-10, 10);
      float  finalYposOfSingleCircle = startYposOfSingleCircle + random(-10, 10);
        
      if(abs(q*800) > 500 || mousePressed){
      singleEllipses.add(new SingleEllipse(finalXposOfSingleCircle,finalYposOfSingleCircle));
      }
    }
    
     for(int j=0;j<singleEllipses.size();j++){
      singleEllipses.get(j).showUpAndMove();
      }
      
     
      println(singleEllipses.size());
  }
}

