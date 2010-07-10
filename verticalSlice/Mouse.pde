// visual appearance handler for the mouse
class Mouse
{
  // when there is nothing to click on
  static final int EMPTY = 0;
  // when you can click on a dude
  static final int JAM = 1;
  // when you are over a jam in your inventory
  static final int PLAY = 2;
  static final int EJECT = 3;
  
  private int mState;
  
  Mouse()
  {
    mState = EMPTY;
  }
  
  void setState( int state )
  {
    mState = state;
  }
  
  void draw()
  {
    
    switch( mState )
    {
    case EMPTY:
      {
        noFill();
        stroke( 56, 214, 212 );
        strokeWeight(1.2);   
        ellipseMode( CENTER );
        ellipse( mouseX, mouseY, 8, 8 );  
      }
      break;
      
    case JAM:
      {
        tint(255);
        image( TAPE, mouseX, mouseY, getTapeWidth() * 0.5f, getTapeHeight() * 0.5f );
      }
      break;
    
    case PLAY:
      {
        fill( 56, 214, 212 );
        noStroke();
        triangle( mouseX - 5, mouseY - 5, mouseX - 5, mouseY + 5, mouseX + 5, mouseY );
      }
      break;
      
    case EJECT:
      {
        fill( 56, 214, 212 );
        noStroke();
        rectMode(CENTER);
        rect( mouseX, mouseY, 10, 10 );
      }
      break;
    }
    
  }
  
}
