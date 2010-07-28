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
  // did I give my jam away
  boolean         mGaveJam;
  
  // abusing a wavefor for down and dirty animation
  Wavetable mAnimCurve;
  // where in the wave for we look for our position offset
  float     mAnimCurveStep;
  // which animation to do 
  int       mAnimation;
  
  private PVector mPos;
  
  private AnimationSet mAnims;
  
  // different animations
  static final int IDLE = 0;
  static final int SHAKE = 1;
  static final int JUMP = 2;
  
  Dude( float x, float y, Jam[] wantToHear, Jam toPlay )
  {
    mPos = new PVector(x, y);
    mRect = new Rectangle( x, y, 64, 64, CENTER, BOTTOM );
    mJamArea = new Rectangle( x, y, 256, 64, CENTER, CENTER );
    mWantToHear = wantToHear;
    mMyJam = toPlay;
    
    mJammed = false;
    mGaveJam = false;
    mLoops = 0;
    
    mAnimCurve = Waves.TRIANGLE;
    mAnimCurveStep = 1.f;
    mAnimation = IDLE;
    
    mAnims = new AnimationSet( animationSystem, new String[] { "idle", "nojam", "yesjam", "play", "jamming" } );
    mAnims.setAnimation( "idle" );
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
    
    if ( mMyJam.isPlaying() )
    {
      mAnims.setAnimation( "jamming" );
      if ( mGaveJam == false )
      {
        player.jam();
      }
    }
    else if ( mGaveJam == false && mJammed && mAnims.currentAnimationName().equals( "jamming" ) )
    {
      mMyJam.queue();
      jamSyncer.addLoopListener( this );
      mAnims.setAnimation( "play", "idle" );
    }
    else if ( mAnims.currentAnimationName().equals( "jamming" ) )
    {
      mAnims.setAnimation( "idle" );
    }
    
    mAnims.update( dt );
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
          mAnims.setAnimation("nojam");
          return;   
        }
      }
      
      // yes all good
      mJammed = true;
      mAnims.setAnimation("yesjam", "jamming");
    }
  }
  
  void looped()
  {
    mLoops++;
    if ( mLoops == 2 )
    {
      inventory.addJam( mMyJam );
      mGaveJam = true;
      player.collect();
      jamSyncer.removeLoopListener( this );
    }
  }
  
  void draw()
  { 
    pushMatrix();
    {
      tint(0, 255, 255);
      imageMode(CENTER);
      translate( mPos.x, mPos.y - mAnims.currentAnimation().height() / 2.f );
      scale( -1, 1 );
      mAnims.draw();
    }
    popMatrix();
    
//    fill(0, 64);
//    mJamArea.draw();
    
    if ( mGaveJam == false )
    {
      PVector pos = mRect.getPos();
      
      rectMode(CENTER);
      
      stroke(0);
      strokeWeight(2);
      fill(255);
      rect( pos.x + 5, pos.y - 75, 5, 5 );
      rect( pos.x + 15, pos.y - 95, 10, 10 );
      
      float bubbleWidth = getTapeWidth() * mWantToHear.length + 5 * mWantToHear.length + 10;
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
          img.draw( startX + offsetX, bubbleCenterY, 1.f );
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
