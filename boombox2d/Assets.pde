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

// physics
Physics gPhysics;


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
      loadStarImages();
      
      float tempo = 121.f;
      float beatPerSec = 60.f / tempo;
    
      minim = new Minim(m_parent);
      // minim.debugOn();
      mainOut = minim.getLineOut( Minim.STEREO, 1024 );
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
      
      gPhysics = new Physics(boombox2d.this, 3900, height);
      gPhysics.getWorld().setGravity( new Vec2( 0.f, -60.f ) );
      // immediately unregister it so the main thread doesn't try to tick it while we are building the world.
      boombox2d.this.unregisterDraw( gPhysics );
      gPhysics.setCustomRenderingMethod( boombox2d.this, "debugDrawForPhysics" );
    
      allJams = new ArrayList<Jam>();
    
      allJams.add( new Jam("backing_loop.wav", JamCategory.OTHER, color(0,0,0), -100, -100 ) );
      allJams.add( new Jam("drums_LP01.wav",   JamCategory.DRUMS, #01e4ff,      580, 120) );
      allJams.add( new Jam("bass_LP01.wav",    JamCategory.BASS,  #77da6f,      600, 400) );
      allJams.add( new Jam("blip_LP01.wav",    JamCategory.BLIP,  #ffffff,      200, 600) );
      allJams.add( new Jam("pad_LP04.wav",     JamCategory.PAD,   #a966cf,      100, 450) );
      allJams.add( new Jam("drums_LP02.wav",   JamCategory.DRUMS, #28a0ae,      580, 120) );
      allJams.add( new Jam("chords_LP02.wav",  JamCategory.CHORD, #212bc0,      600, 400) );
      allJams.add( new Jam("blip_LP02.wav",    JamCategory.BLIP,  #ffee33,      200, 600) );
      allJams.add( new Jam("pad_LP02.wav",     JamCategory.PAD,   #292928,      100, 450) );
      allJams.add( new Jam("drums_LP03.wav",   JamCategory.DRUMS, #d93c65,      580, 120) );
      allJams.add( new Jam("bass_LP03.wav",    JamCategory.BASS,  #fe867d,      600, 400) );
      allJams.add( new Jam("blip_LP03.wav",    JamCategory.BLIP,  #e7a858,      200, 600) );
      allJams.add( new Jam("blip_LP05.wav",    JamCategory.BLIP,  #f4be2e,      100, 450) );
    
      worldJams = new ArrayList<Jam>();
    
      worldJams.add( allJams.get(1) );
      worldJams.add( allJams.get(3) );
      worldJams.add( allJams.get(5) );
      worldJams.add( allJams.get(8) );
      worldJams.add( allJams.get(9) );
      worldJams.add( allJams.get(11));
    
      worldEffects = new ArrayList<EffectPickup>();
    
      worldEffects.add( new EffectPickup( new LineSweep( lowPassCutoff, lowPassCutoffHi, lowPassCutoffLo, lowPassCutoffSweepLength ), 800, 450, #afa38b ) );
      worldEffects.add( new EffectPickup( new Bypasser( granulateBypass ), 1350, 400, #ffffff ) );
      worldEffects.add( new EffectPickup( new SampleRepeat( sampleRepeat ), 3150, 410, #67606b ) );
    
      player = new Avatar( 50, height - 100 );
    
      mouse = new Mouse();
      inventory = new Inventory();
      theStage = new Stage();
      
      // create bodies for all the world jams
      for(int i = 0; i < worldJams.size(); ++i)
      {
        worldJams.get(i).createBody();
      }
      
      // create bodies for all the world effects
      for(int i = 0; i < worldEffects.size(); ++i)
      {
        worldEffects.get(i).createBody();
      }
      
      boombox2d.this.registerDraw( gPhysics );
  }
}
