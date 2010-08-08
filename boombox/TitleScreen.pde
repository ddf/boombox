class TitleScreen
{
  PFont titleFont;
  boolean m_active;
  
  PImage titleImg;
  PImage loading;
  PImage clickPlay;
  
  TitleScreen()
  {
    titleFont = loadFont("ComicSansMS-48.vlw");
    m_active = true;
    
    titleImg = loadImage("Title.png");
    loading = loadImage("Loading.png");
    clickPlay = loadImage("ClickToPlay.png");
  }
  
  boolean isActive()
  {
    return m_active;
  }
  
  void draw()
  {
    imageMode(CORNER);
    
    image(titleImg, 0, 0);
    
    imageMode(CENTER);
    
    if ( loaderThread.isAlive() )
    {
      image(loading, width/2, height/2 + 50);
    }
    else
    {
      image(clickPlay, width/2, height/2 + 50);
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
