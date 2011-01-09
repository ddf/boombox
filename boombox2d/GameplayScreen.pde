class GameplayScreen
{
  // where my camera at
  float cameraPosition = 0;

  // what is my camera's offset from where it started?
  float cameraOffset = 0;
  
  ArrayList<Star> mStars;
  
  GameplayScreen()
  {
      cameraPosition = width/2;
      mStars = new ArrayList<Star>();
  }
  
  void addStar(float x, float y)
  {
    mStars.add( new Star(x, y) );
  }
  
  void update( float dt )
  {
    noCursor();

    if ( inventory.isActive() == false && mousePressed )
    {
      doMouseMove();
    }
  
    theStage.update( dt );
    player.update( dt );
    inventory.update( dt );
    
    Iterator<Star> iter = mStars.iterator();
    while( iter.hasNext() )
    {
      if ( iter.next().update(dt) )
      {
        iter.remove();
      }
    }
  
    float playerX = player.getPos().x;
    float distToCamera = abs( playerX - cameraPosition );
    float cameraSpeed = 175;
    if ( distToCamera < 100 )
    {
      if ( playerX < cameraPosition )
      {
        cameraPosition += cameraSpeed * dt;
      }
      else
      {
        cameraPosition -= cameraSpeed * dt;
      }
    }
    else if ( distToCamera > 200 )
    {
      if ( playerX < cameraPosition )
      {
        cameraPosition -= cameraSpeed * dt;
      }
      else
      {
        cameraPosition += cameraSpeed * dt;
      }
    }
  
    cameraPosition = constrain( cameraPosition, width/2, theStage.moreGround.getBounds().maxX - width/2 );
    cameraOffset = cameraPosition - width/2;
  }
  
  void draw()
  {
    float lowPassCut = lowPass.frequency();
    float r = map( lowPassCut, lowPassCutoffHi, lowPassCutoffLo, 24, 0 );
    float g = r;
    float b = map( lowPassCut, lowPassCutoffHi, lowPassCutoffLo, 24, 60 );
    
    background( r, g, b );
    
    //  camara viz
    //  fill(255,0,0);
    //  noStroke();
    //  rectMode(CENTER);
    //  rect( cameraPosition, height/2.0, 5, 5 );
  
    camera( cameraPosition, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), cameraPosition, height/2.0, 0, 0, 1, 0);
  
    if ( false )
    {
      fill(0, 64);
      rectMode(CORNER);
      rect( cameraOffset - 5, 0, width + 5, height );
    }
  
    // will also draw the player sorted properly with stage elements
    theStage.draw();
  
    Iterator<Jam> iter = worldJams.iterator();
    while ( iter.hasNext() )
    {
      Jam j = iter.next();
  
      if ( player.getBody().isTouching( j.getBody() ) )
      {
        iter.remove();
        // pick it up.
        j.destroyBody();
        inventory.addJam( j );
        player.collect();
      }
      else
      {
        j.draw();
      }
    }
  
    Iterator<EffectPickup> eiter = worldEffects.iterator();
    while( eiter.hasNext() )
    {
      EffectPickup e = eiter.next();
  
//      if ( player.getCollisionRectangle().collidesWith( e.getCollisionRectangle() ) )
//      {
//        eiter.remove();
//        inventory.addEffect( e );
//        player.collect();
//      }
//      else
      {
        e.draw();
      }
    }
    
    Iterator<Star> siter = mStars.iterator();
    while( siter.hasNext() )
    {
      siter.next().draw();
    }
    
    // gPhysics.defaultDraw( gPhysics.getWorld() );
  
    translate( cameraPosition - width/2, 0, 0 );
  
    // jams we can play  
    inventory.draw();
  
    // mouse appearance
    mouse.draw();
  }
  
  void mousePressed()
  {
    inventory.mousePressed();
  }
  
  void mouseReleased()
  {
    player.setXDir( 0 );
    player.setYDir( 0 );
  }
  
  void mouseMoved()
  {
    inventory.mouseMoved();
  }
  
  void doMouseMove()
  {
    float mouseX = boombox2d.this.mouseX;
    float mouseY = boombox2d.this.mouseY;
    
    PVector pos = player.getPos();
    if ( cameraOffset + mouseX < pos.x - player.getWidth() * 0.4f )
    {
      player.setXDir( -1 );
    }
    else if ( cameraOffset + mouseX > pos.x + player.getWidth() * 0.4f )
    {
      player.setXDir( 1 );
    }
    else
    {
      player.setXDir( 0 );
    }
  
    if ( mouseY < pos.y - player.getHeight() )
    {
      player.setYDir( -1 );
    }
    else if ( mouseY > pos.y )
    {
      player.setYDir( 1 );
    }
    else
    {
      player.setYDir( 0 );
    }
  }
  
  void keyPressed()
  {
    char key = boombox2d.this.key;
    if ( key != PApplet.CODED )
    {
      if ( key == 'd' || key == 'D' )
      {
        player.setXDir( 1 );
      }
      else if ( key == 'a' || key == 'A' )
      {
        player.setXDir( -1 );
      }
      else if ( key == 'w' || key == 'W' )
      {
        player.setYDir( -1 );
      }
      else if ( key == 's' || key == 'S' )
      {
        player.setYDir( 1 );
      }
      else if ( (key == 'r' || key == 'R')  && sampleRepeat.isActive() == false )
      {
        sampleRepeat.activate();
      }
      else if ( key == 'f' || key == 'F' )
      {
        if ( filterOn == false )
        {
          println(" Activating Low Pass Sweep!");
          lowPassCutoff.activate( lowPassCutoffSweepLength, lowPassCutoff.getLastValues()[0], lowPassCutoffLo );
          filterOn = true;
        }
      }
      else if ( key == 'g' || key == 'G' )
      {
        if ( granulateBypass.isActive()  )
        {
          granulateBypass.deactivate();
        }
      }
    }
  }
  
  void keyReleased()
  {
    char key = boombox2d.this.key;
    if ( key != PApplet.CODED )
    {
      if ( key == 'd' || key == 'D' )
      {
        player.setXDir( 0 );
      }
      else if ( key == 'a' || key == 'A' )
      {
        player.setXDir( 0 );
      }
      else if ( key == 'w' || key == 'W' )
      {
        player.setYDir( 0 );
      }
      else if ( key == 's' || key == 'S' )
      {
        player.setYDir( 0 );
      }
      else if ( key == 'r' || key == 'R' )
      {
        sampleRepeat.deactivate();
      }
      else if ( key == 'f' || key == 'F' )
      {
        lowPassCutoff.activate( 0.2f, lowPassCutoff.getLastValues()[0], lowPassCutoffHi );
        filterOn = false;
      }
      else if ( key == 'g' || key == 'G' )
      {
        granulateBypass.activate();
      }
    }
  }
}
