// the graphics for the environment
class Stage
{ 
  // all the elevators in the level
  ArrayList<Elevator> mElevators;
  ArrayList<Rectangle> mPlatforms;
  ArrayList<Dude> mDudes;
  // I'm calling it collisions, but it's really just all walkable space
  // this includes the ground, platforms, and elevators
  ArrayList<Rectangle> mCollision; 
  
  FFT mFFT;
  
  float horizonHeight = height * 0.7f;
  
  Stage()
  {
    mElevators = new ArrayList<Elevator>();
    mPlatforms = new ArrayList<Rectangle>();
    mDudes = new ArrayList<Dude>();
    
    float topOfGround = horizonHeight + 5;
    
    theGround = new Rectangle( 0, topOfGround, width * 4, height - horizonHeight - 10 , LEFT, TOP );
    
    { 
      allJams.get(1).setPos( 230, 410 );
      
      Dude dude = new Dude( 410, 420, new Jam[] { allJams.get(1) }, allJams.get(2) );
      
      // this goes on the platform
      allJams.get(3).setPos( 440, 160 );
      Rectangle platform = new Rectangle( 400, 160, 260, 20, LEFT, TOP );
      Elevator elevator = new Elevator( 890, topOfGround, topOfGround - 160, allJams.get(2) ); 
    }
    
    
    mFFT = new FFT( mainOut.bufferSize(), mainOut.sampleRate() );
    mFFT.logAverages( 20, 4 );
  }
  
  void update( float dt )
  {
    for(int i = 0; i < mElevators.size(); ++i)
    {
      mElevators.get(i).update( dt );
    }
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
        line( lineSlope*i, height, lineSpacing + lineSlope*i, horizonHeight );
      }      
    }
    
    // horizon line
    {
      strokeWeight(2);
      stroke(179, 183, 188);
      line( -10, horizonHeight, width+10, horizonHeight );
    }
    
    // ground walkable space
    if ( DRAW_COLLISION )
    {
      noStroke();
      fill(COLLISION_COLOR);
      theGround.draw();
    }
    
    // the platform walkable space
    if ( DRAW_COLLISION )
    {
      noStroke();
      fill(COLLISION_COLOR);
      thePlatform.draw();
    }
  }
}
