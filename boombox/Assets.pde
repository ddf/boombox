// audio junk
Minim minim;

// our main audio path
JamSyncer jamSyncer;
SampleAndRepeat sampleRepeat;
Bypass granulateBypass;
GranulateSteady granulate;
ChebFilter lowPass;
Gain  globalGain;
AudioOutput mainOut;

// controls
Line lowPassCutoff;
float lowPassCutoffSweepLength; // set in setup()
float lowPassCutoffHi = 21000.f;
float lowPassCutoffLo = 400.f;

// something to plug envelope followers into
Sink envFollowSink;

// SFX
AudioSample tapeGet;
AudioSample tapePlay;
AudioSample tapeStop;

// visual junks
Avatar player;
Mouse  mouse;
Inventory inventory;
Stage     theStage;

AnimationSystem animationSystem;

// all the Jams in the game
// Jam 0 is the backing jam
// Jam 1 is the first cassette you pick up
ArrayList<Jam> allJams;
// jams that are out in the world
// just, like, minding their own business, yo
ArrayList<Jam> worldJams;
ArrayList<EffectPickup> worldEffects;

class AssetLoader implements Runnable
{
  PApplet m_parent;
  
  AssetLoader( PApplet parent )
  {
    m_parent = parent;
  }
  
  void run()
  {
      animationSystem = new AnimationSystem(m_parent);
      animationSystem.loadAnimations( "animation/animations.xml" );

      loadEffectImage();
      
      TAPE = loadImage("BoomBox_Cassette_No_Teeth.png");
      
      loadSpeakerImages();
      
      float tempo = 121.f;
      float beatPerSec = 60.f / tempo;
    
      minim = new Minim(m_parent);
      mainOut = minim.getLineOut( Minim.STEREO, 512 );
      jamSyncer = new JamSyncer( tempo );
      sampleRepeat = new SampleAndRepeat( tempo, 0.5f );
      float grainRatio = 0.03f;
      granulate = new GranulateSteady( beatPerSec * (0.125f - grainRatio), beatPerSec * (0.125f + grainRatio), 0.0005f, // grainLength, spaceLength, fadeLength
                                       0.f, 1.f // min and max amplitude
                                     );
      granulateBypass = new Bypass( granulate );
      granulateBypass.activate();
      lowPass = new ChebFilter( lowPassCutoffHi, ChebFilter.LP, 2.0f, 4, mainOut.sampleRate() );
      globalGain = new Gain(0.f);
    
      lowPassCutoffSweepLength = (60.f / 121.f) * 4;
      lowPassCutoff = new Line( lowPassCutoffSweepLength, lowPassCutoffHi, lowPassCutoffLo );
      lowPassCutoff.patch( lowPass.cutoff );
    
      envFollowSink = new Sink();
      envFollowSink.patch( mainOut );
    
      tapeGet  = minim.loadSample( "tape_on.wav" );
      tapeGet.setGain( 2.f );
      tapePlay = minim.loadSample( "tape_in.wav" );
      tapePlay.setGain( 2.f );
      tapeStop = minim.loadSample( "tape_stop.wav" );
      tapeStop.setGain( 2.f );
    
      allJams = new ArrayList<Jam>();
    
      allJams.add( new Jam("backing_loop.wav", JamCategory.OTHER, color(0,0,0), -100, -100 ) );
      allJams.add( new Jam("drums_LP01.wav", JamCategory.DRUMS, #00FFFF, 580, 120) );
      allJams.add( new Jam("bass_LP01.wav", JamCategory.BASS, #FFA500, 600, 400) );
      allJams.add( new Jam("blip_LP01.wav", JamCategory.BLIP, #FFFF00, 200, 600) );
      allJams.add( new Jam("pad_LP04.wav", JamCategory.PAD, #008000, 100, 450) );
      allJams.add( new Jam("drums_LP02.wav", JamCategory.DRUMS, #0000FF, 580, 120) );
      allJams.add( new Jam("chords_LP02.wav", JamCategory.CHORD, #4B0082, 600, 400) );
      allJams.add( new Jam("blip_LP02.wav", JamCategory.BLIP, #EE82EE, 200, 600) );
      allJams.add( new Jam("pad_LP02.wav", JamCategory.PAD, #EEEEEE, 100, 450) );
      allJams.add( new Jam("drums_LP03.wav", JamCategory.DRUMS, #990000, 580, 120) );
      allJams.add( new Jam("bass_LP03.wav", JamCategory.BASS, #5F70FF, 600, 400) );
      allJams.add( new Jam("blip_LP03.wav", JamCategory.BLIP, #222222, 200, 600) );
      allJams.add( new Jam("blip_LP05.wav", JamCategory.BLIP, #00FF00, 100, 450) );
    
      worldJams = new ArrayList<Jam>();
    
      worldJams.add( allJams.get(1) );
      worldJams.add( allJams.get(3) );
      worldJams.add( allJams.get(5) );
      worldJams.add( allJams.get(8) );
      worldJams.add( allJams.get(9) );
      worldJams.add( allJams.get(11));
    
      worldEffects = new ArrayList<EffectPickup>();
    
      worldEffects.add( new EffectPickup( new LineSweep( lowPassCutoff, lowPassCutoffHi, lowPassCutoffLo, lowPassCutoffSweepLength ), 800, 450, #CCCCCC ) );
      worldEffects.add( new EffectPickup( new Bypasser( granulateBypass ), 1350, 400, #FF0000 ) );
      worldEffects.add( new EffectPickup( new SampleRepeat( sampleRepeat ), 3150, 410, #00AA00 ) );
    
      player = new Avatar( 50, height - 100 );
    
      mouse = new Mouse();
      inventory = new Inventory();
      theStage = new Stage();
  }
}
