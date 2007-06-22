# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require "Win32API"
require "singleton"

module Bass
  class Sample
    def initialize(file)
      @base = 60
      @bass = Bass::BassLib.instance
      @hsample = SampleLoader.instance.get(file)
      get_sample_info
    end

    attr_accessor :base

    def play(note = 60, volume = -1, pan = -101)
      sfreq = @freq * mtof(note) / mtof(@base)
      playEx(0, sfreq, volume, pan)
    end

    private

    # Get information of the sample.
    #
    # typedef struct {
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
    # } BASS_SAMPLE; 
    def get_sample_info
      info = ' ' * 1024 
      BASS_SampleGetInfo.call(@hsample, info)
      @freq, @volume, @pan, @flags, @length, @max, @mode3d, @mindist, @maxdist,
      @iangle, @oangle, @outvol, @vam, @priority = info.unpack("SSiSSSSffSSSSS")
    end

    # ŠO•””ñŒöŠJ
    # freq The sample rate. 100(min)-100000(max), -1 = use sample's default. 
    # volume The volume... 0(silent)-100(max), -1 = use sample's default. 
    # pan The panning position. -100(left)-100(right), -101 = use sample's default. 
    # loop TRUE = Loop the sample. -1 = use sample's default. 
    def playEx(start = 0, freq = -1, volume = -1, pan = -101, loop = -1)#:nodoc:
      # We have to check the paramterers for SamplePlayEx.
      freq = freq.to_i
      freq = 100 if freq < 100 && freq != -1
      freq = 100000 if 100000 < freq
      volume = volume.to_i
      volume = 0 if volume < -1
      volume = 100 if 100 < volume
      pan = pan.to_i
      pan = -100 if pan < -101
      pan =  100 if 100 < pan
      ch = BASS_SamplePlayEx.call(@hsample, start, freq, volume, pan, loop)
      @bass.add_playing_channel(ch)
      return ch
    end

    # midi note to frequency
    def mtof(note)
      return mtof(0) if note < 0
      return mtof(127) if 127 < note
      return 8.17579891564 * Math.exp(0.0577622650 * note)
    end

    # frequency to midi note
    def ftom(f)
      return f > 0 ? 17.3123405046 * Math.log(0.12231220585 * f) : -1500
    end
  end

  # private internal Class
  class SampleLoader #:nodoc:
    include Singleton

    MAX_SIMULTANEOUS_PLAYBACKS = 1000

    def initialize
      @samples = {}
    end

    def load(f)
      @samples[f] = load_file(f) if @samples[f].nil?
      return @samples[f]
    end

    alias get load

    def load_file(file)
      return BASS_SampleLoad.call(0, file, 0, 0,
				  MAX_SIMULTANEOUS_PLAYBACKS, 0)
    end
  end
end
