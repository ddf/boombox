// a Jam is a cassette tape that the player can collect and then choose to play
class Jam
{
  private PVector mPos;
  private float   mWidth, mHeight;
  private String  mName;
  private AudioPlayer mAudio;
  
  Jam( String jamName, float x, float y )
  {
    mPos = new PVector( x, y );
    mWidth = 18.f;
    mHeight = 8.f;
    mName = jamName;
    // don't load the player until we actually want to play it.
    mAudio = null;
  }
  
  void setPos( float x, float y )
  {
    mPos.set( x, y, 0 );
  }
  
  PVector getPos()
  {
    return mPos;
  }
  
  float getWidth()
  {
    return mWidth;
  }
  
  boolean pointInside( float x, float y )
  {
    float hw = mWidth * 0.5f;
    float hh = mHeight * 0.5f;
    return ( x > mPos.x - hw && x < mPos.x + hw && y > mPos.y - hh && y < mPos.y + hh );
  }
  
  void draw()
  {
    rectMode( CENTER );
    if ( mAudio != null && mAudio.isPlaying() )
    {
      stroke( 255, 255, 255 );
    }
    else
    {
      noStroke();
    }
    fill( 0, 255, 0 );
    rect( mPos.x, mPos.y, mWidth, mHeight );
  }
  
  void play()
  {
    println("Playing " + mName);
    mAudio = minim.loadFile( mName );
    mAudio.loop();
  }
  
  void eject()
  {
    mAudio.pause();
    mAudio.close();
    mAudio = null;
  }
}

