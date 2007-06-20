# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require "Win32API"
require "singleton"

module Bass
  BASS_OK		= 0	# all is OK
  BASS_ERROR_MEM	= 1	# memory error
  BASS_ERROR_FILEOPEN	= 2	# can't open the file
  BASS_ERROR_DRIVER	= 3	# can't find a free/valid driver
  BASS_ERROR_BUFLOST	= 4	# the sample buffer was lost - please report this!
  BASS_ERROR_HANDLE	= 5	# invalid handle
  BASS_ERROR_FORMAT	= 6	# unsupported format
  BASS_ERROR_POSITION	= 7	# invalid playback position
  BASS_ERROR_INIT	= 8	# BASS_Init has not been successfully called
  BASS_ERROR_START	= 9	# BASS_Start has not been successfully called
  BASS_ERROR_INITCD	= 10	# can't initialize CD
  BASS_ERROR_CDINIT	= 11	# BASS_CDInit has not been successfully called
  BASS_ERROR_NOCD	= 12	# no CD in drive
  BASS_ERROR_CDTRACK	= 13	# can't play the selected CD track
  BASS_ERROR_ALREADY	= 14	# already initialized
  BASS_ERROR_CDVOL	= 15	# CD has no volume control
  BASS_ERROR_NOPAUSE	= 16	# not paused
  BASS_ERROR_NOTAUDIO	= 17	# not an audio track
  BASS_ERROR_NOCHAN	= 18	# can't get a free channel
  BASS_ERROR_ILLTYPE	= 19	# an illegal type was specified
  BASS_ERROR_ILLPARAM	= 20	# an illegal parameter was specified
  BASS_ERROR_NO3D	= 21	# no 3D support
  BASS_ERROR_NOEAX	= 22	# no EAX support
  BASS_ERROR_DEVICE	= 23	# illegal device number
  BASS_ERROR_NOPLAY	= 24	# not playing
  BASS_ERROR_FREQ	= 25	# illegal sample rate
  BASS_ERROR_NOA3D	= 26	# A3D.DLL is not installed
  BASS_ERROR_NOTFILE	= 27	# the stream is not a file stream (WAV/MP3/MP2/MP1/OGG)
  BASS_ERROR_NOHW	= 29	# no hardware voices available
  BASS_ERROR_NOSYNC	= 30	# synchronizers have been disabled
  BASS_ERROR_EMPTY	= 31	# the MOD music has no sequence data
  BASS_ERROR_NONET	= 32	# no internet connection could be opened
  BASS_ERROR_CREATE	= 33	# couldn't create the file
  BASS_ERROR_NOFX	= 34	# effects are not enabled
  BASS_ERROR_PLAYING	= 35	# the channel is playing
  BASS_ERROR_NOOGG	= 36	# OGG.DLL/VORBIS.DLL could not be loaded
  BASS_ERROR_UNKNOWN	= -1	# some other mystery error

  # Device setup flags
  BASS_DEVICE_8BITS	= 1	# use 8 bit resolution, else 16 bit
  BASS_DEVICE_MONO	= 2	# use mono, else stereo
  BASS_DEVICE_3D	= 4	# enable 3D functionality

  # If the BASS_DEVICE_3D flag is not specified when initilizing BASS,
  # then the 3D flags (BASS_SAMPLE_3D and BASS_MUSIC_3D) are ignored when
  # loading/creating a sample/stream/music.
  BASS_DEVICE_A3D	= 8	# enable A3D functionality
  BASS_DEVICE_NOSYNC	= 16	# disable synchronizers
  BASS_DEVICE_LEAVEVOL	= 32	# leave the volume as it is
  BASS_DEVICE_OGG	= 64	# enable OGG support (requires OGG.DLL & VORBIS.DLL)

  # DirectSound interfaces (for use with BASS_GetDSoundObject)
  BASS_OBJECT_DS	= 1	# IDirectSound
  BASS_OBJECT_DS3DL	= 2	# IDirectSound3DListener

  # Music flags
  BASS_MUSIC_RAMP	= 1	# normal ramping
  BASS_MUSIC_RAMPS	= 2	# sensitive ramping
  # Ramping doesn't take a lot of extra processing and improves '
  # the sound quality by removing "clicks". Sensitive ramping will
  # leave sharp attacked samples, unlike normal ramping.
  BASS_MUSIC_LOOP	= 4	# loop music
  BASS_MUSIC_FT2MOD	= 16	# play .MOD as FastTracker 2 does
  BASS_MUSIC_PT1MOD	= 32	# play .MOD as ProTracker 1 does
  BASS_MUSIC_MONO	= 64	# force mono mixing (less CPU usage)
  BASS_MUSIC_3D		= 128	# enable 3D functionality
  BASS_MUSIC_POSRESET	= 256	# stop all notes when moving position
  BASS_MUSIC_SURROUND	= 512	# surround sound
  BASS_MUSIC_SURROUND2	= 1024	# surround sound (mode 2)
  BASS_MUSIC_STOPBACK	= 2048	# stop the music on a backwards jump effect
  BASS_MUSIC_FX		= 4096	# enable DX8 effects
  BASS_MUSIC_CALCLEN	= 8192	# calculate playback length

  BASS_SAMPLE_8BITS	= 1	# 8 bit, else 16 bit
  BASS_SAMPLE_MONO	= 2	# mono, else stereo
  BASS_SAMPLE_LOOP	= 4	# looped
  BASS_SAMPLE_3D	= 8	# 3D functionality enabled
  BASS_SAMPLE_SOFTWARE	= 16	# it's NOT using hardware mixing'
  BASS_SAMPLE_MUTEMAX	= 32	# muted at max distance (3D only)
  BASS_SAMPLE_VAM	= 64	# uses the DX7 voice allocation & management
  BASS_SAMPLE_FX	= 128	# the DX8 effects are enabled
  BASS_SAMPLE_OVER_VOL	= 0x10000	# override lowest volume
  BASS_SAMPLE_OVER_POS	= 0x20000	# override longest playing
  BASS_SAMPLE_OVER_DIST	= 0x30000	# override furthest from listener (3D only)

  BASS_MP3_HALFRATE	= 0x10000	# reduced quality MP3/MP2/MP1 (half sample rate)
  BASS_MP3_SETPOS	= 0x20000	# enable seeking on the MP3/MP2/MP1/OGG

  BASS_STREAM_AUTOFREE	= 0x40000	# automatically free the stream when it stop/ends
  BASS_STREAM_RESTRATE	= 0x80000	# restrict the download rate of internet file streams
  BASS_STREAM_BLOCK	= 0x100000	# download/play internet file stream (MPx/OGG) in small blocks

  BASS_CDID_IDENTITY	= 0
  BASS_CDID_UPC		= 1

  BASS_GetVersion           = Win32API.new("bass", "BASS_GetVersion", "V", "L")
  BASS_GetDeviceDescription = Win32API.new("bass", "BASS_GetDeviceDescription", "IP", "I")
  BASS_SetBufferLength = Win32API.new("bass", "BASS_SetBufferLength", "L", "V")
  BASS_SetGlobalVolumes = Win32API.new("bass", "BASS_SetGlobalVolumes", "III", "V")
  BASS_GetGlobalVolumes = Win32API.new("bass", "BASS_GetGlobalVolumes", "PPP", "V")
  BASS_SetLogCurves = Win32API.new("bass", "BASS_SetLogCurves", "II", "V")
  BASS_Set3DAlgorithm = Win32API.new("bass", "BASS_Set3DAlgorithm", "L", "V")
  BASS_ErrorGetCode = Win32API.new("bass", "BASS_ErrorGetCode", "V", "I")
  BASS_Init = Win32API.new("bass", "BASS_Init", "ILLP", "I")
  BASS_Free = Win32API.new("bass", "BASS_Free", "V", "V")
  BASS_GetDSoundObject = Win32API.new("bass", "BASS_GetDSoundObject", "L", "P")
  BASS_GetInfo = Win32API.new("bass", "BASS_GetInfo", "P", "V")
  BASS_GetCPU = Win32API.new("bass", "BASS_GetCPU", "V", "L")
  BASS_Start = Win32API.new("bass", "BASS_Start", "V", "I")
  BASS_Stop = Win32API.new("bass", "BASS_Stop", "V", "I")
  BASS_Pause = Win32API.new("bass", "BASS_Pause", "V", "I")
  BASS_SetVolume = Win32API.new("bass", "BASS_SetVolume", "L", "I")
  BASS_GetVolume = Win32API.new("bass", "BASS_GetVolume", "V", "I")
  BASS_Set3DFactors = Win32API.new("bass", "BASS_Set3DFactors", "LLL", "I")
  BASS_Get3DFactors = Win32API.new("bass", "BASS_Get3DFactors", "PPP", "I")
  BASS_Set3DPosition = Win32API.new("bass", "BASS_Set3DPosition", "PPPP", "I")
  BASS_Get3DPosition = Win32API.new("bass", "BASS_Get3DPosition", "PPPP", "I")
  BASS_Apply3D = Win32API.new("bass", "BASS_Apply3D", "V", "I")
  BASS_SetEAXParameters = Win32API.new("bass", "BASS_SetEAXParameters", "ILLL", "I")
  BASS_GetEAXParameters = Win32API.new("bass", "BASS_GetEAXParameters", "PPPP", "I")
