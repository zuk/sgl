# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License
# These classes are not using.

module SGL
  class NuVideo
    include Singleton

    def initialize
      Thread.abort_on_exception = true
      @win = Window.alloc.init
    end
    attr_reader :win
  end

  class NuWindow < OSX::NSObject
    def init
      OSX.ruby_thread_switcher_start(0.001, 0.01)
      @app = OSX::NSApplication.sharedApplication
      @app.setMainMenu(OSX::NSMenu.alloc.init)
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100) # color translator
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)
      @mouseX = @mouseY = @mouseDown = 0
      @keynum = 0
      $windowBorder = 1
      $windowShadow = 1
      $windowBackground = 1
      $windowDelay = 1.0/60
      $windowMovie = 0
      @window_initialized = false
      @setup_done = false
      @display_drawing = false

      @bgview = @oview = nil

      return self		# important for RubyCocoa
    end
    attr_reader :mouseX, :mouseY, :mouseDown, :keynum

    # generate window
    def window(w, h)
      return if @window_initialized
      s = OSX::NSScreen.mainScreen.frame.size
      x = (s.width  - w)/2.0
      y = (s.height - h)/2.0
      @win_frame = [x.to_f, y.to_f, w.to_f, h.to_f]
      window_open
    end

    def window_open
      style = OSX::NSClosableWindowMask
      style |= ($windowBorder && $windowBorder == 0) ?
      OSX::NSBorderlessWindowMask : OSX::NSTitledWindowMask
      @win = SglWindow.alloc.
	initWithContentRect(@win_frame,
			    :styleMask, style,
			    :backing, OSX::NSBackingStoreBuffered,
			    :defer, true)
      @win.setTitle("sgl")
      @bgview = BackView.alloc.init
      @bgview.myinit(self)
      @win.setContentView(@bgview)
      @bgcolor = @curcolor = nil
      background(100)	# white
      color(0)		# black
      @win.setDelegate(self)	# for handling windowShouldClose
      @win.setOpaque(false)	# can be transparent
      @win.setHasShadow(!($windowShadow && $windowShadow == 0))
      @win.setReleasedWhenClosed(false)
      @win.makeKeyAndOrderFront(self)
      @win.orderFrontRegardless	# show the window
      window_movie if $windowMovie == 1
      window_overlay if defined?(displayOverlay)
      @window_initialized = true
      @win
    end

    def window_movie
      o = @bgview.frame.origin
      so = @win.convertBaseToScreen([o.x, o.y])
      s = @bgview.frame.size
      @movwin = SglWindow.alloc.
	initWithContentRect([so.x, so.y, s.width, s.height],
			    :styleMask, OSX::NSBorderlessWindowMask,
			    :backing, OSX::NSBackingStoreBuffered,
			    :defer, true)
      @movwin.setOpaque(false)	# can be transparent
      @movwin.setHasShadow(false)
      @movwin.setIgnoresMouseEvents(true)
      @movwin.setAlphaValue(1.0)
      b = @bgview.bounds
      bo, bs = b.origin, b.size
      @movview = MovieView.alloc.initWithFrame([bo.x, bo.y, bs.width, bs.height])
      @movview.myinit(self)
      @movwin.contentView.addSubview(@movview)
      @movwin.orderFront(self)
      @win.addChildWindow(@movwin, :ordered, OSX::NSWindowAbove)
      @movview.setNeedsDisplay(true)
      @movewin
    end

    def window_overlay
      o = @bgview.frame.origin
      so = @win.convertBaseToScreen([o.x, o.y])
      s = @bgview.frame.size
      @owin = SglWindow.alloc.
	initWithContentRect([so.x, so.y, s.width, s.height],
			    :styleMask, OSX::NSBorderlessWindowMask,
			    :backing, OSX::NSBackingStoreBuffered,
			    :defer, true)
      @owin.setOpaque(false)	# can be transparent
      @owin.setHasShadow(false)
      @owin.setIgnoresMouseEvents(true)
      @owin.setAlphaValue(1.0)
      b = @bgview.bounds
      bo, bs = b.origin, b.size
      @oview = OverView.alloc.initWithFrame([bo.x, bo.y, bs.width, bs.height])
      @oview.myinit(self)
      @owin.contentView.addSubview(@oview)
      @owin.orderFront(self)
      if $windowMovie == 1
        @movwin.addChildWindow(@owin, :ordered, OSX::NSWindowAbove)
      else
        @win.addChildWindow(@owin, :ordered, OSX::NSWindowAbove)
      end
      @oview.setNeedsDisplay(true)
