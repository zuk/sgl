#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  window 700, 700
  backgroundHSV 66, 100, 20
  $sound = sound("../media/Pop.aiff")
end

def onMouseDown(x, y)
  if 100 < x && x < 120 && 100 < y && y < 120
    $sound.play
  end
end

def display
  x, y = mouseX, mouseY
  color 100, 0, 0
  rect 100, 100, 120, 120
end

mainloop
