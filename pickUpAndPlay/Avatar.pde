// the thing the player controls
class Avatar
{
  private PVector mPos; // where I am
  private PVector mGoal; // where I am going
  private float   mSpeed = 175.f;
  private float   mSize = 20.f;
  
  Avatar()
  {
    mPos = new PVector( width/2, height/2 );
    mGoal = new PVector( mPos.x, mPos.y );
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
    PVector dir = PVector.sub(mGoal, mPos);
    dir.normalize();
    dir.mult( mSpeed * dt );
    mPos.add( dir );
  }
  
  void draw()
  {
    rectMode( CENTER );
    fill( 255, 0, 0 );
    noStroke();
    rect( mPos.x, mPos.y, mSize, mSize );
  }
  
}
