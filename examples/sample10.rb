require "sgl"

def setup
  window -200, -200, 200, 200
end

def display
  push
  translate 100, 0
  rotateZ 10
  scale 2
  rect -5, -5, 5, 5
  pop
end

mainloop
