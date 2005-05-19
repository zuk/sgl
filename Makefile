test:
	cd sgl; make test; cd ..

dist:
	ruby make.rb

x:
	chmod -x *.html
