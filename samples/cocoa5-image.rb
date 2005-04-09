#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  $windowShadow = 0
  window 700, 700
  backgroundHSV 66, 100, 20
  $image = image("../media/image-heart.psd")
end

def display
  x, y = mouseX, mouseY
  colorHSV 0, 50, 100, y/5
  backgroundHSV 66, 100, 20, 300-x/2
  $image.rect(100, 100, 200, 200)
  $image.rect(0, 0, x, y)
  $image.rect(x, y, x+100, y+100)
end

mainloop
