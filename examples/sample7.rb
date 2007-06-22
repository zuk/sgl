require "sgl"

def setup
  window 200, 200
end

def display
  for a in 0..10
    for b in 0..10
      color a*10, b*10, b*10
      rect a*20+5, b*20+5, a*20+15, b*20+15
    end
  end
end

mainloop 
