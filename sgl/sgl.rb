# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

module SGL
  #DEFAULT_TYPE = "cocoa"
  DEFAULT_TYPE = "opengl"
end

unless defined?($sgl_type) && $sgl_type
  $sgl_type = SGL::DEFAULT_TYPE
end

case $sgl_type
when "cocoa"
  require "sgl/cocoa"
when "opengl"
  require "sgl/opengl"
else
  raise "unknown type"
end
