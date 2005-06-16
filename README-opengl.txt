* sgl - opengl version

* Requirement

** on Windows
- Windows 2000 or later
- ruby 1.8.2 MinGW version
- Ruby/OpenGL
- Ruby/Math3D
- Ruby/SDL

Chech this installation memo.
http://eto.com/wiki/RubySDLonWindows.html

** on Mac OS X
- Mac OS X 10.3 (Panther)
- ruby 1.8.2
- X Window system

* How to get

Use Anonymous CVS.

 % cvs -d:pserver:anonymous@rubyforge.org:/var/cvs/sgl login
 % cvs -z3 -d:pserver:anonymous@rubyforge.org:/var/cvs/sgl co sgl

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

* Liense

Ruby License.

* Author

Kouichirou Eto <2005 at eto.com>

