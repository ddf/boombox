import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

/** 
 * Boombox with JBox2D for physics.
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

void debugDrawForPhysics( World world )
{
  // do nothing.
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