#  BASS_SetA3DResManager = Win32API.new("bass", "BASS_SetA3DResManager", "L", "I")
#  BASS_GetA3DResManager = Win32API.new("bass", "BASS_GetA3DResManager", "V", "L")
#  BASS_SetA3DHFAbsorbtion = Win32API.new("bass", "BASS_SetA3DHFAbsorbtion", "L", "I")
#  BASS_GetA3DHFAbsorbtion = Win32API.new("bass", "BASS_GetA3DHFAbsorbtion", "P", "I")
  BASS_MusicLoad = Win32API.new("bass", "BASS_MusicLoad", "IPLLL", "L")
  BASS_MusicFree = Win32API.new("bass", "BASS_MusicFree", "P", "V")
  BASS_MusicGetName = Win32API.new("bass", "BASS_MusicGetName", "P", "P")
  BASS_MusicGetLength = Win32API.new("bass", "BASS_MusicGetLength", "PI", "L")
  BASS_MusicPreBuf = Win32API.new("bass", "BASS_MusicPreBuf", "P", "I")
  BASS_MusicPlay = Win32API.new("bass", "BASS_MusicPlay", "P", "I")
  BASS_MusicPlayEx = Win32API.new("bass", "BASS_MusicPlayEx", "PLII", "I")
  BASS_MusicSetAmplify = Win32API.new("bass", "BASS_MusicSetAmplify", "PL", "I")
  BASS_MusicSetPanSep = Win32API.new("bass", "BASS_MusicSetPanSep", "PL", "I")
  BASS_MusicSetPositionScaler = Win32API.new("bass", "BASS_MusicSetPositionScaler", "PL", "I")
  BASS_SampleLoad = Win32API.new("bass", "BASS_SampleLoad", "IPLLLL", "L")
  BASS_SampleCreate = Win32API.new("bass", "BASS_SampleCreate", "LLLL", "L")
  BASS_SampleCreateDone = Win32API.new("bass", "BASS_SampleCreateDone", "V", "P")
  BASS_SampleFree = Win32API.new("bass", "BASS_SampleFree", "P", "V")
  BASS_SampleGetInfo = Win32API.new("bass", "BASS_SampleGetInfo", "PP", "I")
  BASS_SampleSetInfo = Win32API.new("bass", "BASS_SampleSetInfo", "PP", "I")
  BASS_SamplePlay = Win32API.new("bass", "BASS_SamplePlay", "L", "L")
  BASS_SamplePlayEx = Win32API.new("bass", "BASS_SamplePlayEx", "PLIIII", "L")
  BASS_SamplePlay3D = Win32API.new("bass", "BASS_SamplePlay3D", "PPPP", "P")
  BASS_SamplePlay3DEx = Win32API.new("bass", "BASS_SamplePlay3DEx", "PPPPLIII", "P")
  BASS_SampleStop = Win32API.new("bass", "BASS_SampleStop", "P", "I")
  BASS_StreamCreate = Win32API.new("bass", "BASS_StreamCreate", "LLPL", "P")
  BASS_StreamCreateFile = Win32API.new("bass", "BASS_StreamCreateFile", "IPLLL", "P")
  BASS_StreamCreateURL = Win32API.new("bass", "BASS_StreamCreateURL", "PLP", "P")
  BASS_StreamFree = Win32API.new("bass", "BASS_StreamFree", "P", "V")
  BASS_StreamGetLength = Win32API.new("bass", "BASS_StreamGetLength", "P", "L")
  BASS_StreamPreBuf = Win32API.new("bass", "BASS_StreamPreBuf", "P", "I")
  BASS_StreamPlay = Win32API.new("bass", "BASS_StreamPlay", "PIL", "I")
  BASS_StreamGetFilePosition = Win32API.new("bass", "BASS_StreamGetFilePosition", "PL", "L")
  BASS_CDInit = Win32API.new("bass", "BASS_CDInit", "P", "I")
  BASS_CDFree = Win32API.new("bass", "BASS_CDFree", "V", "V")
  BASS_CDInDrive = Win32API.new("bass", "BASS_CDInDrive", "V", "I")
  BASS_CDGetID = Win32API.new("bass", "BASS_CDGetID", "L", "P")
  BASS_CDGetTracks = Win32API.new("bass", "BASS_CDGetTracks", "V", "L")
  BASS_CDPlay = Win32API.new("bass", "BASS_CDPlay", "LII", "I")
  BASS_CDGetTrackLength = Win32API.new("bass", "BASS_CDGetTrackLength", "L", "L")
  BASS_ChannelIsActive = Win32API.new("bass", "BASS_ChannelIsActive", "P", "I")
  BASS_ChannelGetFlags = Win32API.new("bass", "BASS_ChannelGetFlags", "L", "L")
  BASS_ChannelStop = Win32API.new("bass", "BASS_ChannelStop", "L", "I")
  BASS_ChannelPause = Win32API.new("bass", "BASS_ChannelPause", "L", "I")
  BASS_ChannelResume = Win32API.new("bass", "BASS_ChannelResume", "L", "I")
  BASS_ChannelSetAttributes = Win32API.new("bass", "BASS_ChannelSetAttributes", "LIII", "I")
  BASS_ChannelGetAttributes = Win32API.new("bass", "BASS_ChannelGetAttributes", "LPPP", "I")
  BASS_ChannelSet3DAttributes = Win32API.new("bass", "BASS_ChannelSet3DAttributes", "LILLIII", "I")
  BASS_ChannelGet3DAttributes = Win32API.new("bass", "BASS_ChannelGet3DAttributes", "LPPPPPP", "I")
  BASS_ChannelSet3DPosition = Win32API.new("bass", "BASS_ChannelSet3DPosition", "LPPP", "I")
  BASS_ChannelGet3DPosition = Win32API.new("bass", "BASS_ChannelGet3DPosition", "LPPP", "I")
  BASS_ChannelSetPosition = Win32API.new("bass", "BASS_ChannelSetPosition", "LL", "I")
  BASS_ChannelGetPosition = Win32API.new("bass", "BASS_ChannelGetPosition", "L", "L")
  BASS_ChannelGetLevel = Win32API.new("bass", "BASS_ChannelGetLevel", "L", "L")
  BASS_ChannelGetData = Win32API.new("bass", "BASS_ChannelGetData", "LPL", "L")
  BASS_ChannelSetSync = Win32API.new("bass", "BASS_ChannelSetSync", "LLLPL", "P")
  BASS_ChannelRemoveSync = Win32API.new("bass", "BASS_ChannelRemoveSync", "LP", "I")
  BASS_ChannelSetDSP = Win32API.new("bass", "BASS_ChannelSetDSP", "LPL", "P")
  BASS_ChannelRemoveDSP = Win32API.new("bass", "BASS_ChannelRemoveDSP", "LP", "I")
  BASS_ChannelSetFX = Win32API.new("bass", "BASS_ChannelSetFX", "LL", "P")
  BASS_ChannelRemoveFX = Win32API.new("bass", "BASS_ChannelRemoveFX", "LP", "I")
  BASS_ChannelSetEAXMix = Win32API.new("bass", "BASS_ChannelSetEAXMix", "LL", "I")
  BASS_ChannelGetEAXMix = Win32API.new("bass", "BASS_ChannelGetEAXMix", "LP", "I")
  BASS_ChannelSetLink = Win32API.new("bass", "BASS_ChannelSetLink", "LL", "I")
  BASS_ChannelRemoveLink = Win32API.new("bass", "BASS_ChannelRemoveLink", "LL", "I")
  BASS_FXSetParameters = Win32API.new("bass", "BASS_FXSetParameters", "PP", "I")
  BASS_FXGetParameters = Win32API.new("bass", "BASS_FXGetParameters", "PP", "I")

  #----------------------------------------------------------------------
