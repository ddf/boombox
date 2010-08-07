// a Dude is someone who you can Jam with
class Dude implements LoopListener, AnimationStateMachine.EventListener
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
  
  // is the player close enough to jam?
  boolean         mCanJam;
  // did I give my jam away
  boolean         mGaveJam;
  
  private PVector mPos;
  
  private AnimationStateMachine mAnims;
  
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
    mCanJam = false;
    mLoops = 0;
    
    mAnims = new AnimationStateMachine( animationSystem, new XMLElement(boombox.this, "animation/dude.xml") );
    mAnims.addEventListener( this );
  }
  
  PVector getPos()
  {
    return mRect.getPos();
  }
  
  void ejectJam()
  {
    mAnims.sendEvent( "eject" );
    mMyJam.queue();
    mLoops = 0;
    jamSyncer.removeLoopListener( this ); 
    
    if ( player.isJamming() )
    {
      player.idle();
    }
  }
  
  void update( float dt )
  {
    if ( mGaveJam == false )
    {
        mMyJam.update( dt );
        
        boolean canHear = mJamArea.pointInside( player.getPos() );
        
        if ( canHear )
        {
          boolean wantToJam = wantToJam();
        
          if ( wantToJam && mMyJam.isPlaying() == false && mMyJam.willPlay() == false && mMyJam.willEject() == false )
          {
            mAnims.sendEvent( "yesjam" );
          }
          else if ( wantToJam == false )
          {
            if ( (mMyJam.isPlaying() || mMyJam.willPlay()) && mMyJam.willEject() == false )
            {
              ejectJam();
            }
            else
            {
              mAnims.sendEvent( "nojam" );
            }
          }
        }
        else
        {
          if ( mMyJam.willPlay() )
          {
            ejectJam();
          }
          else if ( mAnims.getCurrentStateName().equals( "eject" ) == false )
          {
            mAnims.sendEvent( "idle" );
          }
        }
    }
    else
    {   
      if ( mMyJam.isPlaying() )
      {
        mAnims.sendEvent( "jam" );
      }
      else if ( mMyJam.willPlay() == false && mMyJam.willEject() == false )
      {
        mAnims.sendEvent( "idle" );
      }
    }
    
    mAnims.update( dt );
  }
  
  boolean wantToJam()
  {
      for(int i = 0; i < mWantToHear.length; ++i)
      {
        // bail if the player isn't playing something I want to hear
        if ( (mWantToHear[i].isPlaying() == false && mWantToHear[i].willPlay() == false) || mWantToHear[i].willEject() )
        {
          // println("Something I want to hear isn't playing!");
          return false;
        }
      }
      
      return true;
  }
  
  void looped()
  {
    mLoops++;
    if ( mLoops == 1 )
    {
      mAnims.sendEvent( "jam" );
      player.jam();
    }
    else if ( mLoops == 2 )
    {
      inventory.addJam( mMyJam );
      mGaveJam = true;
      player.collect();
      jamSyncer.removeLoopListener( this );
    }
  }
  
  void eventSent( AnimationStateMachine.Event event )
  {
    if ( event.getName().equals("play") )
    {
      mMyJam.queue();
      jamSyncer.addLoopListener( this ); 
    }
  }
  
  void draw()
  { 
    pushMatrix();
    {
      tint(0, 255, 255);
      imageMode(CENTER);
      translate( mPos.x, mPos.y - mAnims.currentAnimation().height() / 2.f );
      if ( player.getPos().x < mPos.x )
      {
        scale( -1, 1 );
      }
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
      if ( mMyJam.isPlaying() == false && mMyJam.willPlay() == false )
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
        if ( mMyJam.isPlaying() )
        {
          mMyJam.drawOnlyImage();
        }
        else
        {
          mMyJam.draw();
        }
      }
    }
  }
  
}
