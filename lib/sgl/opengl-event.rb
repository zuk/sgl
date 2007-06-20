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

  # callback functions for fullscreen
  def onMouseDown0(x,y)	end
  def display0()	end

  # mainloop
  def mainloop
    $__a__.set_setup { setup }
    $__a__.set_mousedown {|x, y| onMouseDown(x, y) }
    $__a__.set_mouseup   {|x, y| onMouseUp(x, y) }
    $__a__.set_keydown   {|k| onKeyDown(k) }
    $__a__.set_keyup     {|k| onKeyUp(k) }
    if ! $__a__.check_display0
      $__a__.set_display0 { display0 }
      $__a__.set_mousedown0 {|x, y| onMouseDown0(x, y) }
    end
    $__a__.set_display { display }

    if ! defined?($__sgl_in_mainloop__)
      $__sgl_in_mainloop__ = true
      $__a__.mainloop
    else
      # do setup only.
      $__a__.mainloop_setup

      # for debug
      # $__a__.mainloop
    end
  end

  # novice mode
  def flip(*a)	$__a__.flip(*a)	end
  def wait(*a)	$__a__.wait(*a)	end
  def process(&b)	$__a__.process(&b)	end

  # get status functions
  def mouseX()	$__a__.mouseX;	end
  def mouseY()	$__a__.mouseY;	end
  def mouseDown()	$__a__.mouseDown;	end
  def key(k)	$__a__.key[k];	end
  def keynum()	$__a__.keynum;	end

  # get status functions for fullscreen
  def mouseX0()	$__a__.mouseX0;	end
  def mouseY0()	$__a__.mouseY0;	end

  # event control
  def useDelay(*a)	$__a__.useDelay(*a)	end
  def useFramerate(*a)	$__a__.useFramerate(*a)	end
  def useRuntime(*a)	$__a__.useRuntime(*a)	end

  class Application
    def initialize_event
      @setup_done = nil
      @display_drawing = nil
      @block = {}

      # status setting
      @mouseX, @mouseY = 0, 0
      @mouseX0, @mouseY0 = 0, 0
      @mouseDown = 0
      @keynum = 0

      @starttime = nil
    end
    private :initialize_event

    # get status
    attr_reader :mouseX, :mouseY
    attr_reader :mouseX0, :mouseY0
    attr_reader :mouseDown
    attr_reader :keynum

    # setup
    def set_setup(&b)
      return unless block_given?
      @block[:setup] = Proc.new
    end

    def setup_pre
      # do nothing
    end

    def do_setup
      setup_pre
      @block[:setup].call if @block[:setup]
      setup_post
    end

    def setup_post
      @setup_done = true
    end
    private :setup_pre, :setup_post

    # display
    def set_display(&b)
      return unless block_given?
      @block[:display] = Proc.new
    end

    def set_display0(&b)
      return unless block_given?
      @block[:display0] = Proc.new
    end

    def check_display0
      return ! @block[:display0].nil?
    end

    def display_pre
      set_camera_position
      check_event
      clear
    end

    def do_display # callback
      return if @setup_done.nil?
