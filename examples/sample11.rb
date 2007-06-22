require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $x = 0
  $y = 0
end
 
def display
  x = mouseX
  y = mouseY
  speed = 20.0
  vx = (x - $x)/speed
  vy = (y - $y)/speed
  $x = $x + vx
  $y = $y + vy
  color 100, 0, 0
  circle($x, $y, 50, POLYGON)
end

mainloop
