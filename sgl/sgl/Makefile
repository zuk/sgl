#RUBY = ruby
RUBY = ruby16

all:	test

test:	testall

x:
	chmod -x *.rb

testall:
	$(RUBY) test-all.rb

testcocoa:
	$(RUBY) test-cocoa-app.rb

testopengl:
	$(RUBY) test-opengl-app.rb

testsgl:
	$(RUBY) sgl-color.rb

clean:
	-rm *~
