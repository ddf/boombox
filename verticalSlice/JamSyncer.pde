// an interface to implement if you want to get called when the loop begins
interface LoopListener
{
  void looped();
}

// a UGen to sync all of the Jams
class JamSyncer extends UGen
{
  // a list of AudioRecordingStreams that we are currently pulling from
  private ArrayList mActive;
  // a list of AudioRecordingStream we should remove at the end of a loop
  private ArrayList mToRemove;
  // a list of AudioRecordingStreams we should add at the end of a loop
  private ArrayList mToAdd;
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
    mActive = new ArrayList();
    mToRemove = new ArrayList();
    mToAdd = new ArrayList();
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
  
  boolean willJamPlay( FilePlayer jam )
  {
    return mToAdd.contains( jam );
  }
  
  boolean willJamEject( FilePlayer jam )
  {
    return mToRemove.contains( jam );
  }
  
  boolean isJamPlaying( FilePlayer jam )
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
  
  void queueJam( FilePlayer jam )
  {
    boolean bActive = mActive.contains(jam);
    if ( bActive == false && mToAdd.contains(jam) == false )
    {
      // println("Adding a jam that is about " + jam.getMetaData().sampleFrameCount() + " samples long. We calc'd one loop at " + mSamplesInMeasure);
      mToAdd.add( jam );
    }
    else if ( bActive == true && mToRemove.contains(jam) == false )
    {
      mToRemove.add( jam );
    }
  }
  
  void playJam( FilePlayer jam )
  {
    mActive.add( jam );
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
      FilePlayer fp = (FilePlayer)mActive.get(i);
      fp.tick( samps );
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
        FilePlayer fp = (FilePlayer)mToRemove.get(i);
        fp.pause();
        mActive.remove( fp );
      }
      mToRemove.clear();
      
      mSampleCount = 0;
      mMeasureCount++;
      
      if ( mMeasureCount % 4 == 0 )
      {
        for(int i = 0; i < mToAdd.size(); ++i)
        {
          FilePlayer fp = (FilePlayer)mToAdd.get(i);
          fp.patch( mSink );
          mActive.add( fp );
        }
        mToAdd.clear();
        
        for( int i = 0; i < mActive.size(); ++i )
        {
          FilePlayer fp = (FilePlayer)mActive.get(i);
          fp.play(0);
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