#      timer = OSX::NSTimer.
#	scheduledTimerWithTimeInterval(1.0/60,
#				       :target, self,
#				       :selector, "timerloop",
#				       :userInfo, nil,
#				       :repeats, true).retain
#      OSX::NSRunLoop.currentRunLoop.
#	addTimer(timer, :forMode, OSX::NSEventTrackingRunLoopMode)
      @owin
    end
    attr_reader :bgcolor, :curcolor

    def setup_post
      @setup_done = true
    end

    def windowShouldClose(sender)
      OSX.NSApp.stop(nil)
      false
    end

    def timerloop
      p "timerloop"
    end

    # main loop
    def mainloop
      @thread = Thread.start {
	loop {
	  setNeedsDisplay
	  delay
	}
      }
    end

    def setNeedsDisplay
      @bgview.setNeedsDisplay(true)
      @oview.setNeedsDisplay(true) if @oview
    end

    def delay
      sleep $windowDelay
    end

    def run
      @app.run
    end

    # handle events
    def winmouseDown
      @mouseDown = 1
      onMouseDown(@mouseX, @mouseY)
    end

    def winmouseUp
      @mouseDown = 0
      onMouseUp(@mouseX, @mouseY)
    end

    def winkeyDown(e)
      calc_keynum(e)
      p @keynum
      onKeyDown(@keynum)
    end

    def winkeyUp(e)
      calc_keynum(e)
      @keynum = 0
      p @keynum
      onKeyUp(@keynum)
    end

    def calc_keynum(e)
      input = event.characters
      @keynum = input.to_s[0]
    end

    # display
    def display_bg(rect)
      return if $windowBackground != 1
      color_set(*@bgcolor)
      OSX::NSRectFill(rect)
#      if @lastbgcolor && @lastbgcolor != @bgcolor
#      end
#      @lastbgcolor = @bgcolor.dup
    end

    def display_pre
      pos = @win.mouseLocationOutsideOfEventStream
      @mouseX, @mouseY = pos.x, pos.y
      color_set(*@curcolor)	# set back current color
    end

    def display_all(rect)
      return if !@setup_done
#     return if @display_drawing
      return if defined?(display_drawing) && display_drawing
      @display_drawing = true
      display_bg(rect)
      display_pre
      display
      display_post
      @display_drawing = false
    end

    def display_mov(rect)
      color_set(0, 0, 0, 0)	# full transparent
      OSX::NSRectFill(rect)
      color_set(*@curcolor)	# set back current color
    end

    def display_overlay_all(rect)
      return if !@setup_done
      return if @display_overlay_drawing
      @display_overlay_drawing = true
      color_set(0, 0, 0, 0)	# display_bg
      OSX::NSRectFill(rect)
      color_set(*@curcolor)	# set back current color
      displayOverlay
      @display_overlay_drawing = false
    end

    def display_post
    end

    # sgl commands
    def background(x, y=nil, z=nil, a=nil)
      @bgcolor = @rgb.norm(x,y,z,a)
    end

    def backgroundHSV(x, y=nil, z=nil, a=nil)
      @bgcolor = @hsv.norm(x,y,z,a)
    end

    def color(x, y=nil, z=nil, a=nil)
      @curcolor = @rgb.norm(x,y,z,a)
      color_set(*@curcolor)
    end

    def colorHSV(x,y=nil,z=nil,a=nil)
      @curcolor = @hsv.norm(x,y,z,a)
      color_set(*@curcolor)
    end

    def color_set(*a)
      color_make(*a).set if @window_initialized
    end

    def color_make(r, g, b, a)
      OSX::NSColor.colorWithDeviceRed(r,:green, g, :blue, b, :alpha, a)
    end

    def color_cur
      color_make(*@curcolor)
    end
  end

  class SglWindow < OSX::NSWindow
#    ns_overrides :keyDown_, :keyUp_
#    def keyDown(event)
#      p "ho"
#    end
  end

  class BackView < OSX::NSView
    ns_overrides :drawRect_,
      :mouseDown_, :mouseDragged_, :mouseUp_, :keyDown_, :keyUp_
    def myinit(win)	@win = win;	end
    def drawRect(rect)	@win.display_all(rect);	end
    def mouseDown(event)	@win.winmouseDown;	end
    def mouseDragged(event)	end
    def mouseUp(event)	@win.winmouseUp;	end
    def keyDown(event)	@win.winkeyDown(event);
      p "ho"
    end
    def keyUp(event)	@win.winkeyUp(event);	end
  end

  class OverView < OSX::NSView
    ns_overrides :drawRect_
    def myinit(win)	@win = win;	end
    def drawRect(rect)	@win.display_overlay_all(rect);	end
  end

  class MovieView < OSX::NSView
    ns_overrides :drawRect_
    def myinit(win)	@win = win;	end
    def drawRect(rect)	@win.display_mov(rect);	end
  end

  class NuWindow < OSX::NSObject
    def movie(u)
