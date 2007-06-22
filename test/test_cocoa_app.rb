#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'

if /osx/ =~ RUBY_PLATFORM

require "sgl/cocoa-app"

class TestCocoaBasic < Test::Unit::TestCase
  def test_basic
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.5
    }
    i = 0
    app.set_display {
      app.line(0, 0, 100, i*5)
      i += 2
      i = 0 if 20 < i
    }
    app.mainloop
  end

  def test_window
    app = SGL::Application.new
    sleep 0.01;	app.window(100, 100)
    sleep 0.01;	app.close_window
    sleep 0.01;	app.window(500, 500)
    sleep 0.01;	app.close_window
    sleep 0.01;	app.window(100, 100, :border=>false)
    sleep 0.01;	app.close_window
    sleep 0.01;	app.window(100, 100, :shadow=>false, :border=>false)
    sleep 0.01;	app.close_window
  end

  def test_color
    app = SGL::Application.new
    app.window(100, 100)
    app.background(100)
    bgcolor = app.instance_eval { @bgcolor }
    assert_equal([1.0, 1.0, 1.0, 1.0], bgcolor)
    app.background(10, 20, 30)
    bgcolor = app.instance_eval { @bgcolor }
    assert_equal([0.1, 0.2, 0.3, 1.0], bgcolor)
    app.color(0)
    curcolor = app.instance_eval { @curcolor }
    assert_equal([0.0, 0.0, 0.0, 1.0], curcolor)
    app.color(10, 20, 30)
    curcolor = app.instance_eval { @curcolor }
    assert_equal([0.1, 0.2, 0.3, 1.0], curcolor)
    app.close_window
  end

  def test_setup_and_display
    app = SGL::Application.new
    app.window(100, 100)

    test_setup_done = false
    app.set_setup { test_setup_done = true }
    assert_equal(false, test_setup_done)
    app.do_setup
    assert_equal(true,  test_setup_done)

    test_display_done = false
    app.set_display { test_display_done = true }
    assert_equal(false, test_display_done)
    app.do_display
    assert_equal(true,  test_display_done)
    app.close_window
  end

  def test_event
    app = SGL::Application.new
    app.window(100, 100)

    test = {}
    app.set_mousedown { test[:mousedown] = true }
    assert_equal(nil,  test[:mousedown])
    app.do_mousedown
    assert_equal(true, test[:mousedown])
  end
end

class TestCocoaDraw < Test::Unit::TestCase
  def test_commands
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.1
    }
    app.set_display {
      app.line(0, 0, 100, 100)
      app.rect(40, 40, 60, 60)
      app.circle(20, 20, 10)
    }
    app.mainloop
  end

  def test_for
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.1
    }
    app.set_display {
      for i in 0..20
	app.line(0, 0, 100, i*5)
      end
    }
    app.mainloop
  end

  def test_iterate
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.5
    }
    i = 0
    app.set_display {
      app.line(0, 0, 100, i*5)
      i += 1
      i = 0 if 20 < i
    }
    app.mainloop
  end

  def test_font
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.1
    }
    font = app.font("Helvetica")
    app.set_display {
      font.text(50, 50, "hello")
    }
    app.mainloop
  end

  def test_font_iterate
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.5
    }
    i = 10
    app.set_display {
      font = app.font("Helvetica", i)
      font.text(0, 0, "hello")
      i += 5
      i = 0 if 200 < i
    }
    app.mainloop
  end

  def test_affine
    app = SGL::Application.new
    app.set_setup {
      app.window(300, 300)
      app.runtime = 0.5
      @font = app.font("Helvetica", 20)
    }
    i = 0
    app.set_display {
      app.colorHSV 66, 100, 100, 50
      app.lineWidth(i/10)
      app.line(0, 0, 300, i)
      app.translate i, i
      app.rotateZ i
      app.colorHSV i, 100, 100
      @font.text(0, 0, "rotate")
      app.rect(-10, -10, +10, +10)
      i += 20
      i = 0 if 300 < i
    }
    app.mainloop
  end
end

class TestCocoaMedia < Test::Unit::TestCase
  def test_image
    app = SGL::Application.new
    app.set_setup {
      app.window(200, 200)
      app.runtime = 0.5
    }
    image = app.image("../media/balls.png")
    i = 10
    app.set_display {
      app.background 100-i
      image.rect(0, i, 100, i+50)
      i += 5
      i = 0 if 100 < i
    }
    app.mainloop
  end

  def nutest_sound
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 1.5
      @sound = app.sound("../media/Pop.aiff")
      @first = true
    }
    app.set_display {
      if @first
	@sound.play
	@first = false
      end
    }
    app.mainloop
  end
end

#class TestCocoaMovie < Test::Unit::TestCase
class TestCocoaMovie
  TEST_MOVIE = "/Applications/iDVD 3/Tutorial/Media/Background Movie.mov"

  def test_movie
    app = SGL::Application.new
    app.set_setup {
      app.window(500, 500)
      app.runtime = 2.0
      @movie = app.movie(TEST_MOVIE)
      @movie.play
    }
    i = 100
    app.set_display {
      app.background 100-i
      @movie.rect(i, i, 200+i, 150+i)
      i += 5
      i = 0 if 500 < i
    }
    app.mainloop
  end

  def test_movie_view
    app = SGL::Application.new
    app.set_setup {
      app.window(500, 500, :movie=>true, :overlay=>true)
      app.runtime = 3.0
      @movie = app.movie(TEST_MOVIE)
      @movie.play
    }
    i = 100
    app.set_display {
      app.background 100-i/5
      app.colorHSV(66, 100, 100, 50)
      app.circle(500-i, i, 100)
      i += 20
      i = 0 if 400 < i
      @movie.rect(i+100, i+100, i+400, i+300)
    }
    app.set_display_overlay {
      app.colorHSV(33, 100, 100, 50)
      app.circle(i, i, 100)
    }
    app.mainloop
  end

  def test_movie_overlay
    app = SGL::Application.new
    app.set_setup {
      app.window(500, 500, :overlay=>true)
      app.runtime = 3.0
      @movie = app.movie(TEST_MOVIE)
      @movie.play
    }
    i = 100
    app.set_display {
      app.background 100-i/5
      @movie.rect(100, 100, 400, 300)
      app.colorHSV(66, 100, 100, 50)
      app.circle(500-i, i, 100)
      i += 20
      i = 0 if 400 < i
    }
    app.set_display_overlay {
      app.colorHSV(33, 100, 100, 50)
      app.circle(i, i, 100)
    }
    app.mainloop
  end
end

end
