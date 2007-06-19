#!/usr/bin/env ruby -w
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")

$VERBOSE = true

def load_files(dir, base)
  Dir.chdir(dir)
  Dir.glob(base+"*.rb") {|filename|
    require filename
  }
end

def main(argv)
  load_files("..", "sgl/test-opengl-")
  load_files("..", "sgl/sgl-")
end
main(ARGV)
