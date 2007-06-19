#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa-app"

app = SGL::Application.new
app.set_setup {
  app.window(100, 100)
}
app.set_display {
  app.line(0, 0, 100, 100)
}
app.mainloop
