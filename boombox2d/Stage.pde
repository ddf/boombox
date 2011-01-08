// the graphics for the environment
class Stage
{ 
  Rectangle theGround;
  Rectangle moreGround;

  PImage theSky;
  float  mSkyAlpha = 0;
  
  PImage groundTex;

  // all the elevators in the level
  ArrayList<Elevator> mElevators;
  ArrayList<Speaker> mSpeakers;
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
    mFFT = new FFT( mainOut.bufferSize(), mainOut.sampleRate() );
    mFFT.logAverages( 11, 2 );

    theSky = loadImage("bg_01.png");
    groundTex = loadImage("ground_02.png");

    mElevators = new ArrayList<Elevator>();
    mPlatforms = new ArrayList<Rectangle>();
    mDudes = new ArrayList<Dude>();
    mCollision = new ArrayList<Rectangle>();
    mSpeakers = new ArrayList<Speaker>();

    float topOfGround = horizonHeight + 5;

    theGround = new Rectangle( 0, topOfGround + 8, 2150, height - horizonHeight - 15, LEFT, TOP );
    moreGround = new Rectangle( 2400, topOfGround + 8, 1500, height - horizonHeight - 15, LEFT, TOP );

    mCollision.add( theGround );
    mCollision.add( moreGround );

    currCollision = theGround;

    { 
      allJams.get(1).setPos( 230, 410 );

      Dude dude = new Dude( 410, 420, new Jam[] { 
        allJams.get(1)
      }
      , allJams.get(2) );
      mDudes.add( dude );

      // this goes on the platform
      allJams.get(3).setPos( 440, 150 );
      Rectangle platform = makePlatform( 400, 160, 460 );
      Elevator elevator = new Elevator( 910, topOfGround, topOfGround - 160, allJams.get(2) ); 

      connect( theGround, elevator );
      connect( elevator, platform );

      mElevators.add( elevator );

      mCollision.add( elevator.getRect() );

      mSpeakers.add( new Speaker( 455, topOfGround, 0.66f ) );
      mSpeakers.add( new Speaker( 805, topOfGround, 0.66f ) );
    }

    {
      Dude dudeGround = new Dude( 1030, 450, new Jam[] { allJams.get(3) }, allJams.get(4) );
      Dude dudePlatform = new Dude( 1500, 220, new Jam[] { allJams.get(2), allJams.get(4) }, allJams.get(6) );
      mDudes.add( dudeGround );
      mDudes.add( dudePlatform );

      allJams.get(5).setPos( 1500, 450 );

      Rectangle platform = makePlatform( 1200, 220, 400 );
      Elevator elevLeft = new Elevator( 1150, topOfGround, topOfGround - 220, allJams.get(4) );
      Elevator elevRight = new Elevator( 1650, topOfGround, topOfGround - 220, allJams.get(4) );

      connect( theGround, elevLeft );
      connect( elevLeft, platform );
      connect( platform, elevRight );
      connect( elevRight, theGround );

      mElevators.add( elevLeft );
      mElevators.add( elevRight );

      mCollision.add( elevLeft.getRect() );
      mCollision.add( elevRight.getRect() );

      mSpeakers.add( new Speaker( 1255, topOfGround, 0.41f ) );
      mSpeakers.add( new Speaker( 1545, topOfGround, 0.41f ) );
    }

    {
      allJams.get(11).setPos( 2000, 400 );

      Rectangle platform = makePlatform( 2100, 220, 350 );
      Elevator elevLeft = new Elevator( 2050, topOfGround, topOfGround - 220, allJams.get(5) );
      Elevator elevRight = new Elevator( 2500, topOfGround, topOfGround - 220, allJams.get(5) );

      connect( theGround, elevLeft );
      connect( elevLeft, platform );
      connect( platform, elevRight );
      connect( elevRight, moreGround );

      mElevators.add( elevLeft );
      mElevators.add( elevRight );

      mCollision.add( elevLeft.getRect() );
      mCollision.add( elevRight.getRect() );

      mSpeakers.add( new Speaker( 2145, topOfGround, 0.41f ) );
      mSpeakers.add( new Speaker( 2405, topOfGround, 0.41f ) );
    }

