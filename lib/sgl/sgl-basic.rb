# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  class RingArray < Array
    alias get []

    def [](nth)
      nth %= length() if nth < 0 || length() <= nth
      return get(nth)
    end

    def self.test
      t = RingArray.new
      t[0],t[1],t[2] = 0,1,2
      p [t[-3], t[-2], t[-1], t[0], t[1], t[2], t[3], t[4]]
      exit
    end
    #RingArray.test
  end

  class Timer
    def initialize(st, et) #starttime秒後に初まって、endtime秒後に終る。
      @bt = Time.now.to_f #begintime→開始時間
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
