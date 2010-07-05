import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

Minim minim;
Avatar player;
Inventory inventory;
// jams that are out in the world
// just, like, minding their own business, yo
ArrayList worldJams;

void setup()
{
  size(1024, 768);
  smooth();
  
  minim = new Minim(this);
  
  player = new Avatar();
  inventory = new Inventory();
  worldJams = new ArrayList();
  
  worldJams.add( new Jam("LP01_drums.aif", 30, 100) );
  worldJams.add( new Jam("LP01_bass.aif", 500, 450) );
  worldJams.add( new Jam("LP01_blip.aif", 200, 600) );
  worldJams.add( new Jam("LP01_pad.aif", 900, 300) );
  
  noCursor();
}

void draw()
{
  float dt = 1.f / frameRate;
  
  player.update( dt );
  inventory.update( dt );
  
  background(0);
  
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
  
  player.draw();
  
  inventory.draw();
  
  // mouse appearance
  stroke( 56, 214, 212 );
  PVector mouse = new PVector( mouseX, mouseY );
  PVector playerPos = player.getPos();
  if ( mousePressed && false == inventory.isActive() && mouse.dist( playerPos ) > player.getSize() )
  {
      PVector dir = PVector.sub( playerPos, mouse );
      dir.normalize();
      
      // an arrow pointing in the direction the player is moving
      pushMatrix();
      {
        translate( mouse.x, mouse.y );
        line( 0, 0, dir.x * 10.f, dir.y * 10.f );
        rotate( radians(30) );
        line( 0, 0, dir.x * 5.f, dir.y * 5.f );
        rotate( radians( -60 ) );
        line( 0, 0, dir.x * 5.f, dir.y * 5.f );
      }
      popMatrix();
  }
  else
  {
    ellipseMode( CENTER );
    noFill();
    strokeWeight( 1.2 );
    ellipse( mouseX, mouseY, 8, 8 );
  }
}

void mousePressed()
{
  if ( false == inventory.isActive() )
  {
    player.setGoal( mouseX, mouseY );
  }
  else
  {
    inventory.mousePressed();
  }
}

void mouseDragged()
{
  if ( false == inventory.isActive() )
  {
    player.setGoal( mouseX, mouseY );
  }
  else
  {
    player.clearGoal();
  }
}

void mouseReleased()
{
  player.clearGoal();
}
