#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'

class TestSound < Test::Unit::TestCase
  TEST_FILENAME = "c:/WINDOWS/Media/start.wav"

  def test_all
    useSound
    sound = loadSound(TEST_FILENAME)
    sound.play; sleep 0.05
  end
end
