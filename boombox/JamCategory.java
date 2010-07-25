public enum JamCategory 
{
  DRUMS (true),
  BASS (true),
  BLIP (false),
  PAD (false),
  OTHER (false);
  
  private boolean m_bExclusive;
  
  private JamCategory( boolean exclusive )
  {
    m_bExclusive = exclusive;
  }
  
  public boolean isExclusive() { return m_bExclusive; }
}
