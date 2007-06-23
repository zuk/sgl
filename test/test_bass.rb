#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require File.dirname(__FILE__) + '/test_helper.rb'
require 'sgl/bass'

class TestSample < Test::Unit::TestCase
  TEST_FILENAME = "c:/WINDOWS/Media/start.wav"

  def test_0_simple_play
    bass = Bass::BassLib.instance
    samp = Bass::Sample.new(TEST_FILENAME)

    # test_play
    samp.play; sleep 0.1

    # test_note
    [0, 2, 4, 5, 7, 9, 11, 12].each {|n|
      samp.play(60 + n); sleep 0.05
    }

    # test_volume
    10.times {|v|
      samp.play(60, v * 10); sleep 0.05
    }

    # test_pan
    10.times {|pos|
      samp.play(60, 100, pos * 20 - 100); sleep 0.05
    }
  end

  def nu_test_1_change_freq
    bass = Bass::BassLib.instance
    samp = Bass::Sample.new(TEST_FILENAME)
    20.times { |i|
      #ret = bass_SamplePlayEx.call(hsample, 0, 1000 * i, 100, 0, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, -1, -1, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, 10 * i, -1, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, -1, -1, 10 * i, -1)
      #ret = bass_SamplePlayEx.call(hsample, 0, 8000 + 1000 * i, -1, -1, -1)
     #ret = samp.playEx(0, 8000 + 1000 * i, -1, -1, -1)
      ret = samp.play(0, 8000 + 1000 * i, -1, -1, -1)
      #printf("ret is %x, errorcode is %d\n", ret, Bass.errorGetCode())
      #printf("ret is %x, errorcode is %d\n", ret, Bass::BASS_ErrorGetCode.call())
      puts"ret is #{ret}, errorcode is #{ Bass::BASS_ErrorGetCode.call}"
      ###define BASS_ERROR_START	= 9	/// BASS_Start has not been successfully called
      sleep 0.2
    }
  end
end
