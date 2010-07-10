// helper class for drawing boxes and querying if a point is inside.
class Rectangle
{
  private int mHorzAlign, mVertAlign;
  private float mWidth, mHeight;
  private float mX, mY;
  
  Rectangle( float x, float y, float w, float h, int ha, int va )
  {
    mX = x;
    mY = y;
    mWidth = w;
    mHeight = h;
    mHorzAlign = ha;
    mVertAlign = va;
  }
  
  void draw()
  {
    rectMode(CENTER);
    float x = mX;
    switch( mHorzAlign )
    {
      case LEFT: x += mWidth * 0.5f; break;
      case RIGHT: x -= mWidth * 0.5f; break;
    }
    
    float y = mY;
    switch( mVertAlign )
    {
      case TOP: y += mHeight * 0.5f; break;
      case BOTTOM: y -= mHeight * 0.5f; break;
    }
    
    rect( x, y, mWidth, mHeight );
  }
  
  PVector getPos()
  {
    return new PVector(mX, mY);
  }
  
  void setPos( float x, float y )
  {
    mX = x;
    mY = y;
  }
  
  boolean pointInside( PVector pos )
  {
    return pointInside( pos.x, pos.y );
  }
  
  boolean pointInside( float x, float y )
  {
    // assume LEFT / TOP
    float minX = mX;
    float minY = mY;
    float maxX = mX + mWidth;
    float maxY = mY + mHeight;
    
    switch( mHorzAlign )
    {
      case CENTER: minX -= mWidth * 0.5f; maxX -= mWidth * 0.5f; break;
      case RIGHT: minX -= mWidth; maxX -= mWidth; break;
    }
    
    switch( mVertAlign )
    {
      case CENTER: minY -= mHeight * 0.5f; maxY -= mHeight * 0.5f; break;
      case BOTTOM: minY -= mHeight; maxY -= mHeight; break;
    }
    
    return ( x > minX && x < maxX && y > minY && y < maxY );
  }
}
