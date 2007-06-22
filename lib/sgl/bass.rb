# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require 'Win32API'
require 'singleton'
require 'sgl/bass-sample'
require 'sgl/bass-api'

module Bass
  at_exit { BASS_Free.call }

  class BassLib
    include Singleton

    def initialize
     #ret = Bass::BASS_Init.call(-1, 44100, BASS_DEVICE_OGG, 0)
      ret = Bass::BASS_Init.call(-1, 44100, 0, 0)
      ver = Bass::BASS_GetVersion.call
      ret = Bass::BASS_Start.call
      @playing_channel = []
    end

    def add_playing_channel(ch)
      @playing_channel << ch
    end

    def stop_all
      @playing_channel.each {|ch|
	ret = Bass::BASS_ChannelStop.call(ch)
      }
      @playing_channel = []
    end
  end

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
end
