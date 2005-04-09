#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
# $windowShadow = 0
# $windowBackground = 0
# $windowDelay = 1
# $windowDelay = 10
  window 900, 700
  backgroundHSV 66, 100, 20
  $bgh = 0
# $movie1 = movie("../media/tower1.mov")
  $movie1 = movie("../media/sample1.mov")
  $movie1.frame(100, 100, 320, 240)
  $movie1.play
# $movie2 = movie("../media/powerbook1.mov")
# $movie2.frame 500, 100, 320, 240
# $movie2.play
# $movie3 = movie("../media/imstudio.mov")
# $movie3.frame 100, 400, 320, 240
# $movie3.play
end

def display
  x, y = mouseX, mouseY
  backgroundHSV $bgh, 100, 20, y/2
  $bgh = $bgh + 1
  if 100 < $bgh then $bgh = 0; end
  colorHSV 0, 100, 100
  rect 100, 50, 120, 70
  circle x, y, 20
  $movie1.frame(x, y, 320, 240)
end

def nudisplayOverlay
end

mainloop
