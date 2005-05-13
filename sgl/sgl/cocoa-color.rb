# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

module SGL
  def background(*a)	$__a__.background(*a);	end
  def backgroundHSV(*a)	$__a__.backgroundHSV(*a);	end
  def color(*a)		$__a__.color(*a);	end
  def colorHSV(*a)	$__a__.colorHSV(*a);	end

  class Application
    def initialize_color
      @bg_color = @cur_color = nil
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100)
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)
    end
    private :initialize_color
    attr_reader :cur_color

    def background(x, y=nil, z=nil, a=nil)
      @bg_color = @rgb.norm(x,y,z,a)
    end

    def backgroundHSV(x, y=nil, z=nil, a=nil)
      @bg_color = @hsv.norm(x,y,z,a)
    end

    def color(x, y=nil, z=nil, a=nil)
      @cur_color = @rgb.norm(x,y,z,a)
      set_cur_color
    end

    def colorHSV(x, y=nil, z=nil, a=nil)
      @cur_color = @hsv.norm(x,y,z,a)
      set_cur_color
    end

    # called from cocoa-media
    # Since thie method called from NSFont, this should be public.
    def make_cur_color
      make_color(*@cur_color)
    end

    def get_cur_color_alpha
      @cur_color[3]
    end

    # private
    def set_cur_color
      set_color(*@cur_color)
    end

    def set_cur_bg
      set_color(*@bg_color)
    end

    def set_color(*a)
      make_color(*a).set if @win
    end

    def make_color(r, g, b, a)
      OSX::NSColor.colorWithDeviceRed(r, :green, g, :blue, b, :alpha, a)
    end
    private :set_cur_color, :set_cur_bg, :set_color, :make_color
  end
end
