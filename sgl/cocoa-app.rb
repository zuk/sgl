# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

require "osx/cocoa"
require "sgl/sgl-color"
require "sgl/cocoa-event"
require "sgl/cocoa-window"
require "sgl/cocoa-draw"
require "sgl/cocoa-media"

module SGL
  class Application
    def initialize
      # cocoa specific
      OSX.ruby_thread_switcher_start(0.001, 0.01)
      Thread.abort_on_exception = true

      @app = OSX::NSApplication.sharedApplication
      mainmenu = OSX::NSMenu.alloc.init
      @app.setMainMenu(mainmenu)

      @win = @bgview = nil
      @width = @height = nil
      @oview = @movview = nil
      @thread = nil

      # color setting
      @bgcolor = @curcolor = nil
      @rgb = ColorTranslatorRGB.new(100, 100, 100, 100)
      @hsv = ColorTranslatorHSV.new(100, 100, 100, 100)

      # block setting
      @setup_done = nil
      @display_drawing = nil
      @display_overlay_drawing = nil
      @options = default_options
      @block = {}
      @delay_time = 1.0/60
      @runtime = nil

      # status setting
      @mouseX, @mouseY = 0, 0
      @mouseDown = 0
      @keynum = 0
    end
    attr_reader :curcolor
    attr_accessor :runtime # for test

    # get status
    attr_reader :mouseX, :mouseY
    attr_reader :mouseDown
    attr_reader :keynum

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

      cocoa_create_window
    end

    def close_window
      @win.close if @win
      @win = @bgview = nil
    end

    attr_reader :width, :height

    def run
      OSX.NSApp.run
      OSX::NSEvent.stopPeriodicEvents
    end

    def stop
      close_window
      OSX.NSApp.stop(nil)
      OSX::NSEvent.startPeriodicEventsAfterDelay(0.01, :withPeriod, 0.01)
    end
  end
end

