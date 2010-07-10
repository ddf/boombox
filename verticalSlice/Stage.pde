// the graphics for the environment
class Stage
{
  
  float horizonHeight = height * 0.7f;
  
  void draw()
  {
    rectMode(CORNER);
    // the sky
    {
      noStroke();
      fill(120, 162, 240);
      rect(0, 0, width, height);
    }
    
    // the ground
    {
      noStroke();
      fill(105, 122, 144);
      rect( -10, horizonHeight, width + 10, height + 10);
    }
    
    // sidewalk cracks
    {
      strokeWeight(2);
      stroke(60, 62, 64);
      float lineSpacing = 100;
      float lineSlope = 75;
      for(int i = 0; i < 20; ++i)
      {
        line( lineSpacing*i, height, lineSpacing + lineSlope*i, horizonHeight );
      }      
    }
    
    // horizon line
    {
      strokeWeight(2);
      stroke(179, 183, 188);
      line( -10, horizonHeight, width+10, horizonHeight );
    }
  }
}