#  class << Bass
#    def init(a, b, c, d) BASS_Init.call(a, b, c, d) end
#    def start() BASS_Start.call() end
#    def errorGetCode() BASS_ErrorGetCode.call() end
#    def getVersion() BASS_GetVersion.call() end
#    def free() BASS_Free.call() end
#    def sampleLoad(a, b, c, d, e, f) BASS_SampleLoad.call(a, b, c, d, e, f) end
#    def samplePlay(a) BASS_SamplePlay.call(a) end
#    def samplePlayEx(a, b, c, d, e, f) BASS_SamplePlayEx.call(a, b, c, d, e, f) end
#  end
  #at_exit { Bass.free; }
  at_exit { Bass::BASS_Free.call(); }

  # ----------------------------------------------------------------------
  class BassLib
    include Singleton

    def initialize
      #ret = Bass.init(-1, 44100, 0, 0)     #BASS_Init(-1,44100,BASS_DEVICE_OGG,0)   #BASS_Init(-1,44100,0,0))
      ret = Bass::BASS_Init.call(-1, 44100, 0, 0)     #BASS_Init(-1,44100,BASS_DEVICE_OGG,0)   #BASS_Init(-1,44100,0,0))
      #ver = Bass.getVersion()
      ver = Bass::BASS_GetVersion.call()
      #printf("ver is %x\n", ver)
      #ret = Bass.start()
      ret = Bass::BASS_Start.call()
      #p ["ret", ret]
      @playing_channel = []
    end

    def add_playing_channel(ch)
      @playing_channel << ch
    end

    def stop_all
      @playing_channel.each {|ch|
	ret = Bass::BASS_ChannelStop.call(ch)
	#p ["ChannelStop", ret]
      }
      @playing_channel = []
    end
  end

  # ----------------------------------------------- 非公開内部クラス
  class SampleLoader
    include Singleton

    MAX_SIMULTANEOUS_PLAYBACKS = 1000    #MAX_SIMULTANEOUS_PLAYBACKS = 65535

    def initialize()
      @h = Hash.new
      @freq = Hash.new
    end

    def get(filename)
      @h[filename] = load_file(filename) if @h[filename] == nil
      #ここで、サンプルの周波数をgetして、@freqに代入するべし。
      @freq[filename] = get_freq(filename) if @freq[filename] == nil
      return @h[filename], @freq[filename]
    end

    def load_file(file)
      #return Bass.sampleLoad(0, file, 0, 0, MAX_SIMULTANEOUS_PLAYBACKS, 0)
      #p ["load_file", file]
      ret = Bass::BASS_SampleLoad.call(0, file, 0, 0, MAX_SIMULTANEOUS_PLAYBACKS, 0)
      return ret

      #HSAMPLE WINAPI BASS_SampleLoad(BOOL mem, void *file, DWORD offset, DWORD length, DWORD max, DWORD flags);
    end

    def get_freq(file)
      hsample = @h[file]
      info = " " * 1024 
      Bass::BASS_SampleGetInfo.call(hsample, info)
      freq, volume, pan, flags, length, max, mode3d, mindist, maxdist, iangle, oangle, outvol, vam, priority =
	info.unpack("SSiSSSSffSSSSS")
      #info.delete!(" ")
      #p [file, hsample, info, freq, volume, pan, flags, length, max, mode3d, mindist, maxdist, iangle, oangle, outvol, vam, priority]
      #p [file, freq, volume, pan, flags, length, max]
      return freq
