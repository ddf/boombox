/** <br/>
 * Use WASD to move around (or the mouse). <br/>
 * Pick up Jams (the cassettes) and Effect (the pedals) by walking over them.<br/>
 * Click on a Jam in your inventory at the top of the screen to play it or eject it.<br/>
 * Click on an Effect in your inventory to apply it to your mix.<br/>
 * Stand next to a green dude and play what he wants to hear to jam with him.<br/>
 * Mix and match your Jams and Effects to make a Fresh Tune.<br/>
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;

import net.compartmental.contraptions.*;

boolean DRAW_COLLISION = false;
color   COLLISION_COLOR = color(0, 255, 0, 128);

Thread loaderThread;
TitleScreen titleScreen;
GameplayScreen gameplayScreen;

void setup()
{
  size(640, 480, P3D);
  
  loaderThread = new Thread( new AssetLoader(this) );
  loaderThread.start();
  
  titleScreen = new TitleScreen();
  gameplayScreen = new GameplayScreen();
}

void draw()
{ 
  float dt = 1.f / frameRate;
  
  if ( titleScreen.isActive() )
  {
    titleScreen.draw();
  }
  else
  {
    gameplayScreen.update( dt );
    gameplayScreen.draw();
  }
  
//  fill( 255 );
//  text( frameRate + "", 10, 20 );
}

void mousePressed()
{
  if ( titleScreen.isActive() )
  {
    titleScreen.mousePressed();
  }
  else
  {
    gameplayScreen.mousePressed();
  }
}

void mouseMoved()
{
  if ( titleScreen.isActive() == false )
  {
    gameplayScreen.mouseMoved();
  }
}

void mouseReleased()
{
  if ( titleScreen.isActive() == false )
  {
    gameplayScreen.mouseReleased();
  }
}

boolean filterOn = false;

void keyPressed()
{
  if ( titleScreen.isActive() == false )
  {
    gameplayScreen.keyPressed();
  }
}

void keyReleased()
{
  if ( titleScreen.isActive() == false )
  {
    gameplayScreen.keyReleased();
  }
}

