// the graphics for the environment
class Stage
{ 
  Rectangle theGround;
  Rectangle moreGround;
  
  // all the elevators in the level
  ArrayList<Elevator> mElevators;
  ArrayList<Rectangle> mPlatforms;
  ArrayList<Dude> mDudes;
  // I'm calling it collisions, but it's really just all walkable space
  // this includes the ground, platforms, and elevators
  ArrayList<Rectangle> mCollision; 
  
  // the collision box the player is currently inside of.
  Rectangle currCollision;
  
  FFT mFFT;
  
  float horizonHeight = height * 0.7f;
  
  Stage()
  {
    mElevators = new ArrayList<Elevator>();
    mPlatforms = new ArrayList<Rectangle>();
    mDudes = new ArrayList<Dude>();
    mCollision = new ArrayList<Rectangle>();
    
    float topOfGround = horizonHeight + 5;
    
    theGround = new Rectangle( 0, topOfGround, 2100, height - horizonHeight - 10 , LEFT, TOP );
    moreGround = new Rectangle( 2450, topOfGround, 1500, height - horizonHeight - 10, LEFT, TOP );
    
    mCollision.add( theGround );
    mCollision.add( moreGround );
    
    currCollision = theGround;
    
    { 
      allJams.get(1).setPos( 230, 410 );
      
      Dude dude = new Dude( 410, 420, new Jam[] { allJams.get(1) }, allJams.get(2) );
      mDudes.add( dude );
      
      // this goes on the platform
      allJams.get(3).setPos( 440, 150 );
      Rectangle platform = new Rectangle( 400, 160, 460, 2, LEFT, TOP );
      Elevator elevator = new Elevator( 910, topOfGround, topOfGround - 160, allJams.get(2) ); 
      
      theGround.AdjacentRects.add( elevator.getRect() );
      elevator.getRect().AdjacentRects.add( platform );
      elevator.getRect().AdjacentRects.add( theGround );
      platform.AdjacentRects.add( elevator.getRect() );
      
      mElevators.add( elevator );
      mPlatforms.add( platform );
      
      mCollision.add( elevator.getRect() );
      mCollision.add( platform );
    }
    
    {
      Dude dudeGround = new Dude( 1030, 450, new Jam[] { allJams.get(3) }, allJams.get(4) );
      Dude dudePlatform = new Dude( 1500, 220, new Jam[] { allJams.get(2), allJams.get(4) }, allJams.get(6) );
      mDudes.add( dudeGround );
      mDudes.add( dudePlatform );
      
      allJams.get(5).setPos( 1500, 450 );
      
      Rectangle platform = new Rectangle( 1200, 220, 400, 2, LEFT, TOP );
      Elevator elevLeft = new Elevator( 1150, topOfGround, topOfGround - 220, allJams.get(4) );
      Elevator elevRight = new Elevator( 1650, topOfGround, topOfGround - 220, allJams.get(4) );
      
      theGround.AdjacentRects.add( elevLeft.getRect() );
      theGround.AdjacentRects.add( elevRight.getRect() );
      
      platform.AdjacentRects.add( elevLeft.getRect() );
      platform.AdjacentRects.add( elevRight.getRect() );
      
      elevLeft.getRect().AdjacentRects.add( platform );
      elevLeft.getRect().AdjacentRects.add( theGround );
      
      elevRight.getRect().AdjacentRects.add( platform );
      elevRight.getRect().AdjacentRects.add( theGround );
      
      mElevators.add( elevLeft );
      mElevators.add( elevRight );
      
      mPlatforms.add( platform );
      
      mCollision.add( elevLeft.getRect() );
      mCollision.add( elevRight.getRect() );
      mCollision.add( platform );
    }
          
    {
      allJams.get(11).setPos( 2000, 400 );
      
      Rectangle platform = new Rectangle( 2100, 220, 350, 2, LEFT, TOP );
      Elevator elevLeft = new Elevator( 2050, topOfGround, topOfGround - 220, allJams.get(5) );
      Elevator elevRight = new Elevator( 2500, topOfGround, topOfGround - 220, allJams.get(5) );
      
      theGround.AdjacentRects.add( elevLeft.getRect() );
      elevLeft.getRect().AdjacentRects.add( theGround );
      elevLeft.getRect().AdjacentRects.add( platform );
      
      platform.AdjacentRects.add( elevLeft.getRect() );
      platform.AdjacentRects.add( elevRight.getRect() );
      
      elevRight.getRect().AdjacentRects.add( platform );
      elevRight.getRect().AdjacentRects.add( moreGround );
      
      mElevators.add( elevLeft );
      mElevators.add( elevRight );
      
      mPlatforms.add( platform );
      
      mCollision.add( elevLeft.getRect() );
      mCollision.add( elevRight.getRect() );
      mCollision.add( platform );
    }
    
    {
      allJams.get(8).setPos( 2850, 400 );
      
      Dude dudeGround = new Dude( 2550, 470, new Jam[] { allJams.get(3), allJams.get(6), allJams.get(8) }, allJams.get(7) );
      Dude dudePlatform = new Dude( 3075, 225, new Jam[] { allJams.get(1), allJams.get(2), allJams.get(5), allJams.get(6), allJams.get(11) }, allJams.get(12) );
      
      mDudes.add( dudeGround );
      mDudes.add( dudePlatform );
      
      Rectangle leftPlat = new Rectangle( 2675, 125, 2900 - 2675, 2, LEFT, TOP );
      Rectangle rightPlat = new Rectangle( 3000, 225, 150, 2, LEFT, TOP );
      
      Elevator elevLow = new Elevator( 2625, topOfGround, topOfGround - 125, allJams.get(7) );
      Elevator elevHigh = new Elevator( 2950, 225, 100, allJams.get(10) );
      
      connect( moreGround, elevLow.getRect() );
      connect( elevLow.getRect(), leftPlat );
      connect( leftPlat, elevHigh.getRect() );
      connect( elevHigh.getRect(), rightPlat );
    
      mElevators.add( elevLow );
      mElevators.add( elevHigh );
      
      mPlatforms.add( leftPlat );
      mPlatforms.add( rightPlat );
    
      mCollision.add( elevLow.getRect() );
      mCollision.add( elevHigh.getRect() );
      mCollision.add( leftPlat );
      mCollision.add( rightPlat );   
    }
    
    {
      allJams.get(9).setPos( 3750, 120 );
      
      Dude dude = new Dude( 3675, 450, new Jam[] { allJams.get(4), allJams.get(5), allJams.get(9) }, allJams.get(10) );
      
      mDudes.add( dude );
      
      Rectangle leftPlat = new Rectangle( 3400, 225, 150, 2, LEFT, TOP );
      Rectangle rightPlat = new Rectangle( 3650, 125, 150, 2, LEFT, TOP );
      
      Elevator elevLow = new Elevator( 3350, topOfGround, topOfGround - 225, allJams.get(1) );
      Elevator elevHigh = new Elevator( 3600, 225, 100, allJams.get(6) );
      
      connect( moreGround, elevLow.getRect() );
      connect( elevLow.getRect(), leftPlat );
      connect( leftPlat, elevHigh.getRect() );
      connect( elevHigh.getRect(), rightPlat );
    
      mElevators.add( elevLow );
      mElevators.add( elevHigh );
      
      mPlatforms.add( leftPlat );
      mPlatforms.add( rightPlat );
    
      mCollision.add( elevLow.getRect() );
      mCollision.add( elevHigh.getRect() );
      mCollision.add( leftPlat );
      mCollision.add( rightPlat );         
    }
    
    mFFT = new FFT( mainOut.bufferSize(), mainOut.sampleRate() );
    mFFT.logAverages( 20, 4 );
  }
  