#     if %r$^http://$ =~ u || %r$^rtsp://$ =~ u
      if /\Ahttp:\/\// =~ u || /\Artsp:\/\// =~ u
	url = OSX::NSURL.URLWithString_(u)
      else
	url = OSX::NSURL.fileURLWithPath_(u)
      end
      mov = OSX::NSMovie.alloc.initWithURL(url, :byReference, true)
      # place it outer of the screen
      obj = SglMovieView.alloc.initWithFrame([-100.0, -100.0, 10.0, 10.0])
      obj.myinit(self)
      obj.setMovie(mov)
      obj.showController(false, :adjustingSize, false)
      if $windowMovie == 1
        @movview.addSubview(obj)
      else
        @bgview.addSubview(obj)
      end
#     @oview.addSubview(obj)
      obj
    end

    def image(file)
      img = SglImage.alloc.initWithContentsOfFile(file)
      img.myinit(self)
      img
    end

    def font(*a)
      SglFont.new(self, *a)
    end

    def sound(file)
      url = OSX::NSURL.fileURLWithPath_(file)
      snd = SglSound.alloc.initWithContentsOfURL(url, :byReference, true)
      snd
    end
  end

  class SglMovieView < OSX::NSMovieView
    def myinit(win)
      @win = win
    end

    def rect(a,b,c,d)
      frame(*to_xywh(a, b, c, d))
    end

    def frame(a,b,c,d)
      setFrame([a, b, c, d])
#      @win.switch_to_over
    end

    def play()	start_;		end
    def stop()	stop_;		end
    def goBegin()	gotoBeginning_;	end
    def goEnd()	gotoEnd_;	end
    def forward()	stepForward_;	end
    def back()	stepBack_;	end
    def loop=(a)	setLoopMode(a);	end
    def rate=(r)	setRate(r/100.0);	end
    def volume=(v)	setVolume(v/100.0);	end
  end

  class SglImage < OSX::NSImage
    def myinit(win)
      @win = win
    end

    def rect(a,b,c,d)	frame(*to_xywh(a, b, c, d));	end
    def frame(x,y,w,h)
      drawInRect([x,y,w,h],
		 :fromRect, [0,0,size.width,size.height],
		 :operation, OSX::NSCompositeSourceOver,
		 :fraction, @win.curcolor[3])
    end
  end

  class SglFont
    def initialize(w, n="Helvetica", s=0.0)
      @win, @name, @size = w, n, s.abs
    end
    attr_accessor :name
    attr_reader :size

    def size=(s)
      @size = s.abs
    end

    def to_sjis(str)
      NKF.nkf("-m0 -s", str)
    end

    def text(x, y, str)
      return unless str.is_a? String
      str = str.to_sjis
      str = to_sjis(str)
      str = OSX::NSMutableAttributedString.alloc.initWithString(str)
      str.addAttribute(OSX::NSFontAttributeName(),
		       :value, OSX::NSFont.fontWithName(@name, :size, @size),
		       :range, [0,str.length])
      str.addAttribute(OSX::NSForegroundColorAttributeName(),
		       :value, @win.color_cur,
		       :range, [0,str.length])
      str.drawAtPoint([x, y])
    end

    def show_fixed()	show(OSX::NSFixedPitchFontMask);	end
    def show_all()	show();	end

    private
    def show(mask=0)
      fmgr = OSX::NSFontManager.sharedFontManager
      fonts = fmgr.availableFontNamesWithTraits(mask).to_a.map{|i| i.to_s }.sort
      puts fonts
    end
  end

  class SglSound < OSX::NSSound
#    def play()	play_;	end
  end


=begin
  # sgl commands
  def point(a,b)
    line(a,b,a,b)
  end

  def lineWidth(w)
    OSX::NSBezierPath.setDefaultLineWidth(w)
  end

  def line(a,b,c,d)
    OSX::NSBezierPath.strokeLineFromPoint(OSX::NSPoint.new(a, b),
				:toPoint, OSX::NSPoint.new(c, d))
  end

  def rect(a,b,c,d)
    rect = OSX::NSRect.new(*to_xywh(a, b, c, d))
    OSX::NSBezierPath.bezierPathWithRect(rect).fill
  end

  def circle(x, y, r)
    rect = OSX::NSRect.new(x - r, y - r, 2*r, 2*r)
    OSX::NSBezierPath.bezierPathWithOvalInRect(rect).fill
  end

  def to_xywh(a,b,c,d)
    [[a, c].min,  [b, d].min, (a - c).abs, (b - d).abs]
  end

  def rotateZ(deg)
    af = OSX::NSAffineTransform.transform
    af.rotateByDegrees(deg)
    af.concat
  end

  def translate(x, y)
    af = OSX::NSAffineTransform.transform
    af.translateXBy(x, :yBy, y)
    af.concat
  end

  def scale(x, y=nil)
    af = OSX::NSAffineTransform.transform
    y ? af.scaleXBy(x, :yBy, y) : af.scaleBy(x)
    af.concat
  end

  def reset()
    OSX::NSAffineTransform.transform.set
  end
=end

end
