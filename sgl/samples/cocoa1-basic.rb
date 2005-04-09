#!/usr/bin/env ruby
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/cocoa"

def setup
  window 100, 100
end

def display
  line 0, 0, 100, 100
end

mainloop
