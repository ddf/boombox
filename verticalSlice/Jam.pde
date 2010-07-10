// the visual appearance for a Jam

// shared image for all jams
PImage TAPE = null;

  
float getTapeWidth()
{
  return TAPE.width * 0.15f;
}

float getTapeHeight()
{
  return TAPE.height * 0.15f;
}

class JamImage
{
  color mTint;
  
  JamImage( color c )
  {
    mTint = c;
    if ( TAPE == null )
    {
      TAPE = loadImage("pixeltape.gif");
    }
  }
  
  void draw( float x, float y )
  {
    imageMode( CENTER );
    tint( mTint );
    image( TAPE, x, y, getTapeWidth(), getTapeHeight() );
  }
}

// a Jam is a cassette tape that the player can collect and then choose to play
class Jam
{
  private PVector mPos;
  private float   mWidth, mHeight;
  private JamImage mImage;
  private String  mName;
  private AudioRecordingStream mAudio;
  
  Jam( String jamName, color c, float x, float y )
  {
    mPos = new PVector( x, y );
    mWidth = 32.f;
    mHeight = 24.f;
    mImage = new JamImage(c);
    mName = jamName;
    mAudio = minim.loadFileStream(jamName, 512, false);
  }
  
  JamImage getImage()
  {
    return mImage;
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
    mImage.draw( mPos.x, mPos.y );
    
    strokeWeight(2);
    stroke(255,255,255);
    if ( willPlay() )
    {
      line( mPos.x - 5, mPos.y, mPos.x + 5, mPos.y );
      line( mPos.x, mPos.y + 5, mPos.x, mPos.y - 5 );
    }
    else if ( willEject() )
    {
      line( mPos.x - 5, mPos.y, mPos.x + 5, mPos.y );
    }
    else if ( isPlaying() )
    {
      fill(255,255,255);
      triangle( mPos.x - 5, mPos.y - 5, mPos.x - 5, mPos.y + 5, mPos.x + 5, mPos.y );
    }
  }
  
  boolean willPlay()
  {
    return jamSyncer.willJamPlay( mAudio );
  }
  
  boolean willEject()
  {
    return jamSyncer.willJamEject( mAudio );
  } 
  
  boolean isPlaying()
  {
    return jamSyncer.isJamPlaying( mAudio );
  }
  
  void queue()
  {
    jamSyncer.queueJam( mAudio );
  }
}

