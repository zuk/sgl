# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  # callback functions
  def setup()		end
  def onMouseDown(x,y)	end
  def onMouseUp(x,y)	end
  def onKeyDown(k)	end
  def onKeyUp(k)	end
  def display()		end

  # mainloop
  def mainloop
    $__a__.set_setup { setup }
    $__a__.set_mousedown {|x, y| onMouseDown(x, y) }
    $__a__.set_mouseup   {|x, y| onMouseUp(x, y) }
    $__a__.set_keydown   {|k| onKeyDown(k) }
    $__a__.set_keyup     {|k| onKeyUp(k) }
    $__a__.set_display { display }
    $__a__.mainloop
  end

  # get status functions
  def mouseX()	$__a__.mouseX;	end
  def mouseY()	$__a__.mouseY;	end
  def mouseDown() $__a__.mouseDown;	end
  def keynum()	$__a__.keynum;	end

  class Application
    def initialize_event
      # block setting
      @setup_done = nil
      @display_drawing = nil
      @display_overlay_drawing = nil
      @block = {}
      @delay_time = 1.0/60
      @runtime = nil

      # status setting
      @mouseX, @mouseY = 0, 0
      @mouseDown = 0
      @keynum = 0
    end
    attr_accessor :runtime # for test

    # get status
    attr_reader :mouseX, :mouseY
    attr_reader :mouseDown
    attr_reader :keynum

    # setup
    def set_setup(&b)
      return unless block_given?
      @block[:setup] = Proc.new
    end

    def do_setup
      setup_pre
      @block[:setup].call if @block[:setup]
      setup_post
    end

    def setup_pre
      # do nothing
    end

    def setup_post
      @setup_done = true
    end
    private :setup_pre, :setup_post

    # display
    def display_all(rect) # callback
      return if @win.nil?
      return if @setup_done.nil?
      return if @display_drawing
      @display_drawing = true
      display_bg(rect)
      display_pre
      do_display
      display_post
      @display_drawing = nil
    end

    def set_display(&b)
      return unless block_given?
      @block[:display] = Proc.new
    end

    def set_display_overlay(&b)
      return unless block_given?
      @block[:display_overlay] = Proc.new
    end

    def do_display
      return if @win.nil?
      display_pre
      @block[:display].call if @block[:display]
      display_post
    end

    def display_pre
      return if @win.nil?
      pos = @win.mouseLocationOutsideOfEventStream
      @mouseX, @mouseY = pos.x.to_i, pos.y.to_i
      set_cur_color	# set back current color
    end

    def display_bg(rect)
      set_cur_bg
      OSX::NSRectFill(rect)
    end

    def display_clear_bg(rect)
      set_color(0, 0, 0, 0)	# full transparent
      OSX::NSRectFill(rect)
    end

    def display_post
      # do nothing
    end
    private :display_pre, :display_bg, :display_clear_bg, :display_post

    # sub view
    def display_mov(rect)
      display_clear_bg(rect)
      set_cur_color	# set back current color
    end

    def display_overlay_all(rect)
      return if @win.nil?
      return if @setup_done.nil?
      return if @display_overlay_drawing
      @display_overlay_drawing = true
      display_clear_bg(rect)
      set_cur_color	# set back current color
      @block[:display_overlay].call if @block[:display_overlay]
      @display_overlay_drawing = nil
    end

    # mainloop
    def mainloop
      starttime = Time.now

      do_setup

      @thread = Thread.start {
	loop {
	  need_display
	  delay

	  if check_runtime_finished(starttime)
	    stop
	    break
	  end
	}
      }

      run
    end

    def check_runtime_finished(starttime)
      diff = Time.now - starttime
      return (@runtime && @runtime < diff)
    end

    def need_display
      return if @app.nil?
      @bgview.setNeedsDisplay(true) if @bgview
      @oview.setNeedsDisplay(true) if @oview
    end

    def delay
      sleep @delay_time
    end
    private :need_display, :delay

    # mouse events
    def set_mousedown(&b)
      return unless block_given?
      @block[:mousedown] = Proc.new
    end

    def do_mousedown
      @mouseDown = 1
      @block[:mousedown].call(@mouseX, @mouseY) if @block[:mousedown]
    end

    def set_mouseup(&b)
      return unless block_given?
      @block[:mouseup] = Proc.new
    end

    def do_mouseup
      @mouseDown = 0
      @block[:mouseup].call(@mouseX, @mouseY) if @block[:mouseup]
    end

    # key events
    def set_keydown(&b)
      return unless block_given?
      @block[:keydown] = Proc.new
    end

    def do_keydown(e)
      calc_keynum(e)
      @block[:keydown].call(@keynum) if @block[:keydown]
    end

    def set_keyup(&b)
      return unless block_given?
      @block[:keyup] = Proc.new
    end

    def do_keyup(e)
      calc_keynum(e)
      @keynum = 0
      @block[:keyup].call(@keynum) if @block[:keyup]
    end

    def calc_keynum(e)
      #input = event.characters
      input = e.characters
      @keynum = input.to_s[0]
    end
    private :calc_keynum
  end
end
