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
  
  boolean willJamPlay( AudioRecordingStream jam )
  {
    return mToAdd.contains( jam );
  }
  
  boolean willJamEject( AudioRecordingStream jam )
  {
    return mToRemove.contains( jam );
  }
  
  boolean isJamPlaying( AudioRecordingStream jam )
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
  
  void queueJam( AudioRecordingStream jam )
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
  
  void playJam( AudioRecordingStream jam )
  {
    mActive.add( jam );
    jam.play();
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
    
    for(int i = 0; i < mActive.size(); ++i)
    {
      AudioStream as = (AudioStream)mActive.get(i);
      float[] samps = as.read();
      for(int s = 0; s < samps.length; ++s)
      {
        channels[s] += samps[s];
      }
    }
    
    if ( mSampleCount == mSamplesInMeasure )
    {
      // remove elements from our active list that are in our toBeRemoved list
      mActive.removeAll( mToRemove );
      mToRemove.clear();
      
      mSampleCount = 0;
      mMeasureCount++;
      
      if ( mMeasureCount % 4 == 0 )
      {
        for( int i = 0; i < mToAdd.size(); ++i)
        {
          AudioRecordingStream ars = (AudioRecordingStream)mToAdd.get(i);
          mActive.add( ars );
        }
        mToAdd.clear();
        
        for( int i = 0; i < mActive.size(); ++i )
        {
          AudioRecordingStream ars = (AudioRecordingStream)mActive.get(i);
          ars.setMillisecondPosition(0);
          ars.play();
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

