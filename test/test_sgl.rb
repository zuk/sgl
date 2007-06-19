#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require File.dirname(__FILE__) + '/test_helper.rb'

require 'test_helper'
require 'test-all'
#require 'test-cocoa-app'
require 'test-module-ruby16'
require 'test-opengl-app'
require 'test-opengl-basic'
require 'test-opengl-fullscreen'
require 'test-opengl-novice'

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
