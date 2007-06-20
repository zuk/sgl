# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

module SGL
  # module control
  def useMidi()		$__a__.useMidi;		end
  def useMidiIn(*a)	$__a__.useMidiIn(*a)	end
  def useSound()	$__a__.useSound;	end

  class Application
    def useMidi
      require "sgl/sgl-midi"
      $__midi__ = SGLMidi.new
    end

    def useMidiIn(num = -1)
      require "sgl/sgl-midiin"
      printMidiDeviceNames
      openMidiIn(num)
      startMidiInThread
    end

    def useSound
      require "sgl/sgl-sound"
      $__sound__ = SGLSound.instance
    end
  end
end
