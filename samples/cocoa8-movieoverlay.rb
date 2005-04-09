#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  $windowShadow = 0
# $windowBackground = 0
  window 900, 700
  backgroundHSV 66, 100, 20
  $movie = movie("/Applications/iDVD 3/Tutorial/Media/Background Movie.mov")
  $movie.loop = 1
end

def onMouseDown(x, y)
  if 100 < x && x < 120 && 100 < y && y < 120
    $movie.play
  end
  if 150 < x && x < 170 && 100 < y && y < 120
    $movie.stop
  end
end

def display
  x, y = mouseX, mouseY
  backgroundHSV 66, 100, 20, y/2
  $movie.frame 100, 200, 640, 480
  $movie.rate = x-350
  $movie.volume = y/7
  colorHSV 0, 100, 100
  rect 100, 100, 120, 120
  colorHSV 33, 100, 100
  rect 150, 100, 170, 120
end

def displayOverlay
  x, y = mouseX, mouseY
  colorHSV 66, 100, 100, 50
  circle x, y, 20
end

mainloop
