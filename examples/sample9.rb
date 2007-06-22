require "sgl"

def setup
  window -200, -200, 200, 200
end

def display
  beginObj(POLYGON)
  color 100, 0, 0, 0
  vertex 60, 90
  color 0, 100, 0, 100
  vertex -120, 60
  color 0, 0, 100, 100
  vertex -90, -90
  color 100, 100, 0, 0
  vertex 120, -90
  endObj
end

mainloop 
