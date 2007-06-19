# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

module SGL
  # window functions
  def window(*a)	$__a__.window(*a);	end
  def close_window()	$__a__.close_window;	end
  def width()		$__a__.width;		end
  def height()		$__a__.height;		end

  class Application
    def initialize_window
      @options = default_options
      @win = @bgview = nil
      @width = @height = nil
      @oview = @movview = nil
      @thread = nil
    end
    private :initialize_window

    def default_options
      {
	:shadow=>true,
	:border=>true,
	:movie=>false,
	:overlay=>false,
      }
    end
    private :default_options

    # create window
    def window(*a)
      return if @win

      @options.update(a.pop) if a.last.is_a? Hash

      if defined?($windowShadow)
	@options[:shadow] = $windowShadow == 1
      end

      if defined?($windowBorder)
	@options[:border] = $windowBorder == 1
      end

      if @block[:display_overlay]
	@options[:overlay] = true
      end

      # get window size
      case a.length
      when 2
	w, h = a
      when 4
	raise "not implemented" # x1, y1, x2, y3 = a
      else
	raise "please specify width and height"
      end
      @width, @height = w, h

      cocoa_create_window(w, h)
    end

    def close_window
      @win.close if @win
      @win = @bgview = nil
    end

    attr_reader :width, :height

    def cocoa_create_window(w, h)
      @receiver = CocoaReceiver.alloc.init
      @receiver.setApp(self)

      # create a window
      s = OSX::NSScreen.mainScreen.frame.size
      x = (s.width  - w) / 2.0
      y = (s.height - h) / 2.0
      win_frame = [x.to_f, y.to_f, w.to_f, h.to_f]
      style = OSX::NSClosableWindowMask
      style |= @options[:border] ? OSX::NSTitledWindowMask :
	OSX::NSBorderlessWindowMask
      win = NSWindow.alloc.
	initWithContentRect(win_frame,
			    :styleMask, style,
			    :backing, OSX::NSBackingStoreBuffered,
			    :defer, true)
      win.setTitle("sgl")

      # create a view
      view = SglNSView.alloc.init
      view.setApp(self)
      win.setContentView(view)
      background(100)	# white
      color(0)		# black

      # for handling windowShouldClose
      win.setDelegate(@receiver)
      win.setOpaque(false)	# can be transparent
      win.setHasShadow(@options[:shadow])
      win.setReleasedWhenClosed(false)
      win.makeKeyAndOrderFront(@receiver)
      win.orderFrontRegardless	# show the window now
      @win = win
      @bgview = view
      window_movie(@options) if @options[:movie]
     #window_overlay(@options) if defined?(displayOverlay)
      window_overlay(@options) if @options[:overlay]
      @win
    end

    # sub view
    def window_movie(options)
      @movwin, @movview = make_view(@win, @bgview, NSViewForMovie, @options)
      @win.addChildWindow(@movwin, :ordered, OSX::NSWindowAbove)
      @movview.setNeedsDisplay(true)
      @movwin
    end

    def window_overlay(options)
      @owin, @oview = make_view(@win, @bgview, NSViewForOverlay, options)
      win = options[:movie] ? @movwin : @win
      win.addChildWindow(@owin, :ordered, OSX::NSWindowAbove)
      @oview.setNeedsDisplay(true)
      @owin
    end

    def make_view(parent_win, parent_view, viewclass, options)
      o = parent_view.frame.origin
      so = parent_win.convertBaseToScreen([o.x, o.y])
      s = parent_view.frame.size
      win_frame = [so.x, so.y, s.width, s.height]
      win = NSWindow.alloc.
	initWithContentRect(win_frame,
			    :styleMask, OSX::NSBorderlessWindowMask,
			    :backing, OSX::NSBackingStoreBuffered,
			    :defer, true)
      win.setOpaque(false)	# can be transparent
      win.setHasShadow(false)
      win.setIgnoresMouseEvents(true)
      win.setAlphaValue(1.0)	# transparent
      b = parent_view.bounds
      bo, bs = b.origin, b.size
      frame = [bo.x, bo.y, bs.width, bs.height]
      view = viewclass.alloc.initWithFrame(frame)
      view.setApp(self)
      win.contentView.addSubview(view)
      win.orderFront(@receiver)
      return win, view
    end
    private :window_movie, :window_overlay, :make_view

    # Cocoa callback methods
    def window_should_close
      stop
    end
  end

  class CocoaReceiver < OSX::NSObject
    def init
      @app = nil
      return self
    end

    def setApp(app)
      @app = app
    end

    # Cocoa callback methods
    def windowShouldClose(sender)
      @app.window_should_close
    end
  end

  class NSWindow < OSX::NSWindow
  end

  # Do not use NSView for class name.
  # It causes Illeagal Instruction Error.
  # I don't know why.
  class SglNSView < OSX::NSView
    ns_overrides :drawRect_,
      :mouseDown_, :mouseDragged_, :mouseUp_, :keyDown_, :keyUp_
    def setApp(app)	@app = app;	end
    def drawRect(rect)	@app.display_all(rect);	end
    def mouseDown(event)	@app.do_mousedown;	end
    def mouseDragged(event)	end # ignore
    def mouseUp(event)	@app.do_mouseup;	end
    def keyDown(event)	@app.do_keydown(event);	end
    def keyUp(event)	@app.do_keyup(event);	end
  end

  class NSViewForOverlay < OSX::NSView
    ns_overrides :drawRect_
    def setApp(app)	@app = app;	end
    def drawRect(rect)	@app.display_overlay_all(rect);	end
  end

  class NSViewForMovie < OSX::NSView
    ns_overrides :drawRect_
    def setApp(app)	@app = app;	end
    def drawRect(rect)	@app.display_mov(rect);	end
  end
end
