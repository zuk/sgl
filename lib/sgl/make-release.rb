#!/usr/bin/env ruby
# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require "pathname"
require "fileutils"
require "sgl/version"

class String
  def path
    Pathname.new(self)
  end
end

class ReleaseMaker
  def self.main(argv)
    releasemaker = self.new
    puts "make version"
    releasemaker.make_version
    puts "make manifest"
    releasemaker.make_manifest
    puts "make dist"
    releasemaker.make_dist
  end

  # ==============================
  def make_version
    version = SGL::VERSION
    date = Time.now.strftime("%Y%m%d")
    code = <<"EOS"
module SGL
  VERSION = "#{version}"
  RELEASE_DATE = "#{date}"
end
EOS
    open("sgl/version.rb", "wb"){|out|
      out.print code
    }
  end

  # ==============================
  def make_manifest
    ar = []
    ".".path.find {|f|
      ar << f.to_s if public_file?(f)
    }
    open("MANIFEST", "wb") {|out|
      out.puts ar.sort
    }
  end

  def public_file?(f)
    return if f.directory?
    s = f.to_s
    return if s =~ /~$/
    ignore_pattern = %w(
CVS memo.txt tar.gz .cvsignore .svn
.stackdump .o .so
)
    ignore_pattern.each {|pat|
      return if s.include?(pat)
    }
    return true
  end

  # ==============================
  def oldmake_dist
    @files = open("MANIFEST"){|f| f.read }.split
    rm_rf @base, @opt
    rm_f  @targz, @opt
    mkdir @base, @opt
    cp_all @files, @base, @opt
    make_default_siteconfig
    make_default_password
    system_p "tar zcf #{@targz} #{@base}", @opt
    rm_rf @base, @opt
  end

  def make_dist
    version = SGL::VERSION
    base = "sgl-"+version
    tarball = base+".tar.gz"
    files = "MANIFEST".path.open {|f| f.read }.split
    base.path.rmtree if base.path.exist?
    base.path.mkdir
    cp_all(files, base)
    system "tar czf #{tarball} #{base}"
    base.path.rmtree
  end

  def cp_all(src, dest)
    src.each {|file|
      next if file.include?('.svn')
      path = file.path
      dir = path.dirname
      destdir = dest.path+dir
      destdir.mkdir if ! destdir.directory?
      FileUtils.cp(path, destdir)
    }
  end
end
