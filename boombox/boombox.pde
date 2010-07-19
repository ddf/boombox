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

boolean DRAW_COLLISION = false;
color   COLLISION_COLOR = color(0, 255, 0, 128);

// audio junk
Minim minim;

// our main audio path
JamSyncer jamSyncer;
Gain  globalGain;
AudioOutput mainOut;

// this plays all the time
FilePlayer backing;

// something to plug envelope followers into
Summer envFollowSink;
Multiplier sinkSilencer;

// visual junks
Avatar player;
Mouse  mouse;
Inventory inventory;
Stage     theStage;

// all the Jams in the game
// Jam 0 is the backing jam
// Jam 1 is the first cassette you pick up
ArrayList<Jam> allJams;

  
// jams that are out in the world
// just, like, minding their own business, yo
ArrayList<Jam> worldJams;

// where my camera at
float cameraPosition = 0;
// what is my camera's offset from where it started?
float cameraOffset = 0;

void setup()
{
  size(640, 480, P3D);
  
  minim = new Minim(this);
  mainOut = minim.getLineOut();
  jamSyncer = new JamSyncer( 121.f );
  globalGain = new Gain(0.f);
  
  backing = new FilePlayer( minim.loadFileStream( "backing_loop.aif", 512, false ) );
  jamSyncer.playJam( backing );
  
  jamSyncer.patch( globalGain ).patch( mainOut );
  
  envFollowSink = new Summer();
  sinkSilencer = new Multiplier(0);
  envFollowSink.patch( sinkSilencer ).patch( mainOut );
  
  allJams = new ArrayList<Jam>();
 
  allJams.add( new Jam("backing_loop.aif", color(0,0,0), -100, -100 ) );
  allJams.add( new Jam("LP01_drums.aif", color(255,128,0), 580, 120) );
  allJams.add( new Jam("LP01_bass.aif", color(0,255,200), 600, 400) );
  allJams.add( new Jam("LP01_blip.aif", color(128,255,0), 200, 600) );
  allJams.add( new Jam("LP01_pad.aif", color(64,0,128), 100, 450) );
  allJams.add( new Jam("LP01_drums.aif", color(128,64,0), 580, 120) );
  allJams.add( new Jam("LP01_bass.aif", color(0,200,64), 600, 400) );
  allJams.add( new Jam("LP01_blip.aif", color(64,160,0), 200, 600) );
  allJams.add( new Jam("LP01_pad.aif", color(128,0,64), 100, 450) );
  allJams.add( new Jam("LP01_drums.aif", color(128,128,0), 580, 120) );
  allJams.add( new Jam("LP01_bass.aif", color(0,128,64), 600, 400) );
  allJams.add( new Jam("LP01_blip.aif", color(64,128,0), 200, 600) );
  allJams.add( new Jam("LP01_pad.aif", color(255,23,128), 100, 450) );
  
  worldJams = new ArrayList<Jam>();
  
  worldJams.add( allJams.get(1) );
  worldJams.add( allJams.get(3) );
  worldJams.add( allJams.get(5) );
  worldJams.add( allJams.get(8) );
  worldJams.add( allJams.get(9) );
  worldJams.add( allJams.get(11));
  
  player = new Avatar( 50, height - 100 );
  
  mouse = new Mouse();
  inventory = new Inventory();
  theStage = new Stage();

  noCursor();
  
  cameraPosition = width/2;
}

void draw()
{
  float dt = 1.f / frameRate;
  
  theStage.update( dt );
  player.update( dt );
  inventory.update( dt );
  
  float playerX = player.getPos().x;
  float distToCamera = abs( playerX - cameraPosition );
  float cameraSpeed = 175;
  if ( distToCamera < 100 )
  {
    if ( playerX < cameraPosition )
    {
      cameraPosition += cameraSpeed * dt;
    }
    else
    {
      cameraPosition -= cameraSpeed * dt;
    }
  }
  else if ( distToCamera > 200 )
  {
    if ( playerX < cameraPosition )
    {
      cameraPosition -= cameraSpeed * dt;
    }
    else
    {
      cameraPosition += cameraSpeed * dt;
    }
  }
  
  cameraPosition = constrain( cameraPosition, width/2, theStage.moreGround.getBounds().maxX - width/2 );
  cameraOffset = cameraPosition - width/2;
  
//  fill(255,0,0);
//  noStroke();
//  rectMode(CENTER);
//  rect( cameraPosition, height/2.0, 5, 5 );
  
  camera( cameraPosition, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), cameraPosition, height/2.0, 0, 0, 1, 0);
  
  background(0);
  
  // will also draw the player sorted properly with stage elements
  theStage.draw();
  
  Iterator<Jam> iter = worldJams.iterator();
  while ( iter.hasNext() )
  {
    Jam j = iter.next();
    
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
  
  translate( cameraPosition - width/2, 0, 0 );

  // jams we can play  
  inventory.draw();

  // mouse appearance
  mouse.draw();
}

void mousePressed()
{
  inventory.mousePressed();
  for(int i = 0; i < theStage.mDudes.size(); i++ )
  {
    Dude dude = theStage.mDudes.get(i);
    dude.mousePressed();
  }
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

