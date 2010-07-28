// the thing the player controls
class Avatar
{
  private PVector mPos; // where I am
  private PVector mGoal; // where I am going
  private float   mSpeed = 175.f;
  private float   mSize = 64.f;
  private int     mXDir = 0;
  private int     mYDir = 0;   
  private float   mScale = 1.f;
  private AnimationSet mAnims;
  
  Avatar( float xPos, float yPos )
  {
    mPos = new PVector( xPos, yPos );
    mGoal = new PVector( mPos.x, mPos.y );
    mAnims = new AnimationSet( animationSystem, new String[] { "idle", "walk", "collect", "play", "eject", "jamming" } );
    mAnims.setAnimation( "idle" );
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
  
  float getSize()
  {
    return mSize;
  }
  
  void update( float dt )
  { 
    String currentAnim = mAnims.currentAnimationName();
    
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
        mAnims.setAnimation( "idle" );
      }
      else
      {
        mAnims.setAnimation( "walk" );
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
      translate( mPos.x, mPos.y - mAnims.currentAnimation().height() / 2.f );
      scale( mScale, 1 );
      mAnims.draw();
    }
    popMatrix();
  }
  
  void collect()
  {
    mAnims.setAnimation( "collect", "idle" );
  }
  
  void play()
  {
    mAnims.setAnimation( "play", "idle" );
  }
  
  void eject()
  {
    mAnims.setAnimation( "eject", "idle" );
  }
  
  void jam()
  {
    mAnims.setAnimation( "jamming" );
  }
  
  void idle()
  {
    mAnims.setAnimation( "idle" );
  }
  
  
}
