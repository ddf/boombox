// helper class for drawing boxes and querying if a point is inside.
class Rectangle
{
    
  class Bounds
  {
    float minX, minY, maxX, maxY;
    
    boolean pointInside( float x, float y )
    {
      return ( x >= minX && x <= maxX && y >= minY && y <= maxY );
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
    mBounds = new Bounds();
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
