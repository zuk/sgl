require "sgl"

def setup
  window -250, -250, 250, 250
  background 100
  $a = 0
end

def display
  x = mouseX
  y = mouseY

  color 50, 50, 50
  rect 190, -190, 200, -240
  rect 230, -190, 240, -240
  color 100, 0, 0
  rect 200, -200, 230, -230

  line x, y, x-5, y

  color 0
  circle 150, 150, 5
  circle 0, -105, 4
  circle -100, 0, 3
  circle -150, 80, 2
  line 150, 155, 150, 250
  line 0, -108, 0, -250
  line -100, -2, -100, -250
  line -150, 81, -150, 250

  if $a == 0
    color 100, 0, 0
    line x, y, 215, -200
  else
    color 100, 0, 0
    line 150, 150, 215, -200
  end

  # 1の穴
  if $a == 0 && 145 <= x && 155 >= x && 145 <= y && 155 >= y
    $a = 1
  end

  if $a == 1
    color 100, 0, 0
    line x, y, 150, 150
  elsif $a > 1
    line 0, -105, 150, 150
  end

  # 2の穴
  if $a == 1 && -5 <= x && 5 >= x && -110 <= y && -100 >= y
    $a = 2
  end

  if $a == 2
    color 100, 0, 0
    line x, y, 0, -105
  elsif $a > 2
    line -100, 0, 0, -105
  end

  # 3の穴
  if $a == 2 && -103 <= x && -98 >= x && -3 <= y && 2 >= y
    $a = 3
  end

  if $a == 3
    color 100, 0, 0
    line x, y, -100, 0
  elsif $a > 3
    line -150, 80, -100, 0
  end

  # 4の穴
  if $a == 3 && -152 <= x && -148 >= x && 78 <= y && 82 >= y
    $a = 4
  end

  if $a == 4
    color 100, 0, 0
    line x, y, -150, 80
  end

  # ゴール地点
  if $a == 4 && -250 <= x && -180 >= x
    $a = 5
  end

  if $a == 5
    background 70, 80, 100
    color 100, 80, 80
    circle -100, 0, 50, POLYGON
    color 80, 80, 100
    circle -100, 0, 30, POLYGON
    color 100, 80, 80
    rect 50, 50, 70, -50

    beginObj(POLYGON)
    vertex 70, -7
    vertex 112, 35
    vertex 138, 35
    vertex 70, -33
    endObj
    beginObj(POLYGON)
    vertex 103, 0
    vertex 140, -50
    vertex 115, -50
    vertex 85, -9
    endObj
  end
end

mainloop

# 大きい穴から始めないと通りません