  private void connect( Rectangle a, Rectangle b )
  {
    a.AdjacentRects.add( b );
    b.AdjacentRects.add( a );
  }

  
  void update( float dt )
  {
    for(int i = 0; i < mElevators.size(); ++i)
    {
      mElevators.get(i).update( dt );
    }
    
    for(int i = 0; i < mDudes.size(); i++)
    {
      mDudes.get(i).update( dt );
    }
  }
  
  void constrainMovement( PVector currPos, PVector desiredPos )
  {
    // figure out if the new position is on collision
    boolean onCollision = currCollision.pointInside( desiredPos );
    for(int i = 0; i < currCollision.AdjacentRects.size(); i++)
    {
      onCollision = onCollision || currCollision.AdjacentRects.get(i).pointInside( desiredPos );
    }
    
    // if we aren't on the collision constrain to a collision rect
    if ( onCollision == false )
    {
      for(int i = 0; i < currCollision.AdjacentRects.size(); i++)
      {
        Rectangle collision = currCollision.AdjacentRects.get(i);
        if ( collision.pointInside( currPos ) )
        {
          collision.constrain( desiredPos );
          currCollision = collision;
          return;
        }
      }
      
      if ( currCollision.pointInside( currPos ) )
      {
        currCollision.constrain( desiredPos );
      }   
    }    
  }
  
  void draw()
  {
    rectMode(CORNERS);
    
    // the sky
    pushMatrix();
    {
      translate( cameraOffset, 0, 0 );
      noStroke();
      fill(120, 162, 240);
      rect(0, 0, width, height);
    }
    popMatrix();
    
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
    
    // the ground and horizon
    {
      noStroke();
      fill(105, 122, 144);
      rect( -10, horizonHeight, theGround.getBounds().maxX + 30, height + 10);
      
      Rectangle.Bounds moreBounds = moreGround.getBounds();
      rect( moreBounds.minX - 30, horizonHeight, moreBounds.maxX + 10, height + 10);    
       // horizon line
      strokeWeight(2);
      stroke(179, 183, 188);
      line( -10, horizonHeight, theGround.getBounds().maxX + 30, horizonHeight );
      line( moreBounds.minX - 30, horizonHeight, moreBounds.maxX + 30, horizonHeight );
    }
    
    // the platforms
    {
      noStroke();
      fill(105, 122, 144);
      
      for (int i = 0; i < mPlatforms.size(); i++)
      {
        Rectangle thePlatform = mPlatforms.get(i);
        Rectangle.Bounds plat = thePlatform.getBounds();
        rect( plat.minX, plat.minY, plat.maxX, plat.maxY + 10 );
        
        strokeWeight(2);
        stroke(179, 183, 188);
        line( plat.minX, plat.minY, plat.maxX, plat.minY );
      }
    }
    
    // sidewalk cracks
    {
//      strokeWeight(2);
//      stroke(60, 62, 64);
//      float lineSpacing = 100;
//      float lineSlope = 75;
//      for(int i = 0; i < 20; ++i)
//      {
//        line( lineSlope*i, height, lineSpacing + lineSlope*i, horizonHeight );
//      }      
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
      for(int i = 0; i < mPlatforms.size(); i++)
      {
        mPlatforms.get(i).draw();
      }
    }
    
    for(int i = 0; i < mElevators.size(); i++)
    {
      mElevators.get(i).draw();
    }
    
    // DUDES
    {
      for(int i = 0; i < mDudes.size(); i++)
      {
        mDudes.get(i).draw();
      }
    }
    
    player.draw();
  }
}
