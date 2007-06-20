# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module SGL
  # window functions
  def window(*a)	$__a__.window(*a)	end
  def close_window()	$__a__.close_window;	end
  def width()	$__a__.width;	end
  def height()	$__a__.height;	end

  # opengl special functions
  def useFov(*a)	$__a__.useFov(*a);	end
  def useDepth(*a)	$__a__.useDepth(*a)	end
  def useSmooth(*a)	$__a__.useSmooth(*a)	end
  def useCulling(*a)	$__a__.useCulling(*a)	end
  def useFullscreen(*a)	$__a__.useFullscreen(*a)	end
  alias useFullScreen useFullscreen
  def useCursor(*a)	$__a__.useCursor(*a)	end

  class Application
    DEFAULT_WINDOW_WIDTH  = 100
    DEFAULT_WINDOW_HEIGHT = 100
    DEFAULT_FULLSCREEN_WIDTH  = 1024
    DEFAULT_FULLSCREEN_HEIGHT = 768

    def initialize_window
      @width, @height = DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT
      @left, @bottom, @right, @top = 0, 0, @width, @height
      @cameraX, @cameraY, @cameraZ = 0, 0, 5
      initialize_sdl
    end

    def initialize_sdl
      SDL.init(SDL::INIT_VIDEO)
      # Setting color size is important for Mac OS X.
      SDL.setGLAttr(SDL::GL_RED_SIZE, 5)
      SDL.setGLAttr(SDL::GL_GREEN_SIZE, 5)
      SDL.setGLAttr(SDL::GL_BLUE_SIZE, 5)
      SDL.setGLAttr(SDL::GL_DEPTH_SIZE, 16)
      SDL.setGLAttr(SDL::GL_DOUBLEBUFFER, 1)
      if !windows?
	SDL.setVideoMode(640, 400, 16, SDL::OPENGL)
      end
      @sdl_event = SDL::Event.new
    end
    private :initialize_window, :initialize_sdl

    def windows?
      r = RUBY_PLATFORM
      (r.index("cygwin") || r.index("mswin32") || r.index("mingw32")) != nil
    end
    private :windows?

    # create window
    def window(*a)
      @options.update(a.pop) if a.last.is_a? Hash

      if a.length == 4
	@left, @bottom, @right, @top = a
      elsif a.length == 2
	@right, @top = a
	@left = @bottom = 0
      else
	raise "error"
      end

      @width, @height = (@right - @left), (@top - @bottom)

      # Do not initialize twice.
      if ! defined?($__sgl_sdl_window_initialized__)
        # sdl_window_init
        mode =  SDL::OPENGL
        if @options[:fullscreen]
          mode |= SDL::FULLSCREEN
          w, h = @options[:fullscreen]
          SDL.setVideoMode(w, h, 0, mode)
        else
          SDL.setVideoMode(@width, @height + 1, 0, mode) # why +1?
        end
        GC.start
        SDL::WM.setCaption("sgl", "sgl")
        $__sgl_sdl_window_initialized__ = true
      end

      # setCurosr
      if @options[:cursor]
	# You can use only black and white for cursor image.
	file = @options[:cursor]
	bmp = SDL::Surface.loadBMP(file) # Create surface from bitmap.
	SDL::Mouse.setCursor(bmp,		# bitmap
			     [255, 255, 255],	# white
			     [  0,   0,   0],	# black
			     [128, 128, 128],	# transparent
			     [100, 100, 100],	# inverted
			     8, 8)		# hot_x, hot_y
      end

      # gl_init
      if @options[:fullscreen]
	set_fullscreen_position
      else
	set_window_position
      end
      set_camera_position
      GL.Enable(GL::BLEND)
      GL.BlendFunc(GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA)
      GL.ShadeModel(GL::SMOOTH)
      useDepth(@options[:depth])
      useCulling(@options[:culling])
      useSmooth(@options[:smooth])

      background(0)
      color(100)

      check_event
    end

    def close_window
      # do nothing for now
    end

    # get window size
    attr_reader :width, :height

    # world control methods
    def useFov(f = 45)
      @options[:fov] = f
    end

    def useDepth(a = true)
      @options[:depth] = a
      @options[:depth] ? GL.Enable(GL::DEPTH_TEST) : GL.Disable(GL::DEPTH_TEST)
    end

    def useSmooth(a = true)
      @options[:smooth] = a
      @options[:smooth] ?
      GL.Enable(GL::LINE_SMOOTH) : GL.Disable(GL::LINE_SMOOTH)
    end

    def useCulling(a = true)
      @options[:culling] = a
      @options[:culling] ? GL.Enable(GL::CULL_FACE) : GL.Disable(GL::CULL_FACE)
    end

    def useFullscreen(w=DEFAULT_FULLSCREEN_WIDTH, h=DEFAULT_FULLSCREEN_HEIGHT)
      if @options[:fullscreen].nil?
        @options[:fullscreen] = (w.nil? || h.nil?) ? nil : [w, h]
      end
    end

    def useCursor(bmpfile)
      @options[:cursor] = bmpfile
    end

    def useDelay(sec)
      @options[:delaytime] = sec
    end

    def useFramerate(f)
      @options[:framerate] = f
    end

    def useRuntime(r)
      @options[:runtime] = r
    end

    def runtime=(r)
      useRuntime(r)
    end

    def set_window_position
      @cameraX, @cameraY = ((@left + @right)/2), ((@bottom + @top)/2)
      fov = @options[:fov]
      @cameraZ = 1.0 +
	@height / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0))
      GL.Viewport(0, 0, @width, @height)
      GL.MatrixMode(GL::PROJECTION)
      loadIdentity
      GLU.Perspective(fov, @width/@height.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end

    def set_fullscreen_position
      cx, cy = ((@left + @right)/2), ((@bottom + @top)/2)
      @cameraX, @cameraY = cx, cy
      w, h = @options[:fullscreen]
      fhw = w / 2 #fullscreen half width
      fhh = h / 2 #fullscreen half height
      left   = cx - fhw
      bottom = cy - fhh
      right  = cx + fhw
      top    = cy + fhh
      GL.Viewport(0, 0, w, h)
      GL.MatrixMode(GL::PROJECTION)
      loadIdentity
      fov = @options[:fov]
      @cameraZ = 1.0 + h / (2.0 * Math.tan(Math::PI * (fov/2.0) / 180.0));
      GLU.Perspective(fov, w/h.to_f, @cameraZ * 0.1, @cameraZ * 10.0)
    end
    private :set_window_position, :set_fullscreen_position

    def set_camera_position
      GL.MatrixMode(GL::MODELVIEW)
      loadIdentity
      GLU.LookAt(@cameraX, @cameraY, @cameraZ,
		 @cameraX, @cameraY, 0,
		 0, 1, 0)
    end

    def set_fullscreen_camera_position
      GL.MatrixMode(GL::MODELVIEW)
      loadIdentity
      GLU.LookAt(0, 0, @cameraZ,
		 0, 0, 0,
		 0, 1, 0)
    end
    private :set_camera_position, :set_fullscreen_camera_position

    def loadIdentity
      GL.LoadIdentity
    end
    private :loadIdentity
  end
end
