#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/opengl"
require "test/unit"

class TestOpenGLFullscreen < Test::Unit::TestCase
  def test_all
    app = SGL::Application.new
    app.set_setup {
      app.useFullscreen(1024, 768)
      app.window(100, 100)
      app.runtime = 1.1
    }
    @i = 0
    app.set_display {
      app.line(0, 0, 100, @i*5)
      @i += 2
      @i = 0 if 20 < @i
    }
    app.mainloop
  end
end
