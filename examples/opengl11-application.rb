#!/usr/bin/env ruby
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require "sgl/opengl-app"

app = SGL::Application.new
app.set_setup {
  app.window(100, 100)
}
app.set_display {
  app.line(0, 0, 100, 100)
}
app.mainloop
