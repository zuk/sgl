# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require "kconv"

module SGL
  def movie(*a)	$__a__.movie(*a);	end
  def image(*a)	$__a__.image(*a);	end
  def font(*a)	$__a__.font(*a);	end
  def sound(*a)	$__a__.sound(*a);	end

  class Application
    def movie(u)
      if /\Ahttp:\/\// =~ u || /\Artsp:\/\// =~ u
	url = OSX::NSURL.URLWithString_(u)
      else
	url = OSX::NSURL.fileURLWithPath_(u)
      end
      mov = OSX::NSMovie.alloc.initWithURL(url, :byReference, true)
      # Place the movie on the out of screen.
      obj = NSMovieView.alloc.initWithFrame([-100.0, -100.0, 10.0, 10.0])
      obj.setApp(self)
      obj.setMovie(mov)
      obj.showController(false, :adjustingSize, false)
      view = @options[:movie] ? @movview : @bgview
      # This "p" is necessary to show the movie.  I don't know why.
      p [@options[:movie], view]
      # p view			# This does not work.
      # dummy = view.inspect	# This does not work also.
      view.addSubview(obj)
      obj
    end

    def image(file)
      img = NSImage.alloc.initWithContentsOfFile(file)
      img.setApp(self)
      img
    end

    def font(*a)
      NSFont.new(self, *a)
    end

    def sound(file)
      url = OSX::NSURL.fileURLWithPath_(file)
      snd = NSSound.alloc.initWithContentsOfURL(url, :byReference, true)
      snd
    end
  end

  class NSMovieView < OSX::NSMovieView
    include FrameTranslator

    def setApp(app)
      @app = app
      @playing = false
    end

    def rect(a,b,c,d)
      frame(*to_xywh(a, b, c, d))
     #frame(*@app.to_xywh(a, b, c, d))
    end

    def frame(a,b,c,d)
      setFrame([a, b, c, d])
    end

    def play
      return if @playing
      @playing = true
      start_
    end

    def stop
      return if ! @playing
      @playing = false
      stop_
    end

    def goBegin()	gotoBeginning_;	end
    def goEnd()	gotoEnd_;	end
    def forward()	stepForward_;	end
    def back()	stepBack_;	end
    def loop=(a)	setLoopMode(a);	end
    def rate=(r)	setRate(r/100.0);	end
    def volume=(v)	setVolume(v/100.0);	end
  end

  class NSImage < OSX::NSImage
    include FrameTranslator

    def setApp(app)	@app = app;	end

    def rect(a,b,c,d)
      frame(*to_xywh(a, b, c, d))
    end

    def frame(x,y,w,h)
      drawInRect([x,y,w,h],
		 :fromRect, [0,0,size.width,size.height],
		 :operation, OSX::NSCompositeSourceOver,
		 :fraction, @app.get_cur_color_alpha)
    end
  end

  class NSFont
    def initialize(w, n="Helvetica", s=0.0)
      @app, @name, @size = w, n, s.abs
    end
    attr_accessor :name
    attr_reader :size

    def size=(s)
      @size = s.abs
    end

    def text(x, y, str)
      return unless str.is_a? String
      str = NKF.nkf("-m0 -s", str)
      str = OSX::NSMutableAttributedString.alloc.initWithString(str)
      str.addAttribute(OSX::NSFontAttributeName(),
		       :value, OSX::NSFont.fontWithName(@name, :size, @size),
		       :range, [0,str.length])
      color = @app.make_cur_color
      str.addAttribute(OSX::NSForegroundColorAttributeName(),
		       :value, color,
		       :range, [0,str.length])
      str.drawAtPoint([x, y])
    end

    def show_fixed()	show(OSX::NSFixedPitchFontMask);	end
    def show_all()	show;	end

    private
    def show(mask=0)
      fmgr = OSX::NSFontManager.sharedFontManager
      fonts = fmgr.availableFontNamesWithTraits(mask).to_a.map{|i| i.to_s }.sort
      puts fonts
    end
  end

  class NSSound < OSX::NSSound
  end
end
