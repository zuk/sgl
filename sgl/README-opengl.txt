* sgl - opengl version

* Requirement

** on Windows
- Windows 2000 or later
- ruby 1.8.2 MinGW version
- Ruby/OpenGL
- Ruby/Math3D
- Ruby/SDL

Chech an installation memo.
http://eto.com/wiki/RubySDLonWindows.html

** on Mac OS X
- Mac OS X 10.3 (Panther)
- ruby 1.8.2
- X Window system

* How to get

Use Anonymous CVS.

 % cd
 % cvs -d:pserver:anonymous@rubyforge.org:/var/cvs/sgl login
 % cvs -z3 -d:pserver:anonymous@rubyforge.org:/var/cvs/sgl co sgl

* Install

I suppose you put the CVS files to "~/sgl".

** on Windows
 % cd ~/sgl
 % mv sgl c:/usr/local/lib/ruby/site_ruby/1.8/
 % mv sgl.rb c:/usr/local/lib/ruby/site_ruby/1.8/

** on Mac OS X
not yet.

* How to use

Use this test program.

==> test1.rb <==
 require "sgl/opengl"
 def setup
   window 100, 100
 end
 def display
   line 0, 0, 100, 100
 end
 mainloop

Type this command from command line.

 % ruby test1.rb

You can see a small window.
The install is successfully finished.
Please see sample code on futher documentation.
And also you can see test code.

* Liense

Ruby License.

* Author

Kouichirou Eto <2005 at eto.com>

