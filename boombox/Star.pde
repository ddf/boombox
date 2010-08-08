// stars that pop up when you jam with a dude

PImage dopeStar = null;
PImage freshStar = null;

void loadStarImages()
{
 dopeStar = loadImage("StarDope.png");
 freshStar = loadImage("StarFresh.png"); 
}

class Star
{
  private PImage mStar;
  private PVector mPos;
  private float  mScale;
  
  private float s_startScale = 0.1f;
  private float s_endScale = 3.f;
  private float s_scaleRate = 3.f;
  
  Star(float x, float y)
  {
    if ( random(1) < 0.5f)
    {
      mStar = dopeStar;
    }
    else
    {
      mStar = freshStar;
    }
    mScale = s_startScale;
    mPos = new PVector(x, y);
  }
  
  boolean update( float dt )
  {
    mScale += s_scaleRate * dt;
    if ( mScale > s_endScale )
    {
      return true;
    }
    
    return false;
  }
  
  void draw()
  {
    float alph = map(mScale, s_startScale, s_endScale, 255, 0);
    tint(255, alph);
    imageMode(CENTER);
    pushMatrix();
      translate(mPos.x, mPos.y);
      scale(mScale);
      image(mStar, 0, 0);
    popMatrix();
  }
}
