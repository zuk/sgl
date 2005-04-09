# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

module SGL
  module FrameTranslator
    def to_xywh(a,b,c,d)
      [[a, c].min,  [b, d].min, (a - c).abs, (b - d).abs]
    end
    private :to_xywh
  end

  class Application
    include FrameTranslator

    # set color
    def background(x, y=nil, z=nil, a=nil)
      @bgcolor = @rgb.norm(x,y,z,a)
    end

    def backgroundHSV(x, y=nil, z=nil, a=nil)
      @bgcolor = @hsv.norm(x,y,z,a)
    end

    def color(x, y=nil, z=nil, a=nil)
      @curcolor = @rgb.norm(x,y,z,a)
      set_cur_color
    end

    def colorHSV(x, y=nil, z=nil, a=nil)
      @curcolor = @hsv.norm(x,y,z,a)
      set_cur_color
    end

    def set_cur_color
      set_color(*@curcolor)
    end

    def set_color(*a)
      make_color(*a).set if @win
    end

    def make_color(r, g, b, a)
      OSX::NSColor.colorWithDeviceRed(r, :green, g, :blue, b, :alpha, a)
    end
    private :set_cur_color, :set_color, :make_color

    # This methos should be public. called from NSFont
    def color_cur
      make_color(*@curcolor)
    end

    # draw
    def point(a,b)
      line(a,b,a,b)
    end

    def lineWidth(w)
      OSX::NSBezierPath.setDefaultLineWidth(w)
    end

    def line(a,b,c,d)
      OSX::NSBezierPath.strokeLineFromPoint(OSX::NSPoint.new(a, b),
					    :toPoint, OSX::NSPoint.new(c, d))
    end

    def rect(a,b,c,d)
      rect = OSX::NSRect.new(*to_xywh(a, b, c, d))
      OSX::NSBezierPath.bezierPathWithRect(rect).fill
    end

    def circle(x, y, r)
      rect = OSX::NSRect.new(x - r, y - r, 2*r, 2*r)
      OSX::NSBezierPath.bezierPathWithOvalInRect(rect).fill
    end

    def rotateZ(deg)
      af = OSX::NSAffineTransform.transform
      af.rotateByDegrees(deg)
      af.concat
    end

    def translate(x, y)
      af = OSX::NSAffineTransform.transform
      af.translateXBy(x, :yBy, y)
      af.concat
    end

    def scale(x, y=nil)
      af = OSX::NSAffineTransform.transform
      y ? af.scaleXBy(x, :yBy, y) : af.scaleBy(x)
      af.concat
    end

    def reset
      OSX::NSAffineTransform.transform.set
    end
  end
end
