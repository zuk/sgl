# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

  class ObjLib
    START_CATEGORY = 1
    START_NUMBER   = 1

    def initialize(c, n)
      @cat = (c != nil) ? c.to_i : START_CATEGORY
      @num = (n != nil) ? n.to_i : START_NUMBER

      lines = [HexagonLines.new, PerpendicularLines.new, TangentLines.new, HomingLines.new, RandomFallLines.new,
	NeonLines.new, RandomCageLines.new, TangeKenzoLines.new, BanShigeruLines.new, CircleLines.new]

      colors = [LayeredCubes.new, ColorCircles.new, ColorfulGrids.new, RotateGrids.new, ColorSquares.new,
	VerticalFields.new, MovingRects.new, TilingSquares.new, PackedCircles.new, GradationFields.new]

      plants = [Ivies.new, TreeFields.new, Ivies.new, Ivies2.new, Ivies3.new]

      gradations = [MeGrads.new, MeGrads.new]

      #loops = [LoopGrids.new]

      @lib = [[], lines, colors, plants, gradations]

      @lx, @ly = nil, nil #��O��potision���Ƃ��Ă���
      h, s, v = @lib[@cat][@num].background_color
      @h = NumSpring.new(h, h, 10, 0.7)
      @s = NumSpring.new(s, s, 10, 0.7)
      @v = NumSpring.new(v, v, 10, 0.7)
      Circle.make_list

      change_stage(@cat, @num)
    end

    def onKeyDown(key)
      if SDL::Key::K0 <= key && key <= SDL::Key::K9
	key -= SDL::Key::K0
	return if @lib[@cat][key] == nil
	change_stage(@cat, key)
      elsif SDL::Key::F1 <= key && key <= SDL::Key::F10
	key -= (SDL::Key::F1-1)
	return if @lib[key] == nil
	return if @lib[key][1] == nil
	change_stage(key, 1)
      elsif key == SDL::Key::SPACE
	fadeout
      end
    end

    def onMouseDown(x, y)
      @lib[@cat][@num].onMouseDown(x, y)
    end

    def onMouseUp(x, y)
      @lib[@cat][@num].onMouseUp(x, y)
    end

    def change_stage(cat, num)
      ocat, onum = @cat, @num
      olib = @lib[@cat][@num]
      olib.end_process()
      @cat, @num = cat, num
      lib = @lib[@cat][@num]
      lib.start_process()
      change_background_color
      #category���ς��āA����lines����Ȃ���ΑS��fadeout
      fadeout if ocat != @cat || @cat != 1
      #fadeout if ocat != @cat || @cat != 1
      #change_setup if @cat != 1
    end

    def change_background_color
      h, s, v = @lib[@cat][@num].background_color
      @h.moving = @s.moving = @v.moving = true
      @h.target,@s.target,@v.target = h,s,v
    end

    def set_background_color
      @h.move;    @s.move;    @v.move
      backgroundHSV @h.x, @s.x, @v.x
    end

    def fadeout
      @lib.each {|cat|
	cat.each {|movement|
	  movement.fadeout
	}
      }
    end

    def display
      mouse(mouseX, mouseY)
      render()
    end

    def mouse(x, y)
      @lib[@cat][@num].add(x, y, @lx, @ly) unless @lx == nil || @ly == nil
      @lx,@ly = x,y  #remember last potision
    end

    def render
      set_background_color
      @lib.each_index {|c|
	cat = @lib[c]
	cat.each_index {|n|
	  lib = @lib[c][n]
	  next if lib == nil
	  next if ! lib.running
	  lib.move
	  lib.render
	}
      }
    end
  end

  # ����Obj��100�ۗL����N���X
  class Objs
    MAX = 100
    def initialize(orgclass, max = MAX)
      @orgclass, @max = orgclass, max
      @a = []
      @max.times {|i|
	@a[i] = @orgclass.dup
	@a[i].index = i
	@a[i].enable = false
      }
      @cur = 0
      @running = false
      @background_color = [66,100,20] # R0,G0,B20�A�Â���
      @top = height/2
      @bottom = -@top
      @right = width/2
      @left = -@right
    end

    attr_reader :background_color
    attr_reader :a, :running, :max, :cur

    def start_process
      useDepth(false)
      useCulling(false)
      useFov(45)
      @running = true
    end

    def end_process
      fadeout
      @running = false
    end

    def onMouseDown(x, y)
    end

    def onMouseUp(x, y)
    end

    def add(x, y, lx, ly)
      len = V2.length(x - lx, y - ly)
      if @a[@cur].enable == true
	@a[@cur].end_process
      end
      @a[@cur].init(self, x, y, lx, ly)
      @a[@cur].start_process()
      @a[@cur].enable = false if len < 3
      @cur += 1
      @cur = 0 if @max <= @cur
      @running = true
      #p [@cur, x, y, lx, ly]
    end

    def fadeout
      @a.each {|m|
	m.fadeout
      }
    end

    def move
      index = @cur
      @a.each_index {
	m = @a[index]
	m.move if m.enable
	index += 1
	index = 0 if @max <= index
      }
    end

    def render
      r = false
      index = @cur
      @a.each_index {
	m = @a[index]
	if m.enable
	  m.render
	  r = true
	end
	index += 1
	index = 0 if @max <= index
      }
      @running = r
    end
  end

  class Obj
    START_FADEOUT = 20

    def initialize
      @dx1,@dy1,@dx2,@dy2 = 0,0,0,0
      @ttl = 0
      @start_fadeout = START_FADEOUT
      @enable = true
      @index = 0
      @top = height/2
      @bottom = -@top
      @right = width/2
      @left = -@right
    end

    def init(lib, x1, y1, x2, y2)
      @lib,@x1,@y1,@x2,@y2 = lib, x1, y1, x2, y2
      @dx1,@dy1,@dx2,@dy2 = x1, y1, x2, y2 # �����l
      @cx = (x1+x2)/2
      @cy = (y1+y2)/2
      @dcx,@dcy = @cx,@cy
      @enable = true
      @ttl = @lib.max
      @sound = ObjSound.new('wav/start.wav')
    end

    def start_process
    end

    def end_process
    end

    attr_reader :x1, :y1, :dx1, :dy1
    attr_accessor :enable, :index

    def inspect() sprintf("[%d,%d-%d,%d]",@x1,@y1,@x2,@y2) end

    def length() V2.length(@x1-@x2, @y1-@y2) end

    def move() end

    def fadeout
      @ttl = @start_fadeout if @start_fadeout < @ttl
    end

    def render
      if @ttl <= 0
	@enable = false
	return 
      end
      @ttl -= 1
      alpha = 100
      alpha = @ttl * 100 / @start_fadeout if @ttl < @start_fadeout
      renderObj(alpha)
    end

    def renderObj(alpha)
    end

    def playXY(alpha)
    end

    def colorline(x1, y1, x2, y2, h, s, v, sa, ea)
      beginObj(LINES)
      colorHSV h, s, v, sa
      vertex x1, y1
      colorHSV h, s, v, ea
      vertex x2, y2
      endObj
    end

    def randVector(r)
      rad = deg2rad(rand(360)) #360�x�̂ǂ����������͗����ł���ƁB
      c = Math.cos(rad) * r
      s = Math.sin(rad) * r
      [c, s]
    end
  end

  class ObjSound
    def initialize(file, base=60, span=4)
      @filename = file
      @samp = loadSound(file)        #@samp = Sample.new(file)
      @samp.base = base
      @count = 0
      @span = span
    end

    def inspect
      "#{@filename} #{@samp.base} #{@span}"
    end

    def play(note, volume, pan)
      @count += 1
      if @span < @count
	@count = 0
	#p [self, note, volume, pan]
	@samp.playNote(note, volume, pan)
      end
    end
  end

  # �O�Տ�
  class TrailFields < Objs
    def initialize(orgclass, max=MAX)
      super(orgclass, max)
      @a = []
      @cur_trail = nil
      onMouseDown(0, 0)
    end

    attr_reader :a

    def onMouseDown(x, y)
      @cur_trail = @orgclass.dup
      @cur_trail.init(self, x, y, x, y)
      @a << @cur_trail
      @a.shift if @max < @a.length
    end

    def onMouseUp(x, y)
      @cur_trail.start_trail_process
    end

    def add(x, y, lx, ly)
      len = V2.length(x - lx, y - ly)
      if len != 0
	@cur_trail.add_trail(x, y, lx, ly, len)
      else
	onMouseUp(x, y)
	onMouseDown(x, y)
      end
      @running = true
    end

    def move
      @a.each {|m|
	m.move if m.enable
      }
    end

    def render
      r = false
      @a.each {|m|
	if m.enable
	  m.render
	  r = true
	end
      }
      @running = r
    end
  end

  class TrailField < Obj
  end
