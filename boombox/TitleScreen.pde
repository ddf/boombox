class TitleScreen
{
  PFont titleFont;
  boolean m_active;
  
  TitleScreen()
  {
    titleFont = loadFont("ComicSansMS-48.vlw");
    m_active = true;
  }
  
  boolean isActive()
  {
    return m_active;
  }
  
  void draw()
  {
    background(24);
    
    textAlign(CENTER);
    textFont( titleFont );
    
    textSize(48);
    text( "BOOMBOX", width/2.f, height/3.f );
    
    textSize(24);
    if ( loaderThread.isAlive() )
    {
      text("Loading...", width/2.f, (height/2.f));
    }
    else
    {
      text("Click to Play", width/2.f, (height/2.f));
    }
  }
  
  void mousePressed()
  {
    if ( loaderThread.isAlive() == false )
    {
      m_active = false;
      jamSyncer.playJam( allJams.get(0) );
      jamSyncer.patch( granulateBypass ).patch( sampleRepeat ).patch( lowPass ).patch( globalGain ).patch( mainOut );
    }
  }
}
