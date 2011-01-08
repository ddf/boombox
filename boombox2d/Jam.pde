// the visual appearance for a Jam

// shared image for all jams
PImage TAPE = null;


float getTapeWidth()
{
  return TAPE.width;
}

float getTapeHeight()
{
  return TAPE.height;
}

class JamImage
{
  private color mTint;
  private PImage mTape;
  private AnimationInstance mTeethTurn;
  private AnimationInstance mTeethStill;
  private AnimationInstance mCurrentAnim;

  JamImage( color c )
  {
    mTint = c;
    mTape = TAPE;
    mTeethTurn = animationSystem.createAnimationInstance( "tapeTeethTurn" );
    mTeethStill = animationSystem.createAnimationInstance( "tapeTeethStill" );
    
    mCurrentAnim = mTeethStill;
  }

  color getColor()
  {
    return mTint;
  }
  
  void update( float dt )
  {
    mCurrentAnim.advance( dt );
  }
  
  void play()
  {
    mCurrentAnim = mTeethTurn;
  }
  
  void pause()
  {
    mCurrentAnim = mTeethStill;
  }

  void draw( float x, float y, float s )
  {
    imageMode( CENTER );
    tint( mTint );
    pushMatrix();
      translate(x,y);
      scale(s);
      image( TAPE, 0, 0, getTapeWidth(), getTapeHeight() );
      tint( 220 );
      mCurrentAnim.draw();
    popMatrix();
  }
}



// a Jam is a cassette tape that the player can collect and then choose to play
class Jam extends UGen 
          implements Comparable<Jam>
{
  private PVector mPos;
  private float   mScale;
  private JamImage mImage;
  private String  mName;
  private float[] mLeftChannel;
  private float[] mRightChannel;
  private int     mSampleNum;
  private boolean mPaused;
  private Rectangle mCollision;
  
  private JamCategory mCategory;

  Jam( String jamName, JamCategory category, color c, float x, float y )
  {
    mPos = new PVector( x, y );
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
  
  Rectangle getCollisionRectangle()
  {
    return new Rectangle( mPos.x, mPos.y, getWidth(), getHeight(), LEFT, TOP ); 
  }

  float getWidth()
  {
    return getTapeWidth() * mScale;
  }
  
  float getHeight()
  {
    return getTapeHeight() * mScale;
  }

  boolean pointInside( float x, float y )
  {
    float hw = getWidth() * 0.5f;
    float hh = getHeight() * 0.5f;
    return ( x > mPos.x - hw && x < mPos.x + hw && y > mPos.y - hh && y < mPos.y + hh );
  }
  
  void update( float dt )
  {
    if ( isPlaying() )
    {
      mImage.play();
    }
    else
    {
      mImage.pause();
    }
    mImage.update( dt );
  }
  
  void drawOnlyImage()
  {
    mImage.draw( mPos.x, mPos.y, mScale );
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
//    else if ( isPlaying() )
//    {
//      fill(0);
//      rectMode( CENTER );
//      rect( mPos.x, mPos.y, 10, 10 );
//    }
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

