# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  def background(*a)	$__a__.background(*a)	end
  def backgroundHSV(*a)	$__a__.backgroundHSV(*a)	end
  def color(*a)		$__a__.color(*a)	end
  def colorHSV(*a)	$__a__.colorHSV(*a)	end

  class Application
    def initialize_color
      @bg_color = @cur_color = nil
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100)
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)
    end
    private :initialize_color

    attr_reader :cur_color # for test

    def background(x, y = nil, z = nil, a = nil)
      GL.ClearColor(*@rgb.norm(x, y, z, a))
      clear
    end

    def backgroundHSV(x, y = nil, z = nil, a = nil)
      GL.ClearColor(*@hsv.norm(x, y, z, a))
      clear
    end

    def clear
      GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    end
    private :clear

    def color(x, y = nil, z = nil, a = nil)
      @cur_color = [x, y, z, a]
      GL.Color(*@rgb.norm(x, y, z, a))
    end

    def colorHSV(x, y = nil, z = nil, a = nil)
      GL.Color(*@hsv.norm(x, y, z, a))
    end
  end
end
