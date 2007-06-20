# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")

module SGL
=begin
  # not yet.
  module SpringModule
  end
=end

  class Spring
    EPSILON = 0.01

    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      @target, @initial, @ks, @kd, @e, @v = target, initial, ks, kd, e, v
      @x = @initial
      @moving = true
    end

    attr_reader :x, :target
    attr_accessor :v, :ks, :kd

    def inspect
      mov = @moving ? "●" : "○"
      sprintf("[%s%.1f %.1f %.1f %.1f %.1f]", mov, @target, @x, @v, @ks, @kd)
    end

    def target=(num)
      @target = num
      @moving = true
    end

    def x=(num)
      @x = num
      @moving = true
    end

    def move
      return if ! @moving
      if @x.is_a?(Vector)
	l = @x - @target
	diff = l.length
	if diff < @e && @v.length < @e
	  @moving = false
	  return
	end
	#fa = -(@ks * diff + @kd * @v)
	ln = l.normalize
	fak = -(@ks * diff + @kd * @v.length)
	fa = ln.scale(fak)
	@v += fa
	@x += @v
	#p ['sp', fa, fak, @v, @x]
      else
	diff = @x - @target
	if diff.abs < @e && @v.abs < @e
	  @moving = false
	  return
	end
	fa = -(@ks * diff + @kd * @v)
	@v += fa
	@x += @v
      end
    end
  end

  class ISpring < Spring
    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      super(target, initial, 1.0/ks, 1.0/kd, e, v) # ksとkdをinverseする。
    end
  end

  class NumSpring
    EPSILON = 0.01

    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      @target, @initial, @ks, @kd, @e, @v = target, initial, ks, kd, e, v
      @x = @initial
      @moving = true
    end

    attr_reader :x, :target
    attr_accessor :v, :ks, :kd, :moving

    def inspect
      mov = @moving ? "●" : "○"
      sprintf("[%s%.1f %.1f %.1f %.1f %.1f]", mov, @target, @x, @v, @ks, @kd)
    end

    def target=(num)
      @target = num
      @moving = true
    end

    def x=(num)
      @x = num
      @moving = true
    end

    def move
      return if ! @moving
      diff = @target - @x
      if diff.abs < @e && @v.abs < @e
	@moving = false
	return
      end
      @v += (diff / @ks)
      @v *= @kd
      @x += @v
    end
  end

  class INumSpring < NumSpring
    # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
    def initialize(target, initial, ks, kd, e=EPSILON, v=0)
      super(target, initial, ks, 1.0 - 1.0/kd, e, v) # kdだけinverseする。
    end
  end
end

=begin
class NuSpringPos
  EPSILON = 0.01

  # 初期値、目標となる値、バネ定数、弾性定数、イプシロン(十分小さい値)
  def initialize(x, y, ks, kd, e=EPSILON)
    @x, @y, @ks, @kd, @e = x, y, ks, kd, e
    @vx, @vy, @tx, @ty = 0, 0, 0, 0
    @moving = true
  end

  attr_reader :x, :y, :moving

  def set_target(tx, ty)
    @tx, @ty = tx, ty
  end

  def move
    return if ! @moving

    #diff = @target - @x
    diff = @tx - @x
    if diff.abs < @e && @v.abs < @e
      @moving = false
      return
    end
    @v += (diff / @ks)
    @v *= @kd
    @x += @v
  end
end

class NuNumSpring
  EPSILON = 0.01

  # 目標となる値、初期値、バネ定数、弾性定数、イプシロン(十分小さい値)
  def initialize(target, initial, ks, kd, e=EPSILON)
    @target, @initial, @ks, @kd, @e = target, initial, ks, kd, e
    @x = @initial
    @v = 0
    @moving = true
  end

  attr_reader :v
  attr_accessor :x, :target, :moving, :ks, :kd

  def inspect
    mov = @moving ? "●" : "○"
    sprintf("[%s%.1f %.1f %.1f %.1f %.1f]", mov, @target, @x, @v, @ks, @kd)
  end

  def move
    return if ! @moving
    diff = @target - @x
    if diff.abs < @e && @v.abs < @e
      @moving = false
      return
    end
    @v += (diff / @ks)
    @v *= @kd
    @x += @v
  end

  def rel_ks_notuse(r)
    @ks += r
    @ks = 1 if @ks <= 0
  end
end
=end

if $0 == __FILE__
  require "test/unit"
  $__test_sgl__ = true
end

if defined?($__test_sgl__) && $__test_sgl__
  class TestSglSpring < Test::Unit::TestCase #:nodoc:
    def test_all

      s = SGL::NumSpring.new(0, 1, 0.1, 0.1)
      assert_equal(1, s.x)
      assert_equal(true, s.moving)

      s.move
      assert_equal(0.0, s.x)

      s.move
      assert_equal(-0.1, s.x)
    end
  end
end
