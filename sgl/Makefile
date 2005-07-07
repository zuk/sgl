RUBY = ruby
#RUBY = ruby16
DRUBY_SERVER_URL = druby://localhost:12345

all:	testall

run:
	$(RUBY) sgl-server.rb $(DRUBY_SERVER_URL)

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
