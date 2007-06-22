#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'

if $0 == __FILE__
class TestOpenGLNovice < Test::Unit::TestCase
  def test_1st
    window 100, 100
    useRuntime(0.1)
    for i in 0..20
      line 0, 0, 100, i*2*5
      flip
    end
    wait
  end

  def test_2nd
    window 400, 400
    useRuntime(0.1)
    useSmooth
    process {
      mx = mouseX
      my = mouseY
      push
      translate mx, my
      colorHSV(-mx+60, my, 100)
      rect 0, 0, 100, 100
      pop
      flip
    }
  end
end
end
