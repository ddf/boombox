// an Elevator is an audio-reactive platform
class Elevator
{
  private Rectangle mRect;
  private float     mX, mMinY, mMaxY;
  private EnvelopeFollower mFollower;
  private color mColor;
  
  Elevator( float x, float y, float maxVertDisp, Jam jamToFollow )
  {
    mRect = new Rectangle( x, y - 20, 100, 6, CENTER, TOP );
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
    rectMode(CORNERS);
    stroke(0);
    strokeWeight(2);
    fill(mColor);
    Rectangle.Bounds bounds = mRect.getBounds();
    rect( bounds.minX, bounds.minY, bounds.maxX, bounds.maxY + 20 );
    
    // our "collision"
//    noStroke();
//    fill(0,0,255);
//    mRect.draw();
  }
}
