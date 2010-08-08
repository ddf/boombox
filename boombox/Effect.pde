// you can pick up effects, just like jams, but they make the audio sound different, instead of adding new audio.

PImage EFFECT = null;
PImage EFFECT_ON = null;

void loadEffectImage()
{
  EFFECT = loadImage("Pedal.png");
  EFFECT_ON = loadImage("Pedal_RedLight.png");
}

interface Effect 
{
  void activate();
  void deactivate();
}

class EffectPickup
{
  private PVector mPos;
  private float   mWidth, mHeight, mScale;
  private color   mColor;
  private boolean mIsActive;
  private Effect  mEffect;
  
  EffectPickup( Effect e, float x, float y, color c )
  {
    mPos = new PVector(x, y);
    mWidth = EFFECT.width;
    mHeight = EFFECT.height;
    mScale = 1f;
    mColor = c;
    mIsActive = false;
    mEffect = e;
  }
  
  boolean isActive()
  {
    return mIsActive;
  }
  
  void activate()
  {
    if ( mIsActive == false )
    {
      mIsActive = true;
      mEffect.activate();
    }
  }
  
  void deactivate()
  {
    if ( mIsActive == true )
    {
      mIsActive = false;
      mEffect.deactivate();
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
    return new Rectangle( mPos.x, mPos.y, getWidth(), getHeight(), CENTER, CENTER );
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
    imageMode( CENTER );
    tint( mColor );
    image( EFFECT, mPos.x, mPos.y, getWidth(), getHeight() );
    
    if ( isActive() )
    {
      noTint();
      image( EFFECT_ON, mPos.x, mPos.y, getWidth(), getHeight() );

//      stroke(255);
//      strokeWeight(2);
//      fill(0);
//      rectMode( CENTER );
//      rect( mPos.x, mPos.y, 10, 10 );
    }
  }
}

class LineSweep implements Effect
{
  private Line mLine;
  private float mHi, mLo, mLength;
  
  LineSweep( Line line, float hi, float lo, float len )
  {
    mLine = line;
    mHi = hi;
    mLo = lo;
    mLength = len;
  }
  
  void activate()
  {
    mLine.activate( mLength, mLine.getLastValues()[0], mLo );
  }
  
  void deactivate()
  {
    mLine.activate( 0.2f, mLine.getLastValues()[0], mHi );
  }
}

class Bypasser implements Effect
{
  private Bypass mBypass;
  
  Bypasser( Bypass b )
  {
    mBypass = b;
  }
  
  void activate()
  {
    mBypass.deactivate();
  }
  
  void deactivate()
  {
    mBypass.activate();
  }
}

class SampleRepeat implements Effect
{
  private SampleAndRepeat mSample;
  
  SampleRepeat( SampleAndRepeat sample )
  {
    mSample = sample;
  }
  
  void activate()
  {
    mSample.activate();
  }
  
  void deactivate()
  {
    mSample.deactivate();
  }
}
