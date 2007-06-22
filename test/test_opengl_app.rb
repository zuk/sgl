#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'

class TestOpenglBasic < Test::Unit::TestCase
  def test_basic
    app = SGL::Application.new
    app.set_setup {
      app.window(100, 100)
      app.runtime = 0.1
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

  def nutest_color
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
      app.runtime = 0.2
    }
    i = 0
    app.set_display {
      app.line(0, 0, 100, i*5)
      i += 1
      i = 0 if 20 < i
    }
    app.mainloop
  end

  def test_affine
    app = SGL::Application.new
    app.set_setup {
      app.window(300, 300)
      app.runtime = 0.2
    }
    i = 0
    app.set_display {
      app.colorHSV 66, 100, 100, 50
      app.lineWidth(i/10)
      app.line(0, 0, 300, i)
      app.translate i, i
      app.rotateZ i
      app.colorHSV i, 100, 100
      app.rect(-10, -10, +10, +10)
      i += 20
      i = 0 if 300 < i
    }
    app.mainloop
  end
end
