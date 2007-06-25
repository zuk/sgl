require 'sgl'

def setup
  useSound
  window -200, -200, 200, 200
  $y = 0
  $sound = loadSound('sine.ogg')
end

def onMouseDown(x, y)
  $y = y
  $sound.play(y / 10 + 60)
end

def display
  line -200, $y, 200, $y
end

mainloop
