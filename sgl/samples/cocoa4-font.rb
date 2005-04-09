#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  window 700, 700
  backgroundHSV 66, 100, 20
  $font1 = font("Helvetica")
  $font2 = font("GothicMB101Pro-Ultra")
#  $font.show_all
#  $font.show_fixed
end

def display
  x, y = mouseX, mouseY
  colorHSV 0, 50, 100, y/3
  $font1.size = x
  $font1.text(x, y, "hello")
  $font2.size = y
  $font2.text(x-50, y-50, "Š¿Žš")
end

mainloop
