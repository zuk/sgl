# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require "sdl"
require "opengl"
require "sgl/sgl-color"
require "sgl/opengl-window"
require "sgl/opengl-color"
require "sgl/opengl-event"
require "sgl/opengl-draw"

module SGL
  # dummy
  def useSound(*a)	end
  def stopSound(*a)	end

  class Application
    def initialize
      Thread.abort_on_exception = true
      @options = default_options
      initialize_window	# opengl-window.rb
      initialize_color	# sgl-color.rb
      initialize_event	# opengl-event.rb
    end

    def default_options
      {
	:fullscreen=>nil,
	:fov=>45,
	:cursor=>nil,
	:depth=>false,
	:culling=>false,
	:smooth=>false,
	:delaytime=>1.0/60,
	:framerate=>nil,
	:runtime=>nil,
      }
    end
    private :default_options
  end
end
