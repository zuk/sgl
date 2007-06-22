# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  # starttime�b��Ɏn�܂��āAendtime�b��ɏI��B
  class Timer
    def initialize(st, et)
      @st, @et = st, et
      revert	# �����߂�
      count
      @span = (@et - @st).to_f
      #p ['Timer', @bt, @st, @et, @span]
    end
    attr_accessor :st, :et

    # start at 0.0, finished at 1.0
    def ratio
      count
      return 0.0 if @now < @st
      return 1.0 if @et <= @now
      return (@now - @st) / @span
    end

    def started?
      count
      @st <= @now
    end

    def ended?
      count
      @et <= @now
    end

    def start
      @bt += @st if ! started?
      @bt = Time.now.to_f - @st if ! started?
    end

    # begintime���J�n����
    def revert
      @bt = Time.now.to_f
    end

    private

    def count
      @now = Time.now.to_f - @bt
    end
  end

  module Fadeout
    EXISTENCE_TIME = 6 # ��������
    FADEOUT_TIME = 2   # fadeout���鎞��

    def fadeout_initialize
      @timer = Timer.new(EXISTENCE_TIME - FADEOUT_TIME, EXISTENCE_TIME)
    end

    def set_longer_timer
      t = 10
      @timer = Timer.new(EXISTENCE_TIME * t - FADEOUT_TIME * t, EXISTENCE_TIME * t)
    end

    def fadeout
      @timer.start
    end

    def ended?
      @timer.ended?
    end
  end
end
