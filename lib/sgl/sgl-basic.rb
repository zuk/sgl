# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$LOAD_PATH.unshift '..' if !$LOAD_PATH.include? '..'

module SGL
  class RingArray < Array
    alias get []

    def [](nth)
      nth %= length() if nth < 0 || length() <= nth
      return get(nth)
    end
  end

  class Timer
    # starttime秒後に初まって、endtime秒後に終る。
    def initialize(st, et)
      # begintime→開始時間
      @bt = Time.now.to_f
      @st,@et = @bt+st,@bt+et
      @now = 0
      @span = (@et - @st).to_f         #p ['Timer', @bt, @st, @et, @span]
    end

    def count
      @now = Time.now.to_f
    end

    # 初めは0で、だんだん1.0にちかづいていく
    def ratio
      count
      return 0.0 if ! (@st <= @now)
      return 1.0 if @et <= @now
      return (@now - @st) / @span
    end

    def started?() count; @st <= @now end
    def ended?()   count; @et <= @now end
  end
end

if $0 == __FILE__
  require 'test/unit'
  $__test_sgl__ = true
end

if defined?($__test_sgl__) && $__test_sgl__
  class TestSglBasic < Test::Unit::TestCase #:nodoc:
    def test_ring_array
      t = SGL::RingArray.new
      t[0], t[1], t[2] = 0, 1, 2
      assert_equal([0, 1, 2, 0, 1, 2, 0, 1],
		   [t[-3], t[-2], t[-1], t[0], t[1], t[2], t[3], t[4]])
    end

    def test_timer
      assert true
    end
  end
end
