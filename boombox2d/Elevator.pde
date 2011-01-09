// an Elevator is an audio-reactive platform
class Elevator
{
  private Body mBody; // area inside of which we will bump the player into the air.
  private Rectangle mRect;
  private float     mX, mMinY, mMaxY;
  private EnvelopeFollower mFollower;
  private color mColor;
  
  Elevator( float x, float y, float maxVertDisp, Jam jamToFollow )
  {
    mRect = new Rectangle( x, y, 100, 10, CENTER, TOP );
    gPhysics.setSensor( true );
    Rectangle.Bounds b = mRect.getBounds();
    mBody = gPhysics.createRect( b.minX + 25, b.minY, b.maxX - 25, b.maxY );
    gPhysics.setSensor( false );
    mX = x;
    mMaxY = y;
    mMinY = mMaxY - maxVertDisp;
    mColor = jamToFollow.getColor();
    mFollower = new EnvelopeFollower( 0.05f, 12.0f, 512 ); // attack, release, buffersize
    jamToFollow.patch( mFollower ).patch( envFollowSink );
  }
  
  Rectangle getRect()
  {
    return mRect;
  }
  
  void update( float dt )
  {
    float y = constrain( mMaxY - mFollower.getLastValues()[0] * 10000.f, mMinY, mMaxY );
    
//    PVector playerPos = player.getPos();
//    if ( mRect.pointInside( playerPos ) )
//    {
//      float deltaY = y - mRect.getPos().y;
//      player.setYPos( playerPos.y + deltaY );
//    }
    
    mRect.setPos( mX, y );
    
    if ( y < mMaxY && mBody.isTouching( player.getBody() ) )
    {
      // println("Bumping player!");
      player.applyForce( 0.f, 180000.f );
    }
  }
  
  void draw()
  { 
    rectMode(CORNER);
    Rectangle.Bounds bounds = mRect.getBounds();
//    stroke(0);
//    strokeWeight(2);
//    rect( bounds.minX, bounds.minY, bounds.maxX, bounds.maxY + 10 );

    noStroke();
    float totalWidth = bounds.maxX - bounds.minX;
    float totalHeight = bounds.maxY - bounds.minY;
    float barWidth = (totalWidth - 12) * 0.25f;
    float spacer = 12 / 3;
    for(int i = 0; i < 4; ++i)
    {
      float xOff = i * (barWidth + spacer);
      
      fill(mColor);
      rect( bounds.minX + xOff, bounds.minY, barWidth, totalHeight );
      
      int dark = 34;
      int alph = 128;
      float minX = bounds.minX + xOff;
      float maxX = minX + barWidth;
      float minY = bounds.maxY;
      float maxY = mMaxY + totalHeight;
      beginShape( QUADS );
        fill( mColor, alph );
        vertex( minX, minY );
        fill( mColor, 0 );
        vertex( minX, maxY );
        vertex( maxX, maxY );
        fill( mColor, alph );
        vertex( maxX, minY );
      endShape();
        
      //rect( bounds.minX + xOff, bounds.maxY, barWidth, mMaxY + totalHeight - bounds.maxY );
    }
    
    // our "collision"
    if ( DRAW_COLLISION )
    {
      noStroke();
      fill(COLLISION_COLOR);
      mRect.draw();
    }
  }
}
