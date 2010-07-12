// the graphics for the environment
class Stage
{
  // the walkable area for the player
  Rectangle theGround;
  Rectangle thePlatform;
  
  FFT mFFT;
  
  float horizonHeight = height * 0.7f;
  
  Stage()
  {
    theGround = new Rectangle( 0, horizonHeight + 5, width, height - horizonHeight - 10 , LEFT, TOP );
    
    mFFT = new FFT( mainOut.bufferSize(), mainOut.sampleRate() );
    mFFT.logAverages( 20, 4 );
  }
  
  void draw()
  {
    rectMode(CORNERS);
    
    // the sky
    {
      noStroke();
      fill(120, 162, 240);
      rect(0, 0, width, height);
    }
    
    rectMode(CENTER);
    
    // subtle equalizer clouds
    {
      float leftBuff = 25.f;
      float barWidth = 25.f;
      float barHeight = 25.f;
      noStroke();
      fill( 125, 168, 245 );
      mFFT.forward( mainOut.mix );
      int startAt = 7;
      for(int i = 0; i < mFFT.avgSize() - startAt; ++i)
      {
        float x = 25 + barWidth * i + leftBuff * i;
        float y = horizonHeight - 120 - i * 4.3f;
        float s = mFFT.getAvg(i+startAt) * 0.5f;
        rect( x, y, barWidth + s, barHeight + s ); 
      }
    }
    
    rectMode(CORNERS);
    
    // the ground
    {
      noStroke();
      fill(105, 122, 144);
      rect( -10, horizonHeight, width + 10, height + 10);
    }
    
    // the platform
    {
      noStroke();
      fill(105, 122, 144);
      Rectangle.Bounds plat = thePlatform.getBounds();
      rect( plat.minX, plat.minY, plat.maxX, plat.maxY + 10 );
      
      strokeWeight(2);
      stroke(179, 183, 188);
      line( plat.minX, plat.minY, width, plat.minY );
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
    
    // ground walkable space
    {
//      noStroke();
//      fill(0, 64);
//      theGround.draw();
    }
    
    // the platform walkable space
    {
//      noStroke();
//      fill(0, 64);
//      thePlatform.draw();
    }
  }
}
