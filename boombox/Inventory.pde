// all the jams that the player has collected
// this also handles the visualize representation
// which is a box at the top of the screen that slides in and out
class Inventory
{
  // all my jams
  private ArrayList<Jam> mJams;
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
  
  private float     mTapeScale = 0.75f;
  
  
  // is the mouse inside of us?
  private boolean   mMouseInside;
  
  Inventory()
  {
    mJams = new ArrayList<Jam>();
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
      Iterator<Jam> iter = mJams.iterator();
      while ( iter.hasNext() )
      {
        Jam j = iter.next();
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
        else if ( mCurrentJam.willPlay() == false )
        {
          mouse.setState( Mouse.PLAY );
        }
        else
        {
          mouse.setState( Mouse.EMPTY );
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
      if ( mCurrentJam.isPlaying() || mCurrentJam.willPlay() )
      {
        player.eject();
      }
      else if ( mCurrentJam.willPlay() == false )
      {
        player.play();
      }
      
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
  
  void drawGroup( ArrayList<Jam> group )
  {
    int groupSize = group.size();
    // println("Drawing a group of " + groupSize + " jams.");
    if ( groupSize > 0 )
    {
      fill( 80 );
      noStroke();
      rectMode( CORNERS );
      
      Jam first = group.get(0);
      Jam last = group.get( groupSize - 1 );
      float minX = first.getPos().x - first.getWidth() * 0.5f - 10;
      float minY = first.getPos().y - first.getHeight() * 0.5f - 6;
      float maxX = last.getPos().x + last.getWidth() * 0.5f + 10;
      float maxY = last.getPos().y + last.getHeight() * 0.5f + 6;
     
      rect( minX, minY, maxX, maxY );
      
      for(int i = 0; i < groupSize; i++)
      {
        group.get(i).draw();
      }
      
      group.clear();
    }
    
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
      
      int offset = 30;    
      // jams, guard against concurrent modification
      Jam[] jams = mJams.toArray( new Jam[] {} );
      ArrayList<Jam> group = new ArrayList<Jam>();
      Jam prev = null;
      for( int i = 0; i < jams.length; i++)
      {
        Jam j = jams[i];
        
        // draw a box?
        if ( prev != null && prev.getCategory() != j.getCategory() )
        {
          drawGroup( group );
          offset += 16;
        }
        
        j.setPos( offset, -mHeight / 2 );
        group.add( j );
        
        offset += (int)j.getWidth() * 2 - 4.f;
        prev = j;
      }
      
      drawGroup( group );
      
      // dividing line
      stroke( 255, 255, 255 );
      strokeWeight( 2 );
      line( 0, 0, width, 0 );
    }
    popMatrix();
  }
  
  void addJam( Jam j )
  {
    tapeGet.trigger();
    j.setScale( mTapeScale );
    mJams.add( j );
    Collections.sort( mJams );
  }
}
