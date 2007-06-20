# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/opengl"
require "sgl/sgl-spring"

class Button
  def initialize(x, y)
    @dx, @dy = x, y
    @x, @y = x, y
    @w, @h = 8, 8
  end

  attr_accessor :x, :y

  def pos
    return [x, y]
  end

  def move_to(x, y)
    @x, @y = x, y
  end

  def draw(s)
    colorHSV(0, s, 100, 60)
    draw_rect(@w, @h)
    colorHSV(0, s,   0, 30)
    draw_rect(@w-1, @h-1)
  end

  def draw_rect(w, h)
    rect(@x-w, @y-h, @x+w, @y+h)
  end

  def inside?(x, y)
    (@x-@w) < x && x < (@x+@w) && (@y-@h) < y && y < (@y+@h)
  end
end

class ButtonColumn
  def initialize(length, dy, hy)
    @length, @dy, @hy = length, dy, hy #destination y and hide y
    @cur = 0
    @buttons = []
    @y_spring = NumSpring.new(@dy, @dy, 5, 0.6)
    make_buttons
  end

  attr_reader :y_spring
  attr_accessor :cur

  def make_buttons
    y = @y_spring.x
    sw = 46
    w = 0
    @length.times {
      @buttons << Button.new(0, y)
      w += sw
    }
    x = -w/2
    @buttons.each {|b|
      b.x = x
      x += sw
    }
  end

  def move(x, y)
    # @y_spring.target = y.abs < (768/2 - 120) ? @hy : @dy
    #if y.abs < (768/2 - 120)
    if (@dy - y).abs < 50
      @y_spring.target = @dy
    else
      @y_spring.target = @hy
    end
    @y_spring.moving = true
    @y_spring.move
    y = @y_spring.x
    @buttons.each {|b|
      b.y = y
    }
  end

  def draw
    @buttons.each_index {|i|
      b = @buttons[i]
      s = (@cur == i) ? 100 : 0
      b.draw(s)
    }
  end

  def onMouseDown(x, y)
    @buttons.each_index {|i|
      b = @buttons[i]
      if b.inside?(x, y)
	@cur = i
	return i
      end
    }
    nil
  end
end

if $0 == __FILE__
  require "test/unit"
  $__test_sgl__ = true
end

if defined?($__test_sgl__) && $__test_sgl__
  class TestSglButton < Test::Unit::TestCase #:nodoc:
    def test_button
      b = Button.new(1, 2)
      assert_equal(1, b.x)
      assert_equal(2, b.y)
      assert_equal([1, 2], b.pos)
    end

    def test_draw
      app = SGL::Application.new
      app.set_setup {
	app.window(100, 100)
	app.runtime = 0.1
      }
      i = 0
      button = Button.new(0, 0)
      app.set_display {
	button.move_to(i, i)
	button.draw(i)
	i += 5
	i = 0 if 100 < i
      }
      app.mainloop
    end
  end
end
