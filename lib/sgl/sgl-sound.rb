# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require 'sgl/bass'

module SGL
  def useSound()	$__a__.useSound;	end
  def loadSound(*a)	$__a__.loadSound(*a)	end
  def stopSound(*a)	$__a__.stopAll(*a)	end

  class Application
    def useSound
      bass = Bass::BassLib.instance
    end

    def loadSound(file)
      return Bass::Sample.new(file)
    end

    def stopSound
      Bass::BassLib.instance.stop_all
    end
  end
end
