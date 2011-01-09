// the thing the player controls
class Avatar
{
  private Body mBody; // my physics representation
  private PVector mPos; // where I am
  private PVector mGoal; // where I am going
  private float   mSpeed = 175.f;
  private int     mXDir = 0;
  private int     mYDir = 0;   
  private float   mScale = 1.f;
  private AnimationStateMachine mAnims;

  Avatar( float xPos, float yPos )
  {
    mPos = new PVector( xPos, yPos );
    mGoal = new PVector( mPos.x, mPos.y );
    mAnims = new AnimationStateMachine( animationSystem, new XMLElement( boombox2d.this, "animation/player.xml" ) );
    
    gPhysics.setDensity( 1.f );
    gPhysics.setFriction( 0.f );
    gPhysics.setRestitution( 0.f );
    gPhysics.setFixedRotation( true );
    mBody = gPhysics.createRect( xPos - getWidth() * 0.3f, 
                                 yPos - getHeight(), 
                                 xPos + getWidth() * 0.3f,
                                 yPos
                                );
    mBody.allowSleeping( false );
    gPhysics.setFixedRotation( false );
  }

  void setXDir( int dir )
  {
    if ( mXDir != dir )
    { 
      mXDir = dir;

      if ( mXDir < 0 )
      {
        mScale = -1.f;
      }
      else if ( mXDir > 0 )
      {
        mScale = 1.f;
      }
    }
  }

  void setYDir( int dir )
  {
    if ( mYDir != dir )
    { 
      mYDir = dir;
    }
  }

  void setGoal( float x, float y )
  {
    mGoal.set( x, y, 0 );
  }

  void clearGoal()
  {
    mGoal.set( mPos.x, mPos.y, 0 );
  }

  void setYPos( float y )
  {
    mPos.y = y;
  }

  PVector getPos()
  {
    return new PVector( mPos.x, mPos.y );
  }

  Body getBody()
  {
    return mBody;
  }
  
  void applyForce( float x, float y )
  {
    String currentAnim = mAnims.getCurrentStateName();

    if ( currentAnim.equals( "idle" ) || currentAnim.equals( "walk" ) )
    {
      gPhysics.applyForce( player.getBody(), x, y );
    }
  }

  float getWidth()
  {
    return mAnims.currentAnimation().width();
  }

  float getHeight()
  {
    return mAnims.currentAnimation().height();
  }
  
  boolean isOnGround()
  {
    Shape myShape = mBody.getShapeList();
    Set<Contact> contacts = myShape.getContacts();
    for (Contact c:contacts) 
    {
      Vec2 normal = null;
      if (c.m_shape1 == myShape && !c.m_shape2.isSensor() ) 
      {
        normal = c.getManifolds().get(0).normal.mul(-1);
      } 
      else  if ( c.m_shape2 == myShape && !c.m_shape1.isSensor() )
      {
        normal = c.getManifolds().get(0).normal.mul(1);
      }
      
      if ( normal != null )
      {
        float dot = Vec2.dot(normal, new Vec2(0,1));
        // println( "Normal is " + normal.x + ", " + normal.y + ". And dot is " + dot);
        if (dot >= 0.3f)
        {
          // we found a ground normal
          return true;
        }
      }
    }
    
    return false;
  }

  void update( float dt )
  { 
    String currentAnim = mAnims.getCurrentStateName();

    Vec2 currentVel = mBody.getLinearVelocity();
    boolean bOnGround = isOnGround();
    if ( currentAnim.equals( "idle" ) || currentAnim.equals( "walk" ) )
    {   
      if ( bOnGround )
      {
        currentVel.x = 15.f * mXDir;
      }
      else
      {
        if ( currentVel.x > 5.f )
        {
          currentVel.x *= 0.99f;
        }
        else 
        {
          currentVel.x = 5.f * mXDir;
        }
      }
      
      mBody.setLinearVelocity( currentVel );

      Vec2 bodyPos = gPhysics.getPosition( mBody );
      PVector newPos = new PVector( bodyPos.x, bodyPos.y );

      if ( mPos.x == newPos.x && mPos.y == newPos.y )
      {
        mAnims.sendEvent( "idle" );
      }
      else
      {
        mAnims.sendEvent( "walk" );
      }

      mPos.set( newPos );
    }
    else
    {
      currentVel.x = 0.f;
      mBody.setLinearVelocity( currentVel );
    }

    mAnims.update( dt );
  }

  void draw()
  {
    pushMatrix();
    {
      imageMode( CENTER ); 
      tint(255);
      translate( mPos.x, mPos.y );
      scale( mScale, 1 );
      mAnims.draw();

      // reflection?
      //      tint(255, 24);
      //      translate( 0, mAnims.currentAnimation().height() - 2);
      //      scale( 1, -1 );
      //      mAnims.draw();
    }
    popMatrix();
  }

  void collect()
  {
    // println("collect");
    tapeGet.trigger();
    mAnims.sendEvent( "collect" );
  }

  void play()
  {
    mAnims.sendEvent( "play" );
  }

  void eject()
  {
    mAnims.sendEvent( "eject" );
  }

  void jam()
  {
    // println("Player going to Jam!");
    mAnims.sendEvent( "jam" );
  }

  boolean isJamming()
  {
    return mAnims.getCurrentStateName().equals( "jam" );
  }

  void idle()
  {
    mAnims.sendEvent( "idle" );
  }
}

