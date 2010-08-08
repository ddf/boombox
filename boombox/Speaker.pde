PImage speakerBox;
PImage speakerConeTop;
PImage speakerConeBottom;

void loadSpeakerImages()
{
  speakerBox = loadImage("SpeakerBox.png");
  speakerConeTop = loadImage("SpeakerTopCone.png");
  //speakerConeTop = loadImage("TopSpeaker.gif");
  //speakerConeBottom = loadImage("SpeakerBottomCone2.png");
  speakerConeBottom = loadImage("BottomSpeaker.gif");
  //speakerConeBottom = loadImage("bottomspeakergrey.png");
}

class Speaker
{
  PVector mPos;
  float   mScale;
  
  Speaker( float x, float y, float s )
  {
    mPos = new PVector(x,y);
    mScale = s;
  }
  
  void draw()
  {
    pushMatrix();
    {
      translate( mPos.x, mPos.y );
      scale( mScale );
      noTint(); 
      imageMode( CENTER );
      image( speakerBox, 0, -speakerBox.height / 2.f, speakerBox.width, speakerBox.height );
      float coneScale = 1.f + mainOut.mix.level() * 0.8f;
      image( speakerConeTop, 0, -speakerBox.height * 0.72f, speakerConeTop.width * coneScale, speakerConeTop.height * coneScale );
      image( speakerConeBottom, 0, -speakerBox.height * 0.3f, speakerConeBottom.width * coneScale, speakerConeBottom.height * coneScale );
    } 
    popMatrix();
  }
  
  void drawShadow()
  {
    pushMatrix();
    {
      translate( mPos.x, mPos.y );
      scale( mScale );
      
      noStroke();
      fill(0, 64);
      beginShape(QUADS);
        float xLeft = -speakerBox.width * 0.5f;
        float xSlant = -speakerBox.width * 0.8f;
        float xRight = speakerBox.width * 0.5f;
        float yHigh = speakerBox.height * 0.4f;
        vertex( xLeft, 0 );
        vertex( xLeft + xSlant, yHigh );
        vertex( xRight + xSlant, yHigh );
        vertex( xRight, 0 );
      endShape();
        
    } 
    popMatrix();
  }
}
