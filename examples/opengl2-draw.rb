#!/usr/bin/env ruby
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require "sgl"

def setup
  window 300, 300
  backgroundHSV 66, 100, 20
end

def display
  x, y = mouseX, mouseY
  colorHSV 0, 50, 100
  lineWidth 3
  line   0,   0, x, y
  line 300,   0, x, y
  line   0, 300, x, y
  line 300, 300, x, y
  colorHSV 0, 100, 100
  rect x-10, y-10, x+10, y+10
end

mainloop
