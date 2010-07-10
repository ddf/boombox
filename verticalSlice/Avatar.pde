// the thing the player controls
class Avatar
{
  private PVector mPos; // where I am
  private PVector mGoal; // where I am going
  private float   mSpeed = 175.f;
  private float   mSize = 64.f;
  private int     mXDir = 0;
  private int     mYDir = 0;   
  
  Avatar( float xPos, float yPos )
  {
    mPos = new PVector( xPos, yPos );
    mGoal = new PVector( mPos.x, mPos.y );
  }
  
  void setXDir( int dir )
  {
    mXDir = dir;
  }
  
  void setYDir( int dir )
  {
    mYDir = dir;
  }
  
  void setGoal( float x, float y )
  {
    mGoal.set( x, y, 0 );
  }
  
  void clearGoal()
  {
    mGoal.set( mPos.x, mPos.y, 0 );
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
    PVector dir = new PVector( mXDir, mYDir );
    dir.normalize();
    dir.mult( mSpeed * dt );
    mPos.add( dir );
    mPos.x = constrain( mPos.x, 0, width );
    mPos.y = constrain( mPos.y, theStage.horizonHeight + 5, height - 5 ); 
  }
  
  void draw()
  {
    rectMode( CENTER );
    fill( 255, 0, 0 );
    noStroke();
    rect( mPos.x, mPos.y - mSize * 0.5f, mSize, mSize );
  }
  
}
