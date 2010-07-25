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
  private color mTint;

  JamImage( color c )
  {
    mTint = c;
    if ( TAPE == null )
    {
      TAPE = loadImage("pixeltape.gif");
    }
  }

  color getColor()
  {
    return mTint;
  }

  void draw( float x, float y, float s )
  {
    imageMode( CENTER );
    tint( mTint );
    image( TAPE, x, y, getTapeWidth() * s, getTapeHeight() * s );
  }
}



// a Jam is a cassette tape that the player can collect and then choose to play
class Jam extends UGen 
          implements Comparable<Jam>
{
  private PVector mPos;
  private float   mWidth, mHeight, mScale;
  private JamImage mImage;
  private String  mName;
  private float[] mLeftChannel;
  private float[] mRightChannel;
  private int     mSampleNum;
  private boolean mPaused;
  
  private JamCategory mCategory;

  Jam( String jamName, JamCategory category, color c, float x, float y )
  {
    mPos = new PVector( x, y );
    mWidth = 32.f;
    mHeight = 24.f;
    mScale = 1.f;
    mImage = new JamImage(c);
    mName = jamName;
    mCategory = category;
    
    // extract uncompressed audio
    AudioSample sample = minim.loadSample( jamName );
    mLeftChannel = sample.getChannel( BufferedAudio.LEFT );
    mRightChannel = sample.getChannel( BufferedAudio.RIGHT );
    mSampleNum = 0;
    mPaused = true;
  }
  
  public int compareTo( Jam j )
  {
    return this.mCategory.compareTo( j.mCategory );
  }
  
  JamCategory getCategory()
  {
    return mCategory;
  }

  JamImage getImage()
  {
    return mImage;
  }

  color getColor()
  {
    return mImage.getColor();
  }
  
  void setSampleNum( int n )
  {
    mSampleNum = n;
  }
  
  void setPaused( boolean paused )
  {
    mPaused = paused;
  }
  
  void uGenerate( float[] out )
  {
    if ( mPaused == false )
    {
      out[0] = mLeftChannel[mSampleNum];
      out[1] = mRightChannel[mSampleNum];
      mSampleNum++;
      if ( mSampleNum == mLeftChannel.length )
      {
        mSampleNum = 0;
      }
    }
    else
    {
      out[0] = 0;
      out[1] = 0;
    }
  }

  void setPos( float x, float y )
  {
    mPos.set( x, y, 0 );
  }

  PVector getPos()
  {
    return mPos;
  }
  
  void setScale( float s )
  {
    mScale = s;
  }

  float getWidth()
  {
    return mWidth * mScale;
  }
  
  float getHeight()
  {
    return mHeight * mScale;
  }

  boolean pointInside( float x, float y )
  {
    float hw = getWidth() * 0.5f;
    float hh = getHeight() * 0.5f;
    return ( x > mPos.x - hw && x < mPos.x + hw && y > mPos.y - hh && y < mPos.y + hh );
  }

  void draw()
  {
    mImage.draw( mPos.x, mPos.y, mScale );

    strokeWeight(2);
    stroke(255,255,255);
    if ( willPlay() )
    {
      strokeWeight(1);
      fill(0);
      float scount = jamSyncer.getSampleCount() + (jamSyncer.getMeasureCount() % 4) * jamSyncer.getLength();
      float totalSamp = jamSyncer.getLength() * 4;
      // println("scount = " + scount + " and totalSamp is " + totalSamp);
      float angle = map( scount, 0, totalSamp, 0, radians(360) );
      arc( mPos.x, mPos.y, 20, 20, -PI/2, -PI/2 + angle );
      strokeWeight(2);
      line( mPos.x - 5, mPos.y, mPos.x + 5, mPos.y );
      line( mPos.x, mPos.y + 5, mPos.x, mPos.y - 5 );
    }
    else if ( willEject() )
    {
      line( mPos.x - 5, mPos.y, mPos.x + 5, mPos.y );
    }
    else if ( isPlaying() )
    {
      fill(0);
      rectMode( CENTER );
      rect( mPos.x, mPos.y, 10, 10 );
    }
  }

  boolean willPlay()
  {
    return jamSyncer.willJamPlay( this );
  }

  boolean willEject()
  {
    return jamSyncer.willJamEject( this );
  } 

  boolean isPlaying()
  {
    return jamSyncer.isJamPlaying( this );
  }

  void queue()
  {
    jamSyncer.queueJam( this );
  }
}