#typedef struct {
#    DWORD freq;
#    DWORD volume;
#    int pan;
#    DWORD flags;
#    DWORD length;
#    DWORD max;
#    DWORD mode3d;
#    float mindist;
#    float maxdist;
#    DWORD iangle;
#    DWORD oangle;
#    DWORD outvol;
#    DWORD vam;
#    DWORD priority;
#} BASS_SAMPLE; 
    end
  end

  class Sample
    def initialize(file=nil)
      @hsample = 0
      @samplefreq = 22000
      @base = 60
      @bass = Bass::BassLib.instance
      load_file(file) if file != nil
      self
    end
    attr_accessor :base
    def load_file(file)
      @hsample, @samplefreq = SampleLoader.instance.get(file)
    end
    def playEx(start=0, freq=-1, volume=-1, pan=-101, loop=-1) #外部非公開
#freq The sample rate... 100 (min) - 100000 (max), -1 = use sample's default. 
#volume The volume... 0 (silent) - 100 (max), -1 = use sample's default. 
#pan The panning position... -100 (left) - 100 (right), -101 = use sample's default. 
#loop TRUE = Loop the sample... -1 = use sample's default. 
      freq = freq.to_i
      freq = 100 if freq < 100 && freq != -1
      freq = 100000 if 100000 < freq
      volume = volume.to_i
      volume = 0 if volume < -1
      volume = 100 if 100 < volume
      pan = pan.to_i
      pan = -100 if pan < -101
      pan =  100 if 100 < pan
      #Bass.samplePlayEx(@hsample, start, freq, volume, pan, loop)  #エラーチェックを強化しないとすぐエラーになる。
      ch = Bass::BASS_SamplePlayEx.call(@hsample, start, freq, volume, pan, loop)  #エラーチェックを強化しないとすぐエラーになる。
      #printf("HCHANNEL is %x\n", ch)
      @bass.add_playing_channel(ch)
    end
    def play(note=60, volume=-1, pan=-101)
      freq = mtof(note)
      sfreq = @samplefreq * freq / mtof(@base)
      playEx(0, sfreq, volume, pan)
    end
    #alias playNote play
    def mtof(note)
      return mtof(0) if note < 0
      return mtof(127) if 127 < note
      return 8.17579891564 * Math.exp(0.0577622650 * note)
    end
    def mtof_nu(f)
      return 0 if (f <= -1500)
      return(mtof(1499)) if (f > 1499)
      return (8.17579891564 * Math.exp(0.0577622650 * f));
    end
    def ftom(f)
      return (f > 0 ? 17.3123405046 * Math.log(0.12231220585 * f) : -1500);
    end
  end
end

if __FILE__ == $0
  def main
    p "main"
    include Bass
    #bass = BassLib.new
    bass = BassLib.instance
    samp = Sample.new("start.wav")
    5.times {
      ret = samp.play
      #puts "ret is #{ret}, errorcode is #{Bass.errorGetCode}"
      puts "ret is #{ret}"
      sleep 0.1
    }
    sleep 1
    20.times { |i|
      #ret = bass_SamplePlayEx.call(hsample, 0, 1000 * i, 100, 0, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, -1, -1, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, 10 * i, -1, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, -1, 10 * i, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, 8000 + 1000 * i, -1, -1, -1)
      ret = samp.playEx(0, 8000 + 1000 * i, -1, -1, -1)
      #printf("ret is %x, errorcode is %d\n", ret, Bass.errorGetCode())
      #printf("ret is %x, errorcode is %d\n", ret, Bass::BASS_ErrorGetCode.call())
      puts"ret is #{ret}, errorcode is #{ Bass::BASS_ErrorGetCode.call}"
      ###define BASS_ERROR_START	= 9	/// BASS_Start has not been successfully called
      sleep 0.2
    }
  end

  main
end
