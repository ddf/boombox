// the thing the player controls
class Avatar
{
  private PVector mPos; // where I am
  private PVector mGoal; // where I am going
  private float   mSpeed = 175.f;
  private int     mXDir = 0;
  private int     mYDir = 0;   
  private float   mScale = 1.f;
  private AnimationStateMachine mAnims;
  
  Avatar( float xPos, float yPos )
  {
    mPos = new PVector( xPos, yPos );
    mGoal = new PVector( mPos.x, mPos.y );
    mAnims = new AnimationStateMachine( animationSystem, new XMLElement( boombox.this, "animation/player.xml" ) );
  }
  
  void setXDir( int dir )
  {
    if ( mXDir != dir )
    { 
      mXDir = dir;
      
      if ( mXDir < 0 )
      {
        mScale = -1.f;
      }
      else if ( mXDir > 0 )
      {
        mScale = 1.f;
      }
    }
  }
  
  void setYDir( int dir )
  {
    if ( mYDir != dir )
    { 
      mYDir = dir;
    }
  }
  
  void setGoal( float x, float y )
  {
    mGoal.set( x, y, 0 );
  }
  
  void clearGoal()
  {
    mGoal.set( mPos.x, mPos.y, 0 );
  }
  
  void setYPos( float y )
  {
    mPos.y = y;
  }
  
  PVector getPos()
  {
    return new PVector( mPos.x, mPos.y );
  }
  
  Rectangle getCollisionRectangle()
  {
    return new Rectangle( mPos.x, mPos.y, getWidth() * 0.8f, getHeight() * 0.8f, CENTER, BOTTOM );
  }
  
  float getWidth()
  {
    return mAnims.currentAnimation().width();
  }
  
  float getHeight()
  {
    return mAnims.currentAnimation().height();
  }
  
  void update( float dt )
  { 
    String currentAnim = mAnims.getCurrentStateName();
    
    if ( currentAnim.equals( "idle" ) || currentAnim.equals( "walk" ) )
    {
      PVector dir = new PVector( mXDir, mYDir );
      dir.normalize();
      dir.mult( mSpeed * dt );
     
      // where we hope to wind up
      PVector newPos = new PVector( mPos.x + dir.x, mPos.y + dir.y );
      
      theStage.constrainMovement( mPos, newPos );
      
      if ( mPos.x == newPos.x && mPos.y == newPos.y )
      {
        mAnims.sendEvent( "idle" );
      }
      else
      {
        mAnims.sendEvent( "walk" );
      }
      
      mPos.set( newPos );
      
    }
    
    mAnims.update( dt );
  }
  
  void draw()
  {
    pushMatrix();
    {
      imageMode( CENTER ); 
      tint(255);
      translate( mPos.x, mPos.y  - mAnims.currentAnimation().height() / 2.f );
      scale( mScale, 1 );
      mAnims.draw();
      
    }
    popMatrix();
  }
  
  void collect()
  {
    // println("collect");
    tapeGet.trigger();
    mAnims.sendEvent( "collect" );
  }
  
  void play()
  {
    mAnims.sendEvent( "play" );
  }
  
  void eject()
  {
    mAnims.sendEvent( "eject" );
  }
  
  void jam()
  {
    // println("Player going to Jam!");
    mAnims.sendEvent( "jam" );
  }
  
  boolean isJamming()
  {
    return mAnims.getCurrentStateName().equals( "jam" );
  }
  
  void idle()
  {
    mAnims.sendEvent( "idle" );
  }
  
  
}
