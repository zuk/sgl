#!/usr/bin/env ruby -w
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/sgl-connect"

module Sgl
  class Client
    def self.main(argv)
      uri = ARGV.shift
      there = DRbObject.new_with_uri(uri)
      there.puts('Hello, World.')
    end
  end
end

if $0 == __FILE__
  require "test/unit"
  $test = true
end

if defined?($test) && $test
  class TestSglColor_SglColor < Test::Unit::TestCase
    def test_all
      rgb = SGL::ColorTranslatorRGB.new(100, 100, 100, 100)
      assert_equal([1.0, 1.0, 1.0, 1.0], rgb.norm(100, 100, 100))
    end
  end
end

Sgl::Client.main(ARGV)
