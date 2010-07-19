// a Dude is someone who you can Jam with
class Dude implements LoopListener
{
  // our visible rectangle
  private Rectangle mRect;
  // have to be inside this one to jam
  private Rectangle mJamArea;
  // the jams this dude wants to jam with
  private Jam[]   mWantToHear;
  // the jam this dude will play and then give away
  private Jam     mMyJam;
  // have I already jammed?
  boolean         mJammed;
  // how many times my jam has looped
  private int     mLoops;
  // is the mouse over me?
  boolean         mMousedOver;
  // is the player close enough to click on me?
  boolean         mCanClick;
  
  // abusing a wavefor for down and dirty animation
  Wavetable mAnimCurve;
  // where in the wave for we look for our position offset
  float     mAnimCurveStep;
  // which animation to do 
  int       mAnimation;
  
  // different animations
  static final int IDLE = 0;
  static final int SHAKE = 1;
  static final int JUMP = 2;
  
  Dude( float x, float y, Jam[] wantToHear, Jam toPlay )
  {
    mRect = new Rectangle( x, y, 64, 64, CENTER, BOTTOM );
    mJamArea = new Rectangle( x, y, 256, 64, CENTER, CENTER );
    mWantToHear = wantToHear;
    mMyJam = toPlay;
    
    mJammed = false;
    mLoops = 0;
    
    mAnimCurve = Waves.TRIANGLE;
    mAnimCurveStep = 1.f;
    mAnimation = IDLE;
  }
  
  PVector getPos()
  {
    return mRect.getPos();
  }
  
  void update( float dt )
  {
    if ( inventory.isActive() == false )
    {
      mMousedOver = false;
      mouse.setState( Mouse.EMPTY );
      if ( mJammed == false && mAnimCurveStep == 1.f )
      {
        mCanClick = mJamArea.pointInside( player.getPos() );
        
        if ( mCanClick && mRect.pointInside( mouseX + cameraOffset, mouseY ) )
        {
          mMousedOver = true;
          mouse.setState( Mouse.JAM );
        }
      }
    }
    
    if ( mAnimCurveStep < 1.f )
    {
      mAnimCurveStep += 6.f * dt;
      if ( mAnimCurveStep > 1.f )
      {
        mAnimCurveStep = 1.f;
        mAnimation = IDLE;
      }
    }
  }
  
  void mousePressed()
  {
    if ( mMousedOver )
    {
      for(int i = 0; i < mWantToHear.length; ++i)
      {
        // bail if the player isn't playing something I want to hear
        if ( mWantToHear[i].isPlaying() == false )
        {
          println("Something I want to hear isn't playing!");
          // trigger the head shake anim
          mAnimCurveStep = 0.f;
          mAnimation = SHAKE;
          return;   
        }
      }
      
      // yes all good
      mJammed = true;
      mAnimCurveStep = 0.f;
      mAnimation = JUMP;
      mMyJam.queue();
      jamSyncer.addLoopListener( this );
    }
  }
  
  void looped()
  {
    mLoops++;
    if ( mLoops == 2 )
    {
      inventory.addJam( mMyJam );
      mMyJam = null;
      jamSyncer.removeLoopListener( this );
    }
  }
  
  void draw()
  {
    
    noStroke();
    fill(0, 255, 0);
    
    pushMatrix();
    {
      if ( mAnimation == SHAKE )
      {
        translate( mAnimCurve.value( mAnimCurveStep ) * 5.f, 0 );
      }
      else 
      if ( mAnimation == JUMP )
      {
        translate( 0, abs( mAnimCurve.value( mAnimCurveStep ) ) * -10.f );
      }
      mRect.draw();
    }
    popMatrix();
    
//    fill(0, 64);
//    mJamArea.draw();
    
    if ( mMyJam != null )
    {
      PVector pos = mRect.getPos();
      
      rectMode(CENTER);
      
      stroke(0);
      strokeWeight(2);
      fill(255);
      rect( pos.x + 5, pos.y - 75, 5, 5 );
      rect( pos.x + 15, pos.y - 95, 10, 10 );
      
      float bubbleWidth = getTapeWidth() * mWantToHear.length + 20;
      float bubbleHeight = getTapeHeight() + 30;
      float bubbleCenterY = pos.y - 140;
      rect( pos.x, bubbleCenterY, bubbleWidth, bubbleHeight );
      
      // these are the tapes in the bubble
      if ( mJammed == false )
      {
        float startX = pos.x - (bubbleWidth*0.5f) + (getTapeWidth()*0.5f) + 8;
        for(int i = 0; i < mWantToHear.length; i++)
        {
          JamImage img = mWantToHear[i].getImage();
          float offsetX = i * (getTapeWidth()+5);
          img.draw( startX + offsetX, bubbleCenterY );
        }
      }
      else
      {
        mMyJam.setPos( pos.x, bubbleCenterY );
        mMyJam.draw();
      }
    }
  }
  
}
