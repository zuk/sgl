#!/usr/bin/env ruby -w
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$LOAD_PATH.unshift("..") if !$LOAD_PATH.include?("..")
require "sgl/sgl-connect"

module Sgl
  class Client
    def self.main(argv)
      uri = ARGV.shift
      there = DRbObject.new_with_uri(uri)
      there.puts('Hello, World.')
    end
  end
end

if $0 == __FILE__
  require "test/unit"
  Sgl::Client.main(ARGV)
end
