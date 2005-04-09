#!/usr/bin/env ruby -w
# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

$VERBOSE = true

def load_files(base)
  Dir.glob(base+"-*.rb") {|filename|
    require filename
  }
end

def main(argv)
  max = 6
  default = 4
  a = argv.shift
  level = a.to_i
  level = default if level == 0
  level = 0 if level < 0
  level = max if max < level
  load_files("test")	if 0 < level

  # usualy does not use these test
  load_files("check")	if 4 < level
end
main(ARGV)
