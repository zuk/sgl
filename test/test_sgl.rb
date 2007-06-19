#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require File.dirname(__FILE__) + '/test_helper.rb'

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")

$VERBOSE = true

require 'test_helper'
#require 'test_all'
#require 'test_cocoa_app'
require 'test_module_ruby16'
require 'test_opengl_app'
require 'test_opengl_basic'
require 'test_opengl_fullscreen'
require 'test_opengl_novice'

=begin
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
=end
