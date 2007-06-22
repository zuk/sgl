require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $xpos = []		# 中身が空の配列をx座標，y座標について用意する．
  $ypos = []
  for a in 0..20	# 配列の要素それぞれについて繰り返す．
    $xpos[a] = 0
    $ypos[a] = 0
  end
  $index = 0		# 現在配列のどこの部分を指しているかを示す．
end

def display
  $xpos[$index] = mouseX	# 添字
  $ypos[$index] = mouseY

  for a in 0..20	# 配列の要素それぞれについて繰り返す．
    x = $xpos[a]
    y = $ypos[a]
    colorHSV 0, 100, 100, 20
    circle x, y, 50, POLYGON
  end

  $index = $index + 1	# 現在を示す$indexを次の値のところにセットする．
  if 20 < $index	# $indexが配列の大きさを越えたら0にセットする
    $index = 0
  end

  p $xpos
  p $ypos
end

mainloop
