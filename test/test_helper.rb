# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

$__test_sgl__ = true

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) if !$LOAD_PATH.include?(libdir)

require 'test/unit'
require 'sgl'
