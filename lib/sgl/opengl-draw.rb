# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  LINES		= GL::LINES
  POINTS	= GL::POINTS
  LINE_STRIP	= GL::LINE_STRIP
  LINE_LOOP	= GL::LINE_LOOP
  TRIANGLES	= GL::TRIANGLES
  TRIANGLE_STRIP = GL::TRIANGLE_STRIP
  TRIANGLE_FAN	= GL::TRIANGLE_FAN
  QUADS		= GL::QUADS
  QUAD_STRIP	= GL::QUAD_STRIP
  POLYGON	= GL::POLYGON

  # draw
  def beginObj(*a)	$__a__.beginObj(*a)	end
  def endObj(*a)	$__a__.endObj(*a)	end
  def push(*a)		$__a__.push(*a)		end
  def pop(*a)		$__a__.pop(*a)		end
  def vertex(*a)	$__a__.vertex(*a)	end
  def normal(*a)	$__a__.normal(*a)	end
  def translate(*a)	$__a__.translate(*a)	end
  def rotateX(*a)	$__a__.rotateX(*a)	end
  def rotateY(*a)	$__a__.rotateY(*a)	end
  def rotateZ(*a)	$__a__.rotateZ(*a)	end
  def scale(*a)		$__a__.scale(*a)	end
  def point(*a)		$__a__.point(*a)	end
  def lineWidth(*a)	$__a__.lineWidth(*a)	end
  def line(*a)		$__a__.line(*a)		end
  def rect(*a)		$__a__.rect(*a)		end
  def triangle(*a)	$__a__.triangle(*a)	end
  def circle(*a)	$__a__.circle(*a)	end
  def box(*a)		$__a__.box(*a)		end
  def cube(*a)		$__a__.cube(*a)		end

  class Application
    LINES	= GL::LINES
    POINTS	= GL::POINTS
    LINE_STRIP	= GL::LINE_STRIP
    LINE_LOOP	= GL::LINE_LOOP
    TRIANGLES	= GL::TRIANGLES
    TRIANGLE_STRIP	= GL::TRIANGLE_STRIP
    TRIANGLE_FAN	= GL::TRIANGLE_FAN
    QUADS	= GL::QUADS
    QUAD_STRIP	= GL::QUAD_STRIP
    POLYGON	= GL::POLYGON

    # draw primitive
    def beginObj(mode = POLYGON)
      GL.Begin(mode)
    end

    def endObj
      GL.End
    end

    def push
      GL.PushMatrix
    end

    def pop
      GL.PopMatrix
    end

    def vertex(a, b = nil, c = nil, d = nil)
      GL.Vertex(a, b, c, d) if d
      GL.Vertex(a, b, c) if c
      GL.Vertex(a, b)
    end

    def normal(a, b = nil, c = nil)
      GL.Normal(a, b, c)
    end

    # matrix manipulation
    def translate(a, b, c = 0)
      GL.Translate(a, b, c)
    end

    def rotateX(a)
      GL.Rotate(a, 1, 0, 0)
    end

    def rotateY(a)
      GL.Rotate(a, 0, 1, 0)
    end

    def rotateZ(a)
      GL.Rotate(a, 0, 0, 1)
    end

    def scale(a)
      GL.Scale(a, a, a)
    end

    # simple draw
    def point(a, b, c = nil)
      GL.Begin(GL::POINTS)
      if c
	GL.Vertex(a, b, c)
      else
	GL.Vertex(a, b)
      end
      GL.End
    end

    def lineWidth(w)
      GL.LineWidth(w)
    end

    def line(a, b, c, d, e = nil, f = nil)
      GL.Begin(GL::LINES) 
      if e && f
	GL.Vertex(a, b, c) # 3D
	GL.Vertex(d, e, f)
      else
	GL.Vertex(a, b) # 2D
	GL.Vertex(c, d)
      end
      GL.End
    end

    def rect(a, b, c, d)
      GL.Rect(a, b, c, d)
    end

    def triangle(a, b, c, d, e, f)
      GL.Begin(GL::TRIANGLES)
      GL.Vertex(a, b)
      GL.Vertex(c, d)
      GL.Vertex(e, f)
      GL.End
    end

    def circleUnit(style = LINE_LOOP, div = nil)
      div = 32 if div.nil?
      e = 2 * Math::PI / div
      GL.Begin(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	GL.Vertex(x, y)
      }
      GL.End
    end
    private :circleUnit

    def circle(x, y, r, style = LINE_LOOP, div = nil)
      GL.PushMatrix
      GL.Translate(x, y, 0)
      GL.Scale(r, r, r)
      circleUnit(style, div)
      GL.PopMatrix
    end

    def box(x1, y1, z1, x2, y2, z2)
      box = [
	[x1, y1, z1], # 0 back left bottom
	[x2, y1, z1], # 1 back right bottom
	[x2, y2, z1], # 2 back right top
	[x1, y2, z1], # 3 back left top
	[x1, y1, z2], # 4 front left bottom
	[x2, y1, z2], # 5 front right bottom
	[x2, y2, z2], # 6 front right top
	[x1, y2, z2]  # 7 front left top
      ]
      GL.Begin(GL::QUADS)
      GL.Vertex(box[1]) # back
      GL.Vertex(box[0])
      GL.Vertex(box[3])
      GL.Vertex(box[2])
      GL.Vertex(box[0]) # left
      GL.Vertex(box[4])
      GL.Vertex(box[7])
      GL.Vertex(box[3])
      GL.Vertex(box[4]) # front
      GL.Vertex(box[5])
      GL.Vertex(box[6])
      GL.Vertex(box[7])
      GL.Vertex(box[5]) # right
      GL.Vertex(box[1])
      GL.Vertex(box[2])
      GL.Vertex(box[6])
      GL.Vertex(box[7]) # top
      GL.Vertex(box[6])
      GL.Vertex(box[2])
      GL.Vertex(box[3])
      GL.Vertex(box[0]) # bottom
      GL.Vertex(box[1])
      GL.Vertex(box[5])
      GL.Vertex(box[4])
      GL.End
    end

    def cube(x, y, z, s)
      s = s / 2
      box(x - s, y - s, z - s, x + s, y + s, z + s)
    end
  end

  # This class is not used for now.
  class FasterCircle
    # circle
    def self.circleUnit(style=LINE_LOOP, div=nil)
      div = 32 if div == nil
      e = 2 * Math::PI / div
      beginObj(style)
      div.times {|i|
	rad = i * e
	x = Math.cos(rad)
	y = Math.sin(rad)
	vertex(x, y)
      }
      endObj()
    end

    def self.make_list
      GL.NewList(1, GL::COMPILE)
      self.circleUnit(LINE_LOOP, 32)
      GL.EndList()
      GL.NewList(2, GL::COMPILE)
      self.circleUnit(POLYGON, 32)
      GL.EndList()
      GL.NewList(3, GL::COMPILE)
      self.circleUnit(LINE_LOOP, 6)
      GL.EndList()
      GL.NewList(4, GL::COMPILE)
      self.circleUnit(POLYGON, 6)
      GL.EndList()
    end

    def self.circleUnitList(style=LINE_LOOP, div=nil)
      if div == 32
	if style == LINE_LOOP
	  GL.CallList(1)
	elsif style == POLYGON
	  GL.CallList(2)
	end
      elsif div == 6
	if style == LINE_LOOP
	  GL.CallList(3)
	elsif style == POLYGON
	  GL.CallList(4)
	end
      end
    end

    def self.circle(x, y, r, style=LINE_LOOP, div=nil)
      push()
      translate(x, y)
      scale(r)
      #circleUnit(style, div)
      self.circleUnitList(style, div)
      pop()
    end
  end

end
