require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
end

def display
  x = mouseX
  y = mouseY

  push
  color 100, 0, 0
  translate x, y, 0
  rotateX x
  rotateY y
  scale 2
  rect -5, -5, 5, 5
  pop

  push
  color 100, 0, 0
  translate x, y, 0
  rotateX x
  rotateY y
  scale 2
  rect 5, 5, 10, 10
  pop
end

mainloop
