# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

require "sdl"
require "opengl"
require "sgl/sgl-color"
require "sgl/opengl-window"
require "sgl/opengl-color"
require "sgl/opengl-event"
require "sgl/opengl-draw"
#require "sgl/opengl-modules"
require "sgl/qp"

module SGL
  # dummy
  def useSound(*a)	end
  def stopSound(*a)	end
  def flip(*a)	end

  class Application
    def initialize
      Thread.abort_on_exception = true
      @options = default_options
      initialize_window
      initialize_color
      initialize_event
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
