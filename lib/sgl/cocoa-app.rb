# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.

require "osx/cocoa"
require "sgl/sgl-color"
require "sgl/cocoa-event"
require "sgl/cocoa-window"
require "sgl/cocoa-draw"
require "sgl/cocoa-color"
require "sgl/cocoa-media"

module SGL
  class Application
    def initialize
      initialize_cocoa
      initialize_window
      initialize_color
      initialize_event
    end

    def initialize_cocoa
      OSX.ruby_thread_switcher_start(0.001, 0.01)
      Thread.abort_on_exception = true

      @app = OSX::NSApplication.sharedApplication
      mainmenu = OSX::NSMenu.alloc.init
      @app.setMainMenu(mainmenu)
    end
    private :initialize_cocoa

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

