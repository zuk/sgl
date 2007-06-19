#!/usr/bin/env ruby -w
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/sgl-connect"

module Sgl
  class Puts
    def initialize(stream=$stdout)
      stream.sync = true
      @stream = stream
    end

    def puts(str)
      @stream.puts(str)
    end
  end

  class Server
    def self.main(argv)
      server = self.new
      server.run
    end

    def run(duration=0)
      uri = DEFAULT_URI
      DRb.start_service(uri, Puts.new)
      puts DRb.uri

      if duration == 0
	sleep
      else
	sleep duration
      end
    end
  end
end

if $0 == __FILE__
  require "test/unit"
  $test = true
end

if defined?($test) && $test
  class TestSglServer < Test::Unit::TestCase
    def test_all
      server = Sgl::Server.new
      Thread.start {
	server.run(5)
      }

      uri = Sgl::DEFAULT_URI
      there = DRbObject.new_with_uri(uri)
      there.puts('Hello, World.')
    end
  end
end
