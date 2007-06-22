#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'

class TestOpenGLFullscreen < Test::Unit::TestCase
  def test_all
    app = SGL::Application.new
    app.set_setup {
      app.useFullscreen(1024, 768)
      app.window(100, 100)
      app.runtime = 0.1
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
