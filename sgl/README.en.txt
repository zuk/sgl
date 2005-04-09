* sgl - simple generic library

This is a simgple generic library for interactive art and design.
This library wraps Cocoa on Mac OS X.

In future, this library also wraps Ruby/SDL and OpenGL.

* Requirement

- Mac OS X 10.2 (Jaguar), 10.3 (Panther)
- ruby 1.6.7, 1.6.8
- RubyCocoa 0.4.0, 0.4.1

I did not test on Ruby 1.8 yet.
I think it's OK, if RubyCocoa works.

* Install

I suppose the tarball is extracted to "~/sgl".

** On Mac OS X 10.2
 % cd ~/sgl
 % sudo mkdir -p /usr/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/lib/ruby/site_ruby/1.6

** On Mac OS X 10.3
 % cd ~/sgl
 % sudo mkdir -p /usr/local/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/local/lib/ruby/site_ruby/1.6

* How to use

Use this program.

==> test1.rb <==
 require "sgl"
 def setup
   window 100, 100
 end
 def display
   line 0, 0, 100, 100
 end
 mainloop

Use this command to run the program.
And you can see a small window.

 % ruby test1.rb

The install is successfully finished.
Please see sample code on futher documentation.
And also you can see test code.

* Anonymous CVS

 % cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik login
 % cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik co sgl

* Liense

Ruby License.

* Author

Kouichirou Eto <2005 at eto.com>
