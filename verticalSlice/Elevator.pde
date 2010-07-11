// an Elevator is an audio-reactive platform
class Elevator
{
  private Rectangle mRect;
  private float     mX, mMinY, mMaxY;
  private EnvelopeFollower mFollower;
  private color mColor;
  
  Elevator( float x, float y, float maxVertDisp, Jam jamToFollow )
  {
    mRect = new Rectangle( x, y, 100, 20, CENTER, BOTTOM );
    mX = x;
    mMaxY = y;
    mMinY = mMaxY - maxVertDisp;
    mColor = jamToFollow.getColor();
    mFollower = new EnvelopeFollower( 0.05f, 1.0f, 512 ); // attack, release, buffersize
    jamToFollow.getAudio().patch( mFollower ).patch( envFollowSink );
  }
  
  Rectangle getRect()
  {
    return mRect;
  }
  
  void update( float dt )
  {
    float y = constrain( mMaxY - mFollower.getLastValues()[0] * 5000.f, mMinY, mMaxY );
    
    PVector playerPos = player.getPos();
    if ( mRect.pointInside( playerPos ) )
    {
      float deltaY = y - mRect.getPos().y;
      player.setYPos( playerPos.y + deltaY );
    }
    
    mRect.setPos( mX, y );
  }
  
  void draw()
  { 
    stroke(0);
    strokeWeight(2);
    fill(mColor);
    mRect.draw();
  }
}
