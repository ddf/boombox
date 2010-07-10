// a Dude is someone who you can Jam with
class Dude
{
  private PVector mPos;
  // the jams this dude wants to jam with
  private Jam[]   mWantToHear;
  // the jam this dude will play and then give away
  private Jam     mMyJam;
  // have I already jammed?
  boolean         mJammed;
  // is the mouse over me?
  boolean         mMousedOver;
  
  Dude( float x, float y, Jam[] wantToHear, Jam toPlay )
  {
    mPos = new PVector(x, y);
    mWantToHear = wantToHear;
    mMyJam = toPlay;
    mJammed = false;
  }
  
  PVector getPos()
  {
    return mPos;
  }
  
  void update( float dt )
  {
    if ( inventory.isActive() == false )
    {
      mMousedOver = false;
      mouse.setState( Mouse.EMPTY );
      if ( mJammed == false && mouseX > mPos.x - 32 && mouseX < mPos.x + 32 && mouseY < mPos.y && mouseY > mPos.y -64 )
      {
        mMousedOver = true;
        mouse.setState( Mouse.JAM );
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
          return;   
        }
      }
      
      // yes all good
      mJammed = true;
      mMyJam.queue();
      
      // and give it right away for now
      inventory.addJam( mMyJam );
    }
  }
  
  void draw()
  {
    rectMode(CENTER);
    
    noStroke();
    fill(0, 255, 0);
    rect( mPos.x, mPos.y - 32, 64, 64 );
    
    if ( mJammed == false )
    {
      stroke(0);
      strokeWeight(2);
      fill(255);
      rect( mPos.x + 5, mPos.y - 75, 5, 5 );
      rect( mPos.x + 15, mPos.y - 95, 10, 10 );
      
      float bubbleWidth = getTapeWidth() * mWantToHear.length + 20;
      float bubbleHeight = getTapeHeight() + 30;
      float bubbleCenterY = mPos.y - 140;
      rect( mPos.x, bubbleCenterY, bubbleWidth, bubbleHeight );
      
      float startX = mPos.x - (bubbleWidth*0.5f) + (getTapeWidth()*0.5f) + 8;
      for(int i = 0; i < mWantToHear.length; i++)
      {
        JamImage img = mWantToHear[i].getImage();
        float offsetX = i * (getTapeWidth()+5);
        img.draw( startX + offsetX, bubbleCenterY );
      }
    }
  }
  
}
