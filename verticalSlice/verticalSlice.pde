/** <br/>
  * Use WASD to move around. <br/>
  * Pick up Jams (the cassettes) by walking over them.<br/>
  * Click on a Jam in your inventory at the top of the screen to play it or eject it.<br/>
  * Stand next to the green dude and click on him to Jam together. <br/>
  * Mix and match your Jams to make a Fresh Tune.
  */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;

// audio junk
Minim minim;
JamSyncer jamSyncer;
Gain  globalGain;
AudioOutput mainOut;
AudioRecordingStream backing;

// visual junks
Avatar player;
Dude   dude;
Mouse  mouse;
Inventory inventory;
Stage     theStage;

// jams that are out in the world
// just, like, minding their own business, yo
ArrayList worldJams;

void setup()
{
  size(640, 480);
  
  minim = new Minim(this);
  mainOut = minim.getLineOut();
  jamSyncer = new JamSyncer( 121.f );
  globalGain = new Gain(0.f);
  
  backing = minim.loadFileStream( "backing_loop.aif", 512, false );
  jamSyncer.playJam( backing );
  
  jamSyncer.patch( globalGain ).patch( mainOut );
  
  worldJams = new ArrayList();
  
  worldJams.add( new Jam("LP01_drums.aif", color(255,128,0), 200, 440) );
  worldJams.add( new Jam("LP01_bass.aif", color(0,255,200), 600, 400) );
//  worldJams.add( new Jam("LP01_blip.aif", color(128,255,0), 200, 600) );
  worldJams.add( new Jam("LP01_pad.aif", color(64,0,128), 300, 350) );
  
  player = new Avatar( 50, height - 100 );
  dude = new Dude( 450, height - 50, new Jam[] { (Jam)worldJams.get(0), (Jam)worldJams.get(1) }, new Jam("LP01_blip.aif", color(128,255,0), 0, 0) );
  mouse = new Mouse();
  inventory = new Inventory();
  theStage = new Stage();

  
  noCursor();
}

void draw()
{
  float dt = 1.f / frameRate;
  
  player.update( dt );
  inventory.update( dt );
  dude.update( dt );
  
  background(0);
  
  theStage.draw();
  
  Iterator iter = worldJams.iterator();
  while ( iter.hasNext() )
  {
    Jam j = (Jam)iter.next();
    
    if ( player.getPos().dist( j.getPos() ) < player.getSize() )
    {
      iter.remove();
      inventory.addJam( j );
    }
    else
    {
      j.draw();
    }
  }
  
  if ( player.getPos().y < dude.getPos().y )
  {
    player.draw();
    dude.draw();
  }
  else
  {
    dude.draw();
    player.draw();
  }
  
  inventory.draw();
  
  // mouse appearance
  mouse.draw();
}

void mousePressed()
{
  inventory.mousePressed();
  dude.mousePressed();
}

void mouseMoved()
{
  inventory.mouseMoved();
}

void keyPressed()
{
  if ( key != CODED )
  {
    if ( key == 'd' )
    {
      player.setXDir( 1 );
    }
    else if ( key == 'a' )
    {
      player.setXDir( -1 );
    }
    else if ( key == 'w' )
    {
      player.setYDir( -1 );
    }
    else if ( key == 's' )
    {
      player.setYDir( 1 );
    }
  }
}

void keyReleased()
{
  if ( key != CODED )
  {
    if ( key == 'd' )
    {
      player.setXDir( 0 );
    }
    else if ( key == 'a' )
    {
      player.setXDir( 0 );
    }
    else if ( key == 'w' )
    {
      player.setYDir( 0 );
    }
    else if ( key == 's' )
    {
      player.setYDir( 0 );
    }
  }
}

