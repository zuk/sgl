require "sgl"

def setup
  window 100, 100
end

def my_rect(x1, y1, x2, y2, outline, fill)
  color fill
  rect x1, y1, x2, y2
  color outline
  line x1, y1, x2, y1
  line x2, y1, x2, y2
  line x2, y2, x1, y2
  line x1, y2, x1, y1
end

def display
  mx = mouseX
  my = mouseY
  my_rect(20, 20, 40, 30, 80, 50)
  my_rect(60, 60, 80, 90, 90, 30)
end

mainloop
