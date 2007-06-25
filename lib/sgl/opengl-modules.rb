# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  # module control
  def useMidi()		$__a__.useMidi;		end
  def useMidiIn(*a)	$__a__.useMidiIn(*a)	end

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
  end
end
