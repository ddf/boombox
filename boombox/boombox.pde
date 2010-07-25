/** <br/>
  * Use WASD to move around. <br/>
  * Pick up Jams (the cassettes) by walking over them.<br/>
  * Click on a Jam in your inventory at the top of the screen to play it or eject it.<br/>
  * Stand next to a green dude and click on him to Jam together. <br/>
  * Mix and match your Jams to make a Fresh Tune.<br/>
  * Hold down R to glitch out your Tune like a pro!
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
SampleAndRepeat sampleRepeat;
Gain  globalGain;
AudioOutput mainOut;

// something to plug envelope followers into
Sink envFollowSink;

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
  mainOut = minim.getLineOut( Minim.STEREO, 512 );
  jamSyncer = new JamSyncer( 121.f );
  sampleRepeat = new SampleAndRepeat( 121.f, 0.5f );
  globalGain = new Gain(0.f);
  
  envFollowSink = new Sink();
  envFollowSink.patch( mainOut );
  
  allJams = new ArrayList<Jam>();
 
  allJams.add( new Jam("backing_loop.wav", JamCategory.OTHER, color(0,0,0), -100, -100 ) );
  allJams.add( new Jam("drums_LP01.wav", JamCategory.DRUMS, #FF0000, 580, 120) );
  allJams.add( new Jam("bass_LP01.wav", JamCategory.BASS, #FFA500, 600, 400) );
  allJams.add( new Jam("blip_LP01.wav", JamCategory.BLIP, #FFFF00, 200, 600) );
  allJams.add( new Jam("pad_LP04.wav", JamCategory.PAD, #008000, 100, 450) );
  allJams.add( new Jam("drums_LP02.wav", JamCategory.DRUMS, #0000FF, 580, 120) );
  allJams.add( new Jam("chords_LP02.wav", JamCategory.CHORD, #4B0082, 600, 400) );
  allJams.add( new Jam("blip_LP02.wav", JamCategory.BLIP, #EE82EE, 200, 600) );
  allJams.add( new Jam("pad_LP02.wav", JamCategory.PAD, #EEEEEE, 100, 450) );
  allJams.add( new Jam("drums_LP03.wav", JamCategory.DRUMS, #990000, 580, 120) );
  allJams.add( new Jam("bass_LP03.wav", JamCategory.BASS, #5F70FF, 600, 400) );
  allJams.add( new Jam("blip_LP03.wav", JamCategory.BLIP, #222222, 200, 600) );
  allJams.add( new Jam("blip_LP05.wav", JamCategory.BLIP, #00FF00, 100, 450) );
  
  jamSyncer.playJam( allJams.get(0) );
  jamSyncer.patch( sampleRepeat ).patch( globalGain ).patch( mainOut );
  
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
    if ( key == 'd' || key == 'D' )
    {
      player.setXDir( 1 );
    }
    else if ( key == 'a' || key == 'A' )
    {
      player.setXDir( -1 );
    }
    else if ( key == 'w' || key == 'W' )
    {
      player.setYDir( -1 );
    }
    else if ( key == 's' || key == 'S' )
    {
      player.setYDir( 1 );
    }
    else if ( (key == 'r' || key == 'R')  && sampleRepeat.isActive() == false )
    {
      sampleRepeat.activate(); 
    }
  }
}

void keyReleased()
{
  if ( key != CODED )
  {
    if ( key == 'd' || key == 'D' )
    {
      player.setXDir( 0 );
    }
    else if ( key == 'a' || key == 'A' )
    {
      player.setXDir( 0 );
    }
    else if ( key == 'w' || key == 'W' )
    {
      player.setYDir( 0 );
    }
    else if ( key == 's' || key == 'S' )
    {
      player.setYDir( 0 );
    }
    else if ( key == 'r' || key == 'R' )
    {
      sampleRepeat.deactivate();
    }
  }
}

