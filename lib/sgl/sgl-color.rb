#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")

module SGL
  RGB = 0
  HSV = 1
  DEFAULT_MAX = 100

  class ColorTranslatorRGB
    def initialize(r=nil, g=nil, b=nil, a=nil)
      a = DEFAULT_MAX if a == nil
      r = DEFAULT_MAX if r == nil
      g = b = r if g == nil || b == nil
      @rm, @gm, @bm, @am = r.to_f, g.to_f, b.to_f, a.to_f
    end

    def norm(r, g=nil, b=nil, a=nil)
      a = DEFAULT_MAX if a == nil
      g = b = r if g == nil || b == nil
      return [r/@rm, g/@gm, b/@bm, a/@am]
    end
  end

  class ColorTranslatorHSV
    def initialize(h=nil, s=nil, v=nil, a=nil)
      a = DEFAULT_MAX if a == nil
      h = DEFAULT_MAX if h == nil
      s = v = h if s == nil || v == nil
      @hm, @sm, @vm, @am = h.to_f, s.to_f, v.to_f, a.to_f
    end 

    def norm(h, s=nil, v=nil, a=nil)
      if h < 0
	base = (h.abs / @hm).to_i + 1
	h += (base * @hm).to_f
      end
      h = (h % @hm) if @hm < h
      a = DEFAULT_MAX if a == nil
      s = v = h if s == nil || v == nil
      r, g, b = hsv_to_rgb(360.0*h/@hm, s/@sm, v/@vm)
      return [r, g, b, a/@am]
    end

    def hsv_to_rgb(h, s, v) #h:[0-360] s,v:[0,1], r,g,b:[0,1]
      return v, v, v if s == 0.0
      h = 0 if h == 360
      h /= 60.0 #h is now [0,6)
      i = h.to_i
      f = (h-i).to_f
      pp = v * (1-s)
      q = v * (1-(s*f))
      t = v * (1-(s*(1-f)))
      #p [h,s,v, i, f, pp, q, t]
      case i
      when 0; return v, t, pp
      when 1; return q, v, pp
      when 2; return pp, v, t
      when 3; return pp, q, v
      when 4; return t, pp, v
      when 5; return v, pp, q
      end
      return 0, 0, 0
    end
  end
end