    {
      allJams.get(8).setPos( 2850, 400 );

      Dude dudeGround = new Dude( 2550, 470, new Jam[] { allJams.get(3), allJams.get(6), allJams.get(8) }, allJams.get(7) );
      Dude dudePlatform = new Dude( 3075, 225, new Jam[] { allJams.get(9), allJams.get(2), allJams.get(11), allJams.get(4), allJams.get(8) }, allJams.get(12) );

      mDudes.add( dudeGround );
      mDudes.add( dudePlatform );

      float leftPlatWidth = 2900 - 2675;
      Rectangle leftPlat = makePlatform( 2675, 125, leftPlatWidth );
      Rectangle rightPlat = makePlatform( 3000, 225, 150 );

      Elevator elevLow = new Elevator( 2625, topOfGround, topOfGround - 125, allJams.get(10) );
      Elevator elevHigh = new Elevator( 2950, 223, 102, allJams.get(7) );

      connect( moreGround, elevLow );
      connect( elevLow, leftPlat );
      connect( leftPlat, elevHigh );
      connect( elevHigh, rightPlat );

      mElevators.add( elevLow );
      mElevators.add( elevHigh );

      mCollision.add( elevLow.getRect() );
      mCollision.add( elevHigh.getRect() );

      mSpeakers.add( new Speaker( 2675 + leftPlatWidth * 0.5f, topOfGround, 0.8f ) );
      mSpeakers.add( new Speaker( 3075, topOfGround, 0.39f ) );
    }

