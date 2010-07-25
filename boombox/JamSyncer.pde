// an interface to implement if you want to get called when the loop begins
interface LoopListener
{
  void looped();
}

// a UGen to sync all of the Jams
class JamSyncer extends UGen
{
  // a list of AudioRecordingStreams that we are currently pulling from
  private ArrayList<Jam> mActive;
  // a list of AudioRecordingStream we should remove at the end of a loop
  private ArrayList<Jam> mToRemove;
  // a list of AudioRecordingStreams we should add at the end of a loop
  private ArrayList<Jam> mToAdd;
  // a dummy summer to bump the output count of active jams
  // eventually I should switch to using this instead of mActive
  private Summer mSink;
  
  // all of our loop listeners
  private ArrayList mLoopListeners;
  
  // where we are at in the sample count for one measure
  private int       mSampleCount;
  // how many samples are in one measure
  private int       mSamplesInMeasure;
  // how many measure have gone by
  private int       mMeasureCount;
  // what BPM we are syncing at
  private float    mBPM;
  
  JamSyncer( float bpm )
  {
    mActive = new ArrayList<Jam>();
    mToRemove = new ArrayList<Jam>();
    mToAdd = new ArrayList<Jam>();
    mLoopListeners = new ArrayList();
    mSink = new Summer();
    
    mSampleCount = 0;
    mMeasureCount = 0;
    mSamplesInMeasure = 0;
    mBPM = bpm;
  }
  
  void addLoopListener( LoopListener ll )
  {
    mLoopListeners.add( ll );
  }
  
  void removeLoopListener( LoopListener ll )
  {
    mLoopListeners.remove( ll );
  }
  
  boolean willJamPlay( Jam jam )
  {
    return mToAdd.contains( jam );
  }
  
  boolean willJamEject( Jam jam )
  {
    return mToRemove.contains( jam );
  }
  
  boolean isJamPlaying( Jam jam )
  {
    return mActive.contains(jam);
  }
  
  int getSampleCount()
  {
    return mSampleCount;
  }
  
  int getLength()
  {
    return mSamplesInMeasure;
  }
  
  int getMeasureCount()
  {
    return mMeasureCount;
  }
  
  void queueJam( Jam jam )
  {
    boolean bActive = mActive.contains(jam);
    if ( bActive == false && mToAdd.contains(jam) == false )
    {
      // println("Adding a jam that is about " + jam.getMetaData().sampleFrameCount() + " samples long. We calc'd one loop at " + mSamplesInMeasure);
      mToAdd.add( jam );
      tapePlay.trigger();
    }
    else if ( bActive == true && mToRemove.contains(jam) == false )
    {
      mToRemove.add( jam );
      tapeStop.trigger();
    }
  }
  
  private void calcSamplesInMeasure()
  {
    float beatPerSec = 60.f / mBPM;
    // 4 beats, one full measure
    float totalSamples = 4 * sampleRate() * beatPerSec;
    println("calcSamplesInMeasure: totalSamples = " + totalSamples);
    mSamplesInMeasure = (int)totalSamples;
  }
  
  void setBPM( float bpm )
  {
    mBPM = bpm;
    calcSamplesInMeasure();
  }
  
  protected void sampleRateChanged()
  {
    calcSamplesInMeasure();
  }
  
  void playJam( Jam jam )
  {
    mActive.add( jam );
    jam.setSampleNum( 0 );
    jam.setPaused( false );
    jam.patch( mSink );
  }
  
  private void removeJam( Jam j )
  {
      j.unpatch( mSink );
      j.setPaused( true );
      mActive.remove( j );
  }
  
  protected void uGenerate( float[] channels )
  {
    mSampleCount++;
    
    for(int i = 0; i < channels.length; ++i)
    {
      channels[i] = 0;
    }
    
    float[] samps = new float[channels.length];
    
    for(int i = 0; i < mActive.size(); ++i)
    {
      Jam j = mActive.get(i);
      j.tick( samps );
      for(int s = 0; s < samps.length; ++s)
      {
        channels[s] += samps[s];
      }
    }
    
    if ( mSampleCount == mSamplesInMeasure )
    {
      // remove elements from our active list that are in our toBeRemoved list
      for( int i = 0; i < mToRemove.size(); ++i )
      {
        Jam j = mToRemove.get(i);
        removeJam( j );
      }
      mToRemove.clear();
      
      mSampleCount = 0;
      mMeasureCount++;
      
      if ( mMeasureCount % 4 == 0 )
      {
        for(int i = 0; i < mToAdd.size(); ++i)
        {
          Jam j = mToAdd.get(i);
          
          // see if there is currently a jam of the same catergory playing
          // and remove it if the category is an exclusive one.
          if ( j.getCategory().isExclusive() )
          {
            Iterator<Jam> iter = mActive.iterator();
            while( iter.hasNext() )
            {
              Jam comp = iter.next();
              if ( comp.getCategory() == j.getCategory() )
              {
                removeJam( comp );
                break;
              }
            }
          }
          
          playJam( j );
        }
        mToAdd.clear();
        
        for( int i = 0; i < mActive.size(); ++i )
        {
          Jam j = mActive.get(i);
          j.setSampleNum( 0 );
        }
        
        for(int i = 0; i < mLoopListeners.size(); ++i)
        {
          LoopListener ll = (LoopListener)mLoopListeners.get(i);
          ll.looped();
        }
      }
    }
  }
  
}

