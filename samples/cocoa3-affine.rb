#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  window 700, 700
  backgroundHSV 66, 100, 20
  $font1 = font("Helvetica", 25)
end

def display
  x, y = mouseX, mouseY
  colorHSV 0, 50, 100
  lineWidth 3
  line   0,   0, x, y
  line 700,   0, x, y
  line   0, 700, x, y
  line 700, 700, x, y
  colorHSV 0, 100, 100

  translate x, y
  rotateZ y
  colorHSV y, 100, 100
  $font1.text(10, 10, "hello")
  rect -10, -10, +10, +10
end

mainloop
