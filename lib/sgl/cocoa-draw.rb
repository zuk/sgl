# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

module SGL
  module FrameTranslator
    def to_xywh(a,b,c,d)
      [[a, c].min,  [b, d].min, (a - c).abs, (b - d).abs]
    end
    private :to_xywh
  end

  def point(*a)	$__a__.point(*a);	end
  def lineWidth(*a)	$__a__.lineWidth(*a);	end
  def line(*a)	$__a__.line(*a);	end
  def rect(*a)	$__a__.rect(*a);	end
  def circle(*a)	$__a__.circle(*a);	end
  def rotateZ(*a)	$__a__.rotateZ(*a);	end
  def translate(*a)	$__a__.translate(*a);	end
  def scale(*a)	$__a__.scale(*a);	end
  def reset(*a)	$__a__.reset(*a);	end

  class Application
    include FrameTranslator

    def point(a,b)
      line(a,b,a,b)
    end

    def lineWidth(w)
      OSX::NSBezierPath.setDefaultLineWidth(w)
    end

    def line(a,b,c,d)
      #OSX::NSBezierPath.strokeLine({:fromPoint=>OSX::NSPoint.new(a, b),
      #				     :toPoint=>OSX::NSPoint.new(c, d)})
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
