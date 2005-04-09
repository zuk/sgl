#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")

require "sgl/cocoa"

def setup
  $windowBorder = 0
  $windowShadow = 0
  window 700, 700
  backgroundHSV 66, 100, 20, 100
end

def display
  x, y = mouseX, mouseY
  colorHSV 0, 50, 100
  backgroundHSV 66, 100, 20, y/7
  lineWidth 3
  line   0,   0, x, y
  line 700,   0, x, y
  line   0, 700, x, y
  line 700, 700, x, y
  colorHSV 0, 100, 100
  rect x-10, y-10, x+10, y+10
end

mainloop
