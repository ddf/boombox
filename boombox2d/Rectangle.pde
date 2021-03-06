// helper class for drawing boxes and querying if a point is inside.
class Rectangle
{
    
  class Bounds
  {
    float minX, minY, maxX, maxY;
    
    Bounds( float x1, float y1, float x2, float y2 )
    {
      minX = x1;
      minY = y1;
      maxX = x2;
      maxY = y2;
    }
    
    boolean pointInside( float x, float y )
    {
      return ( x >= minX && x <= maxX && y >= minY && y <= maxY );
    }
    
    boolean collidesWith( Bounds otherBounds )
    {
      if ( maxY < otherBounds.minY ) return false;
      if ( minY > otherBounds.maxY ) return false;

      if ( maxX < otherBounds.minX ) return false;
      if ( minX > otherBounds.maxX ) return false;

      return true;
    }
    
    void constrain( PVector pos )
    {
      pos.x = PApplet.constrain( pos.x, minX, maxX );
      pos.y = PApplet.constrain( pos.y, minY, maxY );
    }
  }
  
  
  private int mHorzAlign, mVertAlign;
  private float mWidth, mHeight;
  private float mX, mY;
  private Bounds mBounds;
  
  ArrayList<Rectangle> AdjacentRects;

  
  Rectangle( float x, float y, float w, float h, int ha, int va )
  {
    mX = x;
    mY = y;
    mWidth = w;
    mHeight = h;
    mHorzAlign = ha;
    mVertAlign = va;
    AdjacentRects = new ArrayList<Rectangle>();
    mBounds = new Bounds(0,0,0,0);
    calcBounds();
  }
  
  void draw()
  {
    rectMode(CORNERS);
    rect( mBounds.minX, mBounds.minY, mBounds.maxX, mBounds.maxY );
  }
  
  PVector getPos()
  {
    return new PVector(mX, mY);
  }
  
  void setPos( float x, float y )
  {
    mX = x;
    mY = y;
    calcBounds();
  }
  
  Bounds getBounds()
  {
    return mBounds;
  }
  
  void constrain( PVector pos )
  {
    mBounds.constrain( pos );
  }
  
  boolean pointInside( PVector pos )
  {
    return pointInside( pos.x, pos.y );
  }
  
  boolean pointInside( float x, float y )
  {
    return mBounds.pointInside( x, y );
  }
  
  boolean collidesWith( Rectangle otherRect )
  {
    return mBounds.collidesWith( otherRect.mBounds );
  }
  
  void calcBounds()
  {
        // assume LEFT / TOP
    mBounds.minX = mX;
    mBounds.minY = mY;
    mBounds.maxX = mX + mWidth;
    mBounds.maxY = mY + mHeight;
    
    switch( mHorzAlign )
    {
      case CENTER: 
      {
        mBounds.minX -= mWidth * 0.5f; 
        mBounds.maxX -= mWidth * 0.5f; 
        break;
      }
      
      case RIGHT: 
      {
        mBounds.minX -= mWidth; 
        mBounds.maxX -= mWidth; 
        break;
      }
    }
    
    switch( mVertAlign )
    {
      case CENTER: 
      {
        mBounds.minY -= mHeight * 0.5f; 
        mBounds.maxY -= mHeight * 0.5f; 
        break;
      }
      
      case BOTTOM: 
      {
        mBounds.minY -= mHeight; 
        mBounds.maxY -= mHeight; 
        break;
      }
    }
  }
}
