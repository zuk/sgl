require "sgl"

def setup
  window -200, -200, 200, 200
  background 0
  $x1 = 0
  $y1 = 0
  $x2 = 0
  $y2 = 0
end
 
def display
  x = mouseX
  y = mouseY

  speed = 20.0
  vx = (x - $x1)/speed
  vy = (y - $y1)/speed
  $x1 = $x1 + vx
  $y1 = $y1 + vy
  color (200+$x1)/4, 0, 0
  circle($x1, $y1, 50, POLYGON)  ## polygon‚Í“h‚è‚Â‚Ô‚µ
  
  speed = 10.0
  vx = (x - $x2)/speed
  vy = (y - $y2)/speed
  $x2 = $x2 + vx
  $y2 = $y2 + vy
  color 0,(200+$y2)/4,0
  circle($x2+30,$y2+30,80)
end
 
mainloop