#      return if @display_drawing
      @display_drawing = true
      display_pre
      @block[:display].call if @block[:display]
      display_post
      @display_drawing = nil
    end

    def display_post
      set_fullscreen_camera_position
      cur_color = @cur_color
      @block[:display0].call if @block[:display0]
      color(*cur_color)
      SDL.GLSwapBuffers
      #GC.start
    end
    private :display_pre, :display_post

    # mouse events
    def set_mousedown(&b)
      return unless block_given?
      @block[:mousedown] = Proc.new
    end

    def do_mousedown
      @mouseDown = 1
      @block[:mousedown].call(@mouseX, @mouseY) if @block[:mousedown]
      @block[:mousedown0].call(@mouseX0, @mouseY0) if @block[:mousedown0]
    end

    def set_mouseup(&b)
      return unless block_given?
      @block[:mouseup] = Proc.new
    end

    def do_mouseup
      @mouseDown = 0
      @block[:mouseup].call(@mouseX, @mouseY) if @block[:mouseup]
    end

    # mouse events for fullscreen
    def set_mousedown0(&b)
      return unless block_given?
      @block[:mousedown0] = Proc.new
    end

    def check_mousedown0
      return ! @block[:mousedown0].nil?
    end

    # key events
    def set_keydown(&b)
      return unless block_given?
      @block[:keydown] = Proc.new
    end

    def keydown_pre(key)
      exit if key == SDL::Key::ESCAPE
    end
    private :keydown_pre

    def do_keydown(key)
      keydown_pre(key)
      @block[:keydown].call(key) if @block[:keydown]
    end

    def set_keyup(&b)
      return unless block_given?
      @block[:keyup] = Proc.new
    end

    def do_keyup(key)
      @block[:keyup].call(key) if @block[:keyup]
    end

    def calc_keynum(e)
      input = e.characters
      @keynum = input.to_s[0]
    end
    private :calc_keynum

    def mainloop_setup
      do_setup
    end

    def mainloop
      mainloop_setup
      @starttime = Time.now
      loop {
	@begintime = Time.now
	do_display
	delay
	return if check_runtime_finished(@starttime)
      }
    end

    def delay
      if @options[:framerate]
	sec_per_frame = 1.0 / @options[:framerate]
	diff = sec_per_frame - (Time.now - @begintime)
	sleep(diff) if 0 < diff
      else
	delaytime = @options[:delaytime]
	sleep(delaytime)
      end
    end
    private :delay

    def check_runtime_finished(starttime)
      runtime = @options[:runtime]
      return false if runtime.nil?
      diff = Time.now - starttime
      return (runtime && runtime < diff)
    end
    private :check_runtime_finished

    # novice mode
    def flip
      @starttime = Time.now if @starttime.nil?
      display_post
      delay
      display_pre
     #exit if check_runtime_finished(@starttime)
    end

    def wait
      #SGL.flip if !$__v__.flipped
      loop {
	check_event
	delay
	return if check_runtime_finished(@starttime)
      }
    end

    def process(&b)
      block = Proc.new
      @starttime = Time.now
      loop {
	check_event
	block.call
	#yield
	delay
	return if check_runtime_finished(@starttime)
      }
    end

    # check event
    def check_event
      x, y, l, m, r = SDL::Mouse.state
      # x pos, y pos, left button, middle button, right button
      @mouseX, @mouseY = calc_mouse_xy(x, y)
      @mouseX0, @mouseY0 = calc_fullscreen_mouse_xy(x, y)
      event = @sdl_event
      while event.poll != 0
	case event.type
	when SDL::Event::MOUSEBUTTONDOWN
	  do_mousedown
	when SDL::Event::MOUSEBUTTONUP
	  do_mouseup
	when SDL::Event::KEYDOWN
	  @keynum = event.info[2]
	  do_keydown(@keynum)
	when SDL::Event::KEYUP
	  @keynum = event.info[2]
	  do_keyup(@keynum)
	when SDL::Event::QUIT
	  exit
	end
      end
    end

    def calc_mouse_xy(x, y)
      if @options[:fullscreen]
	w, h = @options[:fullscreen]
	mx = @cameraX - (w / 2) + x
	my = @cameraY - (h / 2) + (h - y)
      else
	mx = @left + x
	my = @bottom + (@height - y)
      end
      return [mx, my]
    end

    def calc_fullscreen_mouse_xy(x, y)
      if @options[:fullscreen]
	w, h = @options[:fullscreen]
	mx = - (w / 2) + x
	my = - (h / 2) + (h - y)
      else
	mx = @left + x
	my = @bottom + (@height - y)
      end
      return [mx, my]
    end
    private :check_event, :calc_mouse_xy, :calc_fullscreen_mouse_xy
  end
end
