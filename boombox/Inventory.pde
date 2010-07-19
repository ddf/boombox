// all the jams that the player has collected
// this also handles the visualize representation
// which is a box at the top of the screen that slides in and out
class Inventory
{
  // all my jams
  private ArrayList mJams;
  // the jam the mouse is currently over
  private Jam       mCurrentJam;
  
  // how tall the inventory box is
  private float     mHeight = 50.f;
  // Y coord of the bottom of the box
  private float     mBottom = 0.f;
  
  // where we started
  private float     mBegin = 0.f;
  // where we are headed to
  private float     mTarget = 0.f;
  // how long to take to go from begin to target
  private float     mLerpTime = 0.5;
  // how much time has gone by in our lerp
  private float     mCurrTime;
  
  
  // is the mouse inside of us?
  private boolean   mMouseInside;
  
  Inventory()
  {
    mJams = new ArrayList();
    mCurrentJam = null;
    mCurrTime = mLerpTime;
    open();
  }
  
  void update( float dt )
  {
    if ( mCurrTime != mLerpTime )
    {
      mBottom = map( mCurrTime, 0, mLerpTime, mBegin, mTarget );
      mCurrTime += dt;
      if ( mCurrTime >= mLerpTime )
      {
        mCurrTime = mLerpTime;
        mBottom = mTarget;
      }
    }
    
    boolean mouseWasIn = mMouseInside;
    mMouseInside = mouseY < mBottom + 15.f;
    
    mCurrentJam = null;
    if ( mMouseInside )
    {
      for(int i = 0; i < mJams.size(); ++i)
      {
        Jam j = (Jam)mJams.get(i);
        if ( j.pointInside( mouseX, mouseY - mBottom ) )
        {
          mCurrentJam = j;
          break;
        }
      }
      
      if ( mCurrentJam != null )
      {
        if ( mCurrentJam.isPlaying() )
        {
          mouse.setState( Mouse.EJECT );
        }
        else
        {
          mouse.setState( Mouse.PLAY );
        }
      }
      else
      {
        mouse.setState( Mouse.EMPTY );
      }
    }
    
//    if ( mouseWasIn && !mMouseInside )
//    {
//      close();
//    }
//    else if ( !mouseWasIn && mMouseInside )
//    {
//      open();
//    }
  } 
  
  boolean isActive()
  {
    return mMouseInside;
  }
  
  void mouseMoved()
  {

  }
  
  void mousePressed()
  {
    if ( mCurrentJam != null )
    {
      mCurrentJam.queue();
    }
  }
  
  void open()
  {
    mBegin = mBottom;
    mTarget = mHeight;
    mCurrTime = mLerpTime - mCurrTime;
  }
 
  void close()
  {
    mBegin = mBottom;
    mTarget = 0.f;
    mCurrTime = mLerpTime - mCurrTime;
  }
  
  void draw()
  {
    pushMatrix();
    {
      // get into position
      translate( 0, mBottom );
      
      // background
      noStroke();
      fill( 67, 67, 67 );
      rectMode( CORNERS );
      rect( 0, -mHeight, width, 0 );
      
      // jams
      for(int i = 0; i < mJams.size(); ++i)
      {
        Jam j = (Jam)mJams.get(i);
        j.draw();
      }
      
      // dividing line
      stroke( 255, 255, 255 );
      strokeWeight( 2 );
      line( 0, 0, width, 0 );
    }
    popMatrix();
  }
  
  void addJam( Jam j )
  {
    int offset = 40 + mJams.size() * (int)j.getWidth() * 2;
    j.setPos( offset, -mHeight / 2 );
    mJams.add( j );
  }
}