    {
      allJams.get(9).setPos( 3750, 120 );

      Dude dude = new Dude( 3675, 450, new Jam[] { allJams.get(4), allJams.get(5), allJams.get(3) }, allJams.get(10) );

      mDudes.add( dude );

      Rectangle leftPlat = makePlatform( 3400, 225, 150 );
      Rectangle rightPlat = makePlatform( 3650, 125, 150 );

      Elevator elevLow = new Elevator( 3350, topOfGround, topOfGround - 225, allJams.get(1) );
      Elevator elevHigh = new Elevator( 3600, 225, 100, allJams.get(6) );

      connect( moreGround, elevLow );
      connect( elevLow, leftPlat );
      connect( leftPlat, elevHigh );
      connect( elevHigh, rightPlat );

      mElevators.add( elevLow );
      mElevators.add( elevHigh );

      mCollision.add( elevLow.getRect() );
      mCollision.add( elevHigh.getRect() );

      mSpeakers.add( new Speaker( 3425, topOfGround, 0.39f ) );
      mSpeakers.add( new Speaker( 3525, topOfGround, 0.39f ) );
      mSpeakers.add( new Speaker( 3725, topOfGround, 0.8f ) );
    }
  }

  Rectangle makePlatform( float x, float y, float w )
  {
    Rectangle platform = new Rectangle( x, y, w, 8, LEFT, TOP );
    mPlatforms.add( platform );
    mCollision.add( platform );

    return platform;
  }

  private void connect( Rectangle a, Rectangle b )
  {
    a.AdjacentRects.add( b );
    b.AdjacentRects.add( a );
  }

  private void connect( Elevator e, Rectangle b )
  {
    connect( e.getRect(), b );
  }

  private void connect( Rectangle a, Elevator e )
  {
    connect( a, e.getRect() );
  }


  void update( float dt )
  {
    if ( inventory.isFull() && mSkyAlpha < 255 )
    {
      mSkyAlpha += 64 * dt;
    }
    
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

      currCollision.constrain( desiredPos );
    }
  }

  void draw()
  {
    rectMode(CORNERS);

    // the sky
    pushMatrix();
    if ( inventory.isFull() )
    { 
      translate( gameplayScreen.cameraOffset, 0, 0 );
      tint(255, mSkyAlpha);
      imageMode(CORNER);
      image(theSky, 0, 0, width, height);
    }
    popMatrix();

    // waveform in the sky
    {
      stroke(255, 0, 162, 128);
      strokeWeight(2);
      float waveCenter = 200;
      float sampleWidth = 8;
      float sampleSpacing = 0;
      for(int i = 0; i < mainOut.bufferSize() - 1; ++i)
      {
        float x1 = i * (sampleWidth + sampleSpacing);
        float x2 = x1 + sampleWidth;
        float y1 = waveCenter - mainOut.mix.get(i) * 100;
        float y2 = waveCenter - mainOut.mix.get(i+1) * 100;
        line(x1, y1, x2, y2);
      }
    }

    rectMode(CENTER);

    // equalizer river
    //if ( false )
    {
      mFFT.forward( mainOut.mix );

      float startX = theGround.getBounds().maxX + 20;
      float endX = moreGround.getBounds().minX - 20;
      int totalAverages = 12;
      float totalWidth = endX - startX;
      float spacerTotal = 12;
      float waveWidth = (totalWidth - spacerTotal) / (totalAverages/2);
      float spacerSize = spacerTotal / (totalAverages/2);

      float minY = theGround.getBounds().minY + 20;

      // evens first
      int evens = totalAverages/2;
      for(int i = 0; i < evens; ++i )
      {
        float xOff = i * (waveWidth + spacerSize);

        float minX = startX + xOff;
        float maxX = minX + waveWidth;
        float topY = minY - mFFT.getAvg(i) * random(0.2f, 0.3f);
        float bottomY = height;

        noStroke();
        beginShape(QUADS);
          fill( 0, 0, 200 );
          vertex( minX, topY );
          fill( 0, 0, 100 );
          vertex( minX, bottomY );
          vertex( maxX, bottomY );
          fill( 0, 0, 200 );
          vertex( maxX, topY );
        endShape();

        stroke( 200 );
        strokeWeight( 2 );
        line( minX, topY, maxX, topY );
      }
      
      minY += 20;
      
      // odds on top
      int odds = totalAverages/2 - 1;
      for(int i = 0; i < odds; ++i )
      {
        float xOff = i * (waveWidth + spacerSize);

        float minX = startX + (waveWidth*0.5f) + xOff;
        float maxX = minX + waveWidth;
        float topY = minY - mFFT.getAvg(i + evens) * random(0.3f, 0.4f);
        float bottomY = height;

        noStroke();
        beginShape(QUADS);
          fill( 0, 0, 200 );
          vertex( minX, topY );
          fill( 0, 0, 100 );
          vertex( minX, bottomY );
          vertex( maxX, bottomY );
          fill( 0, 0, 200 );
          vertex( maxX, topY );
        endShape();

        stroke( 200 );
        strokeWeight( 2 );
        line( minX, topY, maxX, topY );
      }
      
      
      
    }

    rectMode(CORNERS);

    // the ground and horizon
    {
      //      noStroke();
      //      fill(105, 122, 144);
      //      rect( -10, horizonHeight, theGround.getBounds().maxX + 30, height + 10);
      //      
      Rectangle.Bounds moreBounds = moreGround.getBounds();
      //      rect( moreBounds.minX - 30, horizonHeight, moreBounds.maxX + 10, height + 10);

      noFill();
      noStroke();
      float lowY = horizonHeight;
      float hiY = horizonHeight + groundTex.height;
      beginShape(QUADS);
      texture( groundTex );
      textureMode( NORMALIZED );
      tint(105, 122, 144);
      // first ground
      for( int x = -10; x < theGround.getBounds().maxX + 30; x += groundTex.width )
      {
        vertex(x, lowY, 0, 0);
        vertex(x, hiY, 0, 1);
        vertex(x + groundTex.width, hiY, 1, 1);
        vertex(x + groundTex.width, lowY, 1, 0);
      }

      // second ground
      for( float x = moreGround.getBounds().minX - 30; x < moreGround.getBounds().maxX + 30; x += groundTex.width )
      {
        vertex(x, lowY, 0, 0);
        vertex(x, hiY, 0, 1);
        vertex(x + groundTex.width, hiY, 1, 1);
        vertex(x + groundTex.width, lowY, 1, 0);
      }

      endShape();

      // horizon line
      strokeWeight(2);
      stroke(0);
      line( -10, horizonHeight, theGround.getBounds().maxX + 34, horizonHeight );
      line( moreBounds.minX - 30, horizonHeight, moreBounds.maxX + 30, horizonHeight );
    }

    // the speakers
    {
      for(int i = 0; i < mSpeakers.size(); ++i)
      {
        mSpeakers.get(i).draw();
      }
    }

    // the platforms
    {

      for (int i = 0; i < mPlatforms.size(); i++)
      {
        Rectangle thePlatform = mPlatforms.get(i);
        Rectangle.Bounds plat = thePlatform.getBounds();
        float lowY = plat.minY;
        float hiY = plat.maxY + 10;
        float v = 22f;

        noStroke();
        tint(105, 122, 144);
//        fill(105, 122, 144);
//        rect( plat.minX, plat.minY, plat.maxX, plat.maxY + 10 );

        beginShape(QUADS);
        texture(groundTex);
        textureMode(IMAGE);
        for( float x = plat.minX; x < plat.maxX; x += groundTex.width )
        {
          float w = groundTex.width;
          if ( x + w > plat.maxX )
          {
            w = plat.maxX - x;
          }
          vertex(x, lowY, 0, 0);
          vertex(x, hiY, 0, v);
          vertex(x + w, hiY, w, v);
          vertex(x + w, lowY, w, 0);
        }
        endShape();

        // line across the top
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

    // sort DUDES and Player
    {
      ArrayList<Dude> dudesBehind = new ArrayList<Dude>();
      ArrayList<Dude> dudesInFront = new ArrayList<Dude>();
      for(int i = 0; i < mDudes.size(); i++)
      {
        if ( mDudes.get(i).getPos().y <= player.getPos().y )
        {
          dudesBehind.add( mDudes.get(i) );
        }
        else
        {
          dudesInFront.add( mDudes.get(i) );
        }
      }

      for(int i = 0; i < dudesBehind.size(); i++)
      {
        dudesBehind.get(i).draw();
      }
      player.draw();
      for(int i = 0; i < dudesInFront.size(); i++)
      {
        dudesInFront.get(i).draw();
      }
    }

    // finally shadow pass
    if ( false )
    {
      for(int i = 0; i < mSpeakers.size(); ++i)
      {
        mSpeakers.get(i).drawShadow();
      }
    }
  }
}

